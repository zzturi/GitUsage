//
//  ExportLoginWebViewController.m
//  Aico
//
//  Created by chen mengtao on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExportLoginWebViewController.h"
#import "NSURL+QAdditions.h"
#import "QWeiboSyncApi.h"
#import "QWeiboAsyncApi.h"
#import "ReUnManager.h"
#import "ExportMainViewController.h"
#import "Reachability.h"

@implementation ExportLoginWebViewController
@synthesize appKey = appKey_;
@synthesize appSecret = appSecret_;
@synthesize tokenKey = tokenKey_;
@synthesize tokenSecret = tokenSecret_;
@synthesize responseData = responseData_;
@synthesize connection = connection_;
@synthesize isExitCurrentCount = isExitCurrentCount_;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"腾讯微博";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgImage.png"]]];    
    // 添加取消按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:kEffectCancelButtonFrameRect];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelBarBtn;
    [cancelBtn release];
    [cancelBarBtn release];    
    // 加载Appkey和AppSecret
    [self loadDefaultKey];  
    self.appKey = [NSString stringWithFormat:@"%@",APPKEY];
	self.appSecret = [NSString stringWithFormat:@"%@",APPSECRET];    
    // 添加背景view
    UIView *bkgView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 436)];
    bkgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bkgView];
    [bkgView release];    
    // 添加转圈
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.center = CGPointMake(160, 218);
    [activityView startAnimating];
    activityView.tag = 5909;
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [window addSubview:activityView];
    [activityView release];    
    // 利用appkey和appSecret第一次发请求
    QWeiboAsyncApi *api = [[[QWeiboAsyncApi alloc] init] autorelease];
    self.connection = [api getRequestTokenWithConsumerKey:self.appKey 
                                           consumerSecret:self.appSecret 
                                                 delegate:self];
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(loadWeb:) 
                                                 name:@"AsyRequest" 
                                               object:nil];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [loginWebView_ release],loginWebView_ =nil;
    self.appKey = nil;
    self.appSecret = nil;
    self.tokenKey = nil;
    self.tokenSecret = nil;
    self.responseData = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc 
{  
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [loginWebView_ release];
    [appKey_ release];
    [appSecret_ release];
    [tokenKey_ release];
    [tokenSecret_ release];
    self.responseData = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIWebViewDelegate

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *query = [[request URL] query];
	NSString *verifier = [self valueForKey:@"oauth_verifier" ofQuery:query];
	if (verifier && ![verifier isEqualToString:@""]) 
    {
		QWeiboSyncApi *api = [[[QWeiboSyncApi alloc] init] autorelease];
		NSString *retString = [api getAccessTokenWithConsumerKey:self.appKey 
												  consumerSecret:self.appSecret 
												 requestTokenKey:self.tokenKey 
											  requestTokenSecret:self.tokenSecret 
														  verify:verifier];        
        NSLog(@"\nget access token:%@", retString);
		[self parseTokenKeyWithResponse:retString];
		[self saveDefaultKey];
        NSString *wbName = [self valueForKey:@"name" ofQuery:retString];
        [[NSUserDefaults standardUserDefaults] setValue:wbName forKey:@"QQuserName"];
        [[NSUserDefaults standardUserDefaults] synchronize];        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HiddenBtn" object:nil];        
		if (self.isExitCurrentCount) 
        {
			NSArray *array = [self.navigationController viewControllers];
			[self.navigationController popToViewController:[array objectAtIndex:([array count]-3)] animated:YES];			
		}
		else 
        {
			[self.navigationController popViewControllerAnimated:YES];
		}  
        return NO;
	}
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self removeActivity];
}

#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{	    
	self.responseData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
	[self.responseData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection 
{
	NSString *str = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    if (![str isEqualToString:@""]) 
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AsyRequest" object:str];
    } 
    else 
    {
        [self removeActivity];
    }    
    [str release];
	self.connection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    [self removeActivity];
    [Common showToastView:@"网络连接错误" hiddenInTime:2.0f];
	self.connection = nil;
}

/**
 * @brief 
 * 移除转圈
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
-(void)removeActivity
{
    // webview加载完成移除转圈
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[window viewWithTag:5909];
    if (activity.isAnimating)
    {
        [activity stopAnimating];
        [activity removeFromSuperview];
    }
}

#pragma mark private methods
/**
 * @brief 
 * 加载tokenKey和tokenSecret值
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)loadDefaultKey 
{
	self.tokenKey = [[NSUserDefaults standardUserDefaults] valueForKey:AppTokenKey];   
	self.tokenSecret = [[NSUserDefaults standardUserDefaults] valueForKey:AppTokenSecret];
}
/**
 * @brief 
 * 保存tokenKey和tokenSecret值
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)saveDefaultKey 
{
	[[NSUserDefaults standardUserDefaults] setValue:self.tokenKey forKey:AppTokenKey];
	[[NSUserDefaults standardUserDefaults] setValue:self.tokenSecret forKey:AppTokenSecret];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
/**
 * @brief 
 * 从字符串中查找key的值
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
-(NSString*) valueForKey:(NSString *)key ofQuery:(NSString*)query
{
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	for(NSString *aPair in pairs){
		NSArray *keyAndValue = [aPair componentsSeparatedByString:@"="];
		if([keyAndValue count] != 2) continue;
		if([[keyAndValue objectAtIndex:0] isEqualToString:key]){
			return [keyAndValue objectAtIndex:1];
		}
	}
	return nil;
}
/**
 * @brief 
 * 从Respone中解析出tokenkey和tokensecret
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)parseTokenKeyWithResponse:(NSString *)aResponse 
{
	NSDictionary *params = [NSURL parseURLQueryString:aResponse];
	self.tokenKey = [params objectForKey:@"oauth_token"];    
	self.tokenSecret = [params objectForKey:@"oauth_token_secret"];
}
/**
 * @brief 
 * 通知的响应方法
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
-(void)loadWeb:(NSNotification *)notification
{
    NSString *str = notification.object;
    [self parseTokenKeyWithResponse:str];    
    if (loginWebView_)
    {
        RELEASE_OBJECT(loginWebView_);
    }
    // 初始化UIWebView
    loginWebView_ = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320.0f, 436.0f)];
    [loginWebView_ setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgImage.png"]]];
    loginWebView_.delegate = self;  
    [self.view addSubview:loginWebView_];
   	NSString *url = [NSString stringWithFormat:@"%@%@", VERIFY_URL, self.tokenKey];
	NSURL *requestUrl = [NSURL URLWithString:url];
	NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
    NSLog(@"%@", request);
	[loginWebView_ loadRequest:request];
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
- (void)cancelBtnPressed:(id)sender
{
    [self removeActivity];
    if (self.isExitCurrentCount) {
        NSArray *array = [self.navigationController viewControllers];
        [self.navigationController popToViewController:[array objectAtIndex:([array count]-3)] animated:YES];
        
    }
	else {
		[self.navigationController popViewControllerAnimated:YES];
	}   
}
@end