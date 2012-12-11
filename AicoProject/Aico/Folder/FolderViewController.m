//
//  FolderViewController.m
//  Aico
//
//  Created by Wang Dean on 12-4-6.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FolderViewController.h"
#import "ShareViewController.h"
#import "GlobalDef.h"
#import "Common.h"
#import "ImageSplitViewController.h"
#import "ReUnManager.h"
#import "UIImage+extend.h"

@implementation FolderViewController
@synthesize numImages;
@synthesize contentArray = contentArray_;
@synthesize backScrollView = backScrollView_;
@synthesize whichClassCallfrom;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (void)viewWillAppear:(BOOL)animated
{
    NSArray *arr =  [self.backScrollView subviews];
    for (id view in arr)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
    }
    self.navigationController.navigationBarHidden = NO;
    NSString *path = [NSString stringWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] ];
    path = [path stringByAppendingPathComponent:@"Icon"];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *err = nil;
    NSArray *tempArray = [fm contentsOfDirectoryAtPath:path error:&err];
    NSLog(@"%@", tempArray);
    
    if (tempArray == nil || [tempArray count] == 0)
    {
        [Common showToastView:@"天天相册没有照片，请美化图片或者拍张照片" hiddenInTime:2.0f];
    }
//    NSMutableArray *mulArray = [NSMutableArray arrayWithArray:tempArray];
//    NSUInteger index = [mulArray indexOfObject:@"First.png"];
//    if (index < [mulArray count])
//    {
//        [mulArray removeObject:@"First.png"];
//        [mulArray insertObject:@"First.png" atIndex:0];
//    }
    
    self.title = [NSString stringWithFormat:@"天天相册（%d）", [tempArray count]];
    [self.contentArray removeAllObjects];
    for (NSString *nameString in tempArray) 
    {
        NSString *folderPath = [[NSString alloc] initWithString:path];
        NSString *imagePathString = [path stringByAppendingPathComponent:nameString];
        [self.contentArray addObject:imagePathString];
        [folderPath release];
    }
    
    int flag = 0;
    for (NSString *path in self.contentArray) 
    {
        UIImage *image = [UIImage imageWithContentsOfFile:path];
//        UIImage *newImage = [image imageByScalingProportionallyToSize:CGSizeMake(kThumberHeight, kThumberHeight)];
//        NSData *imageData = UIImageJPEGRepresentation(newImage, 0);
//        UIImage *compressImage = [UIImage imageWithData:imageData];
        
        if (image != nil)
        {
            UIButton *contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
            contentButton.frame = CGRectMake(kFence + (kFence +kThumberHeight)*(flag % 4), kNavigationHeight + kGapFromTop + (kFence +kThumberHeight)*(flag / 4), kThumberHeight, kThumberHeight);
            
            [contentButton setImage:image forState:UIControlStateNormal];
            [contentButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            contentButton.tag = kFolderStartTag + flag;
            [self.backScrollView addSubview:contentButton];
            flag++;
        }
        else 
        {
            
            continue;
        }
    }
    CGFloat readHeight = kNavigationHeight + kGapFromTop + (kFence +kThumberHeight)*(flag / 4 + 1);
    self.backScrollView.contentSize = CGSizeMake(320, readHeight > 480 ? readHeight : 480);
    if (whichClassCallfrom == EClassAicoMain) 
    {
        //进入这个页面 ，undo和redo的东西就要清除掉了，不然会带入到aico相册的编辑图片中去
        ReUnManager *rm = [ReUnManager sharedReUnManager];
        [rm clearStorage];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.title = [NSString stringWithString:@"天天相册"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSArray *arr =  [self.backScrollView subviews];
    for (id view in arr)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
    }
}

#pragma mark Custom method

/**
 * @brief  每个图片点击的操作
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)buttonPressed:(id)sender
{
    //Aico相册是主页面调用
    if (self.whichClassCallfrom == EClassAicoMain) 
    {
        UIButton *tempButton = (UIButton *)sender;
        int index = tempButton.tag - kFolderStartTag;
        if (self.contentArray != nil  && [self.contentArray count] >= index)
        {
            NSString *imagePath = [self.contentArray objectAtIndex:index];
            ShareViewController *shareViewController = [[ShareViewController alloc] init];
            NSString *tempString = [NSString stringWithString:imagePath];
            NSArray *nameArr = [tempString componentsSeparatedByString:@"/"];
            NSString *name = [nameArr lastObject];
            if (name == nil)
            {
                [shareViewController release];
                return;
            }
            NSString *path = [NSString stringWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] ];
            path = [path stringByAppendingPathComponent:@"Favorite"];
            NSString *newPath = [path stringByAppendingPathComponent:name];
            
            shareViewController.imagePath = newPath;
            shareViewController.index = (index + 1);
			
			//压缩并处理图片
			UIImage *image = [UIImage imageWithContentsOfFile:newPath];
			UIImage *afterImg = [Common adjustedImagePathForImage:image];
			if (afterImg == nil)
			{
				afterImg = image;
			}
			ReUnManager *ru = [ReUnManager sharedReUnManager];
			if (![ru storeImage:afterImg])
			{
				NSLog(@"critical error cannot storeImage %d", __LINE__);
			}
			
            [self.navigationController pushViewController:shareViewController animated:YES];
            [shareViewController release];
        }
        else
        {
            NSLog(@"there is some wrong about NSArray count!!!");
        }
    }
    //Aico相册由插图页面调用
    else if (self.whichClassCallfrom == EClassInsert)
    {
        UIButton *tempButton = (UIButton *)sender;
        int index = tempButton.tag - kFolderStartTag;
        if (self.contentArray != nil  && [self.contentArray count] >= index)
        {
            NSString *imagePath = [self.contentArray objectAtIndex:index];
            NSString *tempString = [NSString stringWithString:imagePath];
            NSArray *nameArr = [tempString componentsSeparatedByString:@"/"];
            NSString *name = [nameArr lastObject];
            if (name == nil)
            {
                return;
            }
            NSString *path = [NSString stringWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] ];
            path = [path stringByAppendingPathComponent:@"Favorite"];
            NSString *newPath = [path stringByAppendingPathComponent:name];
            
            
            ImageSplitViewController *clipVC = [[ImageSplitViewController alloc] init];
            UIImage *image = [UIImage imageWithContentsOfFile:newPath];
            clipVC.srcImage = image;
            
            NSLog(@"image:[%f,%f]",clipVC.srcImage.size.width,clipVC.srcImage.size.height);
            clipVC.isFromInsert = YES;
            clipVC.delegate = self;
            [self.navigationController pushViewController:clipVC animated:YES];
            [clipVC release];
        }
        else
        {
            NSLog(@"there is some wrong about NSArray count!!!");
        }
    }
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    [Common setNavigationBarBackgroundBkg:self.navigationController.navigationBar];
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.contentArray = tempArray;
    [tempArray release];
    
    

    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (whichClassCallfrom == EClassInsert) 
    {
        leftButton.frame = CGRectMake(10, 7, 30, 30);    
        [leftButton setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    }
    if (whichClassCallfrom == EClassAicoMain) 
    {
        leftButton.frame = CGRectMake(0, 0, 60, 30);
        [leftButton setImage:[UIImage imageNamed:@"mainBar.png"] forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"mainBarBack.png"] forState:UIControlStateHighlighted];
    }
    
    [leftButton addTarget:self action:@selector(backToAico:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItem release];
}

/**
 * @brief  从Aico相册返回上层页面的操作
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)backToAico:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.contentArray = nil;
    self.backScrollView  = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    self.contentArray = nil;
    self.backScrollView  = nil;
    [super dealloc];
}


@end
