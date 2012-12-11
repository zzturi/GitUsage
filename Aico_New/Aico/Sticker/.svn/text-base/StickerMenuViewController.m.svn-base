//
//  StickerMenuViewController.m
//  Aico
//
//  Created by YinCheng on 12-5-7.
//  Copyright (c) 2012年 x. All rights reserved.
//

#import "StickerMenuViewController.h"
#import "StickerMainCell.h"
#import "UIColor+extend.h"
#import "TitleViewController.h"
#import "MagicWandViewController.h"
#import "StickerHatsViewController.h"
#import "BalloonViewController.h"
#import "ReUnManager.h"
#import "NetworkDef.h"
#import "NetworkManager.h"
#import "ASIHTTPRequest.h"
#import "CJSONSerializer.h"
#import "Reachability.h"


@interface  StickerMenuViewController(privateMethods)
- (void)requestStickerList;
@end
@implementation StickerMenuViewController
@synthesize tableView = tableView_;
@synthesize selectBgView = selectBgView_;
//@synthesize deSelectBgView = deSelectBgView_;
@synthesize isStickerReplace = isStickerReplace_;
@synthesize stickerInfoArray = stickerInfoArray_;

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

/**
 * @brief 收到通知后回调 刷新列表 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)refreshStickerList:(NSNotification *)notification
{
    //列表图片
    if ([notification.object isKindOfClass:[NSArray class]])
    {
        NSArray *array = notification.object;
        [stickerInfoArray_ removeAllObjects];
        //下载列表完成发过来的通知
        for (NSDictionary *item in array) 
        {
            [stickerInfoArray_ addObject:item];
        }
        [tableView_ reloadData];
    }
    else if([notification.object isKindOfClass:[NSString class]])
    {
        //下载图标完成发过来的通知
        [tableView_ reloadData];
    }
}

/**
 * @brief 请求列表 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)requestStickerList
{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        [Common showToastView:@"无法更新装饰列表，未连接网络" hiddenInTime:2.0f];
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kStickerBaseUrl,kStickerListUrl];//todo
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.requestMethod = @"POST";
//    NSString *downloadPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"stickerList.xml"];
    
//    [request setDownloadDestinationPath:downloadPath];
    NSDictionary *postBodyDic = [NSDictionary dictionaryWithObjectsAndKeys:@"102",kContentType,@"700",kCategory, nil];
    NSString *postBodyStr = [[CJSONSerializer serializer] serializeDictionary:postBodyDic];
    NSData *postBody = [postBodyStr dataUsingEncoding:NSUTF8StringEncoding];
    request.postBody = (NSMutableData *)postBody;
    NSDictionary *dlInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:EStickerListId],kRequestId, nil];
    request.userInfo = dlInfo;
    [[NetworkManager sharedNetworkManager] issueHttpRequest:request];
}
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib..
    
    //黑色斜条纹背景图片
    UIImageView *backGroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    backGroundView.image = [UIImage imageNamed:@"bgImage.png"];
    [self.view addSubview:backGroundView];
    [backGroundView release];
    [self.view setBackgroundColor:[UIColor clearColor]];
        
    UITableView *menuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 436) 
                                                          style:UITableViewStylePlain];
    [menuTable setBackgroundColor:[UIColor clearColor]];
    menuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    menuTable.dataSource = self;
    menuTable.delegate = self;
    self.tableView = menuTable;
    [self.view addSubview:self.tableView];
    [menuTable release];
    
    self.navigationItem.title = isStickerReplace_?@"装饰替换":@"装饰";
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
    
    tableList_ = [[NSArray alloc] initWithObjects:@"泡泡",@"标题",@"魔法棒", nil]; 
    StickerImageArray_ = [[NSArray alloc] initWithObjects:@"wordBalloon.png",@"title.png",@"magic.png", nil];
    
    
    //装饰替换的时候，直接读取本地stickerList.xml，否则需要从服务器上重新请求
    if (!isStickerReplace_) 
    {
        [self requestStickerList];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshStickerList:) name:kRefreshStickerListNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
    self.selectBgView = nil;
    RELEASE_OBJECT(tableList_);
    RELEASE_OBJECT(StickerImageArray_);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.tableView = nil;
    self.selectBgView = nil;
    RELEASE_OBJECT(tableList_);
    RELEASE_OBJECT(StickerImageArray_);
    self.stickerInfoArray = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.stickerInfoArray = nil;
    //先从本地读
    NSString *listPath = [[[NSString alloc] initWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]] autorelease];
    NSFileManager *file_manager = [NSFileManager defaultManager];
    listPath = [listPath stringByAppendingPathComponent:@"stickerList.xml"];
    
    if ([file_manager fileExistsAtPath:listPath]) 
    {
        stickerInfoArray_ = [[NSMutableArray alloc] initWithContentsOfFile:listPath];
    }
    else 
    {
        stickerInfoArray_ = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)cancelOperation
{
    if (!isStickerReplace_) 
    {
        [[ReUnManager sharedReUnManager] clearAllStickers];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger ret = [self.stickerInfoArray count];
    return isStickerReplace_ ? ret : (ret + 3);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    StickerMainCell *cell = (StickerMainCell *)[tableView dequeueReusableCellWithIdentifier:
                            SimpleTableIdentifier];
    if (cell == nil)
    {  
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StickerMainCell" owner:self options:nil];
		for (id oneObj in nib)
		{
			if ([oneObj isKindOfClass:[StickerMainCell class]]) 
			{
                cell = (StickerMainCell *)oneObj;
            }
		}
    }
    
    NSString *title = nil;
    
    if (isStickerReplace_) //装饰替换列表
    {
        cell.imageView.image = [UIImage imageWithContentsOfFile:[[self.stickerInfoArray objectAtIndex:[indexPath row]] objectForKey:@"iconLocalPath"]];
        title = [[self.stickerInfoArray objectAtIndex:[indexPath row]] objectForKey:kContentName];
    }
    else //装饰列表
    {
        if ([indexPath row] >= 3)
        {
            cell.imageView.image = [UIImage imageWithContentsOfFile:[[self.stickerInfoArray objectAtIndex:[indexPath row] - 3] objectForKey:@"iconLocalPath"]];
            title = [[self.stickerInfoArray objectAtIndex:[indexPath row] - 3] objectForKey:kContentName];
        }
        else //标题 泡泡 魔法棒
        {
            cell.imageView.image = [UIImage imageNamed:[StickerImageArray_ objectAtIndex:[indexPath row]]];
            title = [tableList_ objectAtIndex:[indexPath row]];
        }
    }

    cell.titleLabel.text = title;
    cell.titleLabel.textColor = [UIColor getColor:kEffectButtonDeselectStringColor];
    cell.titleLabel.font = [UIFont systemFontOfSize:16];
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
    if (isStickerReplace_) 
    {
        StickerHatsViewController *stick = [[StickerHatsViewController alloc] init];
        stick.stringName = [[self.stickerInfoArray objectAtIndex:[indexPath row]] objectForKey:kContentName];
        stick.contentCode = [[self.stickerInfoArray objectAtIndex:[indexPath row]] objectForKey:kContentCode];
//        stick.imageNum = [[[self.stickerInfoArray objectAtIndex:[indexPath row]] objectForKey:kCountNum] intValue];
        stick.isNeedDownload = [[[self.stickerInfoArray objectAtIndex:[indexPath row]] objectForKey:kIsNeedDownload] boolValue];
        stick.isStickerReplace = isStickerReplace_;
        [self.navigationController pushViewController:stick animated:YES];
        [stick release];
    }
    else
    {
        switch ([indexPath row])
        {
            case 0:
            {
                BalloonViewController *balloonViewController = [[BalloonViewController alloc]init];
                [self.navigationController pushViewController:balloonViewController animated:YES];
                [balloonViewController release];
                break;
            }
            case 1:
            {
                TitleViewController* vc = [[TitleViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                [vc release];
                break;
            }
            case 2:
            {
                MagicWandViewController *magicWandViewCtrl = [[MagicWandViewController alloc] initWithNibName:@"MagicWandViewController" bundle:nil];
                magicWandViewCtrl.title = @"魔法棒";
                [self.navigationController pushViewController:magicWandViewCtrl animated:YES];
                [magicWandViewCtrl release];
                break;
            }
            default:
            {
                StickerHatsViewController *stick = [[StickerHatsViewController alloc] init];
                NSInteger index = [indexPath row] - 3;
                stick.stringName = [[self.stickerInfoArray objectAtIndex:index] objectForKey:kContentName];
//                stick.imageNum = [[[self.stickerInfoArray objectAtIndex:index] objectForKey:kCountNum] intValue];
                stick.isNeedDownload = [[[self.stickerInfoArray objectAtIndex:index] objectForKey:kIsNeedDownload] boolValue];
                stick.isStickerReplace = isStickerReplace_;
                stick.contentCode = [[self.stickerInfoArray objectAtIndex:index] objectForKey:kContentCode];
                [self.navigationController pushViewController:stick animated:YES];
                [stick release];
                break;
            }
                break;
        } 
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
