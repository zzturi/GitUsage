//
//  ColorSelectView.m
//  Aico
//
//  Created by 勇 周 on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ColorSelectViewController.h"
#import "TitleViewController.h"
#import "UIColor+extend.h"

@implementation ColorSelectViewController

@synthesize labelRed        = labelRed_;
@synthesize labelGreen      = labelGreen_;
@synthesize labelBlue       = labelBlue_;
@synthesize labelAlpha      = labelAlpha_;

@synthesize labelRedValue   = labelRedValue_;
@synthesize labelGreenValue = labelGreenValue_;
@synthesize labelBlueValue  = labelBlueValue_;
@synthesize labelAlphaValue = labelAlphaValue_;


@synthesize sliderRed       = sliderRed_;
@synthesize sliderGreen     = sliderGreen_;
@synthesize sliderBlue      = sliderBlue_;
@synthesize sliderAlpha     = sliderAlpha_;

@synthesize btnConfirm      = btnConfirm_;

@synthesize color           = color_;

#define PADDING_OFFSET     CGPointMake(5,5)
#define MARGIN_OFFSET      CGPointMake(5,5)
#define LABEL_SIZE         CGSizeMake(80, 20)
#define SLIDER_SIZE        CGSizeMake(160, 40)
#define BUTTON_SIZE        CGSizeMake(100, 40)

#define INIT_LABEL(label, txt) \
    label = [[UILabel alloc] initWithFrame:CGRectMake(pt.x, pt.y, LABEL_SIZE.width, LABEL_SIZE.height)]; \
    label.text = txt; \
    label.textAlignment = UITextAlignmentCenter; \
    label.font = [UIFont boldSystemFontOfSize:16]; \
    label.textColor = [UIColor getColor:kEffectButtonDeselectStringColor]; \
    label.backgroundColor = [UIColor clearColor]; \
    [self.view addSubview:label]

#define INIT_SLIDER(slider) \
    slider = [[UISlider alloc] initWithFrame:CGRectMake(pt.x, pt.y, SLIDER_SIZE.width, SLIDER_SIZE.height)]; \
    slider.minimumValue = 0; \
    slider.maximumValue = 255; \
    [slider setThumbImage:[UIImage imageNamed:@"thunder.png"] forState:UIControlStateNormal]; \
    [slider setMinimumTrackImage:minImage forState:UIControlStateNormal]; \
    [slider setMaximumTrackImage:[UIImage imageNamed:@"sliderNormalBkg.png"] forState:UIControlStateNormal]; \
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged]; \
    [self.view addSubview:slider]


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithType:(int)type color:(UIColor*)color parentVC:(TitleViewController*)vc
{
    self = [super init];
    if (self)
    {
        colorType_ = type;
        self.color = color;
        vcParent_ = vc;
    }
    return self;
}

- (void)initSliderAndLabelValue
{
    CGFloat red, green, blue, alpha;
    [Common getRed:&red green:&green blue:&blue alpha:&alpha fromUIColor:color_];
    sliderRed_.value   = (int)(red   * 255 + 0.5f);
    sliderGreen_.value = (int)(green * 255 + 0.5f);
    sliderBlue_.value  = (int)(blue  * 255 + 0.5f);
    sliderAlpha_.value = (int)(alpha * 255 + 0.5f);
    
    labelRedValue_.text = [NSString stringWithFormat:@"%d", (int)(sliderRed_.value)];
    labelGreenValue_.text = [NSString stringWithFormat:@"%d", (int)(sliderGreen_.value)];
    labelBlueValue_.text = [NSString stringWithFormat:@"%d", (int)(sliderBlue_.value)];
    labelAlphaValue_.text = [NSString stringWithFormat:@"%d", (int)(sliderAlpha_.value)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kBackGroundImage]];
//    self.view.layer.cornerRadius = 20.0f;
    
    CGFloat viewWith = PADDING_OFFSET.x + LABEL_SIZE.width + MARGIN_OFFSET.x + SLIDER_SIZE.width + PADDING_OFFSET.x;
    CGFloat viewHeight = PADDING_OFFSET.y + (LABEL_SIZE.height*2 + MARGIN_OFFSET.y) * 4 + BUTTON_SIZE.height + PADDING_OFFSET.y;
    self.view.frame = CGRectMake(0, 0, viewWith, viewHeight);
    
    CGPoint pt = PADDING_OFFSET;
    
    INIT_LABEL(labelRed_, @"红");
    pt.y += LABEL_SIZE.height;
    INIT_LABEL(labelRedValue_, @"");
    pt.y += LABEL_SIZE.height + MARGIN_OFFSET.y;
    
    INIT_LABEL(labelGreen_, @"绿");
    pt.y += LABEL_SIZE.height;
    INIT_LABEL(labelGreenValue_, @"");
    pt.y += LABEL_SIZE.height + MARGIN_OFFSET.y;
    
    INIT_LABEL(labelBlue_, @"蓝");
    pt.y += LABEL_SIZE.height;
    INIT_LABEL(labelBlueValue_, @"");
    pt.y += LABEL_SIZE.height + MARGIN_OFFSET.y;
    
    INIT_LABEL(labelRed_, @"透明度");
    pt.y += LABEL_SIZE.height;
    INIT_LABEL(labelAlphaValue_, @"");
    
    pt = CGPointMake(PADDING_OFFSET.x + LABEL_SIZE.width + MARGIN_OFFSET.x, PADDING_OFFSET.y);
    UIImage* minImage = [UIImage imageNamed:@"sliderHighLightBkg.png"];
    minImage = [minImage stretchableImageWithLeftCapWidth:minImage.size.width/2 topCapHeight:minImage.size.height/2];
    
    INIT_SLIDER(sliderRed_);
    pt.y += SLIDER_SIZE.height + MARGIN_OFFSET.y;
    INIT_SLIDER(sliderGreen_);
    pt.y += SLIDER_SIZE.height + MARGIN_OFFSET.y;
    INIT_SLIDER(sliderBlue_);
    pt.y += SLIDER_SIZE.height + MARGIN_OFFSET.y;
    INIT_SLIDER(sliderAlpha_);
    pt.y += SLIDER_SIZE.height + MARGIN_OFFSET.y;
    
    pt.x = (viewWith - BUTTON_SIZE.width) / 2;
    self.btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnConfirm_ addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    btnConfirm_.frame = CGRectMake(pt.x, pt.y, BUTTON_SIZE.width, BUTTON_SIZE.height);
    [btnConfirm_ setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:btnConfirm_];
    
    [self initSliderAndLabelValue];
}

- (void)releaseObjects
{
    self.labelRed = nil;
    self.labelGreen = nil;
    self.labelBlue = nil;
    self.labelAlpha = nil;
    
    self.labelRedValue = nil;
    self.labelGreenValue = nil;
    self.labelBlueValue = nil;
    self.labelAlphaValue = nil;
    
    self.sliderRed = nil;
    self.sliderGreen = nil;
    self.sliderBlue = nil;
    self.sliderAlpha = nil;
    
    self.btnConfirm = nil;
    self.color = nil;
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
#pragma Slider Value Changed Delegate

- (void)sliderValueChanged:(id)sender
{
    UISlider* slider = (UISlider*)sender;
    UILabel* label = nil;
    
    if (sender == sliderRed_) 
        label = labelRedValue_;
    else if (sender == sliderGreen_)
        label = labelGreenValue_;
    else if (sender == sliderBlue_)
        label = labelBlueValue_;
    else if (sender == sliderAlpha_)
        label = labelAlphaValue_;
    
    label.text = [NSString stringWithFormat:@"%d", (int)(slider.value+0.5f)];
}

- (IBAction)buttonPressed:(id)sender
{
    CGFloat red = sliderRed_.value;
    CGFloat green = sliderGreen_.value;
    CGFloat blue = sliderBlue_.value;
    CGFloat alpha = sliderAlpha_.value;
    
    UIColor* color = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f];
    [vcParent_ updateStyleButtonWithType:colorType_ color:color];
   
    [self.view removeFromSuperview];
}

@end
