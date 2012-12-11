//
//  EffectCustomCell.h
//  Aico
//
//  Created by Jiang LiYin on 12-4-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EffectCustomCell : UITableViewCell
{
    UIImageView *imageView_;           //显示缩略图
    UILabel *titleLabel_;              //特效名称
    UIImageView *separatorLineImgView_;//分割线视图
}
@property(nonatomic,retain) IBOutlet UIImageView *imageView;
@property(nonatomic,retain) IBOutlet UILabel *titleLabel;
@property(nonatomic,retain) IBOutlet UIImageView *separatorLineImgView;
@end
