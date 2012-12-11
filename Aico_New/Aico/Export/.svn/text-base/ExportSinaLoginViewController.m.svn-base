//
//  ExportSinaLoginViewController.m
//  Aico
//
//  Created by chen tao on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExportSinaLoginViewController.h"
#import "AicoAppDelegate.h"

@implementation ExportSinaLoginViewController
@synthesize wbEngine = wbEngine_;
@synthesize isExitCurrentCount = isExitCurrentCount_;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgImage.png"]]];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"新浪微博";
    
    // 添加取消按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:kEffectCancelButtonFrameRect];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelBarBtn;
    [cancelBtn release];
    [cancelBarBtn release]; 
    
    // 初始化WBEngine
    WBEngine *engine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    [engine setRootViewController:self];
    [engine setDelegate:self];
    [engine setRedirectURI:@"http://"];
    [engine setIsUserExclusive:NO];
    self.wbEngine = engine;
    [engine release];
    if (isExitCurrentCount_)
    {
        [wbEngine_ logOut];
    }
    else
    {
        [wbEngine_ logIn];
    }

    // 注册通知用于返回分享主界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back:) name:@"CancelSianLogin" object:nil];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.wbEngine = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    RELEASE_OBJECT(wbEngine_);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

#pragma mark - WBEngineDelegate Methods
- (void)engineDidLogIn:(WBEngine *)engine
{
    if (wbEngine_.userID && ![wbEngine_.userID isEqualToString:@""])
    {
        id appDelegate = [[UIApplication sharedApplication] delegate];
        //发请求获取userName
        NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kSinaAccessToken];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:accessToken, @"access_token",wbEngine_.userID,@"uid",nil];
        WBRequest *request = [WBRequest requestWithURL:kGetSinaUserNameByUserIDURL 
                                            httpMethod:@"GET" 
                                                params: params
                                          postDataType:kWBRequestPostDataTypeNone 
                                      httpHeaderFields:nil 
                                              delegate:appDelegate];
        [request connect];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HiddenSinaBtn" object:[NSNumber numberWithBool:YES]];
    [self.navigationController popViewControllerAnimated:YES];

    
}

- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    if ([engine isUserExclusive])
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
                                                           message:@"请先登出！" 
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定" 
                                                 otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    NSLog(@"didFailToLogInWithError: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"登录失败！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)engineDidLogOut:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"登出成功！" 
													  delegate:self
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)engineNotAuthorized:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"engineNotAuthorized！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"请重新登录！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}


/**
 * @brief 
 * 登录成功或者取消返回事件通知
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)back:(NSNotification *)notification
{
    //退出账户和切换账户返回流程不同
    if (isExitCurrentCount_)
    {
        NSArray *array = self.navigationController.viewControllers;
        [self.navigationController popToViewController:[array objectAtIndex:[array count] - 3] animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark - Button Action

/**
 * @brief 
 * 取消按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)cancelBtnPressed
{
    //退出账户和切换账户返回流程不同
    if (isExitCurrentCount_)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HiddenSinaBtn" object:[NSNumber numberWithBool:NO]];
        NSArray *array = self.navigationController.viewControllers;
        [self.navigationController popToViewController:[array objectAtIndex:[array count] - 3] animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
@end
