//
//  MainViewController.m
//  Aico
//
//  Created by  on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "GlobalDef.h"
#import "AdjustMenuViewController.h"
#import "Common.h"
#import "EffectViewController.h"
#import "ImageScrollViewController.h"
#import "StorageViewController.h"
#import "ReUnManager.h"
#import "UIImage+extend.h"
#import "StickerMenuViewController.h"
#import "ExportMainViewController.h"
#import "MainViewController.h"

@implementation MainViewController
@synthesize srcImage = srcImage_;
@synthesize fatherController;

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

//- (void) doubleTapDone:(UITapGestureRecognizer*)gesture
//{    
//    UIScrollView *imageScrollView = (UIScrollView *)[self.view viewWithTag:kMainScrollViewTag];
//    [imageScrollView setZoomScale:1.2 animated:YES];
//}
//
//- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    return [scrollView viewWithTag:kZoomViewTag];
//}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    imageScrollVC_ = [[ImageScrollViewController alloc] init];
    [self.view insertSubview:imageScrollVC_.view atIndex:0]; 
    UIImageView *imageView = (UIImageView *)[imageScrollVC_.view viewWithTag:kZoomViewTag];
    
    UIScrollView *imageScrollView = (UIScrollView *)[imageScrollVC_.view viewWithTag:kMainScrollViewTag];
    ReUnManager *rm = [ReUnManager sharedReUnManager];
    //imageview需要先设置frame，再设置image
    imageView.frame = [Common adaptImageToScreen:[rm getGlobalSrcImage]];
    imageView.image = [rm getGlobalSrcImage];
    imageScrollView.contentOffset = CGPointMake(0, 44);
    [self checkButton];
    rm.snapImage = nil;//只要到了主页面，原来的记录的操作就可以删除了 
}

/**
 * @brief  检查撤销按钮显示
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)checkButton
{
    ReUnManager *rm = [ReUnManager sharedReUnManager];
    UIView *rightView = self.navigationItem.rightBarButtonItem.customView;
    UIButton *leftButton = (UIButton*)[rightView viewWithTag:kLeftButtonTag];
    UIButton *rightButton = (UIButton*)[rightView viewWithTag:kRightButtonTag];
    if ([rm canUndo])
    {
        [leftButton setImage:[UIImage imageNamed:kMainUndo] forState:UIControlStateNormal];
        leftButton.enabled = YES;
    }
    else
    {
        [leftButton setImage:[UIImage imageNamed:kMainUndoGray] forState:UIControlStateNormal];
        leftButton.enabled = NO;
    }
    
    if ([rm canRedo])
    {
        [rightButton setImage:[UIImage imageNamed:kMainRedo] forState:UIControlStateNormal];
        rightButton.enabled = YES;
    }
    else
    {
        [rightButton setImage:[UIImage imageNamed:kMainRedoGray] forState:UIControlStateNormal];
        rightButton.enabled = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
//    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
//    bgImageView.image = [UIImage imageNamed:@"bgImage.png"];
//    [self.view insertSubview:bgImageView atIndex:0];
//    [bgImageView release];
    
    [Common setNavigationBarBackgroundBkg:self.navigationController.navigationBar];
//    
//    UISegmentedControl *segmentedControl=[[UISegmentedControl alloc] initWithFrame:CGRectMake(180.0f, 8.0f, 100.0f, 30.0f) ]; 
    
//    NSArray *imageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"mainLeft.png"], [UIImage imageNamed:@"mainRight.png"], nil];
//    
//    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:imageArray];
//    segmentedControl.frame = CGRectMake(180.0f, 8.0f, 100.0f, 30.0f);
//    segmentedControl.backgroundColor = [UIColor clearColor];
////    [segmentedControl insertSegmentWithTitle:@"上一步" atIndex:0 animated:YES]; 
////    [segmentedControl insertSegmentWithTitle:@"下一步" atIndex:1 animated:YES]; 
//    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar; 
//    segmentedControl.momentary = YES; 
//    segmentedControl.multipleTouchEnabled=NO; 
//    [segmentedControl addTarget:self action:@selector(Selectbutton:) forControlEvents:UIControlEventValueChanged]; 
//    UIBarButtonItem *segButton = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl]; 
//    [segmentedControl release]; 
//    self.navigationItem.rightBarButtonItem = segButton; 
//    [segButton release];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 85, 30)];
    rightView.backgroundColor = [UIColor clearColor];
    UIButton *undoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [undoButton setImage:[UIImage imageNamed:kMainUndo] forState:UIControlStateNormal];
    UIButton *redoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [redoButton setImage:[UIImage imageNamed:kMainRedo] forState:UIControlStateNormal];
    undoButton.tag = kLeftButtonTag;
    redoButton.tag = kRightButtonTag;
    
    [undoButton addTarget:self action:@selector(undoMethod:) forControlEvents:UIControlEventTouchUpInside];
    [redoButton addTarget:self action:@selector(redoMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    [rightView addSubview:undoButton];
    [rightView addSubview:redoButton];
    undoButton.frame = CGRectMake(0, 0, 30, 30);
    redoButton.frame = CGRectMake(55, 0, 30, 30);
    UIBarButtonItem *segButton = [[UIBarButtonItem alloc] initWithCustomView:rightView]; 
    self.navigationItem.rightBarButtonItem = segButton; 
    [segButton release];
    [rightView release];
    
    if (fatherController == 1)//aico
    {
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, 60, 30);
        [leftButton setImage:[UIImage imageNamed:@"mainBar.png"] forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"mainBarBack.png"] forState:UIControlStateHighlighted];
        [leftButton addTarget:self action:@selector(backToAico:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftItem;
        [leftItem release];
    }
    else//main
    {
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, 60, 30);
        [leftButton setImage:[UIImage imageNamed:@"mainBar.png"] forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"mainBarBack.png"] forState:UIControlStateHighlighted];
        [leftButton addTarget:self action:@selector(backToAico:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        
        self.navigationItem.leftBarButtonItem = leftItem;
        [leftItem release];
    }

    //[self checkButton];
}

- (void)viewDidDisappear:(BOOL)animated
{
    UIScrollView *scrollView = (UIScrollView *)[imageScrollVC_.view viewWithTag:kMainScrollViewTag];
    scrollView.delegate = nil;
    [imageScrollVC_.view removeFromSuperview];
    [imageScrollVC_ release],imageScrollVC_ = nil; 
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
//    [imageScrollVC_ release],imageScrollVC_ = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    self.srcImage = nil;
    [imageScrollVC_ release];
    [super dealloc];
}

#pragma mark - Custom Method
/**
 * @brief  返回到主页的响应
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)backToAico:(id)sender
{
    if (fatherController == 1)//aico folder
    {
        ReUnManager *rm = [ReUnManager sharedReUnManager];
        UIImage *imageData = [rm getGlobalSrcImage];
//        NSString *name = rm.currentImageName;
//        [Common writeImageAico:imageData withName:name];
        if ([rm canUndo])
        {
            [Common writeImageAico:imageData withName:nil];//走新建流程,如果没有修改 undo返回NO
        }
        
        //更新最后编辑的图片
        NSString *OrPath = [NSString stringWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] ];
        NSString *lastFloder = [OrPath stringByAppendingPathComponent:@"LastImage"];
        NSString *lastImagePath = [lastFloder stringByAppendingPathComponent:@"lastImage.png"];
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:lastImagePath error:nil];
        [UIImagePNGRepresentation(imageData) writeToFile:lastImagePath atomically:YES];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    else
    {
        ReUnManager *rm = [ReUnManager sharedReUnManager];
        UIImage *imageData = [rm getGlobalSrcImage];
        //        NSString *name = rm.currentImageName;
        //        [Common writeImageAico:imageData withName:name];
        if ([rm canUndo])
        {
            [Common writeImageAico:imageData withName:nil];//走新建流程,如果没有修改 undo返回NO
        }
        
        //更新最后编辑的图片
        NSString *OrPath = [NSString stringWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] ];
        NSString *lastFloder = [OrPath stringByAppendingPathComponent:@"LastImage"];
        NSString *lastImagePath = [lastFloder stringByAppendingPathComponent:@"lastImage.png"];
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:lastImagePath error:nil];
        [UIImagePNGRepresentation(imageData) writeToFile:lastImagePath atomically:YES];
        
        [self.navigationController popViewControllerAnimated:YES];
    }

}

/**
 * @brief  点击编辑按钮响应方法
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note IB调用
 */
- (IBAction)adjustButtonPressed:(id)sender
{
    
    AdjustMenuViewController *adjustMenuController = [[AdjustMenuViewController alloc] init];
    [self.navigationController pushViewController:adjustMenuController animated:YES];
    [adjustMenuController release];
    
}

/**
 * @brief  undo按钮响应
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)undoMethod:(id)sender
{
    if (imageScrollVC_)
    {
        UIScrollView *scrollView = (UIScrollView *)[imageScrollVC_.view viewWithTag:kMainScrollViewTag];
        scrollView.delegate = nil;
        [imageScrollVC_.view removeFromSuperview];
        [imageScrollVC_ release],imageScrollVC_ = nil;
        imageScrollVC_ = [[ImageScrollViewController alloc] init];
        [self.view insertSubview:imageScrollVC_.view atIndex:0]; 
    }
    ReUnManager *rm = [ReUnManager sharedReUnManager];
    NSString *lastImagePath = [rm undoAction];
    if (lastImagePath != nil)
    {
        UIImage *lastImage = [UIImage imageWithContentsOfFile:lastImagePath];
        if (lastImage != nil)
        {
            UIImageView *imageView = (UIImageView *)[imageScrollVC_.view viewWithTag:kZoomViewTag];
            imageView.frame = [Common adaptImageToScreen:lastImage];
            imageView.image = lastImage;
            UIScrollView *imageScrollView = (UIScrollView *)[imageScrollVC_.view viewWithTag:kMainScrollViewTag];
            imageScrollView.contentSize = imageScrollView.frame.size;
            imageView.center = CGPointMake(imageScrollView.frame.size.width/2, imageScrollView.frame.size.height/2);
            
        }
        else
        {
            NSLog(@"undo error1");
        }
        
    }
    else
    {
        NSLog(@"undo error2");
    }
    [self checkButton];
}

/**
 * @brief  redo按钮响应
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)redoMethod:(id)sender
{
    if (imageScrollVC_)
    {
        UIScrollView *scrollView = (UIScrollView *)[imageScrollVC_.view viewWithTag:kMainScrollViewTag];
        scrollView.delegate = nil;
        [imageScrollVC_.view removeFromSuperview];
        [imageScrollVC_ release],imageScrollVC_ = nil;
        imageScrollVC_ = [[ImageScrollViewController alloc] init];
        [self.view insertSubview:imageScrollVC_.view atIndex:0]; 
    }
    ReUnManager *rm = [ReUnManager sharedReUnManager];
    NSString *lastImagePath = [rm redoAction];
    if (lastImagePath != nil)
    {
        UIImage *lastImage = [UIImage imageWithContentsOfFile:lastImagePath];
        if (lastImage != nil)
        {
            UIImageView *imageView = (UIImageView *)[imageScrollVC_.view viewWithTag:kZoomViewTag];
            imageView.frame = [Common adaptImageToScreen:lastImage];
            imageView.image = lastImage;
            UIScrollView *imageScrollView = (UIScrollView *)[imageScrollVC_.view viewWithTag:kMainScrollViewTag];
            imageScrollView.contentSize = imageScrollView.frame.size;
            imageView.center = CGPointMake(imageScrollView.frame.size.width/2, imageScrollView.frame.size.height/2);
        }
        else
        {
            NSLog(@"redo error1");
        }
        
    }
    else
    {
        NSLog(@"redo error2");
    }
    [self checkButton];
}

/**
 * @brief  点击特效响应方法
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note IB调用
 */
- (IBAction)effectButtonPressed:(id)sender
{
    EffectViewController *effectViewController = [[EffectViewController alloc] init];
    UIImage *image = [[ReUnManager sharedReUnManager] getGlobalSrcImage];
    image = [image imageByScalingToSize:kEffectSmallImageSize];
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    effectViewController.smallImage = [UIImage imageWithData:data];
    [self.navigationController pushViewController:effectViewController animated:YES];
    [effectViewController release];
}

/**
 * @brief  点击装饰响应方法
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note IB调用
 */
- (IBAction)stickerButtonPressed:(id)sender
{
//    [Common showToastView:@"此功能还在开发中，敬请期待" hiddenInTime:1.0f];
    StickerMenuViewController *stickerViewController = [[StickerMenuViewController alloc] init];
    stickerViewController.isStickerReplace = NO;
    //每次进入装饰页面，需要将sticker数组清空
    [[ReUnManager sharedReUnManager] clearAllStickers];
    [self.navigationController pushViewController:stickerViewController animated:YES];
    [stickerViewController release];
}

/**
 * @brief  点击导出响应方法
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note IB调用
 */
- (IBAction)exportButtonPressed:(id)sender
{
//    StorageViewController *storageViewController = [[StorageViewController alloc] init];
    ExportMainViewController *exportMainViewController = [[ExportMainViewController alloc] init];
    ReUnManager *rm = [ReUnManager sharedReUnManager];
    UIImage *currentImage = [rm getGlobalSrcImage];
//    if ([rm canUndo]) 
//    {
//        [Common writeImageAico:currentImage withName:nil];
//    }

    exportMainViewController.storeImage = currentImage;
    [self.navigationController pushViewController:exportMainViewController animated:YES];
    [exportMainViewController release];
//    storageViewController.storeImage = currentImage;
//    [self.navigationController pushViewController:storageViewController animated:YES];
//    [storageViewController release];
}
@end
