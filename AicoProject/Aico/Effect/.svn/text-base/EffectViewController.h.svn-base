//
//  EffectViewController.h
//  Aico
//
//  Created by wang cuicui on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum EEfectSectionID 
{		
//    EEffectFirstSection,		
//    EEffectDistortSection,		
    EEffectColorAdjustSection,		
//    EEffectArtisticSection,		
    EEffectPhotoEffectsSection,		
    EEffectFilterFramesSection,		
    EEffectDistortSection,		
//    EEffectMiscSection		
};

@interface EffectViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSDictionary   *effectNameDic_;    //存放各种效果的名称
    NSArray        *effectKeys_;       //字典的key值
    NSArray        *titleForTableView_;//分组表的Title
    UIImage        *smallImage_;       //列表缩略图小图
    NSMutableDictionary        *smallImgByEffectedDic_;//处理后的小图字典
    UITableView    *effectTableView_;  //列表
    UIImageView    *cellSelectedBkgView_;//被选中cell的背景视图
}
@property (nonatomic, retain) NSDictionary *effectNameDic;
@property (nonatomic, retain) NSArray      *effectKeys;
@property (nonatomic, retain) NSArray      *titleForTableView;
@property (nonatomic, retain) UIImage      *smallImage;
@property (nonatomic, retain) NSMutableDictionary *smallImgByEffectedDic;
@property (nonatomic, retain) IBOutlet UITableView *effectTableView;

/**
 * @brief  给列表添加缩略图添加特效 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)effectSmallImage;
@end	