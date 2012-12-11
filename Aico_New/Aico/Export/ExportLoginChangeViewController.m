//
//  ExportLoginChangeViewController.m
//  Aico
//
//  Created by chen mengtao on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExportLoginChangeViewController.h"
#import "ExportLoginWebViewController.h"
#import "ExportLoginWebViewController.h"
#import "ExportSinaLoginViewController.h"
#import "RenrenLoginViewController.h"
#import "Reachability.h"
#import "CommonData.h"
#import "ExportKaiXinViewController.h"
#import "UIColor+extend.h"
#import "KaiXinDefHeader.h"

@implementation ExportLoginChangeViewController
@synthesize userLabel = userLabel_;
@synthesize userName = userName_;
@synthesize strTitle = strTitle_;
@synthesize accountExitBtn = accountExitBtn_;
@synthesize accountBtn = accountBtn_;
@synthesize titleLabel = titleLabel_;
@synthesize rowTag = rowTag_;
@synthesize renren = renren_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgImage.png"]]];
    self.title = self.strTitle;    
    // 添加取消按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:kEffectCancelButtonFrameRect];
    [cancelBtn setImage:[UIImage imageNamed:@"backIcon.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelBarBtn;
    [cancelBtn release];
    [cancelBarBtn release];    
    // 设置标签和按钮字体的颜色
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = [UIColor getColor:@"333333"];
    self.userLabel.font = [UIFont systemFontOfSize:16];
    self.userLabel.textColor = [UIColor getColor:@"333333"];
    self.accountBtn.titleLabel.textColor = [UIColor getColor:@"ffffff"];
    self.accountBtn.titleLabel.highlightedTextColor = [UIColor getColor:@"999999"];
    self.accountExitBtn.titleLabel.textColor = [UIColor getColor:@"ffffff"];
    self.accountExitBtn.titleLabel.highlightedTextColor = [UIColor getColor:@"999999"];
    //注册通知，更新用户名
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateUserName:) 
                                                 name:kUpdateSinaUserName 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateKaiXinUserName:) 
                                                 name:@"updateKaiXinUserName" 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateRenRenUserName:) 
                                                 name:kUpdateRenRenUserName 
                                               object:nil];
    // 读取用户名
    if (rowTag_ == 0)
    {
        NSString *strName = [[NSUserDefaults standardUserDefaults] objectForKey:kSinaUserName];
        if (strName == nil || [strName isEqualToString:@""])
        {
            strName = [[NSUserDefaults standardUserDefaults] objectForKey:kSinaUserID];
        }
        self.userLabel.text = strName;
    }
    else if (rowTag_ == 1)
    {
        NSString *strName = [[NSUserDefaults standardUserDefaults] valueForKey:@"QQuserName"];
        self.userLabel.text = strName;
    } 
    else  if(rowTag_ == 2)
    {
        //获取用户名
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *userName = [defaults objectForKey:kCurrentUserName];
        self.userLabel.text = userName;
    }
    else if(rowTag_ == 3)
    {
        //人人网
        self.renren = [Renren sharedRenren];
        NSString *strName = [[NSUserDefaults standardUserDefaults] valueForKey:kRenRenUserName];
        self.userLabel.text = strName;
    }
 }

- (void)viewWillAppear:(BOOL)animated 
{
	[super viewWillAppear:animated];
    if (rowTag_ == 0)
    {
        NSString *strName = [[NSUserDefaults standardUserDefaults] objectForKey:kSinaUserName];
        if (strName == nil || [strName isEqualToString:@""])
        {
            strName = [[NSUserDefaults standardUserDefaults] objectForKey:kSinaUserID];
        }
        self.userLabel.text = strName;
    }
    else if (rowTag_ == 1)
    {
        NSString *strName = [[NSUserDefaults standardUserDefaults] valueForKey:@"QQuserName"];
        self.userLabel.text = strName;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.userName = nil;
    self.userLabel = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.userLabel = nil;
    self.titleLabel = nil;
    self.accountBtn = nil;
    self.accountExitBtn = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc 
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [userName_ release];
    [userLabel_ release];
    [strTitle_ release];
    self.renren = nil;
    [titleLabel_ release];
    [accountBtn_ release];
    [accountExitBtn_ release];
    [super dealloc];
}

#pragma mark - Button Action
/**
 * @brief 
 * 切换账户按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (IBAction)changeAccount:(id)sender
{
    if (NotReachable == [[Reachability reachabilityForInternetConnection] currentReachabilityStatus]) 
    {
        [Common showToastView:kNetWorkNotReachable hiddenInTime:2.0f];
        return;
    }
    if (self.rowTag == 0) 
    {
        ExportSinaLoginViewController *exprtSinaCtrl = [[ExportSinaLoginViewController alloc] init];
        [self.navigationController pushViewController:exprtSinaCtrl animated:YES];
        [exprtSinaCtrl release];
    } 
    else if(self.rowTag == 1) 
    {
        ExportLoginWebViewController *exportLoginWebViewController = [[ExportLoginWebViewController alloc] init];  
        [self.navigationController pushViewController:exportLoginWebViewController animated:YES];
        [exportLoginWebViewController release];
    } 
    else if(rowTag_ == 2)
    {
        ExportKaiXinViewController *kaixinViewController = [[ExportKaiXinViewController alloc] init];
        kaixinViewController.bChangeAccount = YES;
        [self.navigationController pushViewController:kaixinViewController animated:YES];
        [kaixinViewController release];
    }
    else if(self.rowTag == 3)
    {
        //人人网
        RenrenLoginViewController *rrlVC = [[RenrenLoginViewController alloc]init];
        rrlVC.isFromExit = YES;
        [self.navigationController pushViewController:rrlVC animated:YES];
        [rrlVC release];
    }
}
/**
 * @brief 
 * 退出账户按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (IBAction)exitAccount:(id)sender 
{
    //判断网络状况
    if (NotReachable == [[Reachability reachabilityForInternetConnection] currentReachabilityStatus]) 
    {
        [Common showToastView:kNetWorkNotReachable hiddenInTime:2.0f];
        return;
    }
    if (self.rowTag == 0) 
    {
        ExportSinaLoginViewController *exprtSinaCtrl = [[ExportSinaLoginViewController alloc] init];
        exprtSinaCtrl.isExitCurrentCount = YES;
        [self.navigationController pushViewController:exprtSinaCtrl animated:YES];
        [exprtSinaCtrl release];
    } 
    else if(self.rowTag == 1) 
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowButton" object:nil];
        ExportLoginWebViewController *exportQQLogin = [[ExportLoginWebViewController alloc] init];
        exportQQLogin.isExitCurrentCount = YES;
        [self.navigationController pushViewController:exportQQLogin animated:YES];
        [exportQQLogin release];
    } 
    else  if(rowTag_ == 2)
    {
//        [[CommonData sharedData].kaixin logout:self];   
        ExportKaiXinViewController *kaiXinViewController = [[ExportKaiXinViewController alloc] init];
        kaiXinViewController.bChangeAccount = NO;
        [self.navigationController pushViewController:kaiXinViewController animated:YES];
        [kaiXinViewController release];
//        [kaiXinViewController logout];        
    }  
    else if(self.rowTag == 3)
    {
        //人人网
        [self.renren logout:self];
        RenrenLoginViewController *rrlVC = [[RenrenLoginViewController alloc]init];
        rrlVC.isFromChangeAccount = YES;
        [self.navigationController pushViewController:rrlVC animated:YES];
        [rrlVC release];
        isFromExit_ = YES;
    }
}

//开心网退出登陆成功
- (void)kaixinDidLogout:(NSNotification *)notification
{
//    [self.navigationController popViewControllerAnimated:YES];
//    ExportKaiXinViewController *loginViewController = [[ExportKaiXinViewController alloc] init];
//    [self.navigationController pushViewController:loginViewController animated:YES];
//    loginViewController.bChangeAccount = YES;
//    loginViewController.bExitAccount = YES;
//    [loginViewController release];
    
}
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
    [self.navigationController popViewControllerAnimated:YES];
}
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
    if (isFromExit_)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
}
/**
 * @brief 通知更新sina用户名 回调函数
 * 当获取用户名成功时，会发更新用户名通知，
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)updateUserName:(NSNotification *)notification
{
    NSString *userName = notification.object;
    self.userLabel.text = userName;
}
//更新KaiXin用户名
- (void)updateKaiXinUserName:(NSNotification *)notification
{
    NSString *userName = notification.object;
    self.userLabel.text = userName;
}

/**
 * @brief 更新人人用户名
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
-(void)updateRenRenUserName:(NSNotification *)notification
{
    NSString *userName = notification.object;
    self.userLabel.text = userName;
}

@end
