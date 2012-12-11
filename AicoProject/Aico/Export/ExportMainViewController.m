//
//  ExportMainViewController.m
//  Aico
//
//  Created by chen mengtao on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExportMainViewController.h"
#import "ExportLoginWebViewController.h"
#import "QWeiboAsyncApi.h"
#import "ExportLoginChangeViewController.h"
#import "ReUnManager.h"
#import "ExportItemCell.h"
#import "UIColor+extend.h"
#import "ExportSinaLoginViewController.h"
#import "ExportKaiXinViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "KaiXinDefHeader.h"
#import "ReUnManager.h"

#import "WBSendView.h"
#import "Common.h"
#import "RenrenLoginViewController.h"
#import "CJSONDeserializer.h"
#import "Reachability.h"
#import "GlobalDef.h"

#define kEffectShareButtonFrameRect      CGRectMake(5, 7, 60, 30)
#define BUTTON(Tag)  (UIButton *)[self.view viewWithTag:Tag]
#define SWITCH(Tag)  (UISwitch *)[self.view viewWithTag:Tag]

#define EEConfigureBtnHidden  @"HiddenBtn"
#define EEConfigureBtnShow    @"ShowButton"

#define kActivitySuperViewTag  4857
#define kActivitySuperWindowTag 4765

// 选择分享的方式
typedef enum {
    SelectExportWBSinaLogin,
    SelectExportWBQQLogin,
    SelectExportKaiXinLogin,
    SelectExportRenrenLogin,
} SelectExportWBLogin;

typedef enum {
    EExportSinaConfigureBtnTag=101,
    EExportQQConfigureBtnTag,
    EExportKXConfigureBtnTag,
    EExportRRConfigureBtnTag,
    EExportSinaSwitchTag,
    EExportQQSwitchTag,
    EExportKaiXinSwitchTag,
    EExportRRSwitchTag,
} WBBtnTag;

@implementation ExportMainViewController

@synthesize titleLabel;
@synthesize storeImgBtn = storeImgBtn_;
@synthesize imageName = imageName_;
@synthesize shareWBName = shareWBName_;
@synthesize tableView = tableView_;
@synthesize storeImage = storeImage_;
@synthesize imageView = imageView_;
@synthesize contentView = contentView_;
@synthesize connection = connection_;
@synthesize responseData = responseData_;
@synthesize renren = renren_;
@synthesize toAimiButton = toAimiButton_;

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
    btnTag_ = 101;
    switchTag_ = 105;
	bSending = NO;	
    // wzf
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];    
    self.navigationItem.title = @"保存与分享";
    self.navigationController.navigationBarHidden = NO;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgImage.png"]]];    
    // 添加取消按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:kEffectCancelButtonFrameRect];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelBarBtn;
    [cancelBtn release];
    [cancelBarBtn release];    
    // 添加分享按钮
    UIBarButtonItem *shareBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIControlStateNormal target:self action:@selector(shareBtnPressed)];
    shareBarBtn.style = UIBarButtonItemStylePlain;
    self.navigationItem.rightBarButtonItem = shareBarBtn;
    [shareBarBtn release];
    // 初始化微博名称和微博图片名称
    NSArray *shareName = [[NSArray alloc] initWithObjects:@"新浪微博", @"腾讯微博", @"开心网", @"人人网", nil];
    self.shareWBName = shareName;
    [shareName release];    
    NSArray *imageCellName = [[NSArray alloc] initWithObjects:@"shareSinaIco.png", @"shareQQIco.png", @"shareKaiXinIco.png", @"shareRenRenIco.png", nil];
    self.imageName = imageCellName;
    [imageCellName release];    
    // 显示分享的图片
    // wzf
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 8;
    imageView_.image = self.storeImage;    
    // 注册通知用于隐藏按钮
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(hiddenQQBtn) 
                                                 name:EEConfigureBtnHidden 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(showBtn) 
                                                 name:EEConfigureBtnShow 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(hiddenSinaBtn:) 
                                                 name:@"HiddenSinaBtn" 
                                               object:nil];    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(logoutSucess:) 
                                                 name:kKaiXinLogoutSucess 
                                               object:nil];
    // 设置按钮和标签字体的颜色
    storeImgBtn_.titleLabel.textColor = [UIColor getColor:@"ffffff"];
    storeImgBtn_.titleLabel.highlightedTextColor = [UIColor getColor:@"999999"];
    toAimiButton_.titleLabel.textColor = [UIColor getColor:@"ffffff"];
    toAimiButton_.titleLabel.highlightedTextColor = [UIColor getColor:@"999999"];  
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.textColor = [UIColor getColor:kEffectButtonDeselectStringColor];  
    
    accountInfoDict_ = [[NSMutableDictionary alloc] initWithCapacity:0];  
    //分享到人人网
    if ([[NSUserDefaults standardUserDefaults] valueForKey:kRenRenUserName] == nil)
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:kRenRenUserName];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.renren = [Renren sharedRenren];
    if ([self.renren isSessionValid]) 
    {
        //如果session有效，隐藏配置按钮，把switch的状态恢复到上次退出时状态
        [self hideRenrenBtn];
        NSNumber *switchStatus = [[NSUserDefaults standardUserDefaults] objectForKey:kRenRenSwitchStatus];
        UISwitch *swt = SWITCH(EExportRRSwitchTag);
        [swt setOn:[switchStatus boolValue]];
    }
    else
    {
        [self hideRenrenSwitch];
    }
    kaiXinViewController_ = [[ExportKaiXinViewController alloc] init];
    kaiXinViewController_.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.imageView = nil;
    self.contentView = nil;
    self.connection = nil;
    self.responseData = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.tableView = nil;
    self.shareWBName = nil;
    self.imageName = nil;
    self.storeImgBtn = nil;
    self.titleLabel = nil;
    RELEASE_OBJECT(kaiXinViewController_);
    self.toAimiButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    self.storeImage = nil;
    self.imageView = nil;
    self.contentView = nil;
    self.connection = nil;
    self.responseData = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.tableView = nil;
    self.shareWBName = nil;
    self.imageName = nil;
    self.storeImgBtn = nil;
    self.renren = nil;
    [kaiXinViewController_ release];
    RELEASE_OBJECT(accountInfoDict_);
    RELEASE_OBJECT(sinaWBEngine_);
    [super dealloc];
}

#pragma mark - TableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    static NSString  *simpleTableIdentifier = @"simpleTableIdentifier";
    ExportItemCell *cell = (ExportItemCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (nil == cell) 
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExportItemCell" owner:self options:nil];
		for (id oneObj in nib)
        {
			if ([oneObj isKindOfClass:[ExportItemCell class]]) 
            {
                cell = (ExportItemCell *)oneObj;
				break;
            }
		}
    }
    
    cell.wbNameLabel.text = [self.shareWBName objectAtIndex:row];
    cell.wbNameLabel.font = [UIFont systemFontOfSize:16];
    cell.wbNameLabel.textColor = [UIColor getColor:@"333333"];
    cell.wbNameLabel.highlightedTextColor = [UIColor getColor:@"ffffff"];
    cell.imageView.image = [UIImage imageNamed:[self.imageName objectAtIndex:row]];
    cell.configureBtn.tag = btnTag_++;
    cell.sharefunSwitch.tag = switchTag_++;
    [cell.configureBtn addTarget:self action:@selector(ConfigurePressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.sharefunSwitch addTarget:self action:@selector(doSwitch:) forControlEvents:UIControlEventValueChanged];
    if (row == 0)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSNumber *expireTime = [[NSUserDefaults standardUserDefaults] objectForKey:kSinaExpireTime];
		double nowTime = [[NSDate date] timeIntervalSince1970];
        if (nowTime > [expireTime doubleValue])
        {            
            cell.configureBtn.hidden = NO;
            cell.sharefunSwitch.hidden = YES;
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kSinaAccessToken];
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kSinaUserID];
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithDouble:0] forKey:kSinaExpireTime];
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kSinaUserName];
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:kSinaSwitchStatus];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        else
        {
            NSString *sinaAccessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kSinaAccessToken];
            if (sinaAccessToken && ![sinaAccessToken isEqualToString:@""])
            {
                NSNumber *switchStatus = [[NSUserDefaults standardUserDefaults] objectForKey:kSinaSwitchStatus]; 
                cell.configureBtn.hidden = YES;
                cell.sharefunSwitch.hidden = NO;
                if (switchStatus)
                {
                    [cell.sharefunSwitch setOn:[switchStatus boolValue]];
                }
                else
                {
                    [cell.sharefunSwitch setOn:YES];
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            }
        }
        
    }
    else if (row == 1)
    {
        NSString *QQToken = [[NSUserDefaults standardUserDefaults] objectForKey:AppTokenKey];
        if (QQToken && ![QQToken isEqualToString:@""])
        {
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            
            NSNumber *switchStatus = [[NSUserDefaults standardUserDefaults] objectForKey:kQQSwitchStatus]; 
            cell.configureBtn.hidden = YES;
            cell.sharefunSwitch.hidden = NO;
            if (switchStatus)
            {
                [cell.sharefunSwitch setOn:[switchStatus boolValue]];
            }
            else
            {
                [cell.sharefunSwitch setOn:YES];
            }            
        }
        else
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.configureBtn.hidden = NO;
            cell.sharefunSwitch.hidden = YES;
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:AppTokenKey];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:AppTokenSecret];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"QQuserName"];
        }
    }
    else if (row == 2) 
    {
        //获取开心网保存token
        NSString *kaixinToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"access_Token"];
        BOOL kaixinTokenValid = [self checkDateValid];
    
        if (!kaixinTokenValid)
        {
//             [Common showToastView:@"开心网授权过期，请重新配置" hiddenInTime:2.0f]; 
            //清楚保存的数据
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults removeObjectForKey:@"access_Token"];
            [defaults removeObjectForKey:@"refresh_Token"];   
            [defaults removeObjectForKey:@"kaixin_expiration_Date"];
            [defaults synchronize]; 
        };
        
        if (kaixinToken != nil && kaixinTokenValid)
        {           
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            
            cell.configureBtn.hidden = YES;
            cell.sharefunSwitch.hidden = NO;
            //设置开关状态
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *strValue = [defaults objectForKey:kKainXinSwitchState];
            BOOL switchState = [strValue boolValue];   
            [cell.sharefunSwitch setOn:switchState];
        }
        else
        {    
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.configureBtn.hidden = NO;
            cell.sharefunSwitch.hidden = YES;
        }
    }
    else if (row == 3)//人人网
    {
        //必须加下面这句代码，因为进入本页面，先走cellforrow，然后才是viewdidload, 此时renren_尚未赋值。
        self.renren = [Renren sharedRenren];
        if ([self.renren isSessionValid]) 
        {
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            
            [self hideRenrenBtn];
        }
        else
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [self hideRenrenSwitch];
//            [self.renren logout:nil];
            //把token，session等均移除，这是为了修改过期引起的bug
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults removeObjectForKey:@"access_Token1"];
            [defaults removeObjectForKey:@"secret_Key"];
            [defaults removeObjectForKey:@"session_Key"];
            [defaults removeObjectForKey:@"expiration_Date1"];
            [defaults removeObjectForKey:@"session_UserId"];
            NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            NSArray* graphCookies = [cookies cookiesForURL:
                                     [NSURL URLWithString:@"http://graph.renren.com"]];
            
            for (NSHTTPCookie* cookie in graphCookies) 
            {
                [cookies deleteCookie:cookie];
            }
            NSArray* widgetCookies = [cookies cookiesForURL:[NSURL URLWithString:@"http://widget.renren.com"]];
            
            for (NSHTTPCookie* cookie in widgetCookies) 
            {
                [cookies deleteCookie:cookie];
            }
            [defaults synchronize];
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = [indexPath row];
    NSString *strTitle = [self.shareWBName objectAtIndex:row];
    switch (row) 
    {
        case SelectExportWBSinaLogin:
        {
            UIButton *configureBtn = BUTTON(EExportSinaConfigureBtnTag);
            if (configureBtn.hidden) 
            {                
                ExportLoginChangeViewController *loginChangeViewCtrl = [[ExportLoginChangeViewController alloc] init];
                loginChangeViewCtrl.strTitle = strTitle;
                loginChangeViewCtrl.rowTag = row;
                [self.navigationController pushViewController:loginChangeViewCtrl animated:YES];
                [loginChangeViewCtrl release];
            }
        }
            break;
        case SelectExportWBQQLogin:
        {
            UIButton *configureBtn = BUTTON(EExportQQConfigureBtnTag);
            if (configureBtn.hidden) 
            {                    
                ExportLoginChangeViewController *loginChangeViewCtrl = [[ExportLoginChangeViewController alloc] init];                    
                loginChangeViewCtrl.strTitle = strTitle;
                loginChangeViewCtrl.rowTag = row;
                [self.navigationController pushViewController:loginChangeViewCtrl animated:YES];
                [loginChangeViewCtrl release];
            } 
        }
            break;
        case SelectExportKaiXinLogin:
        {
            UIButton *configureBtn = BUTTON(EExportKXConfigureBtnTag);
            if (configureBtn.hidden) 
            {                 
                ExportLoginChangeViewController *loginChangeViewCtrl = [[ExportLoginChangeViewController alloc] init];
                loginChangeViewCtrl.strTitle = strTitle;
                loginChangeViewCtrl.rowTag = row;
                [self.navigationController pushViewController:loginChangeViewCtrl animated:YES];
//                [kaiXinViewController_ getUserInfo];
                [loginChangeViewCtrl release];
            }             
        }
            break; 
        case SelectExportRenrenLogin:
        {
            UIButton *configureBtn = BUTTON(EExportRRConfigureBtnTag);
            if (configureBtn.hidden) 
            {
                ExportLoginChangeViewController *loginChangeViewCtrl = [[ExportLoginChangeViewController alloc] init];
                loginChangeViewCtrl.strTitle = @"人人网";
                loginChangeViewCtrl.rowTag = row;
                [self.navigationController pushViewController:loginChangeViewCtrl animated:YES];
                [loginChangeViewCtrl release];
            }
        }
            break;
        default:
            [Common showToastView:@"此功能还在开发中" hiddenInTime:2.0f];
            break;
    }
}

#pragma mark - UITextViewDelegate method

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{    
    [self.contentView resignFirstResponder];
    [super touchesBegan:touches withEvent:event];
}

- (void)textViewDidChange:(UITextView *)textView {
	if (nil != contentView_.text && [contentView_.text length] > 140) {		
		contentView_.text = [contentView_.text substringToIndex:140];
	}	
}

#pragma mark - Button Action
/**
 * @brief 
 * 保存图片按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (IBAction)saveImageBtnPressed:(id)sender
{
//    NSString *OrPath = [NSString stringWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] ];
//    NSString *lastFloder = [OrPath stringByAppendingPathComponent:@"LastImage"];
//    NSString *lastImagePath = [lastFloder stringByAppendingPathComponent:@"LastImage.png"];    
//    NSLog(@"%@", lastImagePath);
    //[UIImagePNGRepresentation(self.storeImage) writeToFile:lastImagePath atomically:YES];
    ReUnManager *rm = [ReUnManager sharedReUnManager];
    if (rm.isSaved)
    {
        [Common showToastView:@"图片已经在手机相册" hiddenInTime:2.0f];
    }
    else
    {
        UIImageWriteToSavedPhotosAlbum(self.storeImage, nil, nil, nil);  
        [Common showToastView:@"图片已经保存到手机相册" hiddenInTime:2.0f];
        rm.isSaved = YES;
    }
    
}
/**
 * @brief 显示腾讯配置按钮
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)showBtn
{
    UIButton *btn = BUTTON(EExportQQConfigureBtnTag);
    btn.hidden = NO;
    UISwitch *swt = SWITCH(EExportQQSwitchTag);
    swt.hidden = YES;
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:AppTokenKey];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:AppTokenSecret];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"QQuserName"];
    
    UITableViewCell *cell = (UITableViewCell *)[[swt superview] superview];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

/**
 * @brief 设置新浪微博配置按钮和开关的隐藏或者显示
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)hiddenSinaBtn:(NSNotification *)notification
{
    NSNumber *objNumber = notification.object;
    NSLog(@"hiddenBtn");
    BOOL hiddenConfigBtn = [objNumber boolValue];
    UIButton *btn = BUTTON(EExportSinaConfigureBtnTag);
    btn.hidden = hiddenConfigBtn;
    UISwitch *swt = SWITCH(EExportSinaSwitchTag);
    swt.hidden = !hiddenConfigBtn;
    if (hiddenConfigBtn)
    {
        swt.on = YES;
    }

    if (btn.hidden) 
    {
        UITableViewCell *cell = (UITableViewCell *)[[swt superview] superview];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    else
    {
        UITableViewCell *cell = (UITableViewCell *)[[swt superview] superview];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

/**
 * @brief  隐藏renren配置帐号按钮，显示uiswitch
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)hideRenrenBtn
{
    NSLog(@"hiddenBtn");
    UIButton *btn = BUTTON(EExportRRConfigureBtnTag);
    btn.hidden = YES;
    UISwitch *swt = SWITCH(EExportRRSwitchTag);
    swt.hidden = NO;
    
    UITableViewCell *cell = (UITableViewCell *)[[swt superview] superview];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
}

/**
 * @brief  隐藏renren uiswitch，显示配置帐号按钮
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)hideRenrenSwitch
{
    UIButton *btn = BUTTON(EExportRRConfigureBtnTag);
    btn.hidden = NO;
    UISwitch *swt = SWITCH(EExportRRSwitchTag);
    swt.hidden = YES;
    
    UITableViewCell *cell = (UITableViewCell *)[[swt superview] superview];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}
/**
 * @brief  隐藏腾讯配置帐号按钮，显示UISwitch
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)hiddenQQBtn
{
    UIButton *btn = BUTTON(EExportQQConfigureBtnTag);
    btn.hidden = YES;
    UISwitch *swt = SWITCH(EExportQQSwitchTag);
    swt.hidden = NO;
    [swt setOn:YES];
   
    UITableViewCell *cell = (UITableViewCell *)[[swt superview] superview];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
}
/**
 * @brief  UISwitch事件
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (IBAction)doSwitch:(id)sender 
{
    UISwitch *swt = (UISwitch *)sender;
    //新浪微博
    if (swt.tag == EExportSinaSwitchTag)
    {
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:swt.isOn] forKey:kSinaSwitchStatus];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } 
    else if(swt.tag == EExportQQSwitchTag) 
    {
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:swt.isOn] forKey:kQQSwitchStatus];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if(swt.tag == EExportKaiXinSwitchTag)
    {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:[NSNumber numberWithBool:swt.isOn] forKey:kKainXinSwitchState];
        [defaults synchronize];
        
    }
    else if(swt.tag == EExportRRSwitchTag)
    {
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:swt.isOn] forKey:kRenRenSwitchStatus];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
/**
 * @brief 
 * 配置账户按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (IBAction)ConfigurePressed:(id)sender 
{
    if (NotReachable == [[Reachability reachabilityForInternetConnection] currentReachabilityStatus])
    {
        [Common showToastView:kNetWorkNotReachable hiddenInTime:2.0f];
        return;
    }    
    UIButton *btn = (UIButton*)sender;
    if (btn == BUTTON(EExportSinaConfigureBtnTag)) 
    {
        NSLog(@"sinaconfigure");
        ExportSinaLoginViewController *exportSinaLoginCtrl = [[ExportSinaLoginViewController alloc] init];
        [self.navigationController pushViewController:exportSinaLoginCtrl animated:YES];
        [exportSinaLoginCtrl release];        
    } 
    else if (btn == BUTTON(EExportQQConfigureBtnTag))
    {        
        NSLog(@"QQconfigure");
        ExportLoginWebViewController *exportLoginWebViewController = [[ExportLoginWebViewController alloc] init];
        [self.navigationController pushViewController:exportLoginWebViewController animated:YES];
        [exportLoginWebViewController release];
    } 
    else if (btn == BUTTON(EExportRRConfigureBtnTag))
    {
        if (![self.renren isSessionValid])
        {
            RenrenLoginViewController *rrlVC = [[RenrenLoginViewController alloc]init];
            [self.navigationController pushViewController:rrlVC animated:YES];
            [rrlVC release];
        }
        
    }
    else if(btn == BUTTON(EExportKXConfigureBtnTag))
    {
//        RELEASE_OBJECT(kaiXinViewController_);
//        kaiXinViewController_ = [[ExportKaiXinViewController alloc] init];    
//        kaiXinViewController_.delegate = self;
        kaiXinViewController_.bChangeAccount = YES;
        [kaiXinViewController_ updateView];
        [self.navigationController pushViewController:kaiXinViewController_ animated:YES];
    }
    else  
    {
        [Common showToastView:@"此功能还在开发中" hiddenInTime:2.0f];
    }
}
/**
 * @brief  分享按钮事件
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)shareBtnPressed
{
    [self.contentView resignFirstResponder]; 
    // 判断网络状况
    if (NotReachable == [[Reachability reachabilityForInternetConnection] currentReachabilityStatus]) 
    {
        [Common showToastView:kNetWorkNotReachable hiddenInTime:2.0f];
        return;
    }    
	if (bSending) 
    {
		return;
	}    
	
    NSString *lastImagePath = [[ReUnManager sharedReUnManager] getGlobalSrcImagePath];
    if (!lastImagePath && [lastImagePath isEqualToString:@""]) 
    {
        [Common showToastView:@"图片路径错误" hiddenInTime:2.0f];
        return;
    }
    
    if ([self.contentView.text isEqualToString:@""]) {
        [Common showToastView:@"输入框内容不能为空" hiddenInTime:2.0f];
        return;
    }
    
    UIButton *sinaConfigureBtn = BUTTON(EExportSinaConfigureBtnTag);
    UIButton *QQConfigureBtn = BUTTON(EExportQQConfigureBtnTag);
    UIButton *kaixinConfigureBtn = BUTTON(EExportKXConfigureBtnTag);
    UIButton *RRConfigureBtn = BUTTON(EExportRRConfigureBtnTag);
    //如果所有配置账户按钮都没有隐藏才提示
    if (!sinaConfigureBtn.hidden 
        && !QQConfigureBtn.hidden
        && !kaixinConfigureBtn.hidden
        && !RRConfigureBtn.hidden)
    {
        [Common showToastView:@"分享失败,没有配置账户" hiddenInTime:2.0f];
        return;
    }	
	UISwitch *sinaSwitchBtn = SWITCH(EExportSinaSwitchTag);
    UISwitch *QQSwitchBtn = SWITCH(EExportQQSwitchTag);
    UISwitch *kaiXinSwitchBtn = SWITCH(EExportKaiXinSwitchTag);
    UISwitch *RRSwitchBtn = SWITCH(EExportRRSwitchTag);
	//如果所有按钮都关闭才提示
    if (!((sinaConfigureBtn.hidden&&sinaSwitchBtn.on) 
		  || (QQConfigureBtn.hidden&&QQSwitchBtn.on)
          ||(kaixinConfigureBtn.hidden&&kaiXinSwitchBtn.on)
        ||(RRSwitchBtn.on&&RRConfigureBtn.hidden)))
    {
        [Common showToastView:@"分享失败,没有打开分享功能" hiddenInTime:2.0f];
        return;
    }	
    
    [self getAccountInfoCount];
    //如果打开的微博个数与分享已回调的微博个数相等时，才算微博分享完成
	if (hasSentCount_ == hasOpenCount_)
    {
		return;
	}
	
	bSending = YES;
    [self addActivityView];
    
    // 新浪微博分享图片
    UISwitch *swt = SWITCH(EExportSinaSwitchTag);   
    if (sinaConfigureBtn.hidden && swt.on)
    {
        NSString *sinaAccessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kSinaAccessToken];
        NSTimeInterval expireTime = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:kSinaExpireTime] doubleValue];
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kSinaUserID];
        if (sinaWBEngine_ == nil)
        {
            sinaWBEngine_ = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
            
        }
        [sinaWBEngine_ setRootViewController:self];
        [sinaWBEngine_ setDelegate:self];
        [sinaWBEngine_ setRedirectURI:@"http://"];
        [sinaWBEngine_ setIsUserExclusive:NO];
        sinaWBEngine_.accessToken = sinaAccessToken;
        sinaWBEngine_.expireTime = expireTime;
        sinaWBEngine_.userID = userID;
        [sinaWBEngine_ sendWeiBoWithText:contentView_.text image:[UIImage imageWithContentsOfFile:lastImagePath]];
        
	}
    // 腾讯微博分享图片
    UISwitch *swtQQ = (UISwitch *)[self.view viewWithTag:EExportQQSwitchTag];
    if (QQConfigureBtn.hidden && swtQQ.on) {
        NSString *appKey = [NSString stringWithFormat:APPKEY];
        NSString *appSecret = [NSString stringWithFormat:APPSECRET];
        NSString *tokenKey = [[NSUserDefaults standardUserDefaults] objectForKey:AppTokenKey];
        NSString *tokenSecret = [[NSUserDefaults standardUserDefaults] objectForKey:AppTokenSecret];
        NSLog(@"%@", appKey);
        NSLog(@"%@", appSecret);
        NSLog(@"%@", tokenKey);
        NSLog(@"%@", tokenSecret);     
        
        QWeiboAsyncApi *api = [[[QWeiboAsyncApi alloc] init] autorelease];    
        self.connection = [api publishMsgWithConsumerKey:appKey
                                          consumerSecret:appSecret
                                          accessTokenKey:tokenKey 
                                       accessTokenSecret:tokenSecret 
                                                 content:self.contentView.text 
                                               imageFile:lastImagePath
                                              resultType:RESULTTYPE_JSON 
                                                delegate:self];  
    } 
    UISwitch *swtKaiXin = (UISwitch *)[self.view viewWithTag:EExportKaiXinSwitchTag];
    if (kaixinConfigureBtn.hidden && swtKaiXin.on) 
    {        
        BOOL result = [self checkDateValid];
        if (!result)
        {
            kaixinConfigureBtn.hidden = NO;
            swtKaiXin.hidden = YES;            
           [Common showToastView:@"开心网授权过期，请重新配置" hiddenInTime:2.0f];
            
            //清楚保存的数据
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults removeObjectForKey:@"access_Token"];
            [defaults removeObjectForKey:@"refresh_Token"];   
            [defaults removeObjectForKey:@"kaixin_expiration_Date"];
            [defaults synchronize];
            
            //发表失败处理        
            hasSentCount_++;
            [accountInfoDict_ setValue:[NSNumber numberWithBool:NO] forKey:kShareToKaiXin];        
            [self showShareResult];
        }
        else 
        {
            NSDictionary *contentDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        self.contentView.text,@"content",
                                        [UIImage imageWithContentsOfFile:lastImagePath],@"pic",
                                        nil];
            [kaiXinViewController_ pubilishRecord:contentDic];
            
        }        
       
    } 
    //分享到人人网
    if (RRConfigureBtn.hidden && RRSwitchBtn.on)
    {
        ROPublishPhotoRequestParam *param = [[ROPublishPhotoRequestParam alloc] init];
        param.imageFile = [[ReUnManager sharedReUnManager] getGlobalSrcImage];
        param.caption = self.contentView.text;
        [self.renren publishPhoto:param andDelegate:self];
        [param release];
    }
}
/**
 * @brief  取消按钮事件
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)cancelBtnPressed
{
    self.renren.renrenDelegate = nil;
    kaiXinViewController_.kaixin.delegate = nil;
    kaiXinViewController_.kaixin.request.delegate = nil;
    if (sinaWBEngine_)
    {
        sinaWBEngine_.delegate = nil;
    }
    [self removeActivityView];
    if (timeOutTimer_ && [timeOutTimer_ isValid])
    {
        [timeOutTimer_ invalidate];
    }
    timeOutTimer_ = nil;

    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * @brief  分享微博时，添加转圈
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)addActivityView
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.origin.y, 320, self.tableView.frame.size.height)];
    view.backgroundColor = [UIColor clearColor];
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.center = CGPointMake(self.tableView.frame.size.width/2.0, self.tableView.frame.size.height/2.0);
    [activity startAnimating];
    [view addSubview:activity];
    view.tag = kActivitySuperViewTag;
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    window.tag = kActivitySuperWindowTag;
    [window addSubview:view];
    [view release];
    [activity release];
    timeOutTimer_ = [NSTimer scheduledTimerWithTimeInterval:120.0 target:self selector:@selector(timeOutFire) userInfo:nil repeats:NO];
}

/**
 * @brief  分享微博结束，移除转圈
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)removeActivityView
{
    NSArray *windowsArray = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in windowsArray)
    {
        if (window.tag == kActivitySuperWindowTag)
        {
            for (UIView *subView in [window subviews])
            {
                if (subView.tag == kActivitySuperViewTag) 
                {
                    for (UIView *obj in [subView subviews])
                    {
                        if ([obj isKindOfClass:[UIActivityIndicatorView class]])
                        {
                            UIActivityIndicatorView *activity = (UIActivityIndicatorView *)obj;
                            if ([activity isAnimating])
                            {
                                [activity stopAnimating];
                            }
                            break;
                        }
                        
                    }
                    [subView removeFromSuperview];
                    window.tag = 0;
                    break;
                }
            }
        }
    }
    
    
}

/**
 * @brief 分享超时定时器回调函数
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)timeOutFire
{
    [Common showToastView:@"请求超时！" hiddenInTime:2.0f];
    self.renren.renrenDelegate = nil;
    kaiXinViewController_.kaixin.delegate = nil;
    kaiXinViewController_.kaixin.request.delegate = nil;
    if (sinaWBEngine_)
    {
        sinaWBEngine_.delegate = nil;
    }
    hasOpenCount_ = 0;
    hasSentCount_ = 0;
    [accountInfoDict_ removeAllObjects];
    bSending = NO;
    [self removeActivityView];
    timeOutTimer_ = nil;
}

/**
 * @brief  分享微博结束时，显示各个微博的分享结果
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)showShareResult
{
	//如果可以分享的，与已经回调的个数相等，则需要弹出分享结果
	if (hasOpenCount_ == hasSentCount_)
	{
		[self removeActivityView];
		[Common showCustomAlertInfo:accountInfoDict_ number:hasOpenCount_];
		bSending = NO;
		
		if (timeOutTimer_ && [timeOutTimer_ isValid])
		{
			[timeOutTimer_ invalidate];
		}
		timeOutTimer_ = nil;
	}
	
}
#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
	self.responseData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
	[responseData_ appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection 
{
    //分享请求超时，所有请求不需要回调，所以当bsending ＝＝no 时，表示请求已经结束
    if (!bSending)
    {
        return;
    }
    NSError *error = nil;
    NSDictionary *resultDict = [[CJSONDeserializer deserializer] deserializeAsDictionary:self.responseData error:&error];
    NSNumber *ret = [resultDict objectForKey:@"ret"];  
    NSNumber *errcode = [resultDict objectForKey:@"errcode"];
    hasSentCount_++;    
    if ([ret intValue] == 0)
    {
        [accountInfoDict_ setValue:[NSNumber numberWithBool:YES] forKey:kShareToQQ];
        [self showShareResult];
    }
    else
    {
        if (([ret intValue] == 5) && ([errcode intValue] == 67))//25
        {
           [Common showToastView:@"腾讯:内容不能重复" hiddenInTime:1.5f];           
        }
        [accountInfoDict_ setValue:[NSNumber numberWithBool:NO] forKey:kShareToQQ];
        [self showShareResult];
    }    
	self.connection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{    
    hasSentCount_++;
    [accountInfoDict_ setValue:[NSNumber numberWithBool:NO] forKey:kShareToQQ];
    [self showShareResult];    
	self.connection = nil;
}

#pragma mark - WBEngineDelegate Methods

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    hasSentCount_++;
    [accountInfoDict_ setValue:[NSNumber numberWithBool:YES] forKey:kShareToSina];
    [self showShareResult];
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    if (error != nil) 
    {
        NSDictionary *userInfo = error.userInfo;
        NSDecimalNumber *errorCode = [userInfo objectForKey:@"error_code"];
        if (errorCode.intValue == 21332)
        {
            [Common showToastView:@"新浪授权失效, 请退出后重新登录!" hiddenInTime:2.0f];
        }
    }

    hasSentCount_++;
    [accountInfoDict_ setValue:[NSNumber numberWithBool:NO] forKey:kShareToSina];
    [self showShareResult];
}

- (void)engineNotAuthorized:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"用户没有被授权！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
	hasSentCount_++;
    [accountInfoDict_ setValue:[NSNumber numberWithBool:NO] forKey:kShareToSina];
    [self showShareResult];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"HiddenSinaBtn" object:[NSNumber numberWithBool:NO]];
    
    [Common showToastView:@"新浪微博授权过期，请重新配置" hiddenInTime:2.0f];

}

/**
 * @brief  renren网授权过期后处理提示
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)renrenAuthorizeExpired
{
    hasSentCount_++;
    [accountInfoDict_ setValue:[NSNumber numberWithBool:NO] forKey:kShareToRenRen];
    [self showShareResult];
	
	[self hideRenrenSwitch];
    [Common showToastView:@"人人网授权过期，请重新配置" hiddenInTime:2.0f];
}

#pragma mark - RenrenDelegate methods
/**
 * @brief  把renren uiswitch设为on，每次renren登录成功后会调用此方法
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
-(void)setRenrenSwitchOn
{
    UISwitch *swt = SWITCH(EExportRRSwitchTag);
    [swt setOn:YES];
    [self doSwitch:swt];
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
    [self hideRenrenBtn];
    UISwitch *swt = SWITCH(EExportRRSwitchTag);
    [swt setOn:YES];
    [self doSwitch:swt];
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
	NSString *title = [NSString stringWithFormat:@"Error code:%d", [error code]];
	NSString *description = [NSString stringWithFormat:@"%@", [error localizedDescription]];
	UIAlertView *alertView =[[[UIAlertView alloc] initWithTitle:title message:description delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] autorelease];
	[alertView show];
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
    //分享图片到人人网成功
    if ([response.param isKindOfClass:[ROPublishPhotoRequestParam class]])
    {
        hasSentCount_++;
        [accountInfoDict_ setValue:[NSNumber numberWithBool:YES] forKey:kShareToRenRen];
        [self showShareResult];
    }
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
    if ([error code] == 202)
    {
        [Common showToastView:@"人人网授权失效，请退出后重新登录！" hiddenInTime:2.0f];
    }
    //分享图片到人人网失败
    hasSentCount_++;
    [accountInfoDict_ setValue:[NSNumber numberWithBool:NO] forKey:kShareToRenRen];
    [self showShareResult];
}

/**
 * @brief  获取各个账户是否配置并打开，以及分享结果
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)getAccountInfoCount
{
    NSArray *keyArray = [NSArray arrayWithObjects:kConfigSina,kConfigQQ,kConfigKaiXin,kConfigRenRen,kShareToSina,kShareToQQ,kShareToKaiXin,kShareToRenRen, nil];
    hasOpenCount_ = 0;
    hasSentCount_ = 0;
    [accountInfoDict_ removeAllObjects];
    for (int i = EExportSinaConfigureBtnTag; i < EExportRRConfigureBtnTag + 1; ++i)
    {
        UIButton *configBtn = BUTTON(i);
        UISwitch *switchBtn = SWITCH(i + 4);
        NSString *key = [keyArray objectAtIndex:i - EExportSinaConfigureBtnTag];
        if (!configBtn.hidden)
        {
            [accountInfoDict_ setValue:[NSNumber numberWithBool:NO] forKey:key];
        }
        else if(switchBtn.on)
        {
            [accountInfoDict_ setValue:[NSNumber numberWithBool:YES] forKey:key];
            hasOpenCount_++;
        }
    }
}

//开心网成功登陆
- (void)loginSucess
{
    UIButton *btn = BUTTON(EExportKXConfigureBtnTag);
    btn.hidden = YES;
    UISwitch *swt = SWITCH(EExportKaiXinSwitchTag);
    swt.hidden = NO;
    swt.on = YES;
    
    //设置开心网开关状态
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithBool:YES] forKey:kKainXinSwitchState];
    [defaults synchronize];
    
    UITableViewCell *cell = (UITableViewCell *)[[swt superview] superview];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
}
//开心网发表成功
- (void)publishSucess
{
    hasSentCount_++;
    [accountInfoDict_ setValue:[NSNumber numberWithBool:YES] forKey:kShareToKaiXin];
    [self showShareResult];
}
//开心网发表失败
- (void)publishFailed
{
    hasSentCount_++;
    [accountInfoDict_ setValue:[NSNumber numberWithBool:NO] forKey:kShareToKaiXin];
    [self showShareResult];
    
}
//开心网退出登陆成功
- (void)logoutSucess:(NSNotification *)notification
{
    NSNumber *configBtnHidden = notification.object;
    UIButton *btn = BUTTON(EExportKXConfigureBtnTag);
    btn.hidden = configBtnHidden.boolValue;
    UISwitch *swt = SWITCH(EExportKaiXinSwitchTag);
    swt.hidden = !configBtnHidden.boolValue;
    swt.on = configBtnHidden.boolValue;
    
    //设置开心网开关状态
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithBool:configBtnHidden.boolValue] forKey:kKainXinSwitchState];
    [defaults synchronize];
    
    if (btn.hidden)
    {
        UITableViewCell *cell = (UITableViewCell *)[[swt superview] superview];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    else
    {
        UITableViewCell *cell = (UITableViewCell *)[[swt superview] superview];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

//检查开心网Token有效期
- (BOOL)checkDateValid
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];	
    NSDate  *tokenDate = [defaults objectForKey:@"kaixin_expiration_Date"];
    NSDate  *currentDate = [NSDate date];
    NSComparisonResult checkResult = [currentDate compare:tokenDate];
    
    if (NSOrderedSame == checkResult || NSOrderedAscending == checkResult) 
    {
        return YES;
    }
           
    return NO; 
}

#pragma mark - Export To Aimi Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/cn/app//id523407658?mt=8"];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

/**
 * @brief  分享到Aimi
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (IBAction)exportToAimi:(id)sender
{
        NSURL *url = [NSURL URLWithString:@"Aimi://"];
        if (![[UIApplication sharedApplication] canOpenURL:url]) 
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"您还没有安装天天家园" message:@"是否到AppStore下载?" delegate:self cancelButtonTitle:kCancel otherButtonTitles:kOK, nil];
            [av show];
            [av release];
        }
        else
        {
            [self saveToInstagram];         
        }
}

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    return interactionController;
}

- (void)documentInteractionControllerWillPresentOpenInMenu:(UIDocumentInteractionController *)controller
{
    
}

/**
 * @brief  打开调用界面
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
-(void)saveToInstagram 
{
    NSURL *url;
    UIDocumentInteractionController *dic;
    CGRect rect = CGRectMake(0 ,0 , 0, 0);
//    ReUnManager *rm = [ReUnManager sharedReUnManager];
    //UIImage *currentImage = [rm getGlobalSrcImage];
    //CGRect cropRect = CGRectMake(currentImage.size.width - 306 ,currentImage.size.height - 306 , 612, 612);
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/Test.png"];
//    CGImageRef imageRef = CGImageCreateWithImageInRect([currentImage CGImage], );
//    UIImage *img = [[UIImage alloc] initWithCGImage:imageRef];
//    CGImageRelease(imageRef);
    
    [UIImageJPEGRepresentation(self.storeImage, 1.0) writeToFile:jpgPath atomically:YES];
    url = [[NSURL alloc] initFileURLWithPath:jpgPath];
    dic = [self setupControllerWithURL:url usingDelegate:self];
    [dic presentOpenInMenuFromRect:rect inView:self.view animated:YES];
    [dic retain];
//    [img release];
    [url release];
}

@end
