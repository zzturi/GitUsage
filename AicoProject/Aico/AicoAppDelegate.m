//
//  AicoAppDelegate.m
//  Aico
//
//  Created by petsatan on 12-3-27.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "AicoAppDelegate.h"
#import "ReUnManager.h"
#import "AicoViewController.h"
#import "KaiXinDefHeader.h"
#import "MainViewController.h"
#import "NetworkDef.h"
#import "ASIHTTPRequest.h"
#import "NetworkManager.h"
#import "CJSONSerializer.h"
#import "XMLUtils.h"


@implementation AicoAppDelegate


@synthesize window=_window;


/**
 * @brief 检测新版本
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)requestCheckVersion
{    
    //huawei测试地址
    //NSString *urlString = [NSString stringWithString:@"http://119.145.9.205:18082/OUS/webService/checkVersion.action"];
    
    //cienet测试用地址
    //NSString *urlString = [NSString stringWithString:@"http://10.60.20.57:8080/testupdate/Test"];
    
    //华为正式服务器地址
    NSString *urlString = [NSString stringWithString:@"http://113.105.65.195:80/OUS/webService/checkVersion.action"]; 
    NSURL *url = [NSURL URLWithString:urlString];    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:@"GET"];    
    [request addRequestHeader:@"Content-Type" value:@"application/xml"];
    [request setAllowCompressedResponse:NO];
    
    GDataXMLElement *rootNode = [GDataXMLNode elementWithName:@"root"];
    GDataXMLElement *childNode = nil;
    GDataXMLElement *ruleAttribute = nil;
    
    //ServiceID节点
	childNode = [GDataXMLElement elementWithName:@"rule" stringValue:@"DSM"];
	ruleAttribute = [GDataXMLElement attributeWithName:@"name" stringValue:@"ServiceID"];
	[childNode addAttribute:ruleAttribute];
	[rootNode addChild:childNode];    
    
    //VersionType节点
	childNode = [GDataXMLElement elementWithName:@"rule" stringValue:@"iPhone_DSM_TTPicture_ipa"];
	ruleAttribute = [GDataXMLElement attributeWithName:@"name" stringValue:@"VersionType"];
	[childNode addAttribute:ruleAttribute];
	[rootNode addChild:childNode];    
    
    //Version节点
    NSString *versionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	childNode = [GDataXMLElement elementWithName:@"rule" stringValue:versionStr];
	ruleAttribute = [GDataXMLElement attributeWithName:@"name" stringValue:@"Version"];
	[childNode addAttribute:ruleAttribute];
	[rootNode addChild:childNode];   
    
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithRootElement:rootNode] autorelease];
    //NSLog(@"%@", document.rootElement.XMLString);
    
    NSData *xmlData = document.XMLData;
    [request appendPostData:xmlData];    
    request.userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:ECheckVersionId] forKey:@"requestId"];
    [[NetworkManager sharedNetworkManager] issueHttpRequest:request];
}


/**
 * @brief  激活信息上报
 * 只有在前一次激活失败或者版本号不同时才会上报激活信息
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)requestReportActiveInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kInfoBaseUrl,kReportInvokeInfoUrl];//todo
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.requestMethod = @"POST";
    
    UIDevice *myDevice = [UIDevice currentDevice];
    NSString *localizedModel = myDevice.localizedModel;
    NSString *systemName = myDevice.systemName;
    NSString *systemVersion = myDevice.systemVersion;
    NSString *deviceId = myDevice.uniqueIdentifier;
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *packageId = [NSString stringWithFormat:@"%@_%@_%@",@"1013",version,@"1000018"];
    NSDictionary *deviceActiveInfo = [NSDictionary dictionaryWithObjectsAndKeys:packageId,kPackageId,deviceId,kDeviceId,localizedModel,kDeviceType,[NSString stringWithFormat:@"%@%@",systemName,systemVersion],kOsVesion,[Common localTimer],kLocalActiveTime,nil];
    NSDictionary *postBodyDic = [NSDictionary dictionaryWithObject:deviceActiveInfo forKey:kDeviceActiveInfo];
    NSString *postBodyStr = [[CJSONSerializer serializer] serializeDictionary:postBodyDic];
    NSData *postBody = [postBodyStr dataUsingEncoding:NSUTF8StringEncoding];
    request.postBody = (NSMutableData *)postBody;
    request.userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:EReportActiveInfoId] forKey:kRequestId];
    [[NetworkManager sharedNetworkManager] issueHttpRequest:request];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self requestCheckVersion];
    
    if (ActiveInfoFlag && [Common isNeedActived])
    {
        //激活信息上报
        [self requestReportActiveInfo];
    }
    
    [UIApplication sharedApplication].statusBarHidden = YES;
	//创建AICO文件夹
	NSString *path = [NSString stringWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] ];
    path = [path stringByAppendingPathComponent:@"Favorite"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) 
	{
        if(![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil])
        {
            return 0;//create failure
        }
		else
		{
			/*
            //第一次创建 将工程内的图片复制到
			
			NSString *firstImageName = [[NSBundle mainBundle] pathForResource:@"First" ofType:@"png"];
			if (firstImageName != nil)
			{
				NSFileManager *fm = [NSFileManager defaultManager];
				NSError *err = nil;
				NSString *newPath = [path stringByAppendingPathComponent:@"First.png"];
				if (![fm copyItemAtPath:firstImageName toPath:newPath error:&err]) 
				{
					NSLog(@"%@", [err localizedDescription]);
					return 0;	
				}
			}
			//存储一张图片，这个文件夹里面存放上一张图片，每次保存的时候需要更新这个文件夹内容，这个文件夹只会有一张图片
			NSString *OrPath = [NSString stringWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] ];
			NSString *lastImagePath = [OrPath stringByAppendingPathComponent:@"LastImage"];
			if (![[NSFileManager defaultManager] fileExistsAtPath:lastImagePath]) 
			{
				if(![[NSFileManager defaultManager] createDirectoryAtPath:lastImagePath withIntermediateDirectories:NO attributes:nil error:nil])
				{
					return 0;
				}
				NSFileManager *fm = [NSFileManager defaultManager];
				NSError *err = nil;
				NSString *newPath = [lastImagePath stringByAppendingPathComponent:@"lastImage.png"];
				if (![fm copyItemAtPath:firstImageName toPath:newPath error:&err]) 
				{
					NSLog(@"%@", [err localizedDescription]);
					return 0;	
				}
			}
         */
            NSString *OrPath = [NSString stringWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] ];
			NSString *lastImagePath = [OrPath stringByAppendingPathComponent:@"LastImage"];
			if (![[NSFileManager defaultManager] fileExistsAtPath:lastImagePath]) 
            {
                if(![[NSFileManager defaultManager] createDirectoryAtPath:lastImagePath withIntermediateDirectories:NO attributes:nil error:nil])
				{
					return 0;
				}
            }
		}

    }

    
    ReUnManager *reUnManager = nil;
    reUnManager = [ReUnManager sharedReUnManager];
    
    // Override point for customization after application launch.
    AicoViewController *aicoViewController = [[AicoViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:aicoViewController];
    self.window.rootViewController = navController;
    [aicoViewController release];
    [navController release];
    [self.window makeKeyAndVisible];
    sleep(2);
    
    
    NSURL *fileURL = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:fileURL];
    UIImage *image = [UIImage imageWithData:data];
    [data release];
    
    if (image != nil)
    {
        MainViewController *mainViewController = [[MainViewController alloc] init];
        
        //    [Common setGlobalSrcImage:image];
        //压缩并处理图片 //modified by jiangliyin 2012-6-27 天天家园图片出现模糊
        UIImage *afterImg = image;//[Common adjustedImagePathForImage:image];
//        if (afterImg == nil)
//        {
//            afterImg = image;
//        }
        ReUnManager *ru = [ReUnManager sharedReUnManager];
        if (![ru storeImage:afterImg])
        {
            NSLog(@"critical error cannot storeImage %d", __LINE__);
        }
        ru.isLaunch = YES;
        mainViewController.srcImage = afterImg;
        [navController pushViewController:mainViewController animated:YES];
        [mainViewController release];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    ReUnManager *reUnManager = [ReUnManager sharedReUnManager];
    reUnManager.isLaunch = NO;
    //如果当前界面是魔法棒界面，则发通知到魔法棒界面
    if (reUnManager.isMagicWand)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kMagicWandNotificationEnterBackground object:nil];
        return;
    }
    UIImage *lastImage = nil;
    if (reUnManager.snapImage != nil)
    {
        lastImage = reUnManager.snapImage;
        [Common writeImageAico:lastImage withName:nil];
    }
    else
    {
        lastImage = [reUnManager getGlobalSrcImage];
        if ([reUnManager canUndo] )
        {
            [Common writeImageAico:lastImage withName:nil];//文件名为空的时候走新建保存
        }
    }
    
    //[Common writeImageAico:lastImage withName:reUnManager.currentImageName];

    
    //更新最后编辑的图片
    if (lastImage != nil) 
    {
        NSString *OrPath = [NSString stringWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] ];
        NSString *lastFloder = [OrPath stringByAppendingPathComponent:@"LastImage"];
        NSString *lastImagePath = [lastFloder stringByAppendingPathComponent:@"lastImage.png"];
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:lastImagePath error:nil];
        [UIImagePNGRepresentation(lastImage) writeToFile:lastImagePath atomically:YES];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    ReUnManager *rm = [ReUnManager sharedReUnManager];
    if (!rm.isLaunch)
    {
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        [data release];
        if (image != nil)
        {
            [Common writeImageAico:image withName:nil];
        }
        [Common showToastView:@"您有一张新图片存入了天天相册" hiddenInTime:2.0f];
    }
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}



- (void)request:(WBRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([result isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)result;
        NSLog(@"dict = %@",dict);
        NSString *userName = [dict objectForKey:@"name"];
        if (userName)
        {
            [[NSUserDefaults standardUserDefaults] setValue:userName forKey:kSinaUserName];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateSinaUserName object:userName];
        }
    }
}


- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response
{
    if ([response.param isKindOfClass:[ROUserInfoRequestParam class]])
    {
        NSString *tmpName;
        NSArray *usersInfo = (NSArray *)(response.rootObject);
        for (ROUserResponseItem *item in usersInfo) 
        {
            tmpName = item.name;
        }
        [[NSUserDefaults standardUserDefaults] setValue:tmpName forKey:kRenRenUserName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateRenRenUserName object:tmpName];
    }
}

- (void)request:(KaixinRequest *)request didLoad:(id)result
{
    NSString *userName = [result objectForKey:@"name"];
    if (userName !=nil)
    {
        //保存当前用户信息
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:userName forKey:kCurrentUserName];
        [defaults synchronize];	
        //通知更新用户信息
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateKaiXinUserName" 
                                                            object:userName];
    }
};


@end
