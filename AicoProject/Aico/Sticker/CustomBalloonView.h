//
//  CustomBalloonView.h
//  Aico
//
//  Created by Mike on 12-5-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomBalloonView : UIView<UITextViewDelegate>
{
    UIImageView *firstLine_;                //边框线,弃用，改设layer边框
    UIImageView *secondLine_;
    UIImageView *thirdLine_;
    UIImageView *fourthLine_;
    UIButton *deleteButton_;                //删除文字泡泡,如今用不着了，暂时留着用于校准旋转按钮的位置
    UIImageView *rotateButtonView_;         //放缩旋转文字泡泡,也已弃用
    UILabel *label_;                        //泡泡中显示的文字
    UIImageView *balloonImageView_;         //泡泡
    int balloonStyle_;                      //泡泡样式：0-11(暂时只有12种供选择)
    CALayer *sublayer_;                     //这个layer的作用是提供气泡的边框
}
@property(nonatomic,retain)UIImageView *firstLine;
@property(nonatomic,retain)UIImageView *secondLine;
@property(nonatomic,retain)UIImageView *thirdLine;
@property(nonatomic,retain)UIImageView *fourthLine;
@property(nonatomic,retain)UIButton *deleteButton;
@property(nonatomic,retain)UIImageView *rotateButtonView;
@property(nonatomic,retain)UILabel *label;
@property(nonatomic,retain)UIImageView *balloonImageView;
@property(assign)int balloonStyle;
@property(nonatomic,retain)CALayer *sublayer;
/**
 * @brief  删除文字泡泡
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (void)deleteBalloon;
@end
