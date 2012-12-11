//
//  ShareViewController.h
//  Aico
//
//  Created by Wang Dean on 12-4-6.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShareViewController : UIViewController 
<UIAlertViewDelegate>
{
    UIScrollView *backScrollView_;   //背景滑动
    UIImageView *showImageView_;     //图片展示
    NSString *imagePath_;            //图片绝对地址
    UIButton *biggerButton_;         //add by wangcuicui
    UIButton *smallButton_;          //add bu wangcuicui
    float rate;                      //缩放倍数
    int index;                       //图片目录
}
@property(nonatomic,retain) IBOutlet UIScrollView *backScrollView;
@property(nonatomic,retain) IBOutlet UIImageView *showImageView;
@property(nonatomic,copy) NSString *imagePath;
@property(nonatomic,assign) float rate;
@property(nonatomic,assign) int index;
@property(nonatomic,retain) IBOutlet UIButton *biggerButton;
@property(nonatomic,retain) IBOutlet UIButton *smallButton;

/**
 * @brief  删除显示的图片
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (IBAction)deleteImage:(id)sender;

/**
 * @brief  导出图片
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (IBAction)importImage:(id)sender;

/**
 * @brief  美化图片
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (IBAction)paintImage:(id)sender;

/**
 * @brief  放大图片
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (IBAction)biggerImage:(id)sender;

/**
 * @brief  缩小图片
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (IBAction)smallImage:(id)sender;

/**
 * @brief  调整图片显示位置
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)resetFrame;
@end
