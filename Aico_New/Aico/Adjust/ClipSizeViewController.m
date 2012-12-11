//
//  ClipSizeViewController.m
//  Aico
//
//  Created by Wu RongTao on 12-4-1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ClipSizeViewController.h"

#define kSizeArray [NSArray arrayWithObjects:@"1:1",@"2:3",@"3:2",@"3:4",@"4:3",@"16:9",nil]
#define kMultipleOfSize 50
#define kDefalutSize CGSizeMake(120, 120)

@implementation ClipSizeViewController
@synthesize delegate = delegate_;
@synthesize sizeArray = sizeArray_;
@synthesize sizeIndex = sizeIndex_;
@synthesize maxSize = maxSize_;

/**
 * @brief 初始化操作
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sizeArray_ = [kSizeArray retain];
        sizeIndex_ = 2;
    }
    return self;
}

/**
 * @brief 析构操作
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)dealloc
{
    self.sizeArray = nil;
    [super dealloc];
}

/**
 * @brief 内存警告
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

/**
 * @brief 设置选择尺寸
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (CGSize)setViewSizeFromProportion:(NSInteger)index
{
    CGFloat sizeWidth = self.maxSize.width;
    CGFloat sizeHeight = self.maxSize.height;
    CGFloat minSize = sizeWidth > sizeHeight ? sizeHeight : sizeWidth;
    CGSize newSize;
    switch (index)
    {
        case 0:
        {            
            // 1:1
            if (minSize > 120) 
            {
                newSize = kDefalutSize;           
            }
            else 
            {
                newSize = CGSizeMake(minSize, minSize);
            }
        }
            break;
        case 1:
        {
            // 2:3     
            CGFloat newHeight = sizeHeight > 120 ? 120 : sizeHeight;
            newSize = CGSizeMake(newHeight * 2/3, newHeight);
        }
            break;
        case 2:
        {
            if (sizeWidth/sizeHeight > 3/2)
            {
                CGFloat newHeight = sizeHeight > 120 ? 120 : sizeHeight;
                CGFloat newWidth = newHeight * 3/2 > 120 ? 120 : newHeight * 3/2;
                newSize = CGSizeMake(newWidth, newWidth * 2/3);                
            }
            else 
            {
                CGFloat newwidth = sizeWidth > 120 ? 120 : sizeWidth;
                newSize = CGSizeMake(newwidth, newwidth * 2/3);
            }
        }
            break;
        case 3:
        {
            CGFloat newHeight = sizeHeight > 120 ? 120 : sizeHeight;
            newSize = CGSizeMake(newHeight * 3/4, newHeight);
        }
            break;
        case 4:
        {
            if (sizeWidth/sizeHeight > 4/3)
            {
                CGFloat newHeight = sizeHeight > 120 ? 120 : sizeHeight;
                CGFloat newWidth = newHeight * 4/3 > 120 ? 120 : newHeight * 4/3;
                newSize = CGSizeMake(newWidth, newWidth * 3/4);
            }
            else 
            {
                CGFloat newwidth = sizeWidth > 120 ? 120 : sizeWidth;
                newSize = CGSizeMake(newwidth, newwidth * 3/4);
            }
        }
            break;
        case 5:
        {
            if (sizeWidth/sizeHeight > 16/9)
            {
                CGFloat newHeight = sizeHeight > 160 ? 160 : sizeHeight;
                CGFloat newWidth = newHeight * 16/9 > 160 ? 160 : newHeight * 16/9;
                newSize = CGSizeMake(newWidth, newWidth * 9/16);
            }
            else 
            {
                CGFloat newwidth = sizeWidth > 160 ? 160 : sizeWidth;
                newSize = CGSizeMake(newwidth, newwidth * 9/16);
            }
        }
            break;
            
        default:
            break;
    }
    return newSize;
}

/**
 * @brief 确认选择
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)confirmSelect:(id)sender
{
    //重置所有按钮选中状态
    for (int i = 0; i < 6; i++)
    {
        UIButton *allButton = (UIButton *)[self.view viewWithTag:i + 10000];
        [allButton setSelected:NO];
    }
    UIButton *freeSizeButton = (UIButton *)[self.view viewWithTag:30000];
    [freeSizeButton setSelected:NO]; 
    
    //设置按钮选中背景
    NSInteger index = [sender tag];
    UIButton *currentButton = (UIButton *)[self.view viewWithTag:index];   
    [currentButton setSelected:YES];    
    
    NSInteger arrayIndex = index - 10000;
    //设置裁减框大小
    CGSize indexSize = [self setViewSizeFromProportion:arrayIndex];
    sizeIndex_ = arrayIndex;
    [delegate_ getSelectSize:indexSize andSizeIndex:arrayIndex];
    [self dismissModalViewControllerAnimated:YES];
}

/**
 * @brief 选择自由比例
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)freeSizeSelect:(id)sender
{
    UIButton *freeSizeButton = (UIButton *)[self.view viewWithTag:30000];
    [freeSizeButton setSelected:YES]; 
    
    CGFloat sizeWidth = self.maxSize.width;
    CGFloat sizeHeight = self.maxSize.height;
    CGFloat minSize = sizeWidth > sizeHeight ? sizeHeight : sizeWidth;
    minSize = minSize > 120 ? 120 : minSize;
    [delegate_ getSelectSize:CGSizeMake(minSize, minSize) andSizeIndex: -1];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

/**
 * @brief 系统函数
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    //初始化选择裁减尺寸按钮
    if(!sizeArray_)
    {
        sizeArray_ = [kSizeArray retain]; 
    }
    
}

/**
 * @brief 系统函数
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)loadView
{
    [super loadView];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, 
                                                              self.view.frame.origin.y, 
                                                              160,                                                               
                                                              135)];
    //为选择框添加背景图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:bgView.bounds];
    imageView.image = [UIImage imageNamed:@"ImageClipPopBg.png"];
    [bgView insertSubview:imageView atIndex:0];
    [imageView release];
    
    for (int i = 0; i < [sizeArray_ count]; i++)
    {
        int rowNum = 3;
        UIButton *sizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sizeButton.frame = CGRectMake(
                                      (i%rowNum + 1) * 10 + i%rowNum * 40, 
                                      i/rowNum * 40 + ((i == 0 || i== 1 || i== 2) ? 5 : 2.5), 
                                      40, 
                                      30);
        [sizeButton setBackgroundImage:[UIImage imageNamed:@"ImageClipSizeSelected.png"] 
                              forState:UIControlStateSelected];
        
        sizeButton.tag = i + 10000;
        //设置默认选中按钮
        if (i == sizeIndex_)
        {
            [sizeButton setSelected:YES];
        }
        [sizeButton setTitle:[sizeArray_ objectAtIndex:i] forState:UIControlStateNormal];
        [sizeButton addTarget:self action:@selector(confirmSelect:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:sizeButton];
    }  
    
    UIButton *freeSizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    freeSizeButton.frame = CGRectMake(10, 85, 140, 30);
    freeSizeButton.tag = 30000;
    [freeSizeButton setTitle:@"任意比例" forState:UIControlStateNormal];
    [freeSizeButton setBackgroundImage:[UIImage imageNamed:@"roundBlueButton"] 
                          forState:UIControlStateSelected];
    if (sizeIndex_ == -1)
    {
        [freeSizeButton setSelected:YES];
    }
    [freeSizeButton addTarget:self action:@selector(freeSizeSelect:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:freeSizeButton];
     self.view = bgView;    
    [bgView release];
    
    
}

/**
 * @brief 系统函数
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)viewDidUnload
{
    [super viewDidUnload];
    [sizeArray_ release],sizeArray_ = nil;
}

/** 
 * @brief 系统函数 屏幕旋转
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
