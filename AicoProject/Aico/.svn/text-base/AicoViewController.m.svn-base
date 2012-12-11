//
//  AicoViewController.m
//  Aico
//
//  Created by petsatan on 12-3-27.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "AicoViewController.h"
#import "MainViewController.h"
#import "FolderViewController.h"
#import "Common.h"
#import "ReUnManager.h"
#import "UIImage+extend.h"

@implementation AicoViewController
@synthesize exampleButton = exampleButton_;

- (void)dealloc
{
    self.exampleButton = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
	NSString *OrPath = [NSString stringWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] ];
	NSString *lastImagePath = [OrPath stringByAppendingPathComponent:@"LastImage"];
	NSString *imagePath = [lastImagePath stringByAppendingPathComponent:@"lastImage.png"];
	UIImage *exampleImage = [UIImage imageWithContentsOfFile:imagePath];
    if (exampleImage == nil)
    {
        [self.exampleButton setImage:[Common createRoundedRectImage:[UIImage imageNamed:@"ExampleDefault.png"] size:CGSizeMake(45, 45)] forState:UIControlStateNormal];
    }
    else
    {
        [self.exampleButton setImage:[Common createRoundedRectImage:exampleImage size:CGSizeMake(45, 45)] forState:UIControlStateNormal];
    }

    ReUnManager *rm =[ReUnManager sharedReUnManager];
    [rm clearStorage];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;   
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    self.exampleButton = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Custom View
/**
 * @brief  点击相册响应方法
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note IB调用
 */
- (IBAction)getPictureFromAlbum:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

/**
 * @brief  点击历史图片响应方法
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note IB调用
 */
- (IBAction)getPictureFromCamera:(id)sender
{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }
    
}

/**
 * @brief  点击Aico相册响应方法
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note IB调用
 */
- (IBAction)aicoFolderClick:(id)sender
{
    FolderViewController *folderViewController = [[FolderViewController alloc] init];
    folderViewController.whichClassCallfrom = EClassAicoMain;
    [self.navigationController pushViewController:folderViewController animated:YES];
    [folderViewController release];
}

/**
 * @brief  点击相机响应方法
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note IB调用
 */
- (IBAction)exampleImageClick:(id)sender
{
    NSString *OrPath = [NSString stringWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] ];
	NSString *lastImagePath = [OrPath stringByAppendingPathComponent:@"LastImage"];
	NSString *imagePath = [lastImagePath stringByAppendingPathComponent:@"lastImage.png"];
	UIImage *lastImage = [UIImage imageWithContentsOfFile:imagePath];
    if (lastImage == nil)
    {
        [Common showToastView:@"请美化图片或者先拍张照片" hiddenInTime:2.0f];
    }
    else
    {
        MainViewController *mainViewController = [[MainViewController alloc] init];
        mainViewController.srcImage = lastImage;
        ReUnManager *ru = [ReUnManager sharedReUnManager];
        if (![ru storeImage:lastImage])
        {
            NSLog(@"critical error cannot storeImage %d", __LINE__);
        }
        //[Common setGlobalSrcImage:lastImage];
        [self.navigationController pushViewController:mainViewController animated:YES];
        [mainViewController release];
    }
}

#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
//    ReUnManager *rm =[ReUnManager sharedReUnManager];
//    [rm clearStorage];
//    
    MainViewController *mainViewController = [[MainViewController alloc] init];
    
//    [Common setGlobalSrcImage:image];
    //压缩并处理图片
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
    mainViewController.srcImage = afterImg;
    [self.navigationController pushViewController:mainViewController animated:YES];
    [mainViewController release];
    [picker dismissModalViewControllerAnimated:YES];
}
@end
