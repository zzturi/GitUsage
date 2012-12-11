//
//  FilmFrameEffectViewController.m
//  Aico
//
//  Created by wang cuicui on 3/29/12.
//  Copyright (c) 2012 Cienet. All rights reserved.
//

#import "FilmFrameEffectViewController.h"
#import "GlobalDef.h"
#import "MainViewController.h"
#import "UIColor+extend.h"
#import "ImageScrollViewController.h"
#import "ReUnManager.h"
#import <QuartzCore/QuartzCore.h>


//边框中的8种边框效果。
typedef enum _TFrameIndex 
{
    EWhiteFrame = 0,
    EBlackFrame,
    EClassicsFrame,
    ELovelyFrame,
    EFilmFrame,
    EFeelingFrame,
    EVideoFrame,
    ESellotapeFrame,
    EImageFrameTotal,
    EDesaltEdgeFrame,
    EColorImageFrameTotle
}TFrameIndex;

@implementation FilmFrameEffectViewController
@synthesize frameImage = frameImage_;
@synthesize sourceImage = sourceImage_;
@synthesize frameEffectImage = frameEffectImage_;
@synthesize effectType = effectType_;
@synthesize frameEffectScrollView = frameEffectScrollView_; 
@synthesize frameColorScollView = frameColorScollView_;
@synthesize simpleFrameButton = simpleFrameButton_;
@synthesize colorfulFrameButton = colorfulFrameButton_;
//@synthesize frameImageView = frameImageView_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
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

- (void) dealloc
{
    self.frameImage = nil;
    self.sourceImage = nil;
    self.frameEffectImage = nil;
    self.frameEffectScrollView = nil;
    self.frameColorScollView = nil;
    self.simpleFrameButton = nil;
    self.colorfulFrameButton = nil;
    RELEASE_OBJECT(imageScrollVC_);
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self buttonInFrameScrollView];
    self.navigationController.navigationBarHidden = NO;   
    
    //设置导航拦的背景
    [Common setNavigationBarBackgroundBkg:self.navigationController.navigationBar];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgImage.png"]]];

    self.frameEffectScrollView.contentSize = CGSizeMake(64*8, kScrollViewPointY);
    self.frameColorScollView.contentSize = CGSizeMake(64*8, kScrollViewPointY);
    
    //显示图片
    self.sourceImage = [[ReUnManager sharedReUnManager] getGlobalSrcImage];
    imageScrollVC_ = [[ImageScrollViewController alloc] init];
    
    self.frameEffectImage = (UIImageView *)[imageScrollVC_.view viewWithTag:kZoomViewTag];
    self.frameEffectImage.frame = [Common adaptImageToScreen:[[ReUnManager sharedReUnManager] getGlobalSrcImage]];
    [self.view insertSubview:imageScrollVC_.view atIndex:0];
    
    //添加取消按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:kEffectCancelButtonFrameRect];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:kEffectCancelImage] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelBarBtn;
    [cancelBtn release];
    [cancelBarBtn release];

    //添加确定按钮
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:kEffectConfirmButtonFrameRect];
    [confirmBtn addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:kEffectConfirmImage] forState:UIControlStateNormal];
    UIBarButtonItem *confirmBarBtn = [[UIBarButtonItem alloc] initWithCustomView:confirmBtn];
    self.navigationItem.rightBarButtonItem = confirmBarBtn;
    [confirmBarBtn release];
    [confirmBtn release];
    
    //添加“炫彩边框按钮"
    UIButton *colorButton = [[UIButton alloc] initWithFrame:kEffectColorButtonFrameRect];
    [colorButton setBackgroundImage:[UIImage imageNamed:kEffectSimpleFrameButton] forState:UIControlStateNormal];
    [colorButton setTitle:kEffectColorButtonString forState:UIControlStateNormal];
    [colorButton setTitleColor:[UIColor getColor:kEffectButtonDeselectStringColor] forState:UIControlStateNormal];
    colorButton.titleLabel.font = [UIFont systemFontOfSize:kButtonStringSize];
    //设置汉字显示的位置
    colorButton.titleEdgeInsets = UIEdgeInsetsMake(7, 0, 0, 0);
    [colorButton addTarget:self action:@selector(colorfulFrameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //在炫彩边框的开发中要去掉不能点击和隐藏
    colorButton.enabled = NO;
    colorButton.hidden = YES;
    self.colorfulFrameButton = colorButton;
    [self.view addSubview:self.colorfulFrameButton];
    [colorButton release];
    
    //添加“简单边框按钮”
    UIButton *simpleButton = [[UIButton alloc] initWithFrame:kEffectSimpleButtonFrameRect];
    [simpleButton setBackgroundImage:[UIImage imageNamed:kEffectSimpleFrameButton] forState:UIControlStateNormal];
    [simpleButton setTitle:kEffectSimpleButtonString forState:UIControlStateNormal];
    [simpleButton setTitleColor:[UIColor getColor:kEffectButtonDeselectStringColor] forState:UIControlStateNormal];
    simpleButton.titleLabel.font = [UIFont systemFontOfSize:kButtonStringSize];
    //设置汉字显示的位置
    simpleButton.titleEdgeInsets = UIEdgeInsetsMake(7, -10, 0, 0);
    [simpleButton addTarget:self action:@selector(simpleFrameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.simpleFrameButton = simpleButton;
    [self.view addSubview:self.simpleFrameButton];
    [simpleButton release];
    
    //makeFrameEffect 方法是根据选择的边框效果做相应的操作
    [self performSelector:@selector(makeFrameEffect)];
}

- (void)viewDidUnload
{
    RELEASE_OBJECT(imageScrollVC_);
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidDisappear:(BOOL)animated
{
    UIScrollView *scrollView = (UIScrollView *)[imageScrollVC_.view viewWithTag:kMainScrollViewTag];
    scrollView.delegate = nil;
    [super viewDidDisappear:animated];
}

#pragma mark buttonPressed  and Taps
/**
 * @brief 
 * 取消按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)cancelButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * @brief 
 * 确定按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)confirmButtonPressed:(id)sender
{    
    ReUnManager *rm = [ReUnManager sharedReUnManager];
    [rm storeImage:self.frameEffectImage.image];
    
    NSArray *array = [self.navigationController viewControllers];
    [self.navigationController popToViewController:(MainViewController *)[array objectAtIndex:([array count] - 3)] animated:YES];
}

/**
 * @brief 
 * 简单边框按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */

- (void)simpleFrameButtonPressed:(id)sender
{
    //被点击的按钮会有被放大,另一个会回复原来的大小,主要是背景图片
    [self changeButtonStringAndBackGround];
    [self.view bringSubviewToFront:self.simpleFrameButton];
    [self.colorfulFrameButton setTitleColor:[UIColor getColor:kEffectButtonDeselectStringColor] forState:UIControlStateNormal];
    [self.colorfulFrameButton setBackgroundImage:[UIImage imageNamed:kEffectSimpleFrameButton] forState:UIControlStateNormal];
    //显示简单边框按钮对应的视图，隐藏炫彩边框按钮对应的视图
    self.frameEffectScrollView.hidden = NO;
    self.frameColorScollView.hidden = YES;
}
/**
 * @brief 
 * 绚彩边框按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)colorfulFrameButtonPressed:(id)sender
{
    //被点击的按钮会有被放大,另一个会回复原来的大小，主要是背景图片
//    [self.simpleFrameButton setTitleColor:[UIColor getColor:kEffectButtonDeselectStringColor] forState:UIControlStateNormal];
//    [self.simpleFrameButton setBackgroundImage:[UIImage imageNamed:kEffectSimpleFrameButton] forState:UIControlStateNormal];
//    
//    [self.view bringSubviewToFront:self.colorfulFrameButton];
//    [self.colorfulFrameButton setTitleColor:[UIColor getColor:kEffectButtonSelectStringColor] forState:UIControlStateNormal];
//    [self.colorfulFrameButton setBackgroundImage:[UIImage imageNamed:kEffectSelectButtonBackGround] forState:UIControlStateNormal];
//    //显示炫彩边框按钮对应的视图，隐藏简单边框按钮对应的视图
//    self.frameColorScollView.hidden = NO;
//    self.frameEffectScrollView.hidden = YES;
 
    //由于此功能还没有开放，弹出没有开放的提示框
//    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"此功能暂未开放" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [av show];
//    [av release];
    [Common showToastView:@"此功能还在开发中，敬请期待" hiddenInTime:2.0f];
}



#pragma mark picture process

/**
 * @brief  将图片和边框合成一张图片。
 *
 * @param [in]  边框的名称
 * @param [out] 合并后的图片 
 * @return　　  
 * @note
 */

- (void) mergeImage:(NSString *)frameName  
{  
    //依照上面的尺寸在imageView上重新画出该图片作为第一张图片。
    //modified by jiangliyin on 2012-6-26 修改 给小图添加边框，边框模糊问题
    CGFloat imageWidth = self.frameEffectImage.frame.size.width;//self.frameEffectImage.image.size.width;
    CGFloat imageHeight = self.frameEffectImage.frame.size.height;//self.frameEffectImage.image.size.height;
    CGFloat frameShadowWidth,frameShadowHeight;
    
    //根据不同不同边框的大小，阴影的大小分别处理，阴影和边框总宽度是测量出来的
    //除数是边框的宽和长，乘数数字和阴影的宽度

    //获取第二张图片即边框。
    self.frameImage = [UIImage imageNamed:frameName];
    if ([frameName isEqualToString:kEffectBigWhiteFrameImage] )
    {
        frameShadowWidth = 5.0/302 * imageWidth;
        frameShadowHeight = 5.0/320 * imageHeight * (imageWidth - kEffectImageDecreaseWidth)/imageWidth;
    }
    else if ([frameName isEqualToString:kEffectBigBlackFrameImage])
    {
        frameShadowWidth = 5.0/302 * imageWidth;
        frameShadowHeight = 5.0/320 * imageHeight;
    }
    else if ([frameName isEqualToString:kEffectBigClassicFrameImage])
    {
        frameShadowWidth = 5.0/509 * imageWidth;
        frameShadowHeight = 4.0/333 * imageHeight;
    }
    else if ([frameName isEqualToString:kEffectBigLovelyFrameImage])
    {
        frameShadowWidth = 8.0/298 * imageWidth;
        frameShadowHeight = 8.0/314 * imageHeight;
    }
    else if ([frameName isEqualToString:kEffectBigFilmFrameImage])
    {
        frameShadowWidth = 10.0/248 * imageWidth;
        frameShadowHeight = 12.0/311 * imageHeight;
    }
    else if ([frameName isEqualToString:kEffectBigFeelingFrameImage])
    {
        frameShadowWidth = 5.0/300 * imageWidth;
        frameShadowHeight = 5.0/324 * imageHeight;
    }
    else if ([frameName isEqualToString:kEffectBigVideoFrameImage]) 
    {
        frameShadowWidth = 6.0/285 * imageWidth;
        frameShadowHeight = 6.0/310 * imageHeight;
    }
    else if ([frameName isEqualToString:kEffectBigSellotapeFrameImage])
    {
        frameShadowWidth = 17.0/281 * imageWidth;
        frameShadowHeight = 12.0/305 * imageHeight;
    }
    else
    {
        frameShadowWidth = 0;
        frameShadowHeight = 0;
    }    
    
    //获取imageView上图片的尺寸。
    CGSize contextSize = CGSizeMake(imageWidth + 2 * frameShadowWidth, imageHeight + 2 * frameShadowHeight);
    if (self.sourceImage.size.width <= 150 && self.sourceImage.size.height <= 150)
    {
        UIGraphicsBeginImageContext(contextSize);
    }
    else
    {
        UIGraphicsBeginImageContextWithOptions(contextSize, NO, self.sourceImage.size.width/imageWidth);
    }
    
    UIImageView *sourceImageView = [[UIImageView alloc] initWithImage:self.sourceImage];
    sourceImageView.frame = CGRectMake(frameShadowWidth, frameShadowHeight, imageWidth, imageHeight);
    [self.frameEffectImage addSubview:sourceImageView];
    [sourceImageView release];
    
    UIImageView *frameImageView = [[UIImageView alloc] initWithImage:self.frameImage];
    frameImageView.frame = CGRectMake(0, 0, imageWidth + 2 * frameShadowWidth, imageHeight + 2 * frameShadowHeight);
    frameImageView.backgroundColor = [UIColor clearColor];
    [self.frameEffectImage addSubview:frameImageView];
    [frameImageView release];

    self.frameEffectImage.image = nil;
    [self.frameEffectImage.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.frameEffectImage.image = UIGraphicsGetImageFromCurrentImageContext();

    //按home键会保存已经做过的操作
    [[ReUnManager sharedReUnManager] storeSnap:self.frameEffectImage.image];
    UIGraphicsEndImageContext();
    
    //完成后 移除self.frameEffectImage的子视图，防止越加越多，占用内存
    for (UIImageView *imageView in [self.frameEffectImage subviews])
    {
        [imageView removeFromSuperview];
    }
}


/**
 * @brief 
 * 判断从三级菜单选择那种边框效果进入，并将该效果设置为默认的边框效果,被默认选中的按钮边框增大
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)makeFrameEffect
{
    UIButton *selectButton = (UIButton *)[self.view viewWithTag:effectType_+2];
      
    switch (effectType_)
    {
            //白框
        case EEffectWhiteFrameId:
        {
            [self changeButtonStringAndBackGround];
            [self imageFrame:selectButton];
            break;
        }
            //黑框
        case EEffectBlackFrameId:
        {
            [self changeButtonStringAndBackGround];
            [self imageFrame:selectButton];
            break;
        }
            //经典框
        case EEffectClassicFrameId:
        {
            [self changeButtonStringAndBackGround];
            [self imageFrame:selectButton];
            break;
        }
            //可爱边框
        case EEffectLovelyFrameId:
        {
            [self changeButtonStringAndBackGround];
            [self imageFrame:selectButton];
            break;
        }
            //电影胶片
        case EEffectFilmFrameId:
        {
            [self changeButtonStringAndBackGround];
            [self imageFrame:selectButton];
            break;
        }
            //菲林
        case EEffectFeelingFrameId:
        {
            [self changeButtonStringAndBackGround];
            [self imageFrame:selectButton];
            break;
        }
            //录像
        case EEffectVideoFrameId:
        {
            self.frameEffectScrollView.contentOffset = CGPointMake(55.0, 0);
            [self changeButtonStringAndBackGround];
            [self imageFrame:selectButton];
            break;
        }
            //胶带
        case EEffectCellotapeFrameId:
        {
            self.frameEffectScrollView.contentOffset = CGPointMake(55.0 * 2, 0);
            [self changeButtonStringAndBackGround];
            [self imageFrame:selectButton];
            break;
        }
            //可在此之后增加炫彩边框
        case EEffectColorFrameId:
        {
            [self.view bringSubviewToFront:self.colorfulFrameButton];
            [self.colorfulFrameButton setTitleColor:[UIColor getColor:kEffectButtonSelectStringColor] forState:UIControlStateNormal];
            [self.colorfulFrameButton setBackgroundImage:[UIImage imageNamed:kEffectSelectButtonBackGround] forState:UIControlStateNormal];
            self.frameColorScollView.hidden = NO;
            self.frameEffectScrollView.hidden = YES;
            [self imageFrame:selectButton];
            break;
        }
            
        default:
            break;
    }
}

/**
 * @brief  清除图片的边框效果
 *
 * @param [in]  
 * @param [out] 
 * @return　　   
 * @note
 */
- (void) clearBorderColor 
{
    self.frameEffectImage.image = self.sourceImage;
}

/**
 * @brief  改变简单边框按钮和炫彩边框按钮的字体和背景
 *
 * @param [in]  
 * @param [out] 
 * @return　　   
 * @note
 */
- (void) changeButtonStringAndBackGround
{
    [self.simpleFrameButton setTitleColor:[UIColor getColor:kEffectButtonSelectStringColor] forState:UIControlStateNormal];
    [self.simpleFrameButton setBackgroundImage:[UIImage imageNamed:kEffectSelectButtonBackGround] forState:UIControlStateNormal];
}

/**
 * @brief 照片加边框处理
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)imageFrame:(id)sender 
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    NSInteger index = button.tag - kImageEffectButtonTagBase;
    
    //简单边框
    //在效果图中只可有一个边框为选中状态。
    NSArray *simpleFramearray = self.frameEffectScrollView.subviews;
    NSMutableArray *buttonArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (id obj in simpleFramearray)
    {
        if ([obj isKindOfClass:[UIImageView class]])
        {
            continue;
        }
        [buttonArray addObject:obj];
    }
    //获取frameEffectScrollView中子视图的数目。
    int simpleFrameCount = [buttonArray count];
    //scrollview添加了一个imageview设置背景图片，故i从1开始
    for (int i = 0; i < simpleFrameCount; i++) 
    {
        if ([[buttonArray objectAtIndex:i] isKindOfClass:[UIButton class]]) 
        {
            UIButton *btn = [buttonArray objectAtIndex:i];
            //如果当前边框不是选中边框，则取消选中状态。
            if (btn != button)
            {
                btn.selected = NO;
                //不被选中的按钮恢复原来的大小
                btn.frame = CGRectMake(i*55 + 13, kScrollViewButtonPointY, kScrollViewButtonWidth, kScrollViewButtonHeight);
            } 
            else
            {
                btn.frame = CGRectMake(i*55 + 13 - 3, kScrollViewButtonPointY - 3, kScrollViewClickButtonWidth, kScrollViewClickButtonHeight);
            }
        }
    }
    [buttonArray release];
    
    //炫彩边框
    //在效果图中只可有一个边框为选中状态。
    NSArray *colorFrameArray = self.frameColorScollView.subviews;
    NSMutableArray *colorButtonArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (id obj in colorFrameArray)
    {
        if ([obj isKindOfClass:[UIImageView class]])
        {
            continue;
        }
        [colorButtonArray addObject:obj];
    }
    //获取frameEffectScrollView中子视图的数目。
    int colorFrameCount = [colorButtonArray count];
    for (int i = 0; i < colorFrameCount; i++) 
    {
        if ([[colorButtonArray objectAtIndex:i] isKindOfClass:[UIButton class]]) 
        {
            UIButton *btn = [colorButtonArray objectAtIndex:i];
            //如果当前边框不是选中边框，则取消选中状态。
            if (btn != button)
            {
                btn.selected = NO;
                //没有被按的按钮恢复原来的大小
                btn.frame = CGRectMake(i*55 + 13, kScrollViewButtonPointY, kScrollViewButtonWidth, kScrollViewButtonHeight);
            } 
            else
            {
                //被按的按钮增大
                btn.frame = CGRectMake(i*55 + 13, kScrollViewButtonPointY, kScrollViewClickButtonWidth, kScrollViewClickButtonHeight);
            }
        }
    }
    [colorButtonArray release];
    //原代码是：奇数次点击按钮能够增加边框，偶数次点击按钮会去掉边框，现在改为只要点击按钮都是增加边框
    switch (index) 
    {
        case EWhiteFrame: 
        {        
            self.navigationItem.title = @"白框";
            [self clearBorderColor];
            //使按钮保持被点击图片状态
            button.selected = YES;
            [self mergeImage:kEffectBigWhiteFrameImage];

            break;
        }
        case EBlackFrame: 
        {
            self.navigationItem.title = @"黑框";
            [self clearBorderColor];
            button.selected = YES;
            [self mergeImage:kEffectBigBlackFrameImage];
            break;
        }
        case EClassicsFrame: 
        {
            self.navigationItem.title = @"经典边框";
            [self clearBorderColor];
            button.selected = YES;
            [self mergeImage:kEffectBigClassicFrameImage];
            break;
        }

        case ELovelyFrame: 
        {            
            self.navigationItem.title = @"可爱边框";
            [self clearBorderColor];
            button.selected = YES;
            [self mergeImage:kEffectBigLovelyFrameImage];
            break;
        }
        case EFilmFrame: 
        {
            self.navigationItem.title = @"电影胶片";
            [self clearBorderColor];
            button.selected = YES;
            [self mergeImage:kEffectBigFilmFrameImage];
            break;
        }
        case EFeelingFrame: 
        {

            self.navigationItem.title = @"菲林";
            [self clearBorderColor];
            button.selected = YES;
            [self mergeImage:kEffectBigFeelingFrameImage];
            break;
        }
        case EVideoFrame:
        {
            self.navigationItem.title = @"录像";
            [self clearBorderColor];
            button.selected = YES;
            [self mergeImage:kEffectBigVideoFrameImage];

            break;
        }
        case ESellotapeFrame:
        {            
            self.navigationItem.title = @"胶带";
            [self clearBorderColor];
            button.selected = YES;
            [self mergeImage:kEffectBigSellotapeFrameImage];
            break;
        }
            //炫彩边框按钮的index（与tag值对应）与枚举值相差1，因为枚举中有EImageFrameTotal（用来记录简单边框的总个数）
        case (EDesaltEdgeFrame - 1):
        {
            self.navigationItem.title = @"hello";
            [self clearBorderColor];
            button.selected = YES;
            [self mergeImage:kEffectBigFeelingFrameImage];

            break;
        }

        default:
            break;
    }
}

#pragma mark frame process

/**
 * @brief 存放边框按钮名称的Label的属性设置。
 * 
 * @param [in] 图片的效果数imgEffectNum，图片特效或者加边框imgEffectScrollView,图片各个效果名称imgEffectName。
 * @param [out] 设置好属性的Label。
 * @return
 * @note
 */
- (void) labelPropertySetting: (NSInteger)imgEffectNum: (UIScrollView *)imgEffectScrollView: (NSArray *)imgEffectName 
{
    //根据边框个数，创建相应个数的Label以存放图片效果的名称。
    for (int i = 0; i < imgEffectNum; i++) 
    {
        //则imageEffectScrollView大小。
        [imgEffectScrollView setContentSize:CGSizeMake(imgEffectNum *110, kScrollViewPointY)];
		//存放特效及边框名称的Label的属性设置。
        UILabel *tempLabel = [[UILabel alloc] initWithFrame: CGRectMake(i*55 + 5, kScrollViewLabelPointY, kScrollViewLabelWidth , kScrollViewLabelHeight)];
        [tempLabel setBackgroundColor:[UIColor clearColor]];
        tempLabel.textColor = [UIColor getColor:kEffectLabelStringColor];
        [tempLabel setTextAlignment:(UITextAlignmentCenter)];
        [tempLabel setFont:[UIFont systemFontOfSize:kScrollViewLabelWordSize]];
        [tempLabel setText: [imgEffectName objectAtIndex:i]];
        [imgEffectScrollView addSubview:tempLabel];  
        [tempLabel release];
    }
}
/**
 * @brief 边框按钮的图片，选中与未选中图片。
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void) buttonInFrameScrollView 
{
    //简单边框
    //边框未选中状态的图片。
    NSArray *imageArrayNotSelect = [NSArray arrayWithObjects: kImgDynWhiteFrame, kImgDynBlackFrame,kImgDynClassicFrame, kImgDynLovelyFrame, kImgDynFilmFrame,kImgDynFeelingFrame,kImgDynVideoFrame, kImgDynSellotapeFrame,nil];
    //边框选中状态的图片。
    NSArray *imageArraySelected = [NSArray arrayWithObjects: kImgDynWhiteFrameClick, kImgDynBlackFrameClick, kImgDynClassicFrameClick,kImgDynLovelyFrameClick, kImgDynFilmFrameClick,kImgDynFeelingFrameClick, kImgDynVideoFrameClick,kImgDynSellotapeFrameClick,nil];
    //创建五个按钮，以存放五种边框的图片。
    for (int j = 0; j < EImageFrameTotal; j++) 
    {
        UIButton *tempButton = [[UIButton alloc] initWithFrame: CGRectMake(55*j + 7, kScrollViewButtonPointY, kScrollViewButtonWidth, kScrollViewButtonHeight)];
        //按钮边框处理成圆角矩形。
		tempButton.tag = kImageEffectButtonTagBase + j;
		[tempButton addTarget:self action:@selector(imageFrame:) forControlEvents:UIControlEventTouchDown];	
        //设置边框按钮选中及未选中的背景图片。
        [tempButton setBackgroundImage: [UIImage imageNamed: [imageArrayNotSelect objectAtIndex: j]] forState: UIControlStateNormal];
        [tempButton setBackgroundImage: [UIImage imageNamed: [imageArraySelected objectAtIndex: j]] forState: UIControlStateSelected];

		[self.frameEffectScrollView addSubview:tempButton];
		[tempButton release];
    }
   
    NSArray *frameName = [NSArray arrayWithObjects: kWhiteFrame, kBlackFrame, kClassicFrame, kLovelyFrame, kFilmFrame, kFeelingFrame,kVideoFrame,kSellotapeFrame, nil];
    [self labelPropertySetting: EImageFrameTotal :self.frameEffectScrollView :frameName];
    
    //若要实现炫彩边框功能只需要在下面数组中增加内容就可以了
    //边框未选中状态的图片。
    NSArray *colorImageNotSelect = [NSArray arrayWithObjects: kImgDynLovelyFrame, nil];
    //边框选中状态的图片。
    NSArray *colorImageSelected = [NSArray arrayWithObjects: kImgDynWhiteFrameClick, nil];
    //创建五个按钮，以存放五种边框的图片。
    //按钮的个数（j 的最大值）是根据枚举的定义形式计算的，可参见枚举定义
    for (int j = 0; j < EColorImageFrameTotle - EImageFrameTotal-1; j++) 
    {
        UIButton *tempBut = [[UIButton alloc] initWithFrame: CGRectMake(55*j + 7, kScrollViewButtonPointY, kScrollViewButtonWidth, kScrollViewButtonHeight)];
        //按钮边框处理成圆角矩形。
        [tempBut.layer setMasksToBounds:YES];
        [tempBut.layer setCornerRadius:kCornerToRadius];
		tempBut.tag = kColorImageEffectButtonTag + j;
		[tempBut addTarget:self action:@selector(imageFrame:) forControlEvents:UIControlEventTouchDown];	
        //设置边框按钮选中及未选中的背景图片。
        [tempBut setBackgroundImage: [UIImage imageNamed: [colorImageNotSelect objectAtIndex: j]] forState: UIControlStateNormal];
        [tempBut setBackgroundImage: [UIImage imageNamed: [colorImageSelected objectAtIndex: j]] forState: UIControlStateSelected];
		[self.frameColorScollView addSubview:tempBut];
		[tempBut release];
    }
    
    //增加炫彩边框功能此数组要要修改
    NSArray *colorFrameName = [NSArray arrayWithObjects: kLovelyFrame, nil];
    [self labelPropertySetting: EColorImageFrameTotle - EImageFrameTotal - 1 :self.frameColorScollView :colorFrameName];

}
@end
