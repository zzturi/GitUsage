//
//  IMPopoverController.h
//  DSM_iPad
//
//  Created by Wu Rongtao on 12-04-16.
//  Copyright 2012 cienet. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMPopoverDelegate <NSObject>
@optional
- (void)dismissPopView;

@end

@interface IMWindow : UIWindow
{
	id delegate_;
}

@property (nonatomic, assign) id delegate;

@end


@interface IMPopoverController : NSObject 
{
	UIViewController	*contentViewController_;    //弹出视图控制器
	IMWindow	*popOverWindow_;                    //弹出视图window
	CGSize	popOverSize_;                           //弹出视图大小
    id<IMPopoverDelegate> deletage_;                //弹出实现代理
}

@property(nonatomic) CGSize popOverSize;
@property(nonatomic, assign) id<IMPopoverDelegate> deletage;
@property(nonatomic,retain ) IMWindow *popOverWindow;

/**
 * @brief 初始化操作
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (id) initWithContentViewController:(UIViewController *) con;

/**
 * @brief 获取内容视图控制器
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (UIViewController *) contentViewController;

/**
 * @brief 设置内容视图控制器
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void) setContentViewController:(UIViewController *) newCon animated:(BOOL) animated;

/**
 * @brief 弹出视图
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void) presentPopoverFromRect:(CGRect) rect inView:(UIView *) inView animated:(BOOL) animated;

/**
 * @brief 隐藏视图
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void) dismissPopoverAnimated:(BOOL) animated;

@end
