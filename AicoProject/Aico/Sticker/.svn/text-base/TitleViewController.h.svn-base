//
//  TitleViewController.h
//  Aico
//
//  Created by 勇 周 on 5/8/12.
//  Copyright (c) 2012 cienet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleEditViewController.h"
#import "StylePageControl.h"

@class FXButton;
@class IMPopoverController;
@class TitleEditViewController;

enum TitleOperateType
{
	TitleOperateTypeAdd,
	TitleOperateTypeEdit,
};

#define kTitlePreviewFontSize	50.0f					// 实时显示当前输入框内容效果的字体大小 

@interface TitleViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    FXButton                *btnStyleSelected_;          // 显示选中的字体样式
    UIImageView             *imageViewTextField_;        // textField的背景图片
    UITextField             *textFieldInput_;            // 输入标题的内容
    UIScrollView            *scrollViewStyles_;          // 放置所有字体效果的scrollview
    StylePageControl        *pageControl_;               // 实现翻页效果的pageControl
    NSMutableArray          *arrFontStyle_;              // 存放所有的字体特效
    
    NSMutableArray          *arrFontColorType_;          // 存放标题颜色的种类的标记
    NSMutableArray          *arrFontColorTypeName_;      // 存放标题颜色的种类的字符串名称
    NSMutableArray          *arrFontColor_;              // 存放标题的各种颜色的值
    
    IMPopoverController     *vcPopover_;                 // 弹出框
	
	UIView					*viewCurrentEdit_;			 // 当前正在编辑的标题视图
	TitleEditViewController *vcEdit_;					 // 父view controller
	int						operateType_;				 // 在此视图操作的类型 0：add 1：edit
}

@property (nonatomic, retain) FXButton* btnStyleSelected;
@property (nonatomic, retain) UIImageView *imageViewTextField;
@property (nonatomic, retain) UITextField *textFieldInput;
@property (nonatomic, retain) UIScrollView *scrollViewStyles;
@property (nonatomic, retain) StylePageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *arrFontStyle;
@property (nonatomic, assign) UIView *viewCurrentEdit;
@property (nonatomic) int operateType;

/**
 * @brief 初始化本view controller
 *
 * @param [in] viewEdit: 需要被编辑的字体效果view
 * @param [in] vc: 本view controller的父view controller
 * @param [in] type: 编辑的类型 编辑 还是 删除
 * @param [out]
 * @return 
 * @note 
 */
- (id)initWithEditView:(UIView *)viewEdit parentViewController:(TitleEditViewController *)vc operateType:(int)type;

/**
 * @brief 初始化所有字体效果的button
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)initStyleButtons;

/**
 * @brief 初始化导航栏上的button
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)initNavigatinBarButtons;

/**
 * @brief 切换到指定页面
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (IBAction)changePage:(id)sender;

/**
 * @brief 点击导航栏上的cancel按钮
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)cancelButtonPressed;

/**
 * @brief 点击导航栏上的confirm按钮
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)confirmButtonPressed;

/**
 * @brief 点击显示当前选中的字体按钮
 *
 * @param [in] sender: 被点击的按钮
 * @param [out]
 * @return 
 * @note 
 */
- (IBAction)styleSelectButtonPressed:(id)sender;

/**
 * @brief 文本框完成编辑，即按下enter键位
 *
 * @param [in] textField: 当前获得焦点的textfield
 * @param [out]
 * @return 
 * @note 
 */
- (void)textFieldDoneEdit:(UITextField *)textField;

/**
 * @brief 文本框的内容正在发生变化
 *
 * @param [in] textField: 当前获得焦点的textfield
 * @param [out]
 * @return 
 * @note 
 */
- (void)textFieldEditChanged:(UITextField *)textField;

/**
 * @brief 点击标题效果列表上的某一个标题
 *
 * @param [in] sender: 选中的标题
 * @param [out]
 * @return 
 * @note 
 */
- (IBAction)buttonTouchUpInside:(id)sender;

/**
 * @brief 根据颜色种类获取颜色种类的名称
 *
 * @param [in] type: 颜色种类
 * @param [out]
 * @return 
 * @note 
 */
- (void)getColorTypeStringArrayByColorType:(int)type;

/**
 * @brief 释放本视图的资源
 *
 * @param [in] 
 * @param [out]
 * @return 
 * @note 
 */
- (void)releaseObjects;

/**
 * @brief 根据指定类型颜色更新字体样式按钮
 *
 * @param [in] type: 颜色的类型
 * @param [in] color: 颜色
 * @param [out]
 * @return 
 * @note 
 */
- (void)updateStyleButtonWithType:(int)type color:(UIColor *)color;

@end
