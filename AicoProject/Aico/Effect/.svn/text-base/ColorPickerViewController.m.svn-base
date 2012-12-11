//
//  ColorPickerViewController.m
//  Aico
//
//  Created by cienet on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ColorPickerViewController.h"
#import "ColorSelectorView.h"

#define kSliderBlock        @"sliderTriangle.png"
#define kSliderBackGround   @"blackSliderBackground.png"
@implementation ColorPickerViewController
@synthesize hueSlider = hueSlider_;
@synthesize satSlider = satSlider_;
@synthesize briSlider = briSlider_;
@synthesize opaSlider = opaSlider_;
@synthesize delegate = delegate_;
@synthesize fromViewControllerID = fromViewControllerID_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 设置弹出窗口的背景
    [self setPopwindowBackground];
    
    //add hueSlider & hueView
    hueSlider_ = [[UISlider alloc]initWithFrame:CGRectMake(13, 55, 291, 23)];
    [hueSlider_ setThumbImage:[UIImage imageNamed:kSliderBlock] forState:UIControlStateNormal];
    [hueSlider_ setMinimumTrackImage:[UIImage imageNamed:kSliderBackGround] forState:UIControlStateNormal];
    [hueSlider_ setMaximumTrackImage:[UIImage imageNamed:kSliderBackGround] forState:UIControlStateNormal];
    hueView_ = [[UIImageView alloc]initWithFrame:CGRectMake(20, 41, 278, 21)];
    hueView_.image = [UIImage imageNamed:@"rainbow.png"];
    [self.view addSubview:hueView_];
    
    //add satSlider & saturationView
    satSlider_ = [[UISlider alloc]initWithFrame:CGRectMake(13, 109, 291, 23)];
    [satSlider_ setThumbImage:[UIImage imageNamed:kSliderBlock] forState:UIControlStateNormal];
    [satSlider_ setMinimumTrackImage:[UIImage imageNamed:kSliderBackGround] forState:UIControlStateNormal];
    [satSlider_ setMaximumTrackImage:[UIImage imageNamed:kSliderBackGround] forState:UIControlStateNormal];
    saturationView_= [[ColorSelectorView alloc]initWithFrame:CGRectMake(20, 95, 278, 21)];
    
    //add briSlider & brightnessView
    briSlider_ = [[UISlider alloc]initWithFrame:CGRectMake(13, 163, 291, 23)];
    [briSlider_ setThumbImage:[UIImage imageNamed:kSliderBlock] forState:UIControlStateNormal];
    [briSlider_ setMinimumTrackImage:[UIImage imageNamed:kSliderBackGround] forState:UIControlStateNormal];
    [briSlider_ setMaximumTrackImage:[UIImage imageNamed:kSliderBackGround] forState:UIControlStateNormal];
    brightnessView_ = [[ColorSelectorView alloc]initWithFrame:CGRectMake(20, 149, 278, 21)];
    
    //add opaSlider
    opaSlider_ = [[UISlider alloc]initWithFrame:CGRectMake(20, 198, 278, 23)];
    [opaSlider_ setThumbImage:[UIImage imageNamed:@"sliderRound.png"] forState:UIControlStateNormal];
    [opaSlider_ setMinimumTrackImage:[UIImage imageNamed:@"sliderProcess.png"] forState:UIControlStateNormal];
    [opaSlider_ setMaximumTrackImage:[UIImage imageNamed:@"sliderProcess.png"] forState:UIControlStateNormal];
    
    hueSlider_.tag = 3001;
    satSlider_.tag = 3002;
    briSlider_.tag = 3003;
    opaSlider_.tag = 3004;
    
    [hueSlider_ addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [satSlider_ addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [briSlider_ addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [opaSlider_ addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:hueSlider_];
    [self.view addSubview:satSlider_];
    [self.view addSubview:briSlider_];
    [self.view addSubview:opaSlider_];
    
    [self.view addSubview:hueView_];
    [self.view addSubview:saturationView_];
    [self.view addSubview:brightnessView_];
    
    hueLabel_ = [[UILabel alloc]init];
    hueValue_ = [[UILabel alloc]init];
    satLabel_ = [[UILabel alloc]init];
    satValue_ = [[UILabel alloc]init];
    briLabel_ = [[UILabel alloc]init];
    briValue_ = [[UILabel alloc]init];
    opaLabel_ = [[UILabel alloc]init];
    opaValue_ = [[UILabel alloc]init];
    
    [self setLabelwithID:EHueID withFrame:hueView_.frame];
    [self setLabelwithID:ESaturationID withFrame:saturationView_.frame];
    [self setLabelwithID:EBrightnessID withFrame:brightnessView_.frame];
    [self setLabelwithID:EOpoacity withFrame:opaSlider_.frame];
    
    //点击按钮确定所选颜色
    colorButton_ = [[UIButton alloc]initWithFrame:CGRectMake(80, 230, 165, 43)];
    colorButton_.backgroundColor = [UIColor clearColor];
    [colorButton_ setBackgroundImage:[UIImage imageNamed:@"chooseColorButton.png"] forState:UIControlStateNormal];
    [colorButton_ addTarget:self 
                     action:@selector(colorButtonPressed) 
           forControlEvents:UIControlEventTouchUpInside];
    UILabel *setColorLabel = [[UILabel alloc]initWithFrame:CGRectMake(27, 4, 100, 35)];
    setColorLabel.text = @"Set Color";
    [setColorLabel setBackgroundColor:[UIColor clearColor]];
    setColorLabel.textColor = [UIColor whiteColor];
    [colorButton_ addSubview:setColorLabel];
    [setColorLabel release];
    [self.view addSubview:colorButton_];
    
    //用于显示当前选中的颜色
    currentColorView_ = [[UIView alloc]initWithFrame:CGRectMake(120, 6, 30, 30)];
    [currentColorView_.layer setMasksToBounds:YES];
    [currentColorView_.layer setCornerRadius:4];
    [currentColorView_ setUserInteractionEnabled:NO];
    [colorButton_ addSubview:currentColorView_];
    
    //根据需要分别设置需要隐藏的view和它们的frame
    switch (fromViewControllerID_)
    {
        case ETopLensFilterViewControllerID://上滤镜
        {
            [self setHue:0 saturation:1 brightness:255.0*.75 opacity:1];
            [self setHueHidden:NO saturationHidden:YES brightnessHidden:NO opacity:NO];
        }
            break;
        case EEdgeLensFilterViewControllerID://边框滤镜
        {
            [self setHue:240.0 saturation:1 brightness:255.0*.75 opacity:1];
            [self setHueHidden:NO saturationHidden:YES brightnessHidden:NO opacity:NO];
        }
            break;
        case EMatteViewControllerID://淡化边缘
        {
            [self setHue:0 saturation:0 brightness:255.0 opacity:.75];
        }
            break;
        case EVegnetteViewControllerID://边缘模糊
        {
            [self setHueHidden:YES saturationHidden:YES brightnessHidden:YES opacity:NO];
            [self setHue:0 saturation:0 brightness:0 opacity:0.75];            
            for (UIView *subView in [colorButton_ subviews])
            {
                [subView removeFromSuperview];
            }
            colorButton_.frame = CGRectMake(78, 76, 165, 43);
            colorButton_.backgroundColor = [UIColor clearColor];
            [colorButton_ setBackgroundImage:[UIImage imageNamed:@"vegnetteChooseBtnBack.png"] forState:UIControlStateNormal];
            [colorButton_ addTarget:self 
                             action:@selector(colorButtonPressed) 
                   forControlEvents:UIControlEventTouchUpInside];
            UILabel *setColorLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 4, 100, 35)];
            setColorLabel.text = @"Set Opacity";
            [setColorLabel setBackgroundColor:[UIColor clearColor]];
            setColorLabel.textColor = [UIColor whiteColor];
            [colorButton_ addSubview:setColorLabel];
            [setColorLabel release];
            [self.view addSubview:colorButton_];
        }
            break;
        case ENeonViewControllerID://霓虹灯
        {
            [self setHue:0 saturation:1 brightness:255.0*.75 opacity:1];
            [self setHueHidden:NO saturationHidden:NO brightnessHidden:YES opacity:YES];
            colorButton_.frame = CGRectMake(78, 135, 165, 43);
        }
            break;
        case EDuoToneViewControllerID://双色调
        {
            [self setHue:0 saturation:0 brightness:255 opacity:0.75];
            [opaSlider_ setHidden:YES];
            [opaLabel_ setHidden:YES];
            [opaValue_ setHidden:YES];
            colorButton_.frame = CGRectMake(78, 200, 165, 43);
        }
            break;
        default:
            break;
    }
}

- (void)viewDidUnload
{
    self.hueSlider = nil;
    self.satSlider = nil;
    self.briSlider = nil;
    self.opaSlider = nil;
    RELEASE_OBJECT(hueView_);
    RELEASE_OBJECT(saturationView_);
    RELEASE_OBJECT(brightnessView_);
    RELEASE_OBJECT(colorButton_);
    RELEASE_OBJECT(currentColorView_);
    RELEASE_OBJECT(hueLabel_);
    RELEASE_OBJECT(hueValue_);
    RELEASE_OBJECT(satLabel_);
    RELEASE_OBJECT(satValue_);
    RELEASE_OBJECT(briLabel_);
    RELEASE_OBJECT(briValue_);
    RELEASE_OBJECT(opaLabel_);
    RELEASE_OBJECT(opaValue_);
    [super viewDidUnload];
}

- (void)dealloc
{
    self.hueSlider = nil;
    self.satSlider = nil;
    self.briSlider = nil;
    self.opaSlider = nil;
    RELEASE_OBJECT(hueView_);
    RELEASE_OBJECT(saturationView_);
    RELEASE_OBJECT(brightnessView_);
    RELEASE_OBJECT(colorButton_);
    RELEASE_OBJECT(currentColorView_);
    RELEASE_OBJECT(hueLabel_);
    RELEASE_OBJECT(hueValue_);
    RELEASE_OBJECT(satLabel_);
    RELEASE_OBJECT(satValue_);
    RELEASE_OBJECT(briLabel_);
    RELEASE_OBJECT(briValue_);
    RELEASE_OBJECT(opaLabel_);
    RELEASE_OBJECT(opaValue_);
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 
#pragma mark slider method
/**
 * @brief 
 * 随着slider value的改变，动态地改变view上显示的渐变色
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
- (IBAction)valueChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    switch (slider.tag)
    {
        case 3001://拖动hue slider
        {
            hue_ = slider.value*360.0;
            hueValue_.text = [NSString stringWithFormat:@"%d°",(int)hue_];
            unsigned char r1,g1,b1,r2,g2,b2,r3,g3,b3,r4,g4,b4;
            [Common hue:hue_ saturation:0 brightness:brightness_ toRed:&r1 green:&g1 blue:&b1];
            [Common hue:hue_ saturation:1 brightness:brightness_ toRed:&r2 green:&g2 blue:&b2];
            NSArray *saturationColorArray = [[NSArray alloc]initWithObjects:
                                             [UIColor colorWithRed:r1/255.0 green:g1/255.0 blue:b1/255.0 alpha:1.0], 
                                             [UIColor colorWithRed:r2/255.0 green:g2/255.0 blue:b2/255.0 alpha:1.0], nil ];
            saturationView_.colorArray = saturationColorArray;
            [saturationColorArray release];
            [saturationView_ setNeedsDisplay];
            [Common hue:hue_ saturation:saturation_ brightness:0 toRed:&r3 green:&g3 blue:&b3];
            [Common hue:hue_ saturation:saturation_ brightness:255 toRed:&r4 green:&g4 blue:&b4];
            NSArray *brightnessColorArray = [[NSArray alloc]initWithObjects:
                                             [UIColor colorWithRed:r3/255.0 green:g3/255.0 blue:b3/255.0 alpha:1.0], 
                                             [UIColor colorWithRed:r4/255.0 green:g4/255.0 blue:b4/255.0 alpha:1.0], nil ];
            brightnessView_.colorArray = brightnessColorArray;
            [brightnessColorArray release];
            [brightnessView_ setNeedsDisplay];
        }
            
            break;
            
        case 3002://拖动saturation slider
        {
            saturation_ = slider.value;
            satValue_.text = [NSString stringWithFormat:@"%d%%",(int)(saturation_*100)];
            unsigned char r3,g3,b3,r4,g4,b4;
            
            [Common hue:hue_ saturation:saturation_ brightness:0 toRed:&r3 green:&g3 blue:&b3];
            [Common hue:hue_ saturation:saturation_ brightness:255 toRed:&r4 green:&g4 blue:&b4];
            NSArray *brightnessColorArray = [[NSArray alloc]initWithObjects:
                                             [UIColor colorWithRed:r3/255.0 green:g3/255.0 blue:b3/255.0 alpha:1.0], 
                                             [UIColor colorWithRed:r4/255.0 green:g4/255.0 blue:b4/255.0 alpha:1.0], nil ];
            brightnessView_.colorArray = brightnessColorArray;
            [brightnessColorArray release];
            [brightnessView_ setNeedsDisplay];
        }
            
            break;
        case 3003://拖动brightness slider
        {
            brightness_ = slider.value*255;
            briValue_.text = [NSString stringWithFormat:@"%d%%",(int)(slider.value*100)];
            unsigned char r1,g1,b1,r2,g2,b2;
            [Common hue:hue_ saturation:0 brightness:brightness_ toRed:&r1 green:&g1 blue:&b1];
            [Common hue:hue_ saturation:1 brightness:brightness_ toRed:&r2 green:&g2 blue:&b2];
            
            NSArray *saturationColorArray = [[NSArray alloc]initWithObjects:
                                             [UIColor colorWithRed:r1/255.0 green:g1/255.0 blue:b1/255.0 alpha:1.0], 
                                             [UIColor colorWithRed:r2/255.0 green:g2/255.0 blue:b2/255.0 alpha:1.0], nil ];
            saturationView_.colorArray = saturationColorArray;
            [saturationColorArray release];
            [saturationView_ setNeedsDisplay];
        }
            break;
        case 3004://拖动opacity slider
        {
            opacity_ = slider.value;
            opaValue_.text = [NSString stringWithFormat:@"%d%%",(int)(opacity_*100)];
        }
            
            break;
        default:
            break;
    }
    currentColorView_.backgroundColor = [UIColor colorWithHue:hue_/360.0 
                                              saturation:saturation_ 
                                              brightness:brightness_/255.0 
                                                   alpha:opacity_];
}

/**
 * @brief 
 * 设置要显示的颜色
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
- (void)setHue:(float)h saturation:(float)s brightness:(float)b opacity:(float)o
{
    hue_ = h;
    saturation_ = s;
    brightness_ = b;
    opacity_ = o;
    
    hueSlider_.value = h/360.0;
    satSlider_.value = s;
    briSlider_.value = b/255.0;
    opaSlider_.value = o;
    
    hueValue_.text = [NSString stringWithFormat:@"%d°",(int)hue_];
    satValue_.text = [NSString stringWithFormat:@"%d%%",(int)(saturation_*100)];
    briValue_.text = [NSString stringWithFormat:@"%d%%",(int)(briSlider_.value*100)];
    opaValue_.text = [NSString stringWithFormat:@"%d%%",(int)(opacity_*100)];
    
    unsigned char r1,g1,b1,r2,g2,b2,r3,g3,b3,r4,g4,b4;
    [Common hue:hue_ saturation:0 brightness:brightness_ toRed:&r1 green:&g1 blue:&b1];
    [Common hue:hue_ saturation:1 brightness:brightness_ toRed:&r2 green:&g2 blue:&b2];
    NSArray *saturationColorArray = [[NSArray alloc]initWithObjects:
                                     [UIColor colorWithRed:r1/255.0 green:g1/255.0 blue:b1/255.0 alpha:1.0], 
                                     [UIColor colorWithRed:r2/255.0 green:g2/255.0 blue:b2/255.0 alpha:1.0], nil ];
    saturationView_.colorArray = saturationColorArray;
    [saturationColorArray release];
    [saturationView_ setNeedsDisplay];
    [Common hue:hue_ saturation:saturation_ brightness:0 toRed:&r3 green:&g3 blue:&b3];
    [Common hue:hue_ saturation:saturation_ brightness:255 toRed:&r4 green:&g4 blue:&b4];
    NSArray *brightnessColorArray = [[NSArray alloc]initWithObjects:
                                     [UIColor colorWithRed:r3/255.0 green:g3/255.0 blue:b3/255.0 alpha:1.0], 
                                     [UIColor colorWithRed:r4/255.0 green:g4/255.0 blue:b4/255.0 alpha:1.0], nil ];
    brightnessView_.colorArray = brightnessColorArray;
    [brightnessColorArray release];
    [brightnessView_ setNeedsDisplay];
    
    currentColorView_.backgroundColor = [UIColor colorWithHue:hue_/360.0 
                                                   saturation:saturation_ 
                                                   brightness:brightness_/255.0 
                                                        alpha:opacity_];
}
/**
 * @brief 
 * 点击按钮选择某种颜色
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
- (void)colorButtonPressed
{
    if ([delegate_ respondsToSelector:@selector(closeViewAndSetColorHue:saturation:brightness:opacity:)])
    {
        [delegate_ closeViewAndSetColorHue:hue_ saturation:saturation_ brightness:brightness_ opacity:opacity_];
    }
}

/**
 * @brief 
 * 设置隐藏某些颜色条
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
- (void)setHueHidden:(BOOL)hueShouldHide 
    saturationHidden:(BOOL)saturationShouldHide
    brightnessHidden:(BOOL)brightnessShouldHide 
             opacity:(BOOL)opacityShouldHide
{
    int count = 0;
    if (hueShouldHide)
    {
        count++;
        [hueView_ setHidden:YES];
        [hueSlider_ setHidden:YES];
        [hueLabel_ setHidden:YES];
        [hueValue_ setHidden:YES];
    }
    if (saturationShouldHide)
    {
        count++;
        [saturationView_ setHidden:YES];
        [satSlider_ setHidden:YES];
        [satLabel_ setHidden:YES];
        [satValue_ setHidden:YES];        
    }
    else
    {
        saturationView_.center = CGPointMake(saturationView_.center.x, saturationView_.center.y - 53*count);
        satSlider_.center = CGPointMake(satSlider_.center.x, satSlider_.center.y - 53*count);
        [self setLabelwithID:ESaturationID withFrame:saturationView_.frame];
    }
    if (brightnessShouldHide)
    {
        count++;
        [brightnessView_ setHidden:YES];
        [briSlider_ setHidden:YES];
        [briLabel_ setHidden:YES];
        [briValue_ setHidden:YES];
    }
    else
    {
        brightnessView_.center = CGPointMake(brightnessView_.center.x, brightnessView_.center.y - 53*count);
        briSlider_.center = CGPointMake(briSlider_.center.x, briSlider_.center.y - 53*count);
        [self setLabelwithID:EBrightnessID withFrame:brightnessView_.frame];
    }
    if (opacityShouldHide)
    {
        count++;
        [opaValue_ setHidden:YES];
        [opaSlider_ setHidden:YES];
        [opaLabel_ setHidden:YES];
    }
    else
    {
        opaSlider_.center = CGPointMake(opaSlider_.center.x, opaSlider_.center.y - 53*count);
        [self setLabelwithID:EOpoacity withFrame:opaSlider_.frame];
    }
    colorButton_.center = CGPointMake(colorButton_.center.x, colorButton_.center.y - 53*count);
}

/**
 * @brief 
 * 设置label's frame
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
- (void)setLabelwithID:(enum EHSBOID)ID withFrame:(CGRect)referenceFrame
{
    UILabel *leftLabel = nil;
    UILabel *rightLabel = nil;
    NSString *title = nil;
    switch (ID)
    {
        case EHueID:
        {
            leftLabel = hueLabel_;
            rightLabel = hueValue_;
            title = @"Hue";
        }
            break;
        case ESaturationID:
        {
            leftLabel = satLabel_;
            rightLabel = satValue_;
            title = @"Saturation";
        }
            break;
        case EBrightnessID:
        {
            leftLabel = briLabel_;
            rightLabel = briValue_;
            title = @"Brightness";
        }
            break;
        case EOpoacity:
        {
            leftLabel = opaLabel_;
            rightLabel = opaValue_;
            referenceFrame = CGRectMake(referenceFrame.origin.x, referenceFrame.origin.y + 4, referenceFrame.size.width, referenceFrame.size.width);
            title = @"Opacity";
        }
            break;
        default:
            break;
    }
    [leftLabel setBackgroundColor:[UIColor clearColor]];
    [leftLabel setTextAlignment:UITextAlignmentLeft];
    [leftLabel setTextColor:[UIColor whiteColor]];
    [leftLabel setText:title];
    
    [rightLabel setBackgroundColor:[UIColor clearColor]];
    [rightLabel setTextAlignment:UITextAlignmentRight];
    [rightLabel setTextColor:[UIColor whiteColor]];
    
    leftLabel.frame = CGRectMake(referenceFrame.origin.x, referenceFrame.origin.y - 23, 100, 21);
    rightLabel.frame = CGRectMake(referenceFrame.size.width - 100, referenceFrame.origin.y - 21, 120, 21);
    
    [self.view addSubview:leftLabel];
    [self.view addSubview:rightLabel];
}
/**
 * @brief 
 * 设置弹出窗口的背景
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
- (void)setPopwindowBackground
{    
    [self.view setBackgroundColor:[UIColor clearColor]];

    switch (fromViewControllerID_)
    {
        case EVegnetteViewControllerID://边缘模糊
        {
            UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vegnetteColorBack.png"]];
            [self.view addSubview:backgroundImageView];
            [backgroundImageView release];
            break;
        }
        case ENeonViewControllerID://霓虹灯
        {
            UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"colorPickerBackground.png"]];
            backgroundImageView.frame = CGRectMake(0, 0, 317, 190);
            [self.view addSubview:backgroundImageView];
            [backgroundImageView release];
            break;
        }
        case ETopLensFilterViewControllerID:
        {
            UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"colorPickerBackground.png"]];
            backgroundImageView.frame = CGRectMake(0, 0, 317, 233);
            [self.view addSubview:backgroundImageView];
            [backgroundImageView release];
            break;
        }
        case EEdgeLensFilterViewControllerID:
        {
            UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"colorPickerBackground.png"]];
            backgroundImageView.frame = CGRectMake(0, 0, 317, 233);
            [self.view addSubview:backgroundImageView];
            [backgroundImageView release];
            break;
        }    
        default:
        {
            UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chooseColorBg.png"]];
            [self.view addSubview:backgroundImageView];
            [backgroundImageView release];
             break;
        }
    }
    
}
@end
