//
//  CustomBalloonView.m
//  Aico
//
//  Created by Mike on 12-5-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomBalloonView.h"
#import "UIKit/UIFont.h"
#import <QuartzCore/QuartzCore.h>

#define kBalloonWidth               140.0
#define kBalloonHeight              140.0

@implementation CustomBalloonView
@synthesize firstLine = firstLine_;
@synthesize secondLine = secondLine_;
@synthesize thirdLine = thirdLine_;
@synthesize fourthLine = fourthLine_;
@synthesize deleteButton = deleteButton_;
@synthesize rotateButtonView = rotateButtonView_;
@synthesize label = label_;
@synthesize balloonImageView = balloonImageView_;
@synthesize balloonStyle = balloonStyle_;
@synthesize sublayer = sublayer_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        
        //添加边界线
//        firstLine_ = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kBalloonWidth, 1)];
//        secondLine_ = [[UIImageView alloc]initWithFrame:CGRectMake(kBalloonWidth-1, 0, 1, kBalloonHeight)];
//        thirdLine_ = [[UIImageView alloc]initWithFrame:CGRectMake(0, kBalloonHeight-1, kBalloonWidth, 1)];
//        fourthLine_ = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, kBalloonHeight)];
//        [firstLine_ setBackgroundColor:[UIColor blackColor]];
//        [secondLine_ setBackgroundColor:[UIColor blackColor]];
//        [thirdLine_ setBackgroundColor:[UIColor blackColor]];
//        [fourthLine_ setBackgroundColor:[UIColor blackColor]];
        
//        [self addSubview:firstLine_];
//        [self addSubview:secondLine_];
//        [self addSubview:thirdLine_];
//        [self addSubview:fourthLine_];
        
        //不能写成sublayer_ = [CALayer layer];
        self.sublayer = [CALayer layer];
        self.sublayer.frame = self.bounds;
        self.sublayer.borderWidth = 1.0f;
        self.sublayer.borderColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:sublayer_];
        
        //文字泡泡上的删除按钮
        deleteButton_ = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"cancel.png"] 
                                     forState:UIControlStateNormal];
        [self.deleteButton addTarget:self 
                              action:@selector(deleteBalloon) 
                    forControlEvents:UIControlEventTouchUpInside];
        [self.deleteButton setHidden:YES];
        [self addSubview:self.deleteButton];
        
        //文字泡泡上的旋转缩放按钮
        rotateButtonView_ = [[UIImageView alloc]initWithFrame:CGRectMake(kBalloonWidth-15, kBalloonHeight-15, 30, 30)];
        self.rotateButtonView.image = [UIImage imageNamed:@"circle_big.png"];
        [self.rotateButtonView setUserInteractionEnabled:YES];
        [self addSubview:self.rotateButtonView];
        [self.rotateButtonView setHidden:YES];
        
        label_ = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, kBalloonWidth - 20, kBalloonHeight - 40)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor blackColor];
        self.label.textAlignment = UITextAlignmentCenter;
        self.label.numberOfLines = 0;     
        self.label.lineBreakMode = UILineBreakModeCharacterWrap;   
        self.label.minimumFontSize = 2.0f;
        [self addSubview:self.label];
        balloonImageView_ = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 140, 140)];
        [self insertSubview:self.balloonImageView atIndex:0];
    }
    return self;
}

- (void)dealloc
{
//    self.firstLine = nil;
//    self.secondLine = nil;
//    self.thirdLine = nil;
//    self.fourthLine = nil;
    self.deleteButton = nil;
    self.rotateButtonView = nil;
    self.label = nil;
    self.balloonImageView = nil;
    self.sublayer = nil;
    
    [super dealloc];
}

#pragma mark - 
/**
 * @brief  删除文字泡泡
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (void)deleteBalloon
{
    [self removeFromSuperview];
}

@end
