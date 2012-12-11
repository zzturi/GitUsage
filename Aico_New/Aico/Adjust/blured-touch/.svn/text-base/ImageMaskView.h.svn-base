//
// Scratch and See 
//
// The project provides en effect when the user swipes the finger over one texture 
// and by swiping reveals the texture underneath it. The effect can be applied for 
// scratch-card action or wiping a misted glass.
//
// Copyright (C) 2012 http://moqod.com Andrew Kopanev <andrew@moqod.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal 
// in the Software without restriction, including without limitation the rights 
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
// of the Software, and to permit persons to whom the Software is furnished to do so, 
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all 
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
// PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
// FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
// DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import "TouchesData.h"

@class ImageMaskView;
@protocol ImageMaskFilledDelegate
- (void)imageMaskView:(ImageMaskView *)maskView cleatPercentWasChanged:(float)clearPercent;
@end

@interface ImageMaskView : UIImageView
{
	int tilesX;
	int tilesY;
    
    CGPoint firstPoint;
    CGFloat radius ;
    BOOL   type ;
    
    NSMutableArray *touchesArray_;
    TouchesData *touchesData_;
    UIImage *srcImage_;
}

@property (nonatomic, readonly) CGFloat procentsOfImageMasked;
@property (nonatomic, assign) id<ImageMaskFilledDelegate> imageMaskFilledDelegate;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) BOOL type;
@property (nonatomic, retain) TouchesData *touchesData;
@property (nonatomic, copy) UIImage *srcImage;

/**
 * @brief 初始化 
 * @param [in] frame image
 * @param [out]
 * @return
 * @note 
 */
- (id)initWithFrame:(CGRect)frame image:(UIImage *)img;

/**
 * @brief 执行undo(撤销)操作
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)undo;

/**
 * @brief 执行redo(恢复)操作
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)redo;

/**
 * @brief 当前能否进行撤销操作
 * @param [in]
 * @param [out] YES:可以撤销 NO:不能撤销
 * @return
 * @note 
 */
- (BOOL)canUndo;

/**
 * @brief 当前能否进行恢复操作
 * @param [in]
 * @param [out] YES:可以恢复 NO:不能恢复
 * @return
 * @note 
 */
- (BOOL)canRedo;

/**
 * @brief 根据操作数据，进行绘制操作
 * @param [in] TouchesData:图片绘制需要的数据信息
 * @param [out]
 * @return
 * @note 
 */
- (void)drawOperation:(TouchesData *)data;

/**
 * @brief 撤销恢复操作管理
 * @param [in] managerType:YES/撤销 NO/恢复
 * @param [out] 返回操作后的图片
 * @return
 * @note 
 */
- (UIImage *)undoManagerOperation:(BOOL)managerType;
@end
