//
//  EffectViewController.m
//  Aico
//
//  Created by wang cuicui on 3/29/12.
//  Copyright (c) 2012 Cienet. All rights reserved.
//

#import "EffectViewController.h"
#import "FilmFrameEffectViewController.h"
#import "PhotoEffectsViewController.h"
#import "ColorEffectsViewController.h"
#import "UIColor+extend.h"
#import "ImageInfo.h"
#import "UIImage+extend.h"
#import "EffectCustomCell.h"
#import "ColorEffectsCommon.h"
#import "ReUnManager.h"
#import "GradientView.h"
#import "DizzinessViewController.h"
#import "MatteView.h"
#import "TopLensFilterAndEdgeLensFilterProcess.h"
#import "MatteViewController.h"
#import "TopLensFilterAndEdgeLensFilterViewController.h"
#import "MirrorViewController.h"
#import "HorizontalStretchViewController.h"
#import "TwistViewController.h"
#import "VegnetteViewController.h"
#import "VegnetteView.h"
#import "StretchViewController.h"

#define ADD_EFFECT_IMAGE(value, array) \
        afterImage = [ImageInfo ImageInfoToUIImage:value]; \
        [array addObject:afterImage]; \
        [value release]


@implementation EffectViewController
@synthesize effectNameDic  = effectNameDic_;
@synthesize effectKeys = effectKeys_;
@synthesize titleForTableView = titleForTableView_;
@synthesize smallImage = smallImage_;
@synthesize smallImgByEffectedDic = smallImgByEffectedDic_;
@synthesize effectTableView = effectTableView_;

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

- (void) dealloc
{
    self.effectNameDic = nil;
    self.effectKeys = nil;
    self.titleForTableView = nil;
    self.smallImage = nil;
    self.smallImgByEffectedDic = nil;
    self.effectTableView = nil;
    RELEASE_OBJECT(cellSelectedBkgView_);
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    ReUnManager *rm = [ReUnManager sharedReUnManager];
    rm.snapImage = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //列表的背景图片
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kBackGroundImage]]];
    self.navigationItem.title = @"特效";
    
    cellSelectedBkgView_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shareCellBack.png"]];

    //取消按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 7, 30, 30)];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self 
                  action:@selector(cancelOperation) 
        forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelBarBtn;
    [cancelBtn release];
    [cancelBarBtn release];
      
    // Do any additional setup after loading the view from its nib.
   // NSArray *firstSection = [[NSArray alloc] initWithObjects:@"Paint",@"Insert Picture",@"Pop Colors", nil];
   // NSArray *distortSection = [[NSArray alloc] initWithObjects:@"Spherize",@"Twirl",@"Bulge & Pinch",@"Circle splash",@"Stretch",@"Verical Stretch",@"Horizontal Stretch",@"Mirror", nil];
    NSArray *colorAdjustments = [[NSArray alloc] initWithObjects:@"亮度",@"对比度",@"饱和度",@"曝光", @"调整RGB", @"色温", @"色彩", @"色调", @"锐化", @"平滑", @"模糊", nil];
//    NSArray *artistic = [[NSArray alloc] initWithObjects:@"Comic Print",@"Posterize",@"Pop Art",@"Pencil Sketch",@"Neon",nil];
//    NSArray *photoEffects = [[NSArray alloc] initWithObjects:@"Lomo",@"Cross Process",@"Gritty",@"Fading Colors",@"Film Grain",@"Redscale",@"Faux HDR",@"Sepia Toning",@"Invert",@"Tilt-shift",@"Soft Glow", nil];
    NSArray *photoEffects = [[NSArray alloc] initWithObjects:@"Lomo",@"HDR 渲染",@"底片",@"老照片",@"灰白",@"黑白",@"黄昏",@"素描",@"聚光灯",@"电流色",@"双色调",@"彩虹",@"水彩画",@"柔和",@"移轴",@"上滤镜",@"边框滤镜",@"淡化边缘",@"重影",@"边缘模糊", @"反转片", @"霓虹灯", nil];
    NSArray *filterFrames = [[NSArray alloc] initWithObjects:@"白框",@"黑框",@"经典框",@"可爱边框",@"电影胶片",@"菲林",@"录像",@"胶带", nil];
    NSArray *distortNameArray = [[NSArray alloc] initWithObjects:@"拉伸", @"垂直拉伸", @"水平拉伸", @"镜像", @"球面化",@"旋转",@"凸出",@"发散",nil];
//    NSArray *miscSection = [[NSArray alloc] initWithObjects:@"History Paint",@"Masked Effects",@"Pixelize",@"X-ary",@"Dizziness",@"Heat Map", nil];
//    NSDictionary *effectMenu = [[NSDictionary alloc] initWithObjectsAndKeys:
//                    firstSection,@"0",
//                    distortSection,@"1",
//                    colorAdjustments,@"2",
//                    artistic,@"3",
//                    photoEffects,@"4",
//                    filterFrames,@"5",
//                    miscSection,@"6",
//                    nil];
    NSDictionary *effectMenu = [[NSDictionary alloc] initWithObjectsAndKeys:colorAdjustments,@"0",
        photoEffects,@"1",
        filterFrames,@"2", 
        distortNameArray,@"3",                      
        nil];
    self.effectNameDic = effectMenu;
    
//    NSArray *keys = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6", nil];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"0",@"1",@"2", @"3", nil];
    self.effectKeys = keys;
    
//    NSArray *titleList = [[NSArray alloc] initWithObjects:@"A",@"Distort",@"Color Adjustments",@"Artistic",@"Photo effects",@"FIlter & Frames",@"Misc", nil];
    NSArray *titleList = [[NSArray alloc] initWithObjects:@"调色",@"特效",@"边框", @"扭曲", nil];
    self.titleForTableView = titleList;
    
//    [firstSection release];
//    [distortSection release];
    [colorAdjustments release];
//    [artistic release];
    [photoEffects release];
    [filterFrames release];
    [distortNameArray release];
//    [miscSection release];
    
    [effectMenu release];
    [keys release];
    [titleList release];
    
    if (smallImgByEffectedDic_ == nil)
    {
        smallImgByEffectedDic_ = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    [self performSelectorInBackground:@selector(effectSmallImage) withObject:nil];
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_group_t group = dispatch_group_create();
//    NSLog(@"Begin counting.....");
//    dispatch_group_async(group, queue, ^{
//        [self effectSmallImage];
//    });
//    dispatch_group_notify(group, queue, ^{
//        NSLog(@"end");
//        [self.effectTableView reloadData];
//        
//    });
//    dispatch_release(group);

}

- (void)viewDidUnload
{
    self.effectNameDic = nil;
    self.effectKeys = nil;
    self.titleForTableView = nil;
    self.smallImgByEffectedDic = nil;
    RELEASE_OBJECT(cellSelectedBkgView_);
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark dataSource delegate method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSString *keySection = nil;
    if ([self.effectKeys count] == 0)
    {
        return 0;
    }
    keySection = [self.effectKeys objectAtIndex:section];
    NSArray *nameArray = [self.effectNameDic objectForKey:keySection];
    return [nameArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    NSString *keySection = [NSString stringWithFormat:@"%d",section];
    NSArray  *nameSection = [self.effectNameDic objectForKey:keySection];
    NSArray *imageSection = [self.smallImgByEffectedDic objectForKey:keySection];
    
    static NSString  *simpleTableIdentifier = @"simpleTableIdentifier";
    EffectCustomCell *cell = (EffectCustomCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) 
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EffectCustomCell" owner:self options:nil];
		for (id oneObj in nib)
		{
			if ([oneObj isKindOfClass:[EffectCustomCell class]]) 
			{
                cell = (EffectCustomCell *)oneObj;
            }
		}
	}
    UIImage *image = nil;
    if (row < [imageSection count])
    {
        image = [imageSection objectAtIndex:row];
    }
    
    if (image == nil)
    {
        image = self.smallImage;
    }
    cell.imageView.image = image;
    
    if ([keySection isEqualToString:@"1"]&&row == EEffectRainbowId - 2001)
    {
        GradientView *gradientView = [[GradientView alloc] initWithFrame:cell.imageView.bounds];
        gradientView.alpha = 0.7;
        [cell.imageView addSubview:gradientView];
        [gradientView release];
    }
    else if([keySection isEqualToString:@"1"]&&row == EEffectTiltShiftId - 2001)
    {
        CGRect rect = cell.imageView.frame;
        CGFloat imageWidth = image.size.width;
		CGFloat imageHeight = image.size.height;
		CGFloat scale = imageWidth / rect.size.width;
		CGFloat radius = 20.0f;	// 显示在界面上是50,其实在真正的图片上不是50，因为图片被缩小了
		
		
        Rectangle rectangle;
        rectangle.xView = rect.origin.x + rect.size.width/2;
        rectangle.yView = rect.origin.y + rect.size.height/2;
        rectangle.x = imageWidth/2;
        rectangle.y = imageHeight/2;
        rectangle.heightInView = radius;
        rectangle.widthInView = rect.size.width;
        RectangleClipView *rectangleView = [[RectangleClipView alloc] initWithFrame:rect rectangle:&rectangle imageView:cell.imageView superController:nil];
        rectangleView.userInteractionEnabled = NO;
        rectangleView.scale = scale;
        [rectangleView effect];
        [cell addSubview:rectangleView];
        [rectangleView release];
        
    }
    
    cell.titleLabel.text = [nameSection objectAtIndex:row];
    cell.titleLabel.font = [UIFont systemFontOfSize:16];
    cell.titleLabel.textColor = [UIColor getColor:kEffectButtonDeselectStringColor];
    cell.titleLabel.highlightedTextColor = [UIColor getColor:kEffectButtonSelectStringColor];
    cell.selectedBackgroundView = cellSelectedBkgView_;
    
    if ((section < [self.effectNameDic count] - 1 && row == [nameSection count] - 1))
    {
        cell.separatorLineImgView.hidden = YES;
        return cell;
    }
    
    return cell;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     return ([self.effectKeys count] > 0)?[self.effectKeys count]:1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}


//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if ([self.titleForTableView count] == 0)
//    {
//        return  nil;
//    }
//    
//    NSString *sectionTitle = [self.titleForTableView objectAtIndex:section];
//    if (sectionTitle == UITableViewIndexSearch)
//    {
//        return nil;
//    }
//    return sectionTitle;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [self.titleForTableView objectAtIndex:section];
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    customView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kEffectListSectionBackGround]];
    customView.alpha = 0.5;
    UIView *sectionString = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)] autorelease];
    sectionString.backgroundColor = [UIColor clearColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor getColor:kEffectButtonSelectStringColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:16];
    headerLabel.frame = CGRectMake(10, 0, 320, 25);
    headerLabel.text = sectionTitle;
    headerLabel.textAlignment = UITextAlignmentLeft;
    [sectionString addSubview:customView];
    [sectionString addSubview:headerLabel];
    [headerLabel release];
    [customView release];
    
    //加分割线
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 25, 320, 0.5)];
    [line setBackgroundColor:[UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:99/255.0]];
    [sectionString addSubview:line];
    [line release];
    return sectionString;
}
#pragma mark tableView delegate method

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
	EffectCustomCell *cell = (EffectCustomCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (EEffectPhotoEffectsSection == section) 
    {
        switch (row+2001) 
        {
            case EEffectTopLensFilter://上滤镜
            {
                TopLensFilterAndEdgeLensFilterViewController *tlfvc = [[TopLensFilterAndEdgeLensFilterViewController alloc]init];
                tlfvc.isFromTopLensFilter = YES;
                [self.navigationController pushViewController:tlfvc animated:YES];
                [tlfvc release];
            }
                break;
            case EEffectEdgeLensFilter://边框滤镜
            {
                TopLensFilterAndEdgeLensFilterViewController *elfvc = [[TopLensFilterAndEdgeLensFilterViewController alloc]init];
                [elfvc setIsFromTopLensFilter:NO];
                [self.navigationController pushViewController:elfvc animated:YES];
                [elfvc release];
            }
                break;
            case EEffectMatte://淡化边缘
            {
                MatteViewController *mvc = [[MatteViewController alloc]init];
                [self.navigationController pushViewController:mvc animated:YES];
                [mvc release];
            }
                break;
            case EEffectDizziness://重影
            {
                DizzinessViewController *dvc = [[DizzinessViewController alloc]init];
                [self.navigationController pushViewController:dvc animated:YES];
                [dvc release];
            }
                break;
            case EEffectVegnette://边缘模糊
            {
                VegnetteViewController *vegnetteViewCtrl = [[VegnetteViewController alloc] init];
                [self.navigationController pushViewController:vegnetteViewCtrl animated:YES];
                [vegnetteViewCtrl release];
            }                
                break;
            default://其他
            {
                PhotoEffectsViewController *photoEffectViewCtrl = [[PhotoEffectsViewController alloc] init];
                photoEffectViewCtrl.effectType = row + 2001;//EEfectSectionID从2001开始
                photoEffectViewCtrl.title = cell.titleLabel.text;
                [self.navigationController pushViewController:photoEffectViewCtrl animated:YES];
                [photoEffectViewCtrl release];
            }
                break;
        }
    }
	else if (EEffectColorAdjustSection == section)
	{
		ColorEffectsViewController *vc = [[ColorEffectsViewController alloc] init];
		vc.strEffectType = cell.titleLabel.text;
		vc.effectType = row + 3001;		//EEfectSectionID从3001开始
		[self.navigationController pushViewController:vc animated:YES];
        [vc release];
	}
    else if(EEffectFilterFramesSection == section)
    {
        FilmFrameEffectViewController *filmFrame = [[FilmFrameEffectViewController alloc] init];
        filmFrame.effectType = row + 4001;
        //若要实现炫彩边框等功能，只要直接推出页面就可以了  不需要判断
        if (filmFrame.effectType != EEffectColorFrameId)
        {
            [self.navigationController pushViewController:filmFrame animated:YES];
        }
        else
        {
//            UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"此功能暂未开放" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [av show];
//            [av release];
            [Common showToastView:@"此功能还在开发中，敬请期待" hiddenInTime:2.0f];
        }
        [filmFrame release];
    
    }
    else if (EEffectDistortSection == section)
    {
        NSInteger strrtchType = row+EEffectStretchId;
        
        switch (strrtchType) 
        {
            case EEffectStretchId:
            {
                StretchViewController *stretchVC = [[StretchViewController alloc] init];
                [self.navigationController pushViewController:stretchVC animated:YES];
                [stretchVC release];
                break;
            }
            case EEffectVerticalStretchId:
            {       
                HorizontalStretchViewController *hStretchVC = [[HorizontalStretchViewController alloc] init];
                hStretchVC.horizontalStretch = NO;
                [self.navigationController pushViewController:hStretchVC animated:YES];
                [hStretchVC release];
                break;
            }
            case EEffectHorizontalStretchId:
            {
                HorizontalStretchViewController *hStretchVC = [[HorizontalStretchViewController alloc] init];
                hStretchVC.horizontalStretch = YES;
                [self.navigationController pushViewController:hStretchVC animated:YES];
                [hStretchVC release];
                break;
            }
            case EEffectMirrorStretchId:
            {
                MirrorViewController *mirrorVC = [[MirrorViewController alloc] init];
                [self.navigationController pushViewController:mirrorVC animated:YES];
                [mirrorVC release];
                break;
            }
            /*****************************************
             ******* add by Rongtao Wu 2012-7 
             ******* 添加 球面化、旋转、突出、发散效果
             ******* 点击进入效果页面
             ****************************************/
            case EEffectSpherizeId: 
            case EEffectTwirId: 
            case EEffectBlugeId: 
            case EEffectSplashId:
            {
                TwistViewController *twistVC = [[TwistViewController alloc] init];
                twistVC.effectIndex = row - 4;
                [self.navigationController pushViewController:twistVC animated:YES];
                [twistVC release];
            }
                break;
            ////--------------END--------------
            default:
                break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];    
}

#pragma mark - 
/**
 * @brief  返回上层页面
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (void)cancelOperation
{
    [self.navigationController popViewControllerAnimated:YES];
}



/**
 * @brief  给列表添加缩略图添加特效 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)effectSmallImage
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	ImageInfo *imageInfo = [ImageInfo UIImageToImageInfo:self.smallImage];
	UIImage *afterImage = nil;
	
    //按顺序做处理
    //调色
    NSMutableArray *colorAdjustArray = [[NSMutableArray alloc] initWithCapacity:0];
	// 亮度
	ImageInfo *clone = [imageInfo clone];
	[ColorEffectsCommon brightness:clone level:0.5];
	ADD_EFFECT_IMAGE(clone, colorAdjustArray);
	// 对比度
	clone = [imageInfo clone];
	[ColorEffectsCommon contrast:clone level:1.0f];
	ADD_EFFECT_IMAGE(clone, colorAdjustArray);
	// 饱和度
	clone = [imageInfo clone];
	[ColorEffectsCommon saturation:clone level:2.0f];
	ADD_EFFECT_IMAGE(clone, colorAdjustArray);
	// 曝光度
	clone = [imageInfo clone];
	[ColorEffectsCommon exposure:clone blackThreshold:0 whiteThreshold:350 gamma:1];
	ADD_EFFECT_IMAGE(clone, colorAdjustArray);
	// 调整RGB
	clone = [imageInfo clone];
	[ColorEffectsCommon adjustImage:clone withRed:-50 green:50 blue:50];
	ADD_EFFECT_IMAGE(clone, colorAdjustArray);
    
    // 色温
	clone = [imageInfo clone];
	[ColorEffectsCommon temperature:clone level:100.0];
	ADD_EFFECT_IMAGE(clone, colorAdjustArray);
    // 色彩
	clone = [imageInfo clone];
	[ColorEffectsCommon colorImage:clone level:0.0];
	ADD_EFFECT_IMAGE(clone, colorAdjustArray);
    // 色调
	clone = [imageInfo clone];
	[ColorEffectsCommon toneImage:clone level:50.0];
	ADD_EFFECT_IMAGE(clone, colorAdjustArray);
    // 锐化
	clone = [imageInfo clone];
    ImageInfo *imageEdge = [imageInfo clone];
    [ColorEffectsCommon edgeDetect:imageEdge];
	[ColorEffectsCommon sharpenImage:clone imageEdge:imageEdge level:0.4];
	ADD_EFFECT_IMAGE(clone, colorAdjustArray);
    [imageEdge release];
	
	// 平滑
	clone = [imageInfo clone];
	[ColorEffectsCommon smoothImage:clone level:3];
	ADD_EFFECT_IMAGE(clone, colorAdjustArray);
	// 模糊
	clone = [imageInfo clone];
	[ColorEffectsCommon fastBlurImage:clone radius:3];
	ADD_EFFECT_IMAGE(clone, colorAdjustArray);
	
    //将处理后的图片数组添加到字典
    [smallImgByEffectedDic_ setObject:colorAdjustArray forKey:@"0"];
    [colorAdjustArray release];
    
    //特效
    NSMutableArray *effectArray = [[NSMutableArray alloc] initWithCapacity:0];
    //lomo
    ImageInfo *lomoClone = [imageInfo clone];
    [UIImage lomoEffectAtImage:lomoClone withBrightRadius:1.0 needBalanceColor:YES];
    afterImage = [ImageInfo ImageInfoToUIImage:lomoClone];
    [effectArray addObject:afterImage];
    [lomoClone release];
    
    //HDR
    ImageInfo *hdrClone = [imageInfo clone];
    //用0.95使效果与曝光度区别
    [UIImage HDREffectAtImage:hdrClone withGamma:(1.0 + 0.95)/2];
    afterImage = [ImageInfo ImageInfoToUIImage:hdrClone];
    [effectArray addObject:afterImage];
    [hdrClone release];
    
    //invert
    ImageInfo *invertClone = [imageInfo clone];
    [UIImage invertEffectAtImage:invertClone];
    afterImage = [ImageInfo ImageInfoToUIImage:invertClone];
    [effectArray addObject:afterImage];
    [invertClone release];
    
    //oldPhoto
    ImageInfo *oldPhotoClone = [imageInfo clone];
    [UIImage oldPhotoEffectAtImage:oldPhotoClone withRatio:1.0 needGrayScale:YES];
    afterImage = [ImageInfo ImageInfoToUIImage:oldPhotoClone];
    [effectArray addObject:afterImage];
    [oldPhotoClone release];
    
    //灰白
    ImageInfo *grayScaleClone = [imageInfo clone];
    [EffectMethods grayScaleWithImageInfo:grayScaleClone];
    [EffectMethods adjustLevelsWithInImage:grayScaleClone withBlackLimit:0 withWhiteLimit:255 withGamma:100 withChanel:EChanelRGB]; 
    afterImage = [ImageInfo ImageInfoToUIImage:grayScaleClone];
    [effectArray addObject:afterImage];
    [grayScaleClone release];
    
    //黑白
    ImageInfo *blackWhiteClone = [imageInfo clone];
    [UIImage blackWhite:blackWhiteClone withLevels:127];
    afterImage = [ImageInfo ImageInfoToUIImage:blackWhiteClone];
    [effectArray addObject:afterImage];
    [blackWhiteClone release];
    
    //黄昏
    ImageInfo *redScaleClone = [imageInfo clone];
    [ColorEffectsCommon redScale:redScaleClone level:100.0f];
    afterImage = [ImageInfo ImageInfoToUIImage:redScaleClone];
    [effectArray addObject:afterImage];
    [redScaleClone release];  

    
    //sketch
    ImageInfo *sketchClone = [imageInfo clone];
    [UIImage sketchEffectAtImage:sketchClone withOpacity:1.0 needGrayScale:YES];
    afterImage = [ImageInfo ImageInfoToUIImage:sketchClone];
    [effectArray addObject:afterImage];
    [sketchClone release];
    
    //spot light
    ImageInfo *spotLightClone = [imageInfo clone];
    CGSize size = kEffectSmallImageSize;
    ConcentricCircle circle;
    circle.xView = size.width/2 ;
    circle.yView = size.height/2;
    circle.x = size.width / 2;
    circle.y = size.height / 2;
    circle.minRadius = size.width/4;
    circle.maxRadius = circle.minRadius + 5.0f;
    [EffectMethods concentricCircleClip:spotLightClone circle:&circle];
    afterImage = [ImageInfo ImageInfoToUIImage:spotLightClone];
    [effectArray addObject:afterImage];
    [spotLightClone release];
    
    //电流色
    ImageInfo *heatMapClone = [imageInfo clone];   
    [UIImage heatMap:heatMapClone];
    afterImage = [ImageInfo ImageInfoToUIImage:heatMapClone];
    [effectArray addObject:afterImage];
    [heatMapClone release];
    
    //双色调    
    NSNumber *r1, *g1, *b1, *r2, *g2, *b2;
    r1 = [NSNumber numberWithInt: 0];
    g1 = [NSNumber numberWithInt: 0];
    b1 = [NSNumber numberWithInt: 255];
    r2 = [NSNumber numberWithInt: 255];
    g2 = [NSNumber numberWithInt: 255];
    b2 = [NSNumber numberWithInt: 0];
    NSMutableArray  *colorArray = [[NSMutableArray alloc] initWithObjects:r1, g1, b1, r2, g2, b2, nil];
    ImageInfo *duoToneClone = [imageInfo clone];
    [EffectMethods grayScaleWithImageInfo:duoToneClone];
    [UIImage duoTone:duoToneClone withColor:colorArray withLevel:28];
    afterImage = [ImageInfo ImageInfoToUIImage:duoToneClone];
    [effectArray addObject:afterImage];
    [colorArray release];
    [duoToneClone release ];

    
    //彩虹,不需要在此处理，因为彩虹特效是在imageview上添加一个view，在cellforrow里处理
    [effectArray addObject:self.smallImage];
    
       
    //水彩画
    ImageInfo *paintingClone = [imageInfo clone];
    [UIImage posterize:paintingClone withLevels:2];
    afterImage = [ImageInfo ImageInfoToUIImage:paintingClone];
    [effectArray addObject:afterImage];
    [paintingClone release];
    
    // 柔和
    ImageInfo *softLightClone = [imageInfo clone];
    [UIImage softlightAtImage:softLightClone withOpacity:1.0f];
    afterImage = [ImageInfo ImageInfoToUIImage:softLightClone];
    [effectArray addObject:afterImage];
    [softLightClone release];
    
    //移轴,不需要在此处理，因为移轴特效是在imageview上添加一个view，在cellforrow里处理
    [effectArray addObject:self.smallImage];
    
    //top lens filter
    TopLensFilterAndEdgeLensFilterProcess *tlfaelfp = [[TopLensFilterAndEdgeLensFilterProcess alloc]init];
    UIImage *tlfImage = [tlfaelfp topLensFilter:self.smallImage red:255 green:0 blue:0 opacity:1 heightRatio:1];
    [effectArray addObject:tlfImage];
    
    //edge lens filter
    UIImage *elfImage = [tlfaelfp edgeLensFilter:self.smallImage red:0 green:0 blue:255 opacity:1 heightRatio:0.3];
    [tlfaelfp release];
    [effectArray addObject:elfImage];
    
    //matte
    MatteView *mv = [[MatteView alloc]init];
    UIImage *mImage = [mv getSmallImage:self.smallImage];
    [mv release];
    [effectArray addObject:mImage];
    
    //dizziness
    DizzinessViewController *dvc = [[DizzinessViewController alloc]init];
    UIImage *dImage = [dvc getSmallImage:self.smallImage];
    [dvc release];
    [effectArray addObject:dImage];
    
    //边缘模糊
    VegnetteView *vegnetteView = [[VegnetteView alloc] init];
    UIImage *newImg = [vegnetteView getEffectSmallImage:self.smallImage];
    [effectArray addObject:newImg];
    [vegnetteView release];
    
    //反转片
    ImageInfo *reversalFilmClone = [imageInfo clone];
    [UIImage reversalFilmAtImage:reversalFilmClone withOpacity:1.0f];
    afterImage = [ImageInfo ImageInfoToUIImage:reversalFilmClone];
    [effectArray addObject:afterImage];
    [reversalFilmClone release];
    
    // neon
    ImageInfo *neonClone = [imageInfo clone];
    [UIImage neonAtImage:neonClone hue:0 saturation:1 bright:191.25 withOpacity:1.0f];
//    [UIImage neonAtImage:neonClone red:255 green:0 blue:0 withOpacity:1.0f];
    afterImage = [ImageInfo ImageInfoToUIImage:neonClone];
    [effectArray addObject:afterImage];
    [neonClone release];
    
    //将处理后的图片数组添加到字典
    [smallImgByEffectedDic_ setObject:effectArray forKey:@"1"];
    [effectArray release];
    
    
    //边框
    NSMutableArray *filmArray = [[NSMutableArray alloc] initWithCapacity:0];
    //将处理后的图片数组添加到字典
    
    //白框
    CGRect whiteRect = CGRectMake(0, 0, 60, 60);
    UIImage *whiteImage = [Common addTwoImageToOne:self.smallImage twoImage:kEffectBigWhiteFrameImage toRect:whiteRect];
    [filmArray addObject:whiteImage];
    
    
    //黑框
    CGRect blackRect = CGRectMake(0, 0, 60, 60);
    UIImage *blackImage = [Common addTwoImageToOne:self.smallImage twoImage:kEffectBigBlackFrameImage toRect:blackRect];
    [filmArray addObject:blackImage];
    
    //经典框
    CGRect classicRect = CGRectMake(0, 0, 60, 60);
    UIImage *classicImage = [Common addTwoImageToOne:self.smallImage twoImage:kEffectBigClassicFrameImage toRect:classicRect];
    [filmArray addObject:classicImage];
    
    //可爱边框
    CGRect lovelyRect = CGRectMake(0, 0, 60, 60);
    UIImage *lovelyImage = [Common addTwoImageToOne:self.smallImage twoImage:kEffectBigLovelyFrameImage toRect:lovelyRect];
    [filmArray addObject:lovelyImage];
    
    //film
    CGRect filmRect = CGRectMake(0, 0, 60, 60);
    UIImage *filmImage = [Common addTwoImageToOne:self.smallImage twoImage:kEffectBigFilmFrameImage toRect:filmRect];
    [filmArray addObject:filmImage];
    
    //feeling
    CGRect feelingRect = CGRectMake(0, 0, 60, 60);
    UIImage *feelingImage = [Common addTwoImageToOne:self.smallImage twoImage:kEffectBigFeelingFrameImage toRect:feelingRect];
    [filmArray addObject:feelingImage];
    
    //video
    CGRect videoRect = CGRectMake(0, 0, 60, 60);
    UIImage *videoImage = [Common addTwoImageToOne:self.smallImage twoImage:kEffectBigVideoFrameImage toRect:videoRect];
    [filmArray addObject:videoImage];
    
    //sellotape
    CGRect sellotapeRect = CGRectMake(0, 0, 60, 60);
    UIImage *sellotapeImage = [Common addTwoImageToOne:self.smallImage twoImage:kEffectBigSellotapeFrameImage toRect:sellotapeRect];
    [filmArray addObject:sellotapeImage];

    
    [smallImgByEffectedDic_ setObject:filmArray forKey:@"2"];
    [filmArray release];
    
    
    //特效
    NSMutableArray *distortArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    //Stretch
    UIImage *stretchImage = [StretchViewController imageStretch:self.smallImage];
    [distortArray addObject:stretchImage];
    
    //VerticalStretch   
    UIImage *vStretchImage = [HorizontalStretchViewController imageVStretch:self.smallImage];    
    [distortArray addObject:vStretchImage];
    
    //HorizontalStretch   
    UIImage *hStretchImage = [HorizontalStretchViewController imageHStretch:self.smallImage];    
    [distortArray addObject:hStretchImage];
    
    //Mirror
    UIImage *mirrorImage = [MirrorViewController mirrorEffect:self.smallImage];
    [distortArray addObject:mirrorImage];
    
    [smallImgByEffectedDic_ setObject:distortArray forKey:@"3"];
    [distortArray release];    
    
    //回到主线程刷新列表，防止出现主线程和后台同时处理列表引起crash
    [self.effectTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    [pool release];
    
}

@end
