//
//  ExportKaiXinViewController.m
//  Aico
//
//  Created by rongtaowu on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ExportKaiXinViewController.h"
#import "CommonData.h"
#import "KaixinConnect.h"
#import "KaiXinDefHeader.h"
#import "AicoAppDelegate.h"


@interface ExportKaiXinViewController ()
- (void)cancelOperation;
@end

@implementation ExportKaiXinViewController
@synthesize kaixin = kaixin_;
@synthesize delegate = delegate_;
@synthesize bChangeAccount = bChangeAccount_;
@synthesize bExitAccount = bExitAccount_;

/**
 * @brief  初始化共享模块
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)initKaiXinMoudle
{
    if (kaixin_ == nil)
    {
        kaixin_ = [[Kaixin alloc] initWithAppId:kAppId 
                                    reDirectURL:kRedirectURL 
                                      secretKey:kSecretKey];
    }
    
    [kaixin_ authorizeDelegate:self];
}

/**
 * @brief  初始化
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        [self initKaiXinMoudle];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(showAictivitiyView:) 
                                                     name:kShowKaiXinActivityView
                                                   object:nil];
        activityView_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return self;
}

/**
 * @brief  析构操作
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)dealloc
{
    [kaixin_ release];
    [displayWebView_ release];
    [activityView_ release];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:kShowKaiXinActivityView 
                                                  object:nil];
    [super dealloc];
}

/**
 * @brief  初始化操作
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"开心网";
    displayWebView_ = [[kaixin_ getRequestView] retain];
    displayWebView_.frame = CGRectMake(0, 44, 320, 480);
    [self.view addSubview:displayWebView_];
    
    //设置等待显示
    activityView_.center = self.view.center;
    [self.view addSubview:activityView_];
    [activityView_ startAnimating];
    
    //添加返回按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, -5, 30, 30)];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self 
                  action:@selector(cancelOperation) 
        forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelBarBtn;
    [cancelBtn release];
    [cancelBarBtn release];
    
    //设置页面背景
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgImage.png"]]];
    if (bChangeAccount_)
    {
        [self updateView];
        
    }
    else
    {
        [self logout];
    }
}

/**
 * @brief  收到内存告警操作
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)viewDidUnload
{
    [kaixin_ release],kaixin_ = nil;
    [super viewDidUnload];
}

/**
 * @brief  屏幕旋转
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/**
 * @brief 退出操作
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)cancelOperation
{    
    
    if (!bChangeAccount_ )
    {
        NSArray *allViewController = [self.navigationController viewControllers];
        UIViewController *dstController = [allViewController objectAtIndex:[allViewController count] - 3];
        [self.navigationController popToViewController:dstController animated:YES];
    }
    else 
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 * @brief 显示旋转等待
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)showAictivitiyView:(NSNotification *)notification
{
    NSString *stringValue = [notification object];
    if ([stringValue isEqualToString:kShowView]) {
        [activityView_ startAnimating];
        
    }
    else if([stringValue isEqualToString:kHideView]){
        [activityView_ stopAnimating];
    }
}
#pragma mark -LogicFunc

/**
 * @brief 登陆成功回调
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)KaixinDidLogin
{  
    NSLog(@"Login Sucess");
   
    [[NSNotificationCenter defaultCenter] postNotificationName:kKaiXinLogoutSucess 
                                                        object:[NSNumber numberWithBool:YES]];
    
    //切换账号或保存的账号信息为空时容许更新信息
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *userInfo = [defaults objectForKey:kCurrentUserName];
    if (bChangeAccount_ ||userInfo == nil)
    {
        [self getUserInfo];
    }
    [self cancelOperation];
    
}

/**
 * @brief  登陆失败
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
-(void)KaixinDidNotLogin:(BOOL)cancelled
{
    NSLog(@"did not login");
}

/**
 * @brief 退出登陆
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)KaixinDidLogout 
{
    //退出后删除保存用户信息
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kCurrentUserName];
    [defaults synchronize];	
    [[NSNotificationCenter defaultCenter] postNotificationName:kKaiXinLogoutSucess 
                                                        object:[NSNumber numberWithBool:NO]];
 
    [self updateView];
    
    
}

/**
 * @brief 收到网络回应
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)request:(KaixinRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"received response");
}

/**
 * @brief  请求完成
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)request:(KaixinRequest *)request didLoad:(id)result
{
    [CommonData sharedData].uid = [[result objectForKey:@"rid"] intValue];  
    if ([CommonData sharedData].uid) 
    {
        [delegate_ publishSucess];
    }
    else 
    {
        [delegate_ publishFailed];
        
    };
    
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
        bChangeAccount_ = NO;
    }
};

/**
 * @brief  请求失败
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)request:(KaixinRequest *)request didFailWithError:(NSError *)error 
{
	NSLog(@"didFailWithError is :%@",  [error localizedDescription]);
     [delegate_ publishFailed];
};
#pragma mark - CreateRecord

/**
 * @brief 发表操作实现
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)pubilishRecord:(NSDictionary *)content
{
    NSString *UIDString = [NSString stringWithFormat:@"%d", [[CommonData sharedData] uid]];
    NSString *contentString = [content objectForKey:@"content"];
    UIImage  *image = [content objectForKey:@"pic"];
    
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:
								 UIDString,@"uid",
                                 contentString,@"content",
                                 image,@"pic",
    							 nil];
    [kaixin_ requestWithSeparateURL:kAddRecordURL 
                             params:params 
                      andHttpMethod:@"POST" 
                        andDelegate:self];
}

/**
 * @brief  获取用户信息实现
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)getUserInfo
{
    id appDelegate = [[UIApplication sharedApplication] delegate];
//    NSString* requestURL = @"https://api.kaixin001.com/users/me.json";
    [kaixin_ requestWithSeparateURL:kGetUserInfoURL 
                      andHttpMethod:@"GET" 
                        andDelegate:appDelegate];
}

/**
 * @brief  退出登陆
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)logout
{
    [kaixin_ logout:self];
}

/**
 * @brief  更新网页视图
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)updateView
{
    [self initKaiXinMoudle];
    [kaixin_ authorizeWithKXAppAuth];

    displayWebView_ = [[kaixin_ getRequestView] retain];
    displayWebView_.frame = CGRectMake(0, 44, 320, 480);
    [self.view addSubview:displayWebView_];
    [self.view bringSubviewToFront:activityView_];
}

@end
