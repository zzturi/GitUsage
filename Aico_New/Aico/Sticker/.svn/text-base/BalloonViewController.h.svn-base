//
//  BalloonViewController.h
//  Aico
//
//  Created by Mike on 12-5-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WordBalloonViewController;

@interface BalloonViewController : UIViewController<UITextFieldDelegate>
{
    UIImage *sourcePicture_;                            //要处理的源图片
    UIImageView *currentImageView_;                     //显示的图片
    UIButton *cancelBtn_;                               //左上角取消按钮
    UIButton *confirmBtn_;                              //右上角确定按钮
    UIScrollView *scrollView_;                          //暂时上面只有12种泡泡，占一页，以后多了方便扩展
    UITextField *textField_;                            //页面上文本输入框
    UILabel *label_;                                    //泡泡上显示文字的label
    UIImageView *textFieldBgImageView_;                 //textfield所在的view
    UIImageView *balloonImageView_;                     //上方显示的泡泡
    NSString *wordBalloonName_;                         //保存选中的泡泡图片的名字:xxxx.png
    int balloonStyle_;                                  //泡泡样式：0-11
    CGRect labelFrame_;                                 //没用,留着
    BOOL isNewBalloon_;                                 //判断是否是新创建的泡泡（还是已存在的泡泡）
    WordBalloonViewController *wordBalloonVC_;          //泡泡预览页面
    BOOL isFromStickerList_;                            //判断是否从sticker列表进入本页面
    
    int size[40]; //这么多字体，从大到小挨个尝试
    int fontHeight[12];
    int fontWidth[12];
    UIFont *labelFont_;
    NSUInteger stringLength_;//记住label中string的长度
    int fontNumber_;//font所在数组size中的位置
    BOOL increase_;
    float fontSize_;
    
    BOOL textHasChanged_;
}
@property(nonatomic,copy)UIImage *sourcePicture;
@property(nonatomic,retain)UIImageView *currentImageView;
@property(nonatomic,retain)UIButton *cancelBtn;
@property(nonatomic,retain)UIButton *confirmBtn;
@property(nonatomic,retain)UIScrollView *scrollView;
@property(nonatomic,retain)UITextField *textField;
@property(nonatomic,retain)UILabel *label;
@property(nonatomic,retain)UIImageView *textFieldBgImageView;
@property(nonatomic,retain)UIImageView *balloonImageView;
@property(nonatomic,copy)NSString *wordBalloonName;
@property(assign)int balloonStyle;
@property(nonatomic,assign)CGRect labelFrame;
@property(nonatomic,assign)BOOL isNewBalloon;
@property(nonatomic,retain)WordBalloonViewController *wordBalloonVC;
@property(nonatomic,assign)BOOL isFromStickerList;
@property(nonatomic,retain)UIFont *labelFont;
@property(assign)float fontSize;
@end
