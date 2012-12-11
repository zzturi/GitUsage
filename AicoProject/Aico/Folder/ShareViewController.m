//
//  ShareViewController.m
//  Aico
//
//  Created by Wang Dean on 12-4-6.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ShareViewController.h"
#import "MainViewController.h"
#import "ReUnManager.h"
#import "StorageViewController.h"
#import "ExportMainViewController.h"

@implementation ShareViewController
@synthesize backScrollView = backScrollView_;
@synthesize showImageView =showImageView_;
@synthesize imagePath = imagePath_;
@synthesize biggerButton = biggerButton_;
@synthesize smallButton = smallButton_;
@synthesize rate;
@synthesize index;
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
    UIImage *image = nil;
    if (self.imagePath != nil)
    {
        image = [UIImage imageWithContentsOfFile:self.imagePath];
        if (image != nil)
        {
            self.showImageView.image = image;
        }
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    rate = 1.0f;
    if (index != 0)
    {
        self.title = [NSString stringWithFormat:@"照片 %d", index];
    }
    self.showImageView.userInteractionEnabled = YES;
    UIImage *image = nil;
    if (self.imagePath != nil)
    {
        image = [UIImage imageWithContentsOfFile:self.imagePath];
        if (image != nil)
        {
            self.showImageView.image = image;
        }
    }
    CGSize imageSize = image.size;
    CGSize compareSize = self.backScrollView.frame.size;
    //这段后期需要优化
    if (imageSize.width <= compareSize.width && imageSize.height <= compareSize.height) 
    {
        self.showImageView.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
        self.showImageView.center = self.backScrollView.center;
    }
    else if (imageSize.width > compareSize.width && imageSize.height <= compareSize.height)//长图片
    {
        //self.showImageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        self.showImageView.bounds = CGRectMake(0, 0, 320, 320/imageSize.width*imageSize.height);
        self.showImageView.center = self.backScrollView.center;
    }
    else if (imageSize.width <= compareSize.width && imageSize.height > compareSize.height)//树形图片
    {
        //self.showImageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        self.showImageView.bounds = CGRectMake(0, 0, 381/imageSize.height*imageSize.width, 381);
        self.showImageView.center = self.backScrollView.center;
    }
    else//大于显示位置的图片
    {
        float comparefloat = 320.0f/381.0f;
        if ((float)(imageSize.width/imageSize.height) > comparefloat) //长图片
        {
            self.showImageView.bounds = CGRectMake(0, 0, 320, 320/imageSize.width*imageSize.height);
        }
        else//数图片
        {
            self.showImageView.bounds = CGRectMake(0, 0, 381/imageSize.height*imageSize.width, 381);
        }
        self.showImageView.center = self.backScrollView.center;
    }
    
    self.backScrollView.contentSize = self.showImageView.bounds.size;
    [self resetFrame];
    
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(import:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    [rightBarButton release];
    
    UIPinchGestureRecognizer *gestureRecognizer = [[UIPinchGestureRecognizer alloc] init];
    [gestureRecognizer addTarget:self action:@selector(scale:)];
    [self.showImageView addGestureRecognizer:gestureRecognizer];
    [gestureRecognizer release];
    
    self.navigationItem.backBarButtonItem.title = @"天天相册";
}

- (void)scale:(UIPinchGestureRecognizer *)sender
{
    self.biggerButton.enabled = YES; 
    self.smallButton.enabled = YES; 
    if ([sender state] == UIGestureRecognizerStateEnded) 
    {
        rate = 1.0f;
    }
    
    CGFloat scale = 1.0f - (rate - sender.scale);
    
    UIImage *image = [UIImage imageWithContentsOfFile:self.imagePath];
    CGSize size = image.size;
    CGRect rect = self.showImageView.bounds; 
    
    if (scale < 1.0f)
    {
        if ((rect.size.width + (scale - 1)* 120) < 120  || (rect.size.height + (scale - 1)* 120*(size.height/size.width)) < 120) 
        {
            self.smallButton.enabled = NO; 
            self.showImageView.bounds = CGRectMake(0, 0, 120, 120*(size.height/size.width));
            self.backScrollView.contentSize = self.showImageView.bounds.size;
            self.showImageView.center = self.backScrollView.center;
            [self resetFrame];
            return;
        }
    }
    else
    {
        if (rect.size.width > size.width*2  || rect.size.height > size.height*2 )
        {
            self.biggerButton.enabled = NO; 
            return;
        }
    }

    self.showImageView.bounds = CGRectMake(0, 0, rect.size.width + (scale - 1)* 120, rect.size.height + (scale - 1)* 120*(size.height/size.width));
    self.backScrollView.contentSize = self.showImageView.bounds.size;
    self.showImageView.center = self.backScrollView.center;
    [self resetFrame];
}


- (void)import:(id)sender
{
    UIImage *image = [UIImage imageWithContentsOfFile:self.imagePath];
    ExportMainViewController *exportMainViewController = [[ExportMainViewController alloc] init];
    exportMainViewController.storeImage = image;
    [self.navigationController pushViewController:exportMainViewController animated:YES];
    [exportMainViewController release];
//    StorageViewController *storageViewController = [[StorageViewController alloc] init];
//    storageViewController.storeImage = image;
//    [self.navigationController pushViewController:storageViewController animated:YES];
//    [storageViewController release];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark Custom method
/**
 * @brief  删除显示的图片
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (IBAction)deleteImage:(id)sender
{
    NSArray *names = [self.imagePath componentsSeparatedByString:@"/"];
    NSString *nameString = [names lastObject];
    if (nameString != nil && [nameString isEqualToString:@"First.png"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:kCannotDeleteDefaultImage delegate:self cancelButtonTitle:kOK otherButtonTitles: nil];
        [alertView show];
        [alertView release];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:kImageDeleteMessage delegate:self cancelButtonTitle:kCancel otherButtonTitles:kOK, nil];
        [alertView show];
        [alertView release];
    }

}

/**
 * @brief  导出图片
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (IBAction)importImage:(id)sender
{
    UIImage *image = [UIImage imageWithContentsOfFile:self.imagePath];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [Common showToastView:@"图片已经保存到手机相册" hiddenInTime:2.0f];
    //need a tip
}

/**
 * @brief  美化图片
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (IBAction)paintImage:(id)sender
{
    UIImage *image = [UIImage imageWithContentsOfFile:self.imagePath];
    MainViewController *mainViewController = [[MainViewController alloc] init];
    mainViewController.srcImage = image;
    mainViewController.fatherController = 1;
    //[Common setGlobalSrcImage:image];
    ReUnManager *ru = [ReUnManager sharedReUnManager];
    [ru clearStorage];
    NSArray *names = [self.imagePath componentsSeparatedByString:@"/"];
    NSString *nameString = [names lastObject];
    ru.currentImageName = nameString;
    if (![ru storeImage:image])
    {
        NSLog(@"critical error cannot storeImage %d", __LINE__);
    }
    
    [self.navigationController pushViewController:mainViewController animated:YES];
    [mainViewController release];
}

/**
 * @brief  放大图片
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (IBAction)biggerImage:(id)sender
{
    UIImage *image = [UIImage imageWithContentsOfFile:self.imagePath];
    CGSize size = image.size;
    CGRect rect = self.showImageView.bounds; 
    
    if (rect.size.width > size.width*2  || rect.size.height > size.height*2 )
    {
        self.biggerButton.enabled = NO;            //add by wangcuicui
        return;
    }
    else
    {
         self.smallButton.enabled = YES;
    }
    self.showImageView.bounds =CGRectMake(rect.origin.x, rect.origin.y, rect.size.width + 20, rect.size.height + 20*(size.height/size.width));
    
    self.backScrollView.contentSize = self.showImageView.frame.size;
    [self resetFrame];

}

/**
 * @brief  缩小图片
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (IBAction)smallImage:(id)sender
{
    UIImage *image = [UIImage imageWithContentsOfFile:self.imagePath];
    CGSize size = image.size;
    CGRect rect = self.showImageView.bounds; 
    if ((rect.size.width - 20) < 80  || (rect.size.height - 20) < 80) 
    {
        self.smallButton.enabled = NO;                //add  by wangcuicui
        return;
    }
    else
    {
         self.biggerButton.enabled = YES;
    }

    self.showImageView.bounds =CGRectMake(rect.origin.x, rect.origin.y, rect.size.width - 20, rect.size.height - 20*(size.height/size.width));
    self.backScrollView.contentSize = self.showImageView.frame.size;
    [self resetFrame];
}

/**
 * @brief  调整图片显示位置
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)resetFrame 
{
    
    // center the image as it becomes smaller than the size of the screen
    
    CGSize boundsSize = self.backScrollView.bounds.size;//320,381
    CGRect frameToCenter = self.showImageView.frame;
    
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
    {
        frameToCenter.origin.x = 0;
        if ((frameToCenter.size.height < boundsSize.height)) 
        {
            self.backScrollView.contentOffset = CGPointMake((frameToCenter.size.width - 320)/2, 0);
        }
        else
        {
            self.backScrollView.contentOffset = CGPointMake((frameToCenter.size.width - 320)/2, (frameToCenter.size.height - 381)/2);
        }

    }
        //frameToCenter.origin.x = 0;
        
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
    {
        frameToCenter.origin.y = 0;
        if (frameToCenter.size.width < boundsSize.width)
        {
            self.backScrollView.contentOffset = CGPointMake(0, (frameToCenter.size.height - 381)/2);
        }
        else
        {
            self.backScrollView.contentOffset = CGPointMake((frameToCenter.size.width - 320)/2, (frameToCenter.size.height - 381)/2);
        }
        
    }
        //frameToCenter.origin.y = 0;
        
    self.showImageView.frame = frameToCenter;
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:self.imagePath]) 
        {
            NSError *error = nil;
            [fm removeItemAtPath:self.imagePath error:&error];
            if (error != nil)
            {
                NSLog(@"something wrong with remove image reason %@", [error localizedDescription]);
            }
        }
        
        //需要删除对应的icon，不然会导致crash
        NSArray *arrayName = [self.imagePath componentsSeparatedByString:@"/"];
        NSString *nameString = [arrayName lastObject];
        if (nameString != nil)
        {
            NSString *path = [NSString stringWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] ];
            path = [path stringByAppendingPathComponent:@"Icon"];
            NSString *iconPath = [path stringByAppendingPathComponent:nameString];
            if ([fm fileExistsAtPath:iconPath]) 
            {
                NSError *error = nil;
                [fm removeItemAtPath:iconPath error:&error];
                if (error != nil)
                {
                    NSLog(@"222something wrong with remove image reason %@", [error localizedDescription]);
                }
            }
        }
        
        //[self.navigationController popViewControllerAnimated:YES];
        NSString *path = [NSString stringWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] ];
        path = [path stringByAppendingPathComponent:@"Favorite"];
        NSError *err = nil;
        NSArray *tempArray = [fm contentsOfDirectoryAtPath:path error:&err];
        NSLog(@"%@", tempArray);
//        NSMutableArray *mulArray = [NSMutableArray arrayWithArray:tempArray];
//        NSUInteger indexArr = [mulArray indexOfObject:@"First.png"];
//        if (indexArr < [mulArray count])
//        {
//            [mulArray removeObject:@"First.png"];
//            [mulArray insertObject:@"First.png" atIndex:0];
//        }
        NSString *nextImagePath = nil;
        if ([tempArray count] == 0)
        {
            
        }
        else
        {
            if (index  == ([tempArray count] + 1))//用户选择的是最后一张图片
            {
                //nextImagePath = [path stringByAppendingPathComponent:@"First.png"];//删除后就显示第一张图片
                nextImagePath = [path stringByAppendingPathComponent:[tempArray objectAtIndex:0]];
                index = 1;
            }
            else
            {
                nextImagePath = [path stringByAppendingPathComponent:[tempArray objectAtIndex:(index - 1)]];
            }
        }
        

        self.imagePath = nextImagePath;
        
        UIImage *nextImage = [UIImage imageWithContentsOfFile:nextImagePath];
        if (nextImagePath != nil)
        {
            self.showImageView.image = nextImage;
            CGSize imageSize = nextImage.size;
            CGSize compareSize = self.backScrollView.frame.size;
            //这段后期需要优化
            if (imageSize.width <= compareSize.width && imageSize.height <= compareSize.height) 
            {
                self.showImageView.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
                self.showImageView.center = self.backScrollView.center;
            }
            else if (imageSize.width > compareSize.width && imageSize.height <= compareSize.height)//长图片
            {
                //self.showImageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
                self.showImageView.bounds = CGRectMake(0, 0, 320, 320/imageSize.width*imageSize.height);
                self.showImageView.center = self.backScrollView.center;
            }
            else if (imageSize.width <= compareSize.width && imageSize.height > compareSize.height)//树形图片
            {
                //self.showImageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
                self.showImageView.bounds = CGRectMake(0, 0, 381/imageSize.height*imageSize.width, 381);
                self.showImageView.center = self.backScrollView.center;
            }
            else//大于显示位置的图片
            {
                float comparefloat = 320.0f/381.0f;
                if ((float)(imageSize.width/imageSize.height) > comparefloat) //长图片
                {
                    self.showImageView.bounds = CGRectMake(0, 0, 320, 320/imageSize.width*imageSize.height);
                }
                else//数图片
                {
                    self.showImageView.bounds = CGRectMake(0, 0, 381/imageSize.height*imageSize.width, 381);
                }
                self.showImageView.center = self.backScrollView.center;
            }
            
            self.backScrollView.contentSize = self.showImageView.bounds.size;
            [self resetFrame];
            if (index != 0)
            {
                self.title = [NSString stringWithFormat:@"照片 %d", index];
            }
            
            //放大和缩小按钮需要重置
            self.smallButton.enabled = YES;
            self.biggerButton.enabled = YES;
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    //self.imagePath = nil;
    self.biggerButton = nil;
    self.smallButton = nil;
    self.backScrollView = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    self.imagePath = nil;
    self.biggerButton = nil;
    self.smallButton = nil;
    self.backScrollView = nil;
    self.imagePath = nil;
    [super dealloc];
}


@end
