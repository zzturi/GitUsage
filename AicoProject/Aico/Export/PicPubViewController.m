//
//  PicPubViewController.m
//  Aico
//
//  Created by chen tao on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PicPubViewController.h"
#import "ReUnManager.h"
#import "QWeiboAsyncApi.h"

@implementation PicPubViewController
@synthesize srcImage = srcImage_;
@synthesize titleText = titleText_;
@synthesize insertPicBtn = insertPicBtn_;
@synthesize pubPicBtn = pubPicBtn_;
@synthesize imageView = imageView_;
@synthesize fileUrl = fileUrl_;

@synthesize appKey = appKey_;
@synthesize appSecret = appSecret_;
@synthesize tokenKey = tokenKey_;
@synthesize tokenSecret = tokenSecret_;
@synthesize type = type_;

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
    
    self.navigationController.navigationBarHidden = NO;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgImage.png"]]];
    self.title = @"发布图片";
    self.titleText.text = @"图片";
    self.titleText.delegate = self;

    // 加载分享图片
    self.srcImage = [[ReUnManager sharedReUnManager] getGlobalSrcImage];
    self.imageView.image = self.srcImage;
    
    NSString *OrPath = [NSString stringWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] ];
    NSString *lastFloder = [OrPath stringByAppendingPathComponent:@"LastImage"];
    NSString *lastImagePath = [lastFloder stringByAppendingPathComponent:@"LastImage.png"];    
    NSLog(@"%@", lastImagePath);
	[UIImagePNGRepresentation(self.srcImage) writeToFile:lastImagePath atomically:YES];
	self.fileUrl = lastImagePath;
    
    // 添加取消按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:kEffectCancelButtonFrameRect];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelBarBtn;
    [cancelBtn release];
    [cancelBarBtn release]; 
    
}

- (void)viewDidUnload
{
    [self setInsertPicBtn:nil];
    [self setPubPicBtn:nil];
    [self setImageView:nil];
    [self setTitleText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
 
    [insertPicBtn_ release];
    [pubPicBtn_ release];
    [imageView_ release];
    
    [appKey_ release];
    [appSecret_ release];
    [tokenKey_ release];
    [tokenSecret_ release];
    
    [titleText_ release];
    [super dealloc];
}

#pragma mark - Button Action

- (void)cancelBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)publishMsg:(id)sender
{
    if (type_ == 1) {
        QWeiboAsyncApi *api = [[[QWeiboAsyncApi alloc] init] autorelease];
        NSString *content = self.titleText.text;
        
        [api publishMsgWithConsumerKey:self.appKey 
                        consumerSecret:self.appSecret 
                        accessTokenKey:self.tokenKey 
                     accessTokenSecret:self.tokenSecret 
                               content:content 
                             imageFile:self.fileUrl 
                            resultType:RESULTTYPE_JSON 
                              delegate:self];
        [Common showToastView:@"发布成功" hiddenInTime:1.5];

    }
    
    if (type_ == 2) {

    WBSendView *sendView = [[WBSendView alloc] initWithAppKey:self.appKey appSecret:self.appSecret text:self.titleText.text image:[UIImage imageWithContentsOfFile:self.fileUrl]];
    [sendView setDelegate:self];
    
    [sendView show:YES];
    [sendView release];
        
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.titleText resignFirstResponder];
    [super touchesBegan:touches withEvent:event];
}
@end
