//
//  ColorPaletteViewController.m
//  Aico
//
//  Created by chentao on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ColorPaletteViewController.h"



@implementation ColorPaletteViewController

@synthesize hueSlider = hueSlider_;
@synthesize satSlider = satSlider_;
@synthesize briSlider = briSlider_;
@synthesize opaSlider = opaSlider_;
@synthesize satSliderHidden = satSliderHidden_;
@synthesize delegate = delegate_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    [self.view setFrame:CGRectMake(0, 0, 300, 300)];
    [self.view setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];

    hueSlider_ = [[UISlider alloc]initWithFrame:CGRectMake(20, 47, 260, 23)];
    hueSlider_.value = 0;
    hueSlider_.tag = 3001;
    hue_ = 0.0;
//    [self.view addSubview:hueSlider_];
    
    //hue
    hueView_ = [[ColorSelectorView alloc]initWithFrame:CGRectMake(20, 24, 260, 23)];
    //渐变色颜色分布：红橙黄绿青蓝紫红
    NSArray *hueColorArray = [[NSArray alloc]initWithObjects:
                              [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1.0], 
                              [UIColor colorWithRed:255/255.0 green:128/255.0 blue:0/255.0 alpha:1.0], 
                              [UIColor colorWithRed:255/255.0 green:255/255.0 blue:0/255.0 alpha:1.0], 
                              [UIColor colorWithRed:0/255.0 green:255/255.0 blue:0/255.0 alpha:1.0], 
                              [UIColor colorWithRed:0/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], 
                              [UIColor colorWithRed:0/255.0 green:0/255.0 blue:255/255.0 alpha:1.0], 
                              [UIColor colorWithRed:128/255.0 green:0/255.0 blue:255/255.0 alpha:1.0], 
                              [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1.0], nil ];
    hueView_.colorArray = hueColorArray;
    [hueColorArray release];
//    [self.view insertSubview:hueView_ atIndex:1];   
    
    

    satSlider_ = [[UISlider alloc]initWithFrame:CGRectMake(20, 110, 260, 23)];
    satSlider_.tag = 3002;
    briSlider_ = [[UISlider alloc]initWithFrame:CGRectMake(20, 173, 260, 23)];
    
//    opaSlider_ = [[UISlider alloc]initWithFrame:CGRectMake(20, 216, 260, 23)];
    opaSlider_ = [[UISlider alloc]initWithFrame:CGRectMake(20, 20, 240, 23)];
    
    //saturation
    saturationView_= [[ColorSelectorView alloc]initWithFrame:CGRectMake(20, 87, 260, 23)];
    NSArray *saturationColorArray = [[NSArray alloc]initWithObjects:
                                     [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], 
                                     [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1.0], nil ];
    saturationView_.colorArray = saturationColorArray;
    [saturationColorArray release];
//    [self.view insertSubview:saturationView_ atIndex:1];
    
    //brightness
    brightnessView_ = [[ColorSelectorView alloc]initWithFrame:CGRectMake(20, 150, 260, 23)];
    NSArray *brightnessColorArray = [[NSArray alloc]initWithObjects:
                                     [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0], 
                                     [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], nil ];
    brightnessView_.colorArray = brightnessColorArray;
    [brightnessColorArray release];
//    [self.view insertSubview:brightnessView_ atIndex:1];
    
    saturation_ = 0.0;
    brightness_ = 1*255.0;
    opacity_ = 0.75;
    
    satSlider_.value = 0;
    briSlider_.value = 1;
    opaSlider_.value = 0.75;

    briSlider_.tag = 3003;
    opaSlider_.tag = 3004;
    
    [hueSlider_ addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [satSlider_ addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [briSlider_ addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [opaSlider_ addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:satSlider_];
//    [self.view addSubview:briSlider_];
    [self.view addSubview:opaSlider_];
    
    //点击按钮确定所选颜色
    colorButton_ = [[UIButton alloc]initWithFrame:CGRectMake(110, 60, 80, 30)];
    colorButton_.backgroundColor = [UIColor grayColor];
    [colorButton_ addTarget:self 
                     action:@selector(colorButtonPressed) 
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:colorButton_];
    
    currentColorView_ = [[UIView alloc]initWithFrame:CGRectMake(55, 5, 20, 20)];
    currentColorView_.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:1 alpha:0.75];
    [currentColorView_ setUserInteractionEnabled:NO];
    [colorButton_ addSubview:currentColorView_];
    
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
//    [delegate_ closeViewAndSetColorHue:hue_ saturation:saturation_];
    [delegate_ setOpacity:opacity_];
}
@end

