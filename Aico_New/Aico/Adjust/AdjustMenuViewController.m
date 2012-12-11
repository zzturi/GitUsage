//
//  AdjustMenuViewController.m
//  Aico
//
//  Created by Wu RongTao on 12-3-28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdjustMenuViewController.h"
#import "AdjustRotateViewController.h"
#import "AdjustClipViewController.h"
#import "MainViewController.h"
#import "AdjustMosaicViewController.h"
#import "FixRedEyeViewController.h"
#import "AdjustInsertPictureViewController.h"
#import "ReUnManager.h"
#import "FolderViewController.h"
#import "GlobalDef.h"
#import "UIColor+extend.h"
#import "AdjustMenuCell.h"

@implementation AdjustMenuViewController
@synthesize pictureNameListArray = pictureNameListArray_;
@synthesize selectBgView = selectBgView_;
@synthesize deSelectBgView = deSelectBgView_;
@synthesize tableView = tableView_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.tableView = nil;
    self.pictureNameListArray = nil;
    self.selectBgView = nil;
    self.deSelectBgView = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    ReUnManager *rm = [ReUnManager sharedReUnManager];
    rm.snapImage = nil;
}

- (void)viewDidUnload
{
    self.tableView = nil;
    self.pictureNameListArray = nil;
    self.selectBgView = nil;
    self.deSelectBgView = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //黑色斜条纹背景图片
    UIImageView *backGroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    backGroundView.image = [UIImage imageNamed:@"bgImage.png"];
    [self.view addSubview:backGroundView];
    [backGroundView release];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    pictureNameListArray_ = [[NSArray alloc]initWithObjects:@"newCrop.png",@"newRotate.png",@"newMosaic.png",@"newInsertPicture.png",@"newRedEye.png", nil];
    
    UITableView *menuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 460) 
                                                          style:UITableViewStylePlain];
    [menuTable setBackgroundColor:[UIColor clearColor]];
    menuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    menuTable.dataSource = self;
    menuTable.delegate = self;
    self.tableView = menuTable;
    [self.view addSubview:self.tableView];
    [menuTable release];
    
    self.navigationItem.title = @"编辑";
    //添加返回按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, -5, 30, 30)];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self 
                  action:@selector(cancelOperation) 
        forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelBarBtn;
    [cancelBtn release];
    [cancelBarBtn release];
    
    //cell选中时的背景
    selectBgView_ = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"newBlueBar.png"]];
    //cell未选中时的背景
    deSelectBgView_ = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 65)];
    [self.deSelectBgView setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - public method
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

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    AdjustMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:
                            SimpleTableIdentifier];
    if (cell == nil)
    {  
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AdjustMenuCell" owner:self options:nil];
		for (id oneObj in nib)
		{
			if ([oneObj isKindOfClass:[AdjustMenuCell class]]) 
			{
                cell = (AdjustMenuCell *)oneObj;
            }
		}
    }
    NSArray *array = [NSArray arrayWithObjects:@"裁剪",@"旋转",@"马赛克",@"插入图片",@"去红眼",nil]; 
    cell.imageView.image = [UIImage imageNamed:[pictureNameListArray_ objectAtIndex:[indexPath row]]];
    cell.titleLabel.text = [array objectAtIndex:[indexPath row]];
    cell.titleLabel.textColor = [UIColor getColor:kEffectButtonDeselectStringColor];
    cell.titleLabel.font = [UIFont systemFontOfSize:16];
    //不能设none，否则设selectedBackgroundView就会没有效果
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectedBackgroundView = self.selectBgView;
    cell.titleLabel.highlightedTextColor = [UIColor whiteColor];
    return cell;
    
    
}
#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath row])
    {
        case 0:
        {
            ImageSplitViewController *adjustVC = [[ImageSplitViewController alloc] init];
            adjustVC.delegate = self;
            adjustVC.isFromInsert = NO;
            ReUnManager *rm = [ReUnManager sharedReUnManager];
            adjustVC.srcImage = [rm getGlobalSrcImage];
            [self.navigationController pushViewController:adjustVC animated:YES];
            [adjustVC release];
            break;
        }
        case 1:
        {
            AdjustRotateViewController *rotateVC = [[AdjustRotateViewController alloc] init];
            [self.navigationController pushViewController:rotateVC animated:YES];
            [rotateVC release];
            break;
        }
        case 2:
        {
            AdjustMosaicViewController *mosaicVC = [[AdjustMosaicViewController alloc] init];
            [self.navigationController pushViewController:mosaicVC animated:YES];
            [mosaicVC release];
            break;
        }    
        case 3:
        {
            UIActionSheet *actionMenu = [[UIActionSheet alloc] initWithTitle:@"" 
                                                                    delegate:self 
                                                           cancelButtonTitle:nil
                                                      destructiveButtonTitle:@"手机相册"
                                                           otherButtonTitles:@"天天相册",@"取消" ,nil];
            actionMenu.destructiveButtonIndex = 2;
            [actionMenu showInView:self.view];
            [actionMenu release];
            break;
        }
        case 4:
        {
            FixRedEyeViewController *fixRedEyeViewController = [[FixRedEyeViewController alloc]init];
            [self.navigationController pushViewController:fixRedEyeViewController animated:YES];
            [fixRedEyeViewController release];
            break;
        }
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setPicture:(UIImage *)curImage
{
    ReUnManager *rm = [ReUnManager sharedReUnManager];
    [rm storeImage:curImage];
    NSArray *viewController = self.navigationController.viewControllers;
    [self.navigationController popToViewController:(MainViewController *)[viewController objectAtIndex:([viewController count] - 3)] animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) 
    {
        case 0:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            [self presentModalViewController:picker animated:YES];
            [picker release];
        }
            break;
        case 1:
        {
            FolderViewController *folderViewController = [[FolderViewController alloc] init];
            folderViewController.whichClassCallfrom = EClassInsert;
            [self.navigationController pushViewController:folderViewController animated:YES];
            [folderViewController release];
            
        }
            break;
        default:
            break;
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    //压缩并处理图片
    UIImage *afterImg = [Common adjustedImagePathForImage:image];
    if (afterImg == nil)
    {
        afterImg = image;
    }
    ImageSplitViewController *clipVC = [[ImageSplitViewController alloc] init];
    clipVC.srcImage = afterImg;
    NSLog(@"afterImg:[%f,%f]",afterImg.size.width,afterImg.size.height);
    clipVC.isFromInsert = YES;
    clipVC.delegate = self;
    [self.navigationController pushViewController:clipVC animated:YES];
    [clipVC release];
    [picker dismissModalViewControllerAnimated:YES];
}
@end
