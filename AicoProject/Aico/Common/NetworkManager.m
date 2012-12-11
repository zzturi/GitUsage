
//
//  NetworkManager.m
//  iPhoneDSM
//
//  Created by Maserati on 11-6-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NetworkManager.h"
#import "Common.h"
#import "NetworkDef.h"
#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"
#import "NetworkDef.h"
#import "XMLUtils.h"
#import "GDataXMLNode.h"
#import "ZipArchive.h"

#define AlertTagNewVersion 0
#define AlertTagForceVersion 1

NSString* const NetworkInvalidErrorDomain = @"NetworkInvalidErrorDomain";
NSInteger const NetworkInvalidErrorCode = 9;
static NetworkManager *networkManager_ = nil;
static NSString *url = nil;
@interface NetworkManager (privateMethods) <UIAlertViewDelegate>

/**
 * @brief  网络请求失败信息处理
 *
 * @param [in] 
 * @param [out] 
 * @return
 * @note 
 */
- (void) notifyNetworkRequestError:(NSError *)err withReqInfo:(ASIHTTPRequest *)request;

/**
 * @brief  分发请求回调
 *
 * @param [in] 
 * @param [out] 
 * @return
 * @note 
 */
- (void) dispatchNotification:(NSInteger)requestId withResponseData:(NSString*)rspData andRequestData:(ASIHTTPRequest *)rqtData;

/**
 * @brief  通知网络状态
 *
 * @param [in] 
 * @param [out] 
 * @return
 * @note 
 */
- (void)reachabilityChanged:(NSNotification *)note;

/**
 * @brief 启动网络状态通知
 *
 * @param [in] 
 * @param [out] 
 * @return
 * @note 
 */
- (void)startNotifier;

/**
 * @brief 解析素材列表数据
 *
 * @param [in] 
 * @param [out] 
 * @return
 * @note 
 */
- (NSArray *)parserResourceList:(NSString *)responseString;

/**
 * @brief 发送下载请求
 *
 * @param [in] 
 * @param [out] 
 * @return
 * @note 
 */
- (void)issueDownloadHttpRequest:(NSDictionary *)downloadInfo;
@end

@implementation NetworkManager
@synthesize requestQueue = requestQueue_;
@synthesize hostReach = hostReach_;
@synthesize hostStatus = hostStatus_;

- (id)init {
    
    self = [super init];
    
    if (self) 
    {
        
        self.hostStatus = ReachableViaWiFi;
        requestQueue_ = [[NSOperationQueue alloc] init];
        requestList_ = [[NSMutableArray alloc] initWithCapacity:4];
        [self startNotifier];
    }
    
    return self;
}

/**
 * @brief  创建单例和获取单例的方法
 *
 * @param [in] 
 * @param [out] 返回单例本身
 * @return
 * @note 
 */
+ (NetworkManager *)sharedNetworkManager
{
    if (networkManager_ == nil)
    {
        networkManager_ = [[NetworkManager alloc] init];
    }
    return networkManager_;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.requestQueue = nil;
    [self.hostReach stopNotifier];
    [hostReach_ release];
    [requestList_ removeAllObjects];
    [requestList_ release];
    [super dealloc];
    
}

/**
 * @brief 发送下载请求
 *
 * @param [in] 
 * @param [out] 
 * @return
 * @note 
 */
- (void)issueDownloadHttpRequest:(NSDictionary *)downloadInfo
{
    NSString *linkStr = [downloadInfo objectForKey:@"iconUrl"];
    NSString *downloadPath = [downloadInfo objectForKey:@"downloadPath"];
	NSString *contentCode = [downloadInfo objectForKey:kContentCode];
    NSString *moduleStr = [downloadInfo objectForKey:@"module"];
	
	if (contentCode == nil 
        || downloadPath == nil
        || linkStr == nil 
        || moduleStr == nil
        || [contentCode isKindOfClass:[NSNull class]] 
        || [downloadPath isKindOfClass:[NSNull class]]
        || [linkStr isKindOfClass:[NSNull class]]
        || [moduleStr isKindOfClass:[NSNull class]]) 
    {
        return;
    }
	
    NSURL *url = [NSURL URLWithString:linkStr];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
   
    [request setDownloadDestinationPath:downloadPath];
    NSDictionary *dlInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:EDownloadIconRequestId], @"requestId",contentCode,kContentCode,moduleStr,@"module", nil];
    request.userInfo = dlInfo;
    [self issueHttpRequest:request];
}
/**
 * @brief  添加网络请求
 *
 * @param [in] 
 * @param [out] 
 * @return
 * @note 
 */
- (void) issueHttpRequest:(ASIHTTPRequest *)aRequest 
{
    
    if (self.hostStatus == NotReachable) 
    {
        NSError *ntwkInvalidError =[[NSError alloc] initWithDomain:NetworkInvalidErrorDomain code:NetworkInvalidErrorCode userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Network Invalid...",NSLocalizedDescriptionKey,nil]]; 
        aRequest.error = ntwkInvalidError;
        [ntwkInvalidError release];
        [self requestFailed:aRequest];

        return;
    }

    [aRequest setDelegate:self];
    
    //激活信息上报不用添加消息头
    if ([[aRequest.userInfo objectForKey:kRequestId] intValue] != EReportActiveInfoId
        && ([[aRequest.userInfo objectForKey:kRequestId] intValue] != EDownloadIconRequestId && ![[aRequest.userInfo objectForKey:@"module"] isEqualToString:@"stickerImages"]))
    {
        [aRequest addRequestHeader:kUserType value:@"3"];
        [aRequest addRequestHeader:kUserID value:@"guest_domestic"];
        [aRequest addRequestHeader:kLangue value:@"zh_CN"];
        [aRequest addRequestHeader:kDeviceID value:@"Huawei_ODP"];
        NSString *dateStr = [Common getUTCFormateDate:[NSDate date]];
        [aRequest addRequestHeader:kTimestamp value:dateStr];
        [aRequest addRequestHeader:kOperatorID value:@"8601"];
    }
    
    //下载zip包必须加此消息头，否则不能下载
    if ( [[aRequest.userInfo objectForKey:kRequestId] intValue] == EDownloadIconRequestId && [[aRequest.userInfo objectForKey:@"module"] isEqualToString:@"stickerImages"]) 
    {
        [aRequest addRequestHeader:@"Accept" value:@"*/*"];
    }
    
    [requestList_ addObject:aRequest];
    [self.requestQueue addOperation:aRequest];
}

/**
 * @brief  根据请求id取消某个请求
 *
 * @param [in] 
 * @param [out] 
 * @return
 * @note 
 */
- (void) cancelHttpRequest:(NSInteger)aRequestId 
{
    for (int i = 0; i < [requestList_ count]; i++)
    {
        ASIHTTPRequest *request = [requestList_ objectAtIndex:i];
        NSInteger requestId = [[request.userInfo objectForKey:kRequestId] intValue];
        if (requestId == aRequestId)
        {
            [request cancel];
            [request clearDelegatesAndCancel];
        }
    }
}

/**
 * @brief  取消所有请求
 *
 * @param [in] 
 * @param [out] 
 * @return
 * @note 
 */
- (void) cancelAllHttpRequest 
{
    for (int i = 0; i < [requestList_ count]; i++)
    {
        ASIHTTPRequest *request = [requestList_ objectAtIndex:i];
        [request cancel];
        [request clearDelegatesAndCancel];
    }
}

/**
 * @brief  网络请求失败信息处理
 *
 * @param [in] 
 * @param [out] 
 * @return
 * @note 
 */
- (void) notifyNetworkRequestError:(NSError *)err withReqInfo:(ASIHTTPRequest *)request 
{
    NSNumber *requestId = [request.userInfo objectForKey:kRequestId];
    switch ([requestId intValue])
    {
        case EStickerListId:
        {
            [Common showToastView:@"无法更新装饰列表" hiddenInTime:2.0f];
            break;
        }
        case EDownloadIconRequestId:
        {
            NSString *moduleStr = [request.userInfo objectForKey:@"module"];
            if ([moduleStr isEqualToString:@"iconImage"])
            {
                break;
            }
        }
        case EStickerDetailListId:
        {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kServerErrorNotification object:[NSString stringWithFormat:kServerError]];
            break;
        }
            
        default:
            break;
    }
    //NSLog(@"notifyNetworkRequestError RequestId = %d",[requestId intValue]);

}

/**
 * @brief  分发请求回调
 *
 * @param [in] 
 * @param [out] 
 * @return
 * @note 
 */
- (void) dispatchNotification:(NSInteger)requestId withResponseData:(NSString*)rspData andRequestData:(ASIHTTPRequest *)rqtData 
{
    
    switch (requestId) 
    {
        case EReportActiveInfoId://激活信息上报
        {
            NSError *error = nil;
            NSDictionary *dic = [[CJSONDeserializer deserializer] deserializeAsDictionary:[rspData dataUsingEncoding:NSUTF8StringEncoding] error:&error];
            NSString *resultCode = [dic objectForKey:@"resultCode"];
            if ([resultCode isEqualToString:@"00000000"])
            {
                [Common saveActiveResult:YES];
            }
            else
            {
                [Common saveActiveResult:NO];
            }
            
            break;
        }
        case ECheckVersionId://检测版本
        
        {
            NSError *error = nil;
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:rspData options:0 error:&error];
            //NSLog(@"%@", doc.rootElement.XMLString);
            
            //定位status节点
            NSArray *array = [doc.rootElement elementsForName:@"status"];
            if (array.count > 0) {
                GDataXMLElement *statusElement = (GDataXMLElement *)[array objectAtIndex:0];
                if ([statusElement.stringValue isEqual:@"0"])
                {
                    //定位components节点
                    NSArray *componentsArray = [doc.rootElement elementsForName:@"components"];
                    if (componentsArray.count > 0) {
                        GDataXMLElement *componentsElement = (GDataXMLElement *)[componentsArray objectAtIndex:0];
                        
                        //定位component节点
                        NSArray *componentArray = [componentsElement elementsForName:@"component"];
                        if (componentArray.count > 0) {
                            GDataXMLElement *componentElement = (GDataXMLElement *)[componentArray objectAtIndex:0];
                            
                            //定位url节点
                            array = [componentElement elementsForName:@"url"];
                            if (array.count > 0) {
                                GDataXMLElement *urlElement = (GDataXMLElement *)[array objectAtIndex:0];
                                url = [[NSString alloc] initWithString:urlElement.stringValue];
                            }   
                            
                            //定位forcedupdate节点
                            array = [componentElement elementsForName:@"forcedupdate"];
                            if (array.count > 0) 
                            {
                                GDataXMLElement *forcedupdateElement = (GDataXMLElement *)[array objectAtIndex:0];
                                if ([forcedupdateElement.stringValue isEqual:@"1"])
                                {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                                        message:@"您必须升级到最新版本才能正常使用，请升级。"
                                                                                       delegate:self
                                                                              cancelButtonTitle:@"取消"
                                                                              otherButtonTitles:@"升级", nil];
                                    alertView.tag = AlertTagForceVersion;
                                    [alertView show];
                                    [alertView release];
                                }
                                else 
                                {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil 
                                                                                        message:@"有新版本啦！是否要更新"
                                                                                       delegate:self
                                                                              cancelButtonTitle:@"取消"
                                                                              otherButtonTitles:@"确定", nil];
                                    alertView.tag = AlertTagNewVersion;
                                    [alertView show];
                                    [alertView release];
                                }    
                            }  
                        }
                    }
                }
            }
            
            [doc release];
            
            
            break;
        }
            
        case EStickerListId:
        {
            GDataXMLDocument *doc = [XMLUtils initDocumentWithString:rspData];
            GDataXMLElement *operResultCode = [[doc.rootElement elementsForName:@"operResultCode"] objectAtIndex:0];
            NSString *operResultCodeStr = [[operResultCode stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([operResultCodeStr isEqualToString:@"0"]) 
            {
                //success
                NSArray *stickerListArray = [self parserResourceList:rspData];
                if ([stickerListArray count] > 0)
                {
                    //通知页面刷新列表
                    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshStickerListNotification object:stickerListArray];
                }
                
            }
            else
            {
                [Common showToastView:@"服务器异常,请重试!" hiddenInTime:2.0f];
            }
            break;
        }
        case EDownloadIconRequestId:
        {
            NSString *moduleStr = [rqtData.userInfo objectForKey:@"module"];
            if ([moduleStr isEqualToString:@"iconImage"]) 
            {
                if ([[rqtData.userInfo objectForKey:kContentCode] length] > 0)
                {
                    //通知页面刷新列表
                    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshStickerListNotification object:[rqtData.userInfo objectForKey:kContentCode]];
                }
            }
            else if([moduleStr isEqualToString:@"stickerImages"])
            {
                //需要解压，然后发通知
                NSString *path = [[Common downloadDirectory] stringByAppendingString:[rqtData.userInfo objectForKey:kContentCode]];
                //设置解压文件夹的路径
                NSString *unZipPath = path;//[path stringByAppendingPathComponent:@"xpa_resource"];
                //初始化ZipArchive
                ZipArchive *zip = [[ZipArchive alloc] init];
                
                BOOL result;
                
                if ([zip UnzipOpenFile:[rqtData downloadDestinationPath]]) 
                {
                    
                    result = [zip UnzipFileTo:unZipPath overWrite:YES];//解压文件
                    if (!result) 
                    {
                        //解压失败
                        NSLog(@"unzip fail................");
//                        [Common showToastView:@"服务器异常,请重试!" hiddenInTime:2.0f];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kServerErrorNotification object:kServerError];
                    }
                    else
                    {
                        //解压成功
                        NSLog(@"unzip success.............");
                        NSString *stickerListXmlPath = [[[NSString alloc] initWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]] autorelease];
                        NSArray *stickerListArray = [NSArray arrayWithContentsOfFile:[stickerListXmlPath stringByAppendingPathComponent:@"stickerList.xml"]];
                        for (NSDictionary *itemInfo in stickerListArray) 
                        {
                            if ([[itemInfo objectForKey:kContentCode] isEqualToString:[rqtData.userInfo objectForKey:kContentCode]])
                            {
                                [itemInfo setValue:unZipPath forKey:@"resourceZipPath"];
                                [itemInfo setValue:[NSNumber numberWithBool:NO] forKey:kIsNeedDownload];
                                break;
                            }
                        }
                        [stickerListArray writeToFile:[stickerListXmlPath stringByAppendingPathComponent:@"stickerList.xml"] atomically:YES];


                    }
                    
                    [zip UnzipCloseFile];//关闭
                    [zip release];
                    
                    //通知发送解压svgz请求
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUncompressSVGZNotification object:nil];
                }
                else
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kServerErrorNotification object:kServerError];
                    break;
                }
            }
            
            break;
        }
        case EStickerDetailListId:
        {
            GDataXMLDocument *doc = [XMLUtils initDocumentWithString:rspData];
            GDataXMLElement *operResultCode = [[doc.rootElement elementsForName:@"operResultCode"] objectAtIndex:0];
            NSString *operResultCodeStr = [[operResultCode stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([operResultCodeStr isEqualToString:@"0"])
            {
                //downloadURL
                NSArray *downloadURLArr = [doc.rootElement elementsForName:@"downloadURL"];
                if ([downloadURLArr count] > 0)
                {
                    GDataXMLNode *downloadURL = [downloadURLArr objectAtIndex:0];
                    NSString *downloadURLStr = [[downloadURL stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                    NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:downloadURLStr,@"downloadURL",[rqtData.userInfo objectForKey:kContentCode],kContentCode, nil];
                    
                    //通知发送下载请求
                    [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadStickerImageListNotification object:infoDic];
                    break;
                }
                
                
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kServerErrorNotification object:kServerError];
            
            break;
        }

        default:
            break;
    }
}
 
/**
 * @brief  通知网络状态
 *
 * @param [in] 
 * @param [out] 
 * @return
 * @note 
 */
- (void)reachabilityChanged:(NSNotification *)note 
{
 
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    self.hostStatus = status;
    if (status == NotReachable) 
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kServerErrorNotification object:[NSString stringWithFormat:kNetWorkError]];
        
    }
    else
    {

    }
}

/**
 * @brief 启动网络状态通知
 *
 * @param [in] 
 * @param [out] 
 * @return
 * @note 
 */
- (void)startNotifier
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    hostReach_ = [[Reachability reachabilityForInternetConnection] retain];
    [self.hostReach startNotifier];
}

#pragma -
#pragma mark Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) requestFinished:(ASIHTTPRequest *)request 
{
    NSString *rspString = [request responseString];
    NSNumber *idNum = [request.userInfo objectForKey:kRequestId];
//    NSLog(@"RequestId = %d",[idNum intValue]);
    NSLog(@"Network Response: %@",rspString);
    [self dispatchNotification:[idNum intValue] withResponseData:rspString andRequestData:request];
    for (int i = 0; i < [requestList_ count]; i++) 
    {
        ASIHTTPRequest *request = [requestList_ objectAtIndex:i];
        NSInteger requestId = [[request.userInfo objectForKey:kRequestId] intValue];
        if (requestId == [idNum intValue])
        {
            [requestList_ removeObjectAtIndex:i];
        }
    }

}

- (void) requestFailed:(ASIHTTPRequest *)request 
{
    NSError *error = [request error];
    NSLog(@"Network Request Error");
    NSLog(@"%@",error);
    
     NSNumber *idNum = [request.userInfo objectForKey:kRequestId];
    if (idNum.intValue == EReportActiveInfoId)
    {
        //上报激活信息失败
        [Common saveActiveResult:NO];
    }

    if (error != nil) 
    {
        [self notifyNetworkRequestError:error withReqInfo:request];
    }
    for (int i = 0; i < [requestList_ count]; i++) 
    {
        ASIHTTPRequest *request = [requestList_ objectAtIndex:i];
        NSInteger requestId = [[request.userInfo objectForKey:kRequestId] intValue];
        if (requestId == [idNum intValue]) 
        {
            [requestList_ removeObjectAtIndex:i];
        }
    }

}


-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders 
{
    NSLog(@"--------aaaadidReceiveResponseHeadersaaaa-----%@",responseHeaders);
    
}


#pragma  -
#pragma mark UIAlertViewDelegate Method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if (AlertTagForceVersion == alertView.tag) 
    {
        if(1 == buttonIndex) 
        {            
            if (nil != url) 
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }        
            else 
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil 
                                                                    message:@"服务器地址错误!"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                alertView.tag = AlertTagNewVersion;
                [alertView show];
                [alertView release];
            }
        }  
        
        [url release];
        exit(0);
    }
    else 
    {
        if(1 == buttonIndex) 
        { 
            if (nil != url) 
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                [url release]; 
                
                exit(0);
            }    
            else 
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil 
                                                                    message:@"服务器地址错误!"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                alertView.tag = AlertTagNewVersion;
                [alertView show];
                [alertView release];
            }
        } 
        
        [url release]; 
    }
}

/**
 * @brief 解析素材列表数据
 *
 * @param [in] 
 * @param [out] 
 * @return
 * @note 
 */
- (NSArray *)parserResourceList:(NSString *)responseString
{
    GDataXMLDocument *doc = [XMLUtils initDocumentWithString:responseString];
    GDataXMLElement *contentList = [[doc.rootElement elementsForName:@"contentList"] objectAtIndex:0];
    NSArray *contentItemArray = [contentList elementsForName:@"contentItem"];
    NSMutableArray *itemInfoArray = [NSMutableArray arrayWithCapacity:0];
    
    NSString *stickerListXmlPath = [[[NSString alloc] initWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]] autorelease];
    stickerListXmlPath = [stickerListXmlPath stringByAppendingPathComponent:@"stickerList.xml"];
    NSArray *oldListArray = [NSArray arrayWithContentsOfFile:stickerListXmlPath];
    if ([contentItemArray count] > 0)
    {
        for (GDataXMLElement *item in contentItemArray)
        {
            NSMutableDictionary *itemInfo = [NSMutableDictionary dictionaryWithCapacity:0];
            GDataXMLElement *contentCode = [[item elementsForName:kContentCode] objectAtIndex:0];
            NSString *contentCodeStr = [[contentCode stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [itemInfo setValue: contentCodeStr forKey:kContentCode];
            GDataXMLElement *contentName = [[item elementsForName:kContentName] objectAtIndex:0];
            NSString *name = [[contentName stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [itemInfo setValue:name forKey:kContentName];
            
            //版本号
            GDataXMLElement *application = [[item elementsForName:@"application"] objectAtIndex:0];
            GDataXMLElement *appVersion = [[application elementsForName:kApplicationVersion] objectAtIndex:0];
            NSString *appVersionStr = [[appVersion stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [itemInfo setValue:appVersionStr forKey:kApplicationVersion];
            BOOL isNeedDownload = YES;
            for (NSDictionary *objDic in oldListArray)
            {
                if ([[objDic objectForKey:kContentCode] isEqualToString:contentCodeStr])
                {
                    isNeedDownload = [[objDic objectForKey:kIsNeedDownload] boolValue];
                    //如果数据中版本号与之前下载列表内的版本号相等，则不用下载
                    if ([[objDic objectForKey:kApplicationVersion] isEqualToString:appVersionStr] && !isNeedDownload)
                    {
                        isNeedDownload = NO;
                    }
                    else
                    {
                        isNeedDownload = YES;
                    }
                    break;
                }
            }
            [itemInfo setValue:[NSNumber numberWithBool:isNeedDownload] forKey:kIsNeedDownload];
            
            //图标，如果本地不存在，则下载
            GDataXMLElement *iconPath = [[item elementsForName:kIconPath] objectAtIndex:0];
            NSString *url = [[iconPath stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *localPath = [Common getLocalPathFromUrl:url];
             NSFileManager *fileMgr = [NSFileManager defaultManager];
            if (![fileMgr fileExistsAtPath:localPath])
            {
                NSMutableDictionary *picDownloadInfo = [NSMutableDictionary dictionaryWithCapacity:0];
                [picDownloadInfo setValue:url forKey:@"iconUrl"];
                [picDownloadInfo setValue:localPath forKey:@"downloadPath"];
                [picDownloadInfo setValue:contentCodeStr forKey:kContentCode];
                [picDownloadInfo setValue:@"iconImage" forKey:@"module"];
                [self issueDownloadHttpRequest:picDownloadInfo];
            }
            [itemInfo setValue:localPath forKey:@"iconLocalPath"];//存储本地路径
            [itemInfo setValue:url forKey:@"iconUrl"];
            
            [itemInfoArray addObject:itemInfo];
        }
        
    }
    
    [itemInfoArray writeToFile:stickerListXmlPath atomically:YES];
    return itemInfoArray;
}
@end
