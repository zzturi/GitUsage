//
//  ClipSizeViewController.h
//  Aico
//
//  Created by Wu RongTao on 12-4-1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectSizeDelegate <NSObject>

@required
- (void)getSelectSize:(CGSize)selectSize andSizeIndex:(NSInteger)index;
@end


@interface ClipSizeViewController : UIViewController 
{
    id <SelectSizeDelegate> delegate_;
    NSArray      *sizeArray_;               //选择比例数组
    NSString     *selectSize_;              //选择的比例
    NSInteger    sizeIndex_;                //当前选中size的索引
    CGSize       maxSize_;                  //支持的最大裁减尺寸
    
}

@property(nonatomic, assign) id <SelectSizeDelegate> delegate;
@property(nonatomic, retain) NSArray *sizeArray;
@property(nonatomic, assign) NSInteger    sizeIndex;
@property(nonatomic, assign) CGSize       maxSize;
@end
