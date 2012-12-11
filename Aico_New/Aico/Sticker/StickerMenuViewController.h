//
//  StickerMenuViewController.h
//  Aico
//
//  Created by Yincheng on 12-5-7.
//  Copyright (c) 2012年 x. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StickerMenuViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>
{
    UITableView *tableView_;        //装饰列表
    UIImageView *selectBgView_;     //列表cell选中时显示背景
    NSArray     *tableList_;        //存放列表数组
    BOOL        isStickerReplace_;  //是否是进行替换装饰push过来
    NSArray     *StickerImageArray_;//用于装饰列表缩略图
    NSMutableArray     *stickerInfoArray_; //列表信息，由字典组成，每个字典包括contentCode,contentName,iconLocalPath,iconUrl，resourceZipPath ,count
    
}
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) UIImageView *selectBgView;
@property(nonatomic,assign) BOOL isStickerReplace;
@property(nonatomic,retain) NSMutableArray *stickerInfoArray;
@end
