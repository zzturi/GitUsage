//
//  AicoViewController.h
//  Aico
//
//  Created by petsatan on 12-3-27.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AicoViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate> 
{
    UIButton *exampleButton_; //历史图片按钮
}
@property(nonatomic,retain) IBOutlet UIButton *exampleButton;

/**
 * @brief  点击相册响应方法
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note IB调用
 */
- (IBAction)getPictureFromAlbum:(id)sender;

/**
 * @brief  点击历史图片响应方法
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note IB调用
 */
- (IBAction)exampleImageClick:(id)sender;

/**
 * @brief  点击Aico相册响应方法
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note IB调用
 */
- (IBAction)aicoFolderClick:(id)sender;

/**
 * @brief  点击相机响应方法
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note IB调用
 */
- (IBAction)getPictureFromCamera:(id)sender;
@end
