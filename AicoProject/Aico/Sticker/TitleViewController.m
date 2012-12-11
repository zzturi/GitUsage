//
//  TitleViewController.m
//  Aico
//
//  Created by 勇 周 on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TitleViewController.h"
#import "FXLabel.h"
#import "ColorSelectViewController.h"
#import "IMPopoverController.h"
#import "UIColor+extend.h"
#import "TitleEditViewController.h"
#import "StickerMainViewController.h"
#import "ReUnManager.h"

#define SHOW_BORDER(view, color) view.layer.borderColor = color.CGColor; view.layer.borderWidth = 1
#define kColorMenuRowHeight		40

#define kLabelTotalCount		64
// scrollview一行放置的label个数
#define kLabelCountPerLine		16
// 每个label 的大小
#define kLabelWidth				80
// 第一个label与父view的偏移位置
#define kLabelMargin			CGPointMake(0,10)
// 相邻label之间的间隔大小
#define kLabelPaddingSize		CGSizeMake(0,0)
// label初始字符串
#define kLabelDefaultText		@"ABC"
// 标题字符的最大长度
#define kTitleMaxLength			100
// 标题字体显示的最小大小
#define kTitleMinFontSize		30.0f
#define kTitlePreviewFontSize	50.0f

@implementation TitleViewController

@synthesize btnStyleSelected    = btnStyleSelected_;
@synthesize imageViewTextField  = imageViewTextField_;
@synthesize textFieldInput      = textFieldInput_;
@synthesize scrollViewStyles    = scrollViewStyles_;
@synthesize pageControl         = pageControl_;
@synthesize arrFontStyle        = arrFontStyle_;
@synthesize viewCurrentEdit		= viewCurrentEdit_;
@synthesize operateType			= operateType_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
	{
        operateType_ = TitleOperateTypeAdd;
    }
    return self;
}

- (id)initWithEditView:(UIView*)viewEdit parentViewController:(TitleEditViewController*)vc operateType:(int)type
{
	self = [super init];
    if (self) 
	{
        viewCurrentEdit_ = viewEdit;
		vcEdit_ = vc;
		operateType_ = type;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat viewHeight = CGRectGetHeight(self.view.frame) + 20;	// 480
    
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	
    // 初始化 显示当前输入字符的字体效果
    CGPoint ptOriginLabel = {0, kNavigationHeight};
    CGFloat labelWidth = viewWidth - ptOriginLabel.x * 2;
    CGFloat labelHeight = version >= 5.0 ? 145 : 180;

    btnStyleSelected_ = [[FXButton alloc] initWithFrame:CGRectMake(ptOriginLabel.x, ptOriginLabel.y, labelWidth, labelHeight)];
	btnStyleSelected_.titleLabel.numberOfLines = 0;
    btnStyleSelected_.backgroundColor = [UIColor getColor:@"C9C9C9"];
    btnStyleSelected_.tag = 8000;
    [btnStyleSelected_ addTarget: self 
                          action: @selector(styleSelectButtonPressed:) 
                forControlEvents: UIControlEventTouchUpInside];
    
    // 初始化文本输入框背景
    CGPoint ptOriginImageView = {0, ptOriginLabel.y + labelHeight};
    CGFloat imageViewHeight = 40;
    imageViewTextField_ = [[UIImageView alloc] initWithFrame:CGRectMake(ptOriginImageView.x, ptOriginImageView.y, viewWidth, imageViewHeight)];
    imageViewTextField_.image = [UIImage imageNamed:@"WordBalloonBlackBar.png"];
    imageViewTextField_.userInteractionEnabled = YES;
    
    // 初始化文本输入框
    CGFloat textFieldHeight = 30;
    CGPoint ptOriginImageViewTextField = {10, (imageViewHeight - textFieldHeight)/2};
    CGFloat imageViewTextFieldWidth = viewWidth - ptOriginImageViewTextField.x * 2;
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"WordBalloonTextfield.png"]];
    imageView.frame = CGRectMake(ptOriginImageViewTextField.x, ptOriginImageViewTextField.y, imageViewTextFieldWidth, textFieldHeight);
    [imageViewTextField_ addSubview:imageView];
    [imageView release];
    
    CGPoint ptOriginTextField = {25, (imageViewHeight - textFieldHeight) / 2};
    CGFloat textFieldWidth = viewWidth - ptOriginTextField.x * 2;
    textFieldInput_ = [[UITextField alloc] initWithFrame:CGRectMake(25, 6, textFieldWidth, textFieldHeight)];
    textFieldInput_.borderStyle = UITextBorderStyleNone;
	textFieldInput_.placeholder = kLabelDefaultText;
    textFieldInput_.clearButtonMode = UITextFieldViewModeWhileEditing;
    textFieldInput_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;     // 垂直剧中
	textFieldInput_.delegate = self;
	textFieldInput_.returnKeyType = UIReturnKeyDone;
    [textFieldInput_ addTarget:self action:@selector(textFieldDoneEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
	[textFieldInput_ addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [imageViewTextField_ addSubview:textFieldInput_];
    
    // 初始化 显示所有字体效果的scrollview
    CGPoint ptOriginScrollView = {0, ptOriginImageView.y+imageViewHeight};
    CGFloat scrollViewWidth = viewWidth - ptOriginScrollView.x * 2;
    CGFloat scrollViewHeight = viewHeight - ptOriginScrollView.y;
    scrollViewStyles_ = [[UIScrollView alloc] initWithFrame:CGRectMake(ptOriginScrollView.x, ptOriginScrollView.y, scrollViewWidth, scrollViewHeight)];
    scrollViewStyles_.contentSize = CGSizeMake(kLabelCountPerLine * (kLabelWidth + kLabelPaddingSize.width) - kLabelPaddingSize.width + 2 * kLabelMargin.x, scrollViewHeight);
    scrollViewStyles_.backgroundColor = [UIColor getColor:@"EEEEEE"];
    //使用翻页属性
    scrollViewStyles_.pagingEnabled = YES;
    scrollViewStyles_.showsHorizontalScrollIndicator = NO;
    scrollViewStyles_.delegate = self;
//SHOW_BORDER(scrollViewStyles_, [UIColor blueColor]);
    
    //定义pageContrl
    pageControl_ = [[StylePageControl alloc]initWithFrame:CGRectMake(130, 465, 60, 15)];
    pageControl_.backgroundColor = [UIColor clearColor];
    pageControl_.numberOfPages = 4;    
    pageControl_.currentPage = 0;
    [pageControl_ setNormalImage:[UIImage imageNamed:@"emptyPoint.png"]];
	[pageControl_ setSelectedImage:[UIImage imageNamed:@"blackPoint.png"]];
    [pageControl_ addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    [self initStyleButtons];
    
    [self.view addSubview:btnStyleSelected_];
    [self.view addSubview:imageViewTextField_];
    [self.view addSubview:scrollViewStyles_];
    [self.view addSubview:pageControl_];
    
    [self initNavigatinBarButtons];
    
    self.navigationController.navigationBarHidden = NO;
	self.navigationItem.title = @"标题";
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kBackGroundImage]];
	[Common setNavigationBarBackgroundBkg:self.navigationController.navigationBar];
    
    arrFontColorType_ = [[NSMutableArray alloc] init];
    arrFontColorTypeName_ = [[NSMutableArray alloc] init];
    arrFontColor_ = [[NSMutableArray alloc] init];
    
    //添加键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillHide:) 
                                                 name:UIKeyboardWillHideNotification object:nil];
}

/**
 * @brief 释放本视图的资源
 *
 * @param [in] 
 * @param [out]
 * @return 
 * @note 
 */
- (void)releaseObjects
{
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillHideNotification
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillShowNotification
												  object:nil];
    
    self.btnStyleSelected = nil;
    self.imageViewTextField = nil;
    self.textFieldInput = nil;
    self.scrollViewStyles = nil;
    self.pageControl = nil;
    self.arrFontStyle = nil;
    RELEASE_OBJECT(arrFontColorType_);
    RELEASE_OBJECT(arrFontColorTypeName_);
    RELEASE_OBJECT(arrFontColor_);
    RELEASE_OBJECT(vcPopover_);
	RELEASE_OBJECT(vcEdit_);
}
- (void)viewDidUnload
{
    [self releaseObjects];
    [super viewDidUnload];
}
- (void)dealloc
{
    [self releaseObjects];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark 初始化子视图

/**
 * @brief 初始化所有字体效果的button
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)initStyleButtons
{
    arrFontStyle_ = [[NSMutableArray alloc] initWithCapacity:kLabelTotalCount];
    
    int lines = kLabelTotalCount / kLabelCountPerLine + (kLabelCountPerLine % kLabelCountPerLine != 0 ? 1 : 0);
    CGFloat btnHeight = (scrollViewStyles_.bounds.size.height - kLabelMargin.y * 2) / lines;
    
    int x = 0, y = 0;   // 坐标
    for (NSInteger i=0; i<kLabelTotalCount; ++i)
    {
        CGFloat originX = kLabelMargin.x + x * (kLabelPaddingSize.width + kLabelWidth);
        CGFloat originY = kLabelMargin.y + y * (kLabelPaddingSize.height + btnHeight);
        
        FXButton *button = [[FXButton alloc] initWithFrame:CGRectMake(originX, originY, kLabelWidth, btnHeight)];
        button.userInteractionEnabled = YES;
        button.tag = i+1;
		//button.hidden = YES;
        button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:kTitleMinFontSize];
        button.titleLabel.text = kLabelDefaultText;
        [button setTitle:kLabelDefaultText forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor colorWithWhite:0.7f alpha:1.0f] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"shareCellBack.png"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        [arrFontStyle_ addObject:button];
        [scrollViewStyles_ addSubview:button];
        
//SHOW_BORDER(label, [UIColor blueColor]);
        [button release];
        
        if (++x >= kLabelCountPerLine) 
        {
            x = 0;
            ++y;
        }
    }
    
    FXButton *button = nil;
    int i = -1;
    // 1. demonstrate shadow
    button = [arrFontStyle_ objectAtIndex:++i];
	button.fillColor = [UIColor blackColor];
    button.titleLabel.shadowOffset = CGSizeMake(0.0f, 2.0f);
    button.titleLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
    button.shadowBlur = 5.0f;
    button.colorType = ColorTypeFill | ColorTypeShadow;
    
    //2. demonstrate gradient fill
    button = [arrFontStyle_ objectAtIndex:++i];
    button.gradientStartColor = [UIColor redColor];
    button.gradientEndColor = [UIColor orangeColor];
    button.colorType = ColorTypeGradientStart | ColorTypeGradientEnd;
    
    //3. demonstrate multi-part gradient
    button = [arrFontStyle_ objectAtIndex:++i];
    button.gradientStartPoint = CGPointMake(0.0f, 0.0f);
    button.gradientEndPoint = CGPointMake(1.0f, 1.0f);
    button.gradientColors = [NSArray arrayWithObjects:
                             [UIColor redColor],
                             [UIColor yellowColor],
                             [UIColor greenColor],
                             [UIColor cyanColor],
                             [UIColor blueColor],
                             [UIColor purpleColor],
                             [UIColor redColor],
                             nil];
    button.colorType = ColorTypeGradients;
    
    //4. everything
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.shadowColor = [UIColor blackColor];
    button.titleLabel.shadowOffset = CGSizeZero;
    button.shadowBlur = 20.0f;
    button.innerShadowColor = [UIColor yellowColor];
    button.innerShadowOffset = CGSizeMake(1.0f, 2.0f);
    button.gradientStartColor = [UIColor redColor];
    button.gradientEndColor = [UIColor yellowColor];
    button.gradientStartPoint = CGPointMake(0.0f, 15);
    button.gradientEndPoint = CGPointMake(1.0f, 15);
    button.oversampling = 2;
    button.colorType = ColorTypeInnerShadow | ColorTypeGradientStart | ColorTypeGradientEnd;
    
    // 5. fill color
    button = [arrFontStyle_ objectAtIndex:++i];
    button.fillColor = [UIColor redColor];
    button.colorType = ColorTypeFill;
    
    // 6. stroke color
    button = [arrFontStyle_ objectAtIndex:++i];
    button.strokeColor = [UIColor blueColor];
    button.colorType = ColorTypeStroke;
    
    // 7. fill stroke color
    button = [arrFontStyle_ objectAtIndex:++i];
    button.fillColor = [UIColor redColor];
    button.strokeColor = [UIColor blueColor];
    button.colorType = ColorTypeFill | ColorTypeStroke;
    
	// 8. BradleyHandITCT-Bold
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:kTitleMinFontSize];
	button.fillColor = [UIColor yellowColor];
    button.colorType = ColorTypeFill;
	
    // 9. MarkerFelt-Wide
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:kTitleMinFontSize];
	button.fillColor = [UIColor blackColor];
    button.colorType = ColorTypeFill;
	
	// 10. MarkerFelt-Wide
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:kTitleMinFontSize];
    button.fillColor = [UIColor greenColor];
    button.strokeColor = [UIColor blueColor];
    button.colorType = ColorTypeFill | ColorTypeStroke;
	
    
    // 11. Cocbin-BoldItalic
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:kTitleMinFontSize];		// Noteworthy-Bold
    button.fillColor = [UIColor greenColor];
    button.strokeColor = [UIColor blueColor];
    button.colorType = ColorTypeFill | ColorTypeStroke;
	
	// 12
	button = [arrFontStyle_ objectAtIndex:++i];
    button.gradientStartPoint = CGPointMake(0.0f, 0.0f);
    button.gradientEndPoint = CGPointMake(1.0f, 1.0f);
    button.gradientColors = [NSArray arrayWithObjects:
                             [UIColor greenColor],
                             [UIColor orangeColor],
                             [UIColor brownColor],
                             [UIColor purpleColor],
                             [UIColor greenColor],
                             nil];
	button.strokeColor = [UIColor brownColor];
    button.colorType = ColorTypeGradients | ColorTypeStroke;
    
    // 13. PartyLetPlain
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"Georgia" size:kTitleMinFontSize];
	button.fillColor = [UIColor blackColor];
    button.colorType = ColorTypeFill;
    
    // 14. Baskerville-BoldItalic
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"Baskerville-BoldItalic" size:kTitleMinFontSize];
    button.strokeColor = [UIColor colorWithRed:0.9 green:0.6 blue:0.6 alpha:1.0];
    button.fillColor = [UIColor whiteColor];
    button.colorType = ColorTypeFill | ColorTypeStroke;
	
	// 15
	button = [arrFontStyle_ objectAtIndex:++i];
	button.titleLabel.font = [UIFont fontWithName:@"AppleColorEmoji" size:kTitleMinFontSize];
	button.fillColor = [UIColor purpleColor];
	button.colorType = ColorTypeFill;
	
    // 16. DBLCDTempBlack
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"DBLCDTempBlack" size:kTitleMinFontSize];
	button.fillColor = [UIColor blackColor];
    button.colorType = ColorTypeFill;
    
    // 17. SnellRoundhand-Black
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:kTitleMinFontSize];
	button.fillColor = [UIColor blackColor];
    button.colorType = ColorTypeFill;

	// 18. Zapfino
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:kTitleMinFontSize];
	button.fillColor = [UIColor orangeColor];
    button.colorType = ColorTypeFill;
	
    // 19. Zapfino
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:kTitleMinFontSize];
	button.gradientStartColor = [UIColor orangeColor];
    button.gradientEndColor = [UIColor brownColor];
    button.colorType = ColorTypeGradientStart | ColorTypeGradientEnd;
	
	// 20. Cochin-Bold
	button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"Cochin-Bold" size:kTitleMinFontSize];
	button.fillColor = [UIColor blackColor];
    button.colorType = ColorTypeFill;
    
    //21. Baskerville-BoldItalic 
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"Baskerville-BoldItalic" size:kTitleMinFontSize];
	button.fillColor = [UIColor magentaColor];
    button.titleLabel.shadowOffset = CGSizeMake(0.0f, 2.0f);
    button.titleLabel.shadowColor = [UIColor colorWithWhite:0.3f alpha:0.8f];
    button.shadowBlur = 5.0f;
    button.colorType = ColorTypeFill | ColorTypeShadow;
    
    //22. Verdana
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"Verdana" size:kTitleMinFontSize];
	button.fillColor = [UIColor brownColor];
    button.colorType = ColorTypeStroke;
    
    //23. Noteworthy-Bold
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"Noteworthy-Bold" size:kTitleMinFontSize];
    button.strokeColor = [UIColor blackColor];
    button.gradientStartColor = [UIColor greenColor];
    button.gradientEndColor = [UIColor blueColor];
    button.colorType = ColorTypeGradientStart | ColorTypeGradientEnd| ColorTypeStroke;
    
    //24. Palatino-BoldItalic
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"Palatino-BoldItalic" size:kTitleMinFontSize];
	button.fillColor = [UIColor greenColor];
    button.colorType = ColorTypeFill;
    
    //25. ArialHebrew-Bold
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"ArialHebrew-Bold" size:kTitleMinFontSize];
    button.titleLabel.shadowColor = [UIColor blackColor];
    button.titleLabel.shadowOffset = CGSizeZero;
    button.shadowBlur = 10.0f;
    button.innerShadowColor = [UIColor yellowColor];
    button.innerShadowOffset = CGSizeMake(1.0f, 2.0f);
    button.gradientStartColor = [UIColor redColor];
    button.gradientEndColor = [UIColor purpleColor];
    button.gradientStartPoint = CGPointMake(0.0f, 10);
    button.gradientEndPoint = CGPointMake(1.0f, 10);
    button.oversampling = 2;
    button.colorType = ColorTypeInnerShadow | ColorTypeGradientStart | ColorTypeGradientEnd;
    
    //26. TimesNewRomanPS-BoldItalicMT
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:kTitleMinFontSize];	
    button.gradientStartPoint = CGPointMake(0.0f, 0.0f);
    button.gradientEndPoint = CGPointMake(1.0f, 1.0f);
    button.gradientColors = [NSArray arrayWithObjects:
                             [UIColor redColor],
                             [UIColor blueColor],
                             nil];
    button.colorType = ColorTypeGradients;
    
    //27. Helvetica-BoldOblique
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:kTitleMinFontSize];
    button.gradientStartPoint = CGPointMake(0.0f, 0.0f);
    button.gradientEndPoint = CGPointMake(1.0f, 1.0f);
    button.gradientColors = [NSArray arrayWithObjects:
                             [UIColor yellowColor],
                             [UIColor blackColor],
                             [UIColor greenColor],
                             [UIColor blackColor],
                             nil];
    button.colorType = ColorTypeGradients;
    
    //28. TrebuchetMS
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:kTitleMinFontSize];
	button.strokeColor = [UIColor blackColor];
    button.fillColor = [UIColor blueColor];
    button.titleLabel.shadowOffset = CGSizeMake(0.0f, 4.0f);
    button.titleLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    button.shadowBlur = 3.0f;
    button.colorType = ColorTypeStroke | ColorTypeFill | ColorTypeShadow;
    
    //29. OriyaSangamMN-Bold
    button = [arrFontStyle_ objectAtIndex:++i]; 
    button.titleLabel.font = [UIFont fontWithName:@"OriyaSangamMN-Bold" size:kTitleMinFontSize];
    button.gradientStartPoint = CGPointMake(0.0f, 0.0f);
    button.gradientEndPoint = CGPointMake(1.0f, 1.0f);
    button.gradientColors = [NSArray arrayWithObjects:
                             [UIColor blueColor],
                             [UIColor yellowColor],
                             [UIColor magentaColor],
                             [UIColor redColor],
                             [UIColor blueColor],
                             [UIColor yellowColor],
                             [UIColor blueColor],
                             nil];
    button.colorType = ColorTypeGradients;
    
    //30. STHeitiSC-Medium
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:kTitleMinFontSize];
    button.strokeColor = [UIColor magentaColor];
    button.titleLabel.shadowOffset = CGSizeMake(0.0f, 4.0f);
    button.titleLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.9f];
    button.shadowBlur = 5.0f;
    button.colorType = ColorTypeStroke | ColorTypeShadow;
    
    //31. GurmukhiMN-Bold
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"GurmukhiMN-Bold" size:kTitleMinFontSize];
	button.strokeColor = [UIColor blackColor];
    button.fillColor = [UIColor yellowColor];
    button.colorType = ColorTypeStroke | ColorTypeFill;
    
    //32. GurmukhiMN-Bold
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"GurmukhiMN-Bold" size:kTitleMinFontSize];
	button.strokeColor = [UIColor blackColor];
    button.fillColor = [UIColor redColor];
    button.colorType = ColorTypeStroke | ColorTypeFill; 
    
    //33. kailasa
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"kailasa" size:kTitleMinFontSize];
	button.strokeColor = [UIColor purpleColor];
    button.fillColor = [UIColor yellowColor];
    button.colorType = ColorTypeStroke | ColorTypeFill;
    
    //34. Georgia-BoldItalic
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"Georgia-BoldItalic" size:kTitleMinFontSize];
    button.innerShadowColor = [UIColor blackColor];
    button.innerShadowOffset =CGSizeMake(0.5f, 1.0f);
    button.gradientStartPoint = CGPointMake(0.0f, 0.0f);
    button.gradientEndPoint = CGPointMake(1.0f, 1.0f);
    button.gradientColors = [NSArray arrayWithObjects:
                             [UIColor purpleColor],
                             [UIColor darkGrayColor],
                             [UIColor yellowColor],
                             [UIColor purpleColor],
                             [UIColor yellowColor],
                             [UIColor darkGrayColor],
                             [UIColor purpleColor],
                             nil];
    button.colorType = ColorTypeGradients | ColorTypeInnerShadow;
    
    //35. Cochin-Italic
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"Cochin-Italic" size:kTitleMinFontSize];
	button.fillColor = [UIColor colorWithRed:0.9 green:0.4 blue:0.4 alpha:1.0];
    button.strokeColor = [UIColor purpleColor];
    button.colorType = ColorTypeFill | ColorTypeStroke;
    
    //36. Palatino-BoldItalic
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"Palatino-BoldItalic" size:kTitleMinFontSize];
    button.fillColor = [UIColor whiteColor];
    button.strokeColor = [UIColor blackColor];
    button.colorType = ColorTypeFill | ColorTypeStroke;
    
    //37. MarkerFelt-Thin
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:kTitleMinFontSize];
    button.fillColor = [UIColor blueColor];
	button.shadowBlur = 20.0f;
    button.innerShadowColor = [UIColor whiteColor];
    button.innerShadowOffset = CGSizeMake(2.0f, 1.0f);
    button.colorType = ColorTypeShadow | ColorTypeFill | ColorTypeInnerShadow;
    
    //38. SnellRoundhand-Bold
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"SnellRoundhand-Bold" size:kTitleMinFontSize];
    button.fillColor = [UIColor colorWithRed:0.4 green:0.7 blue:0.9 alpha:1.0];
    button.colorType = ColorTypeFill;
    
    //39. Courier-BoldOblique
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"Courier-BoldOblique" size:kTitleMinFontSize];
    button.gradientStartPoint = CGPointMake(0.0f, 0.0f);
    button.gradientEndPoint = CGPointMake(1.0f, 1.0f);
    button.gradientColors = [NSArray arrayWithObjects:
                             [UIColor yellowColor],
                             [UIColor orangeColor],
                             [UIColor yellowColor],
                             [UIColor orangeColor],
                             nil];
    button.colorType = ColorTypeGradients;

    //40. Noteworthy-Light
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"Noteworthy-Light" size:kTitleMinFontSize];
    button.fillColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.5 alpha:0.8];
    button.colorType = ColorTypeFill;
    
    //41. Georgia-Italic
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"Georgia-Italic" size:kTitleMinFontSize];
	button.strokeColor = [UIColor blackColor];
    button.fillColor = [UIColor colorWithRed:0.2 green:0.9 blue:0.6 alpha:0.6];
    button.titleLabel.shadowOffset = CGSizeMake(0.0f, 3.0f);
    button.titleLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    button.shadowBlur = 3.0f;
    button.colorType = ColorTypeStroke | ColorTypeFill | ColorTypeShadow;
    
    //42. SnellRoundhand
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"SnellRoundhand" size:kTitleMinFontSize];
    button.fillColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    button.colorType = ColorTypeFill;
    
    //43. HelveticaNeue-BoldItalic
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:kTitleMinFontSize];
	button.fillColor = [UIColor whiteColor];
    button.strokeColor = [UIColor blueColor];
    button.colorType = ColorTypeFill | ColorTypeStroke;
    
    //44. Palatino-BoldItalic
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"Palatino-BoldItalic" size:kTitleMinFontSize];
	button.innerShadowColor = [UIColor blackColor];
    button.innerShadowOffset =CGSizeMake(0.5f, 1.0f);
    button.gradientStartPoint = CGPointMake(0.0f, 0.0f);
    button.gradientEndPoint = CGPointMake(1.0f, 1.0f);
    button.gradientColors = [NSArray arrayWithObjects:
                             [UIColor darkGrayColor],
                             [UIColor blueColor],
                             [UIColor magentaColor],
                             [UIColor blueColor],
                             [UIColor darkGrayColor],
                             nil];
    button.colorType = ColorTypeGradients | ColorTypeInnerShadow;
    
    //45. Noteworthy-Light
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"Noteworthy-Light" size:kTitleMinFontSize];
    button.fillColor = [UIColor colorWithRed:0.5 green:1.0 blue:1.0 alpha:1.0];
    button.colorType = ColorTypeFill;
    
    //46. DBLCDTempBlack
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"DBLCDTempBlack" size:kTitleMinFontSize];
	button.fillColor = [UIColor greenColor];
    button.colorType = ColorTypeFill;
    
    //47. Georgia
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"Georgia" size:kTitleMinFontSize];
	button.fillColor = [UIColor blueColor];
	button.shadowBlur = 20.0f;
    button.innerShadowColor = [UIColor whiteColor];
    button.innerShadowOffset = CGSizeMake(0.5f, 1.0f);
    button.colorType = ColorTypeShadow | ColorTypeFill | ColorTypeInnerShadow;
    
    //48. MarkerFelt-Wide
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:kTitleMinFontSize];
    button.strokeColor = [UIColor blackColor];
    button.fillColor = [UIColor redColor];
    button.colorType = ColorTypeFill | ColorTypeStroke;
    
    //49.
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.shadowColor = [UIColor blackColor];
    button.titleLabel.shadowOffset = CGSizeZero;
    button.shadowBlur = 20.0f;
    button.innerShadowColor = [UIColor yellowColor];
    button.innerShadowOffset = CGSizeMake(1.0f, 2.0f);
    button.gradientStartColor = [UIColor magentaColor];
    button.gradientEndColor = [UIColor yellowColor];
    button.gradientStartPoint = CGPointMake(0.0f, 15);
    button.gradientEndPoint = CGPointMake(1.0f, 15);
    button.oversampling = 2;
    button.colorType = ColorTypeInnerShadow | ColorTypeGradientStart | ColorTypeGradientEnd;
    
    //50. Noteworthy-Bold
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"Noteworthy-Bold" size:kTitleMinFontSize];
    button.fillColor = [UIColor colorWithRed:0.4f green:0.8f blue:0.9f alpha:1.0];
    button.colorType = ColorTypeFill;
    
    //51. Baskerville-BoldItalic
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"Baskerville-BoldItalic" size:kTitleMinFontSize];
	button.fillColor = [UIColor redColor];
    button.titleLabel.shadowOffset = CGSizeMake(0.0f, 2.0f);
    button.titleLabel.shadowColor = [UIColor colorWithWhite:0.3f alpha:0.8f];
    button.shadowBlur = 5.0f;
    button.colorType = ColorTypeFill | ColorTypeShadow;
    
    //52. MarkerFelt-Wide
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:kTitleMinFontSize];
    button.fillColor = [UIColor colorWithRed:1.0f green:0.5f blue:0.7f alpha:1.0];
	button.shadowBlur = 20.0f;
    button.innerShadowColor = [UIColor whiteColor];
    button.innerShadowOffset = CGSizeMake(2.0f, 1.0f);
    button.colorType = ColorTypeShadow | ColorTypeFill | ColorTypeInnerShadow;
    
    //53. MalayalamSangamMN-Bold
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"MalayalamSangamMN-Bold" size:kTitleMinFontSize];
    button.gradientStartPoint = CGPointMake(0.0f, 0.0f);
    button.gradientEndPoint = CGPointMake(1.0f, 1.0f);
    button.gradientColors = [NSArray arrayWithObjects:
                             [UIColor blueColor],
                             [UIColor orangeColor],
                             [UIColor darkGrayColor],
                             [UIColor orangeColor],
                             [UIColor blueColor],
                             nil];
    button.colorType = ColorTypeGradients;
    
    //54. Futura-CondensedExtraBold
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:kTitleMinFontSize];
	button.strokeColor = [UIColor whiteColor];
    button.fillColor = [UIColor colorWithRed:0.5f green:0.7f blue:0.7f alpha:1.0];
    button.titleLabel.shadowOffset = CGSizeMake(0.0f, 4.0f);
    button.titleLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    button.shadowBlur = 3.0f;
    button.colorType = ColorTypeStroke | ColorTypeFill | ColorTypeShadow;
    
    //55. AppleGothic
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"AppleGothic" size:kTitleMinFontSize];
    button.fillColor = [UIColor magentaColor];
	button.shadowBlur = 10.0f;
    button.innerShadowColor = [UIColor darkGrayColor];
    button.innerShadowOffset = CGSizeMake(2.0f, 1.0f);
    button.colorType = ColorTypeFill | ColorTypeInnerShadow | ColorTypeShadow;
    
    //56. DBLCDTempBlack
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"DBLCDTempBlack" size:kTitleMinFontSize];
    button.gradientStartPoint = CGPointMake(0.0f, 0.0f);
    button.gradientEndPoint = CGPointMake(1.0f, 1.0f);
    button.gradientColors = [NSArray arrayWithObjects:
                             [UIColor blackColor],
                             [UIColor purpleColor],
                             [UIColor blackColor],
                             nil];
    button.colorType = ColorTypeGradients;
    
    //57. GurmukhiMN 
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"GurmukhiMN" size:kTitleMinFontSize];
    button.fillColor = [UIColor colorWithRed:0.9f green:0.1f blue:0.6f alpha:1.0];
    button.colorType = ColorTypeFill;
    
    //58. CourierNewPS-BoldItalicMT
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"CourierNewPS-BoldItalicMT" size:kTitleMinFontSize];
    button.fillColor = [UIColor yellowColor];
    button.strokeColor = [UIColor blackColor];
    button.colorType = ColorTypeFill | ColorTypeStroke;
    
    //59. SnellRoundhand-Bold
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"SnellRoundhand-Bold" size:kTitleMinFontSize];
    button.fillColor = [UIColor colorWithRed:0.2f green:0.0f blue:0.7f alpha:1.0];
    button.colorType = ColorTypeFill;
    
    //60. Futura-MediumItalic
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"Futura-MediumItalic" size:kTitleMinFontSize];
    button.gradientStartColor = [UIColor redColor];
    button.gradientEndColor = [UIColor orangeColor];
    button.colorType = ColorTypeGradientStart | ColorTypeGradientEnd;
    
    //61. DevanagariSangamMN-Bold
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"DevanagariSangamMN-Bold" size:kTitleMinFontSize];
    button.titleLabel.shadowColor = [UIColor blackColor];
    button.titleLabel.shadowOffset = CGSizeZero;
    button.shadowBlur = 20.0f;
    button.innerShadowColor = [UIColor yellowColor];
    button.innerShadowOffset = CGSizeMake(1.0f, 2.0f);
    button.gradientStartColor = [UIColor orangeColor];
    button.gradientEndColor = [UIColor yellowColor];
    button.gradientStartPoint = CGPointMake(0.0f, 15);
    button.gradientEndPoint = CGPointMake(1.0f, 15);
    button.oversampling = 2;
    button.colorType = ColorTypeInnerShadow | ColorTypeGradientStart | ColorTypeGradientEnd;
    
    //62. MarkerFelt-Thin
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:kTitleMinFontSize];
    button.strokeColor = [UIColor blackColor];
    button.fillColor = [UIColor colorWithRed:0.4 green:0.7 blue:0.9 alpha:1.0];
    button.colorType = ColorTypeFill | ColorTypeStroke;
    
    //63. STHeitiK-Medium
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"STHeitiK-Medium" size:kTitleMinFontSize];
	button.strokeColor = [UIColor blackColor];
    button.fillColor = [UIColor orangeColor];
    button.titleLabel.shadowOffset = CGSizeMake(0.0f, 4.0f);
    button.titleLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    button.shadowBlur = 3.0f;
    button.colorType = ColorTypeStroke | ColorTypeFill | ColorTypeShadow;
    
    //64. AppleColorEmoji
    button = [arrFontStyle_ objectAtIndex:++i];
    button.titleLabel.font = [UIFont fontWithName:@"AppleColorEmoji" size:kTitleMinFontSize];
	button.fillColor = [UIColor blackColor];
    button.colorType = ColorTypeFill;
}

/**
 * @brief 初始化导航栏上的button
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)initNavigatinBarButtons
{
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelBarBtn;
    [cancelBtn release];
    [cancelBarBtn release];
	
	UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [confirmBtn setImage:[UIImage imageNamed:@"confirm.png"] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *confirmBarBtn = [[UIBarButtonItem alloc] initWithCustomView:confirmBtn];
    self.navigationItem.rightBarButtonItem = confirmBarBtn;
    [confirmBarBtn release];
    [confirmBtn release];
}

#pragma mark -
#pragma mark View Appear Methods
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// 添加新标题需要重置预览视图的样式 编辑的话就要用编辑的标题样式初始化预览视图
	if (operateType_ == TitleOperateTypeAdd)
	{
		textFieldInput_.text = nil;
		
		FXButton *btn = [[FXButton alloc] init];
		btn.titleLabel.text = kLabelDefaultText;
		btn.titleLabel.font = [UIFont systemFontOfSize:kTitlePreviewFontSize];
		btn.fillColor = [UIColor blackColor];
		btn.colorType = ColorTypeFill;
		btnStyleSelected_.titleLabel.text = kLabelDefaultText;
		[btnStyleSelected_ updateFromButton:btn fontSize:kTitlePreviewFontSize];
		[btn release];
	}
	else if (operateType_ == TitleOperateTypeEdit)
	{
		FXButton *btn = (FXButton*)[[viewCurrentEdit_ subviews] objectAtIndex:0];
		btnStyleSelected_.titleLabel.text = btn.titleLabel.text;		
		[btnStyleSelected_ updateFromButton:btn fontSize:kTitlePreviewFontSize];
		
		textFieldInput_.text = btn.titleLabel.text;
	}
}

#pragma mark -
#pragma mark Scroll View Delegate Methods

/**
 * @brief scrollView滑动获取页数
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)scrollViewDidScroll:(UIScrollView *)sender 
{
    CGFloat pageWidth = scrollViewStyles_.frame.size.width;
    int page = floor((scrollViewStyles_.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl_.currentPage = page;
    NSArray *subView = pageControl_.subviews;     
	for (int i = 0; i < [subView count]; i++) 
    {
		UIImageView *dot = [subView objectAtIndex:i];
		dot.image = (pageControl_.currentPage == i ? [UIImage imageNamed:@"blackPoint.png"] : [UIImage imageNamed:@"emptyPoint.png"]);
	}
}

#pragma mark -
#pragma mark pageControl切换页面响应函数

/**
 * @brief 切换到指定页面
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (IBAction)changePage:(id)sender 
{ 
    int page =  ((UIPageControl *)sender).currentPage;
    NSArray *subViews = ((UIPageControl *)sender).subviews;
    for (int i = 0; i < [subViews count]; i++) 
    {
        UIView *subView = [subViews objectAtIndex:i];
        ((UIImageView *)subView).image = (page == i ? [UIImage imageNamed:@"blackPoint.png"] : [UIImage imageNamed:@"emptyPoint.png"]);
    }
    //根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
    CGRect frame = scrollViewStyles_.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollViewStyles_ scrollRectToVisible:frame animated:YES]; 
}

#pragma mark -
#pragma mark 导航栏按钮响应函数
/**
 * @brief 点击导航栏上的cancel按钮
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)cancelButtonPressed
{
	if (operateType_ == TitleOperateTypeAdd)
	{
		[self.navigationController popViewControllerAnimated:YES];
	}
	else if (operateType_ == TitleOperateTypeEdit)
	{
		[self.navigationController pushViewController:vcEdit_ animated:YES];
	}
}

/**
 * @brief 点击导航栏上的confirm按钮
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)confirmButtonPressed
{
	if ([textFieldInput_ isFirstResponder])
	{
		[self textFieldDoneEdit:textFieldInput_];
	}

    if (operateType_ == TitleOperateTypeEdit)			//编辑标题
	{
		[self.navigationController pushViewController:vcEdit_ animated:YES];
        [vcEdit_ addTitle:btnStyleSelected_ tag:viewCurrentEdit_.tag operateType:TitleOperateTypeEdit];	
    }
    else if (operateType_ == TitleOperateTypeAdd)		//添加新标题
	{
		if (vcEdit_ == nil)
		{
			vcEdit_ = [[TitleEditViewController alloc] initWithParentViewController:self];
		}
		[self.navigationController pushViewController:vcEdit_ animated:YES];
		[vcEdit_ addTitle:self.btnStyleSelected tag:0 operateType:TitleOperateTypeAdd];
    }
}

#pragma mark -
#pragma mark 点击预览字体按钮
/**
 * @brief 点击显示当前选中的字体按钮
 *
 * @param [in] sender: 被点击的按钮
 * @param [out]
 * @return 
 * @note 
 */
- (IBAction)styleSelectButtonPressed:(id)sender
{
	if ([textFieldInput_ isFirstResponder])
	{
		[textFieldInput_ resignFirstResponder];
	}
	return;
	
    [self getColorTypeStringArrayByColorType:btnStyleSelected_.colorType];
    
    UITableViewController *vc = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kBackGroundImage]];
    vc.tableView.dataSource = self;
    vc.tableView.delegate = self;
    vc.view.frame = CGRectMake(0, 0, 160, kColorMenuRowHeight * arrFontColorTypeName_.count);
    if (vcPopover_ != nil)
    {
        RELEASE_OBJECT(vcPopover_);
    }
    vcPopover_ = [[IMPopoverController alloc] initWithContentViewController:vc];
    vcPopover_.deletage = nil;
	vcPopover_.popOverSize = vc.view.frame.size;
    CGRect newRect = CGRectMake(self.view.frame.size.width/2 - vc.view.frame.size.width/2 , 
                                self.view.frame.size.height/2 -  vc.view.frame.size.height/2, 
                                vc.view.frame.size.width,
                                vc.view.frame.size.height);
	[vcPopover_ presentPopoverFromRect:newRect inView:self.view animated:YES];
    [vc release];
}

#pragma mark -
#pragma mark TextField Deletage Methods
/**
 * @brief 文本框完成编辑，即按下enter键位
 *
 * @param [in] textField: 当前获得焦点的textfield
 * @param [out]
 * @return 
 * @note 
 */
- (void)textFieldDoneEdit:(UITextField*)textField
{
	[textField resignFirstResponder];
    
    NSString *text = textField.text;
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    textField.text = ([text isEqualToString:@""] || text == nil) ? kLabelDefaultText : text;
	if (![textField.text isEqualToString:btnStyleSelected_.titleLabel.text])
	{
		btnStyleSelected_.titleLabel.text = textField.text;
		[btnStyleSelected_ setNeedsDisplay];
	}
}

/**
 * @brief 文本框的内容正在发生变化
 *
 * @param [in] textField: 当前获得焦点的textfield
 * @param [out]
 * @return 
 * @note 
 */
- (void)textFieldEditChanged:(UITextField*)textField
{
	NSString *strText = [textField.text isEqualToString:@""] ? kLabelDefaultText : textField.text;
	if (strText.length > kTitleMaxLength)
	{
		NSString *strNewText = [strText substringToIndex:kTitleMaxLength];
		textField.text = strNewText;
		strText = strNewText;
	}
	
	if (![strText isEqualToString:btnStyleSelected_.titleLabel.text]) 
	{
		btnStyleSelected_.titleLabel.text = strText;
		[btnStyleSelected_ setNeedsDisplay];
	}
}

// 限制输入的字符数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
	
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
	return [toBeString length] <= kTitleMaxLength ? YES : NO;
}

#pragma mark -
#pragma mark 键盘显示，消失事件

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardFrame;
    [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
     
    [UIView beginAnimations:@"TextFieldMoveUp" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGRect oldFrame = imageViewTextField_.frame;
    CGRect newFrame = { oldFrame.origin.x, 
                        self.view.frame.size.height - keyboardFrame.size.height - oldFrame.size.height, 
                        oldFrame.size.width,
                        oldFrame.size.height
                      };
    imageViewTextField_.frame = newFrame;
    CGRect oldFrameBtn = btnStyleSelected_.frame;
    btnStyleSelected_.frame = CGRectMake(oldFrameBtn.origin.x, oldFrameBtn.origin.y, oldFrameBtn.size.width, oldFrameBtn.size.height + newFrame.origin.y - oldFrame.origin.y);
    [self.view bringSubviewToFront:imageViewTextField_];
    [btnStyleSelected_ setNeedsDisplay];
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView beginAnimations:@"TextFieldMoveDown" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGRect oldFrame = imageViewTextField_.frame;
    CGRect newFrame = { oldFrame.origin.x, 
                        self.view.frame.size.height - scrollViewStyles_.frame.size.height - oldFrame.size.height, 
                        oldFrame.size.width, 
                        oldFrame.size.height
                      };
    imageViewTextField_.frame = newFrame;
    CGRect oldFrameBtn = btnStyleSelected_.frame;
    btnStyleSelected_.frame = CGRectMake(oldFrameBtn.origin.x, oldFrameBtn.origin.y, oldFrameBtn.size.width, oldFrameBtn.size.height + newFrame.origin.y-oldFrame.origin.y);
    [btnStyleSelected_ setNeedsDisplay];
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark 点击ScrollView上的button
/**
 * @brief 点击标题效果列表上的某一个标题
 *
 * @param [in] sender: 选中的标题
 * @param [out]
 * @return 
 * @note 
 */
- (IBAction)buttonTouchUpInside:(id)sender
{
    if ([textFieldInput_ isFirstResponder])
        [textFieldInput_ resignFirstResponder];
    
    NSString *text = textFieldInput_.text;
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    btnStyleSelected_.titleLabel.text = ([text isEqualToString:@""] || text == nil) ? kLabelDefaultText : text;
    
    FXButton *button = (FXButton*)sender;
    [btnStyleSelected_ updateFromButton:button fontSize:kTitlePreviewFontSize];
}

#pragma mark -
#pragma mark Table View Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrFontColorTypeName_.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kColorMenuRowHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                            SimpleTableIdentifier];
    if (cell == nil) {    
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  
                                      reuseIdentifier:SimpleTableIdentifier] autorelease];  
    }
    
    cell.textLabel.text = [arrFontColorTypeName_ objectAtIndex:[indexPath row]];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.textLabel.textColor = [UIColor getColor:kEffectButtonDeselectStringColor];
    cell.textLabel.highlightedTextColor = [UIColor getColor:kEffectButtonSelectStringColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [vcPopover_ dismissPopoverAnimated:YES];
    RELEASE_OBJECT(vcPopover_);
    
    UIColor *color = [arrFontColor_ objectAtIndex:indexPath.row];
    int type = [[arrFontColorType_ objectAtIndex:indexPath.row] intValue];
    
    ColorSelectViewController *vc = [[ColorSelectViewController alloc] initWithType:type color:color parentVC:self];
    vcPopover_ = [[IMPopoverController alloc] initWithContentViewController:vc];
    vcPopover_.deletage = nil;
    vcPopover_.popOverSize = vc.view.frame.size;
    
    CGRect newRect = CGRectMake(self.view.frame.size.width/2 - vc.view.frame.size.width/2 , 
                                0, 
                                vc.view.frame.size.width,
                                vc.view.frame.size.height);
	[vcPopover_ presentPopoverFromRect:newRect inView:self.view animated:YES];
    [vc release];
}

#pragma mark -
#pragma mark 根据颜色种类获取颜色种类的名称

/**
 * @brief 根据颜色种类获取颜色种类的名称
 *
 * @param [in] type: 颜色种类
 * @param [out]
 * @return 
 * @note 
 */
- (void)getColorTypeStringArrayByColorType:(int)type
{
    [arrFontColorType_ removeAllObjects];
    [arrFontColorTypeName_ removeAllObjects];
    [arrFontColor_ removeAllObjects];
    
    if (type & ColorTypeFill)
    {
        [arrFontColorType_ addObject:[NSNumber numberWithInt:ColorTypeFill]];
        [arrFontColorTypeName_ addObject:@"填充色"];
        if (btnStyleSelected_.fillColor != nil)
            [arrFontColor_ addObject:btnStyleSelected_.fillColor];
        else
        {
            UIColor *color = btnStyleSelected_.titleLabel.textColor;
            [arrFontColor_ addObject:color];
        }
    }
    if (type & ColorTypeStroke)
    {
        [arrFontColorType_ addObject:[NSNumber numberWithInt:ColorTypeStroke]];
        [arrFontColorTypeName_ addObject:@"边框色"];
        [arrFontColor_ addObject:btnStyleSelected_.strokeColor];
    }
    if (type & ColorTypeShadow)
    {
        [arrFontColorType_ addObject:[NSNumber numberWithInt:ColorTypeShadow]];
        [arrFontColorTypeName_ addObject:@"阴影色"];
        [arrFontColor_ addObject:btnStyleSelected_.titleLabel.shadowColor];
    }
    if (type & ColorTypeInnerShadow)
    {
        [arrFontColorType_ addObject:[NSNumber numberWithInt:ColorTypeInnerShadow]];
        [arrFontColorTypeName_ addObject:@"内阴影色"];
        [arrFontColor_ addObject:btnStyleSelected_.innerShadowColor];
    }
    if (type & ColorTypeGradientStart)
    {
        [arrFontColorType_ addObject:[NSNumber numberWithInt:ColorTypeGradientStart]];
        [arrFontColorTypeName_ addObject:@"渐变起始色"];
        [arrFontColor_ addObject:btnStyleSelected_.gradientStartColor];
    }
    if (type & ColorTypeGradientEnd)
    {
        [arrFontColorType_ addObject:[NSNumber numberWithInt:ColorTypeGradientEnd]];
        [arrFontColorTypeName_ addObject:@"渐变终止色"];
        [arrFontColor_ addObject:btnStyleSelected_.gradientEndColor];
    }
}

/**
 * @brief 根据指定类型颜色更新字体样式按钮
 *
 * @param [in] type: 颜色的类型
 * @param [in] color: 颜色
 * @param [out]
 * @return 
 * @note 
 */
- (void)updateStyleButtonWithType:(int)type color:(UIColor *)color
{
    switch (type)
    {
        case ColorTypeFill:
            btnStyleSelected_.fillColor = color;
            break;
        case ColorTypeStroke:
            btnStyleSelected_.strokeColor = color;
            break;
        case ColorTypeShadow:
            btnStyleSelected_.titleLabel.shadowColor = color;
            break;
        case ColorTypeInnerShadow:
            btnStyleSelected_.innerShadowColor = color;
            break;
        case ColorTypeGradientStart:
            btnStyleSelected_.gradientStartColor = color;
            break;
        case ColorTypeGradientEnd:
            btnStyleSelected_.gradientEndColor = color;
            break;
        default:
            break;
    }
    
    [btnStyleSelected_ setNeedsDisplay];
}

@end
