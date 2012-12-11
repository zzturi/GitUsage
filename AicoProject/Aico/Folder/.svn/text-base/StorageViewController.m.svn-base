//
//  StorageViewController.m
//  Aico
//
//  Created by Wang Dean on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StorageViewController.h"
#import "UIColor+extend.h"
#import "ShareItemCell.h"
#import "ExportLoginWebViewController.h"
#import "ExportSinaLoginViewController.h"

// 选择分享的方式
typedef enum {
    SelectExportWBQQLogin,
    SelectExportWBSinaLogin,
    SelectExportKaiXinLogin
} SelectExportWBLogin;

@implementation StorageViewController
@synthesize tableView = tableView_;
@synthesize storageButton = storageButton_;
@synthesize tipLabel = tipLabel_;
@synthesize imageArray = imageArray_;
@synthesize nameArray = nameArray_;
@synthesize storeImage = storeImage_;
@synthesize cellBackImageView = cellBackImageView_;

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

#pragma mark - Custom method
- (IBAction)saveImage:(id)sender
{
    UIImageWriteToSavedPhotosAlbum(self.storeImage, nil, nil, nil);
    [Common showToastView:@"图片已经保存到手机相册" hiddenInTime:2.0f];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"保存与分享";
    
    //取消按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, -5, 30, 30)];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self 
                  action:@selector(cancelOperation) 
        forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelBarBtn;
    [cancelBtn release];
    [cancelBarBtn release];

    NSArray *tempImage = [[NSArray alloc] initWithObjects:@"shareGoogle.png",@"shareGoogle.png", @"shareGoogle.png", @"shareMail.png", @"shareFacebook.png", @"shareSkype.png", @"shareYahoo.png", @"shareTwitter.png", @"shareFlickr.png", nil];
    self.imageArray = tempImage;
    [tempImage release];
    NSArray *tempName = [[NSArray alloc] initWithObjects:@"腾讯微博", @"新浪微博", @"Gmail", @"AICO Mail", @"Facebook", @"Skype", @"Yahoo", @"Twitter", @"Flickr", nil];
    self.nameArray = tempName;
    
    self.tipLabel.textColor = [UIColor getColor:kCommonTipColor];
    [tempName release];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shareCellBack.png"]];
    self.cellBackImageView = tempImageView;
    [tempImageView release];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imageArray = nil;
    self.nameArray = nil;
    self.tableView = nil;
    self.storageButton = nil;
    self.tipLabel = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - TableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"RecordCellIdentifier";
    ShareItemCell *cell = (ShareItemCell*)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    int row = [indexPath row];
    
    if (nil == cell) 
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShareItemCell" owner:self options:nil];
		for (id oneObj in nib)
        {
			if ([oneObj isKindOfClass:[ShareItemCell class]]) 
            {
                cell = (ShareItemCell *)oneObj;
				break;
            }
		}
    }
    cell.imageView.image = [UIImage imageNamed:[self.imageArray objectAtIndex:row]];
    cell.detailLabel.text = [self.nameArray objectAtIndex:row];
    cell.selectedBackgroundView = self.cellBackImageView;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.detailLabel.highlightedTextColor = [UIColor getColor:@"ffffff"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = [indexPath row];
	ShareItemCell *cell = (ShareItemCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *strTitle = cell.detailLabel.text;
    // 根据每行的索引跳转到不同的分享界面
    switch (row) {
        case SelectExportWBQQLogin:
            {  
                ExportLoginWebViewController *exportLoginWebViewController = [[ExportLoginWebViewController alloc] init];
                exportLoginWebViewController.title = strTitle;
                [self.navigationController pushViewController:exportLoginWebViewController animated:YES];
                [exportLoginWebViewController release];
            }
            break;
        case SelectExportWBSinaLogin:
            {
                ExportSinaLoginViewController *exportSinaLoginViewController = [[ExportSinaLoginViewController alloc] init];
                exportSinaLoginViewController.title = strTitle;
                [self.navigationController pushViewController:exportSinaLoginViewController animated:YES];
                [exportSinaLoginViewController release];
            }
            break;
        default:
             [Common showToastView:@"此功能还在开发中，敬请期待" hiddenInTime:2.0f];
            break;
    }

//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.contentView addSubview:self.cellBackImageView];
    [cell.contentView sendSubviewToBack:self.cellBackImageView];
 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)dealloc {
    self.imageArray = nil;
    self.nameArray = nil;
    self.tableView = nil;
    self.storageButton = nil;
    self.tipLabel = nil;
    self.cellBackImageView = nil;
    [super dealloc];
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


@end
