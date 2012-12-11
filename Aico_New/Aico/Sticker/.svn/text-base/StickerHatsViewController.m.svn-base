//
//  StickerHatsViewController.m
//  Aico
//
//  Created by Yincheng on 12-5-10.
//  Copyright (c) 2012年 x. All rights reserved.
//

#import "StickerHatsViewController.h"
#import "MainViewController.h"
#import "ReUnManager.h"
#import "StickerMainViewController.h"
#import "UIColor+extend.h"
#import "NSData+extend.h"
#import "Common.h"
#import "GlobalDef.h"
#import "NSData+QBase64.h"
#import "NetworkDef.h"
#import "ASIHTTPRequest.h"
#import "CJSONSerializer.h"
#import "NetworkManager.h"

#define kDefaultTag 6000

@implementation StickerHatsViewController
@synthesize stringName = stringName_;
@synthesize imageNum = imageNum_;
@synthesize isStickerReplace = isStickerReplace_;
@synthesize contentCode = contentCode_;
@synthesize isNeedDownload = isNeedDownload_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
/**
 * @brief 导航栏初始化 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)initNavigation
{
    self.navigationController.navigationBarHidden = NO;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgImage.png"]]];
    [Common setNavigationBarBackgroundBkg:self.navigationController.navigationBar];
    self.navigationItem.title = self.stringName;
    
    //添加返回按钮
    UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, -5, 30, 30)];
    [returnBtn setImage:[UIImage imageNamed:@"backIcon.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self 
                  action:@selector(returnButtonPressed:) 
        forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *returnBarBtn = [[UIBarButtonItem alloc] initWithCustomView:returnBtn];
    self.navigationItem.leftBarButtonItem = returnBarBtn;
    [returnBtn release];
    [returnBarBtn release];
    
    //添加退出按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:kEffectConfirmButtonFrameRect];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cancelmBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.rightBarButtonItem = cancelmBarBtn;
    [cancelmBarBtn release];
    [cancelBtn release];
}

- (void)showToastView:(NSString *)str
{
    [Common showToastView:str hiddenInTime:2.0f];
}

/**
 * @brief 取消alertview 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)clearAlertView
{
    if (activityIndicatorView_)
    {
        if ([activityIndicatorView_ isAnimating]) 
        {
            [activityIndicatorView_ stopAnimating];
        }
        [activityIndicatorView_ release],activityIndicatorView_ = nil;
    }
    if (alterView_) 
    {
        [alterView_ dismissWithClickedButtonIndex:0 animated:YES];
        [alterView_ release],alterView_ = nil;
    }
}
/**
 * @brief 取消alertview 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)cancelAlertView:(NSNotification *)notification
{
    [self performSelector:@selector(clearAlertView) withObject:nil afterDelay:1.5f];
    NSString *str = notification.object;
    if (str && ![str isEqualToString:@""])
    {
        [self performSelector:@selector(showToastView:) withObject:str afterDelay:0.75f];
    }
    
}
/**
 * @brief 解压svgz图片 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)compressSVGZfile:(NSNotification *)notification
{
    NSString *path = [Common downloadDirectory];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",self.contentCode]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) 
	{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        NSArray *fileList =  [fileManager subpathsOfDirectoryAtPath:path error:&error];

        if ([fileList count] > 0) 
        {
            imageNum_ = 0;
            for (NSString *svgzName in fileList) 
            {
                if ([svgzName hasSuffix:@"svgz"]) 
                {
                    ++imageNum_;
                    //获取svgz路径
                    NSString *newPath = [path stringByAppendingPathComponent:svgzName];
                    //将svgz转化为data数据格式
                    NSData *data = [NSData dataWithContentsOfFile:newPath];
                    NSData *newData = [NSData uncompressData:data];
                    //默认为1.svg
                    NSString *lastPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.svg",imageNum_]];
                    [newData writeToFile:lastPath atomically:YES];
                }
            }
            
            //将count写如countNum.xml中
            NSString *countNumXmlPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"countNum.xml"]];
            
            NSDictionary *itemInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",imageNum_],kCountNum, nil];
            [itemInfo writeToFile:countNumXmlPath atomically:YES];
            [itemInfo release];
        }
        [self addStickerPictrue];
    }
    else
    {
        //解压svgz失败，取消提示
        [self clearAlertView];
    }
}
/**
 * @brief 隐藏webview的背景 
 * @param [in] 图片文件名
 * @param [out]
 * @return
 * @note 
 */
- (void)hideGradientBackground:(UIView*)theView
{
    for (UIView * subview in theView.subviews)
    {
        if ([subview isKindOfClass:[UIImageView class]])
            subview.hidden = YES;
        [self hideGradientBackground:subview];
    }
}

/**
 * @brief 添加装饰图片 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)addStickerPictrue
{
   
    //默认加载12个装饰图
    imageNum_ = (imageNum_ <= 0) ? 12 : imageNum_;
    //装饰图个数不为3倍数时，补全
    imageNum_ = (imageNum_%3 == 0) ? imageNum_ : ((imageNum_/3+1)*3);
    //重设scrollview
    scrollView_.contentSize = CGSizeMake(320, (imageNum_/3)*106);
        
    for (int index=1; index<=imageNum_; index++) 
    {
        NSString *path = [Common downloadDirectory];
        path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/",self.contentCode]];
        NSString *imageStr = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.svg",index]];
        UIButton *imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(1+((index-1)%3)*106, ((index-1)/3)*106, 106, 106)];
        
//        CALayer *layer = [imageBtn layer];
//        layer.borderColor = [[UIColor whiteColor] CGColor];
//        layer.borderWidth = 1.0f;
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:imageStr]) 
        {
            CGSize size = [Common parseLoginResAndSaveInfo:imageStr];
            int nwidth = size.width;
            int nheight = size.height;
            
            if (nwidth>=nheight) 
            {
                nheight = (nheight*75)/nwidth;
                nwidth = 75;
            }
            else 
            {
                nwidth = (nwidth*75)/nheight;
                nheight = 75;
            }
            
            NSString *HTMLData = nil;
            int marginTop = (106 - nheight)/2;
            
            //直接读取方法
            if (1) 
            {
                HTMLData = [NSString stringWithFormat:@" \
                            <div align='center' style='margin-top:%dpx'> \
                            <img src='%@' alt='picture' width='%dpx' height='%dpx'> \
                            </div> \
                            ",marginTop,imageStr,nwidth,nheight];
            }
            
            //使用nsdata方法 base64
            if (0) 
            {
                NSData* imageData = [[NSData alloc] initWithContentsOfFile:imageStr];
                NSString* imageString = [imageData base64EncodedString];
                HTMLData = [NSString stringWithFormat:@" \
                            <div align='center' style='margin-top:%dpx'> \
                            <img src='data:image/svg+xml;base64,%@' alt='picture' width='%dpx' height='%dpx'> \
                            </div> \
                            ",marginTop,imageString,nwidth,nheight];
                [imageData release];
            }
            
            UIWebView *webView = [[UIWebView alloc] initWithFrame:imageBtn.bounds];
            [webView loadHTMLString:HTMLData baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
            webView.userInteractionEnabled = NO;
            
            //最后一个webview加载完后，需要取消转圈
            if (index == imageNum_) 
            {
                webView.delegate = self;
            }
            
            webView.backgroundColor = [UIColor clearColor];
            webView.opaque = NO;
            [self hideGradientBackground:webView];
            [imageBtn addSubview:webView];
            
            imageBtn.tag = kDefaultTag + index;
            imageBtn.showsTouchWhenHighlighted = YES;
            [imageBtn addTarget:self action:@selector(chooseSticker:) forControlEvents:UIControlEventTouchUpInside];
            [webView release];
        }
        else 
        {
            [imageBtn setEnabled:NO];
            //加载svg图片失败，取消提示
            [self clearAlertView];
        }

        imageBtn.backgroundColor = [UIColor clearColor];
        [scrollView_ addSubview:imageBtn];
        [imageBtn release];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self performSelector:@selector(clearAlertView) withObject:nil afterDelay:1.0f];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self performSelector:@selector(clearAlertView) withObject:nil afterDelay:1.0f];
}

- (void)refreshStickerDetailList:(NSNotification *)notification
{
    //刷新列表  如果request的userinfo中的kSubcategory值与成员变量subCatagory_的值相等时，才刷新列表
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initNavigation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshStickerDetailList:) name:kRefreshStickerDetailListNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestDownloadStickerImageList:) name:kDownloadStickerImageListNotification object:nil];
    
    //如果zip包解压开来，开始进行svgz解压
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(compressSVGZfile:) name:kUncompressSVGZNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelAlertView:) name:kServerErrorNotification object:nil];
    
    scrollView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, 320, 435)];
    [scrollView_ setBackgroundColor:[UIColor getColor:@"eeeeee"]];
    [self.view addSubview:scrollView_];
    
    imageNum_ = 0;
    
    NSString *path = [Common downloadDirectory];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",self.contentCode]];
    //将count写如countNum.xml中
    NSString *countNumXmlPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"countNum.xml"]];
    
    if (!self.isNeedDownload) 
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:countNumXmlPath]) 
        {
            activityIndicatorView_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            activityIndicatorView_.center = self.view.center;
            [activityIndicatorView_ startAnimating];
            [self.view addSubview:activityIndicatorView_];

            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:countNumXmlPath];
            NSString *strCount = [dict objectForKey:kCountNum];
            if (strCount && ![strCount isEqualToString:@""] && [strCount intValue]>0)
            {
                self.imageNum = [strCount intValue];
                [self addStickerPictrue];
            }
            else 
            {
                [self compressSVGZfile:nil];
            }
        }
    }
    else
    {
        if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable)
        {
            alterView_ = [[UIAlertView alloc] initWithTitle:@"正在下载图片..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [alterView_ show];
            activityIndicatorView_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//            activityIndicatorView_.center = CGPointMake(alterView_.bounds.size.width / 2.0f, alterView_.bounds.size.height - 40.0f);
            [activityIndicatorView_ startAnimating];
            [alterView_ addSubview:activityIndicatorView_];
            activityIndicatorView_.center = CGPointMake(alterView_.bounds.size.width / 2.0f, alterView_.bounds.size.height - 40.0f);
        }
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) 
        {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
        [self requestStickerDetailList];
    }
  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    RELEASE_OBJECT(scrollView_);
    [self clearAlertView];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    RELEASE_OBJECT(scrollView_);
    self.stringName = nil;
    self.contentCode = nil;
    [self clearAlertView];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/**
 * @brief 返回按钮处理 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)returnButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * @brief 取消按钮处理 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)cancelButtonPressed:(id)sender
{
    NSArray *viewController = self.navigationController.viewControllers;
    if (isStickerReplace_) 
    {
        [self.navigationController popToViewController:(StickerMainViewController *)[viewController objectAtIndex:([viewController count] - 3)] animated:YES];
    }
    else
    {
        //清除保存装饰操作的字典，此步必须做
        [[ReUnManager sharedReUnManager] clearAllStickers];
        [self.navigationController popToViewController:(MainViewController *)[viewController objectAtIndex:([viewController count] - 3)] animated:YES];  
    }
}

/**
 * @brief 点击装饰处理 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)chooseSticker:(id)sender
{
    NSLog(@"chooseSticker");
    UIButton *imageBtn = (UIButton *)sender;
    NSString *path = [Common downloadDirectory];
    NSString *imageStr = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%d.svg",self.contentCode,imageBtn.tag-kDefaultTag]];
    
    if (isStickerReplace_) 
    {
        [[ReUnManager sharedReUnManager] replaceLastStickerWithImageName:imageStr];
        NSArray *viewController = self.navigationController.viewControllers;
        [[NSNotificationCenter defaultCenter] postNotificationName:kStickerNotificationCenter object:nil];
        [self.navigationController popToViewController:(StickerMainViewController *)[viewController objectAtIndex:([viewController count] - 3)] animated:YES];
    }
    else
    {
        [[ReUnManager sharedReUnManager] addOneStickerToArray:imageStr];
        StickerMainViewController *main = [[StickerMainViewController alloc] init];
        [self.navigationController pushViewController:main animated:YES];
        [main release];  
    }
}

/**
 * @brief 请求装饰图片列表 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)requestStickerDetailList
{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        [Common showToastView:@"无法获取下载地址，未连接网络" hiddenInTime:2.0f];
        [self clearAlertView];
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kStickerBaseUrl,kGetDownloadUrl];//todo
//    urlString = [urlString stringByAppendingFormat:@"contentCode=%@&payType=1&isDemo=0&fileType=0",self.contentCode];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.requestMethod = @"POST";
    NSDictionary *postBodyDic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"payType",@"0",@"isDemo", self.contentCode,kContentCode,@"0",@"fileType",nil];
    NSString *postBodyStr = [[CJSONSerializer serializer] serializeDictionary:postBodyDic];
    NSData *postBody = [postBodyStr dataUsingEncoding:NSUTF8StringEncoding];
    request.postBody = (NSMutableData *)postBody;
    NSDictionary *dlInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:EStickerDetailListId],kRequestId, self.contentCode,kContentCode,nil];
    request.userInfo = dlInfo;
    
    [[NetworkManager sharedNetworkManager] issueHttpRequest:request];
}

/**
 * @brief 请求装饰图片列表 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)requestDownloadStickerImageList:(NSNotification *)notification
{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        [Common showToastView:@"无法下载装饰图片，未连接网络" hiddenInTime:2.0f];
        //网络异常，取消提示框
        [self clearAlertView];
        return;
    }
    NSDictionary *infoDic = notification.object;
    if ([[infoDic objectForKey:kContentCode] isEqualToString:self.contentCode])
    {
        NSString *downloadURL = [infoDic objectForKey:@"downloadURL"];

        NSString *downloadURLStr = [downloadURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:downloadURLStr];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        request.requestMethod = @"POST";
        
        NSString *downloadPath = [[Common downloadDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",self.contentCode]];
        NSString *path = [[[NSString alloc] initWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]] autorelease];
        NSString *tempPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",self.contentCode]];
        [request setDownloadDestinationPath:downloadPath];
        [request setTemporaryFileDownloadPath:tempPath];
        NSDictionary *dlInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:EDownloadIconRequestId],kRequestId, self.contentCode,kContentCode,@"stickerImages",@"module",nil];
        request.userInfo = dlInfo;

        [[NetworkManager sharedNetworkManager] issueHttpRequest:request];
    }
    
}
@end
