//
//  RenrenLoginViewController.m
//  Aico
//
//  Created by Mike on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RenrenLoginViewController.h"
#import "ExportMainViewController.h"

@implementation RenrenLoginViewController
@synthesize renren = renren_;
@synthesize isFromChangeAccount = isFromChangeAccount_;
@synthesize isFromExit = isFromExit_;

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
    
    //添加导航栏
    [Common setNavigationBarBackgroundBkg:self.navigationController.navigationBar];
    self.navigationItem.title = @"人人网";
    self.navigationController.navigationBarHidden = NO;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgImage.png"]]];
    
    //添加导航栏上取消按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel.png"] 
               forState:UIControlStateNormal];
    [cancelBtn addTarget:self
                  action:@selector(cancelOperation)
        forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelBarBtn;
    [cancelBtn release];
    [cancelBarBtn release];
    
    self.renren = [Renren sharedRenren];
    NSArray *permissions = [NSArray arrayWithObjects:@"read_user_album",@"status_update",@"photo_upload",@"publish_feed",@"create_album",@"operate_like",nil];
    if (isFromExit_)//点击退出帐号后进入本页面
    {
        //addsubview：一个定制的webview
        [self.renren authorizationWithPermisson3:permissions andDelegate:self andOnView:self.view];
    }
    else//由保存与分享页面进入，或者是点击切换帐号后进入
    {
        [self.renren authorizationWithPermisson2:permissions andDelegate:self andOnView:self.view];
    }
    self.renren.renrenDelegate = self;
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    self.renren = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/**
 * @brief  点击左上角的返回按钮
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (IBAction)cancelOperation
{
    self.renren.renrenDelegate = nil;
    if (self.isFromChangeAccount)//从退出帐号过来的
    {
        NSArray *viewController = self.navigationController.viewControllers;
        ExportMainViewController *emVC = (ExportMainViewController *)[viewController objectAtIndex:([viewController count] - 3)];
        [emVC hideRenrenSwitch];
        [self.navigationController popToViewController:(ExportMainViewController *)[viewController objectAtIndex:([viewController count] - 3)] animated:YES];
        return;
    }
    if (self.isFromExit)//从切换帐号过来的
    {
        NSArray *viewController = self.navigationController.viewControllers;
        [self.navigationController popToViewController:(ExportMainViewController *)[viewController objectAtIndex:([viewController count] - 2)] animated:YES];
    }
        [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - RenrenDelegate methods

/**
 * @brief  授权登录成功时被调用
 *
 * @param [in] renren 传回代理授权登录接口请求的Renren类型对象。
 * @param [out]
 * @return
 * @note 
 */
-(void)renrenDidLogin:(Renren *)renren
{    
    if (isFromChangeAccount_)//来自退出
    {
        if ([self.renren isSessionValid]) 
        {
            //此时已登录成功，然后发送请求人人用户名，在appdelegate中处理回调，把用户名保存到NSUserDefaults
            id appDelegate = [[UIApplication sharedApplication] delegate];
            ROUserInfoRequestParam *requestParam = [[[ROUserInfoRequestParam alloc] init] autorelease];
            requestParam.fields = [NSString stringWithFormat:@"uid,name,sex,birthday,headurl"];
            [self.renren getUsersInfo:requestParam andDelegate:appDelegate];
        }
        NSArray *viewController = self.navigationController.viewControllers;
        ExportMainViewController *emVC = (ExportMainViewController *)[viewController objectAtIndex:([viewController count] - 3)];
        [emVC hideRenrenBtn];
        [emVC setRenrenSwitchOn];
        [self.navigationController popToViewController:(ExportMainViewController *)[viewController objectAtIndex:([viewController count] - 3)] animated:YES];
    }
    else if(isFromExit_)//来自切换账号
    {
        if ([self.renren isSessionValid]) 
        {
            id appDelegate = [[UIApplication sharedApplication] delegate];
            ROUserInfoRequestParam *requestParam = [[[ROUserInfoRequestParam alloc] init] autorelease];
            requestParam.fields = [NSString stringWithFormat:@"uid,name,sex,birthday,headurl"];
            [self.renren getUsersInfo:requestParam andDelegate:appDelegate];
        }
        NSArray *viewController = self.navigationController.viewControllers;
        ExportMainViewController *emVC = (ExportMainViewController *)[viewController objectAtIndex:([viewController count] - 3)];
        [emVC hideRenrenBtn];
        [emVC setRenrenSwitchOn];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else//由保存与分享页面进入
    {
        if ([self.renren isSessionValid]) 
        {
            id appDelegate = [[UIApplication sharedApplication] delegate];
            ROUserInfoRequestParam *requestParam = [[[ROUserInfoRequestParam alloc] init] autorelease];
            requestParam.fields = [NSString stringWithFormat:@"uid,name,sex,birthday,headurl"];
            [self.renren getUsersInfo:requestParam andDelegate:appDelegate];
        }
        NSArray *viewController = self.navigationController.viewControllers;
        ExportMainViewController *emVC = (ExportMainViewController *)[viewController objectAtIndex:([viewController count] - 2)];
        [emVC hideRenrenBtn];
        [emVC setRenrenSwitchOn];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 * @brief  授权登录失败时被调用
 *
 * @param [in] renren 传回代理授权登录接口请求的Renren类型对象。
 * @param [out]
 * @return
 * @note 
 */
- (void)renren:(Renren *)renren loginFailWithError:(ROError*)error
{
    [Common showToastView:kNetWorkNotReachable hiddenInTime:2.0f];
    [self cancelOperation];
}

/**
 * @brief  接口请求成功
 *
 * @param [in] renren 传回代理授权登录接口请求的Renren类型对象。
 * @param [in] response 传回接口请求的响应
 * @param [out]
 * @return
 * @note 
 */
- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response
{
    
}

/**
 * @brief  接口请求失败
 *
 * @param [in] renren 传回代理授权登录接口请求的Renren类型对象。
 * @param [in] error 传回接口请求的错误对象
 * @param [out]
 * @return
 * @note 
 */
- (void)renren:(Renren *)renren requestFailWithError:(ROError*)error
{
    NSString* errorCode = [NSString stringWithFormat:@"Error:%d",error.code];
    NSString* errorMsg = [error localizedDescription];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:errorCode 
                                                     message:errorMsg 
                                                    delegate:nil 
                                           cancelButtonTitle:@"确定" 
                                           otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self cancelOperation];
}
@end
