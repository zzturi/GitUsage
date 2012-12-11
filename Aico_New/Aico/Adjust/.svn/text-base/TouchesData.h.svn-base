//
//  TouchesData.h
//  Aico
//
//  Created by Yin Cheng on 7/27/12.
//  Copyright (c) 2012 cienet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchesPoint : NSObject
{
    CGPoint point_;
}
@property(nonatomic,assign)CGPoint point;
@end

//此类用作于 保存触摸操作的数据
@interface TouchesData : NSObject
{
    BOOL brushType_;
    BOOL brushMode_;
    CGFloat brushRadius_;
    int brushOpacity_;
    NSMutableArray *pointArray_;
    CGFloat alpha_;
}
@property(nonatomic,assign) BOOL brushType;
@property(nonatomic,assign) BOOL brushMode;
@property(nonatomic,assign) CGFloat brushRadius;
@property(nonatomic,assign) int brushOpacity;
@property(nonatomic,retain) NSMutableArray *pointArray;
@property(nonatomic,assign) CGFloat alpha;

- (void)addLastPoint:(CGPoint)point;
- (void)addPoint:(CGPoint)point index:(NSUInteger)index;
- (CGPoint)getLastPoint;
- (CGPoint)getPointAtIndex:(NSUInteger)index;
- (NSInteger)countOfPoint;
@end
