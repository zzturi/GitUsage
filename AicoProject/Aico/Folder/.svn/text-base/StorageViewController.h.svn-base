//
//  StorageViewController.h
//  Aico
//
//  Created by Wang Dean on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StorageViewController : UIViewController
{
    UITableView *tableView_;          //微博列表
    UIButton *storageButton_;         //分享按钮
    UILabel *tipLabel_;               //分享到提示
    NSArray *imageArray_;             //微博图标名字数组
    NSArray *nameArray_;              //微博名字数组
    UIImage *storeImage_;             //编辑区图片
    UIImageView *cellBackImageView_;  //cell背景
}
@property(nonatomic,retain) IBOutlet UITableView *tableView;
@property(nonatomic,retain) IBOutlet UIButton *storageButton;
@property(nonatomic,retain) IBOutlet UILabel *tipLabel;
@property(nonatomic,retain) NSArray *imageArray;
@property(nonatomic,retain) NSArray *nameArray;
@property(nonatomic,retain) UIImage *storeImage;
@property(nonatomic,retain) UIImageView *cellBackImageView;

/**
 * @brief  保存图片操作
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note IB调用
 */
- (IBAction)saveImage:(id)sender;
@end
