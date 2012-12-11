//
//  FXLabel.h
//
//  Version 1.3.3
//
//  Created by Nick Lockwood on 20/08/2011.
//  Copyright 2011 Charcoal Design
//
//  Distributed under the permissive zlib license
//  Get the latest version from either of these locations:
//
//  http://charcoaldesign.co.uk/source/cocoa#fxlabel
//  https://github.com/nicklockwood/FXLabel
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

//
//  ARC Helper
//
//  Version 1.2.2
//
//  Created by Nick Lockwood on 05/01/2012.
//  Copyright 2012 Charcoal Design
//
//  Distributed under the permissive zlib license
//  Get the latest version from here:
//
//  https://gist.github.com/1563325
//

#ifndef AH_RETAIN
#if __has_feature(objc_arc)
#define AH_RETAIN(x) (x)
#define AH_RELEASE(x) (void)(x)
#define AH_AUTORELEASE(x) (x)
#define AH_SUPER_DEALLOC (void)(0)
#else
#define __AH_WEAK
#define AH_WEAK assign
#define AH_RETAIN(x) [(x) retain]
#define AH_RELEASE(x) [(x) release]
#define AH_AUTORELEASE(x) [(x) autorelease]
#define AH_SUPER_DEALLOC [super dealloc]
#endif
#endif

//  ARC Helper ends

#import <UIKit/UIKit.h>

enum ColorType
{
    ColorTypeFill               = 0x01,
    ColorTypeStroke             = 0x02,
    ColorTypeShadow             = 0x04,
    ColorTypeInnerShadow        = 0x08,
    ColorTypeGradientStart      = 0x10,
    ColorTypeGradientEnd        = 0x20,
    ColorTypeGradients          = 0x40,
};

@interface FXButton : UIButton

@property(nonatomic, assign) CGFloat shadowBlur;			// 阴影模糊系数
@property(nonatomic, assign) CGSize innerShadowOffset;		// 内阴影偏移位置
@property(nonatomic, retain) UIColor *innerShadowColor;		// 内阴影颜色
@property(nonatomic, retain) UIColor *gradientStartColor;	// 渐变色开始的颜色
@property(nonatomic, retain) UIColor *gradientEndColor;		// 渐变色终止的颜色
@property(nonatomic, copy)   NSArray *gradientColors;		// 指定所有色渐变色
@property(nonatomic, assign) CGPoint gradientStartPoint;	// 渐变色开始的位置
@property(nonatomic, assign) CGPoint gradientEndPoint;		// 渐变色结束额位置
@property(nonatomic, assign) NSUInteger oversampling;		// 采样数
@property(nonatomic, assign) UIEdgeInsets textInsets;		// 文本内边距
@property(nonatomic, assign) int colorType;					// 颜色类别

// 自己新添加的
@property(nonatomic, retain) UIColor *fillColor;			// 填充色
@property(nonatomic, retain) UIColor *strokeColor;			// 边框色

/**
 * @brief 用指定button的样式更新自己
 *
 * @param [in] button: 指定的button
 * @param [in] fontSize: 显示文字的字体大小
 * @param [out]
 * @return 
 * @note 
 */
- (void)updateFromButton:(FXButton *)button fontSize:(CGFloat)fontSize;

@end

