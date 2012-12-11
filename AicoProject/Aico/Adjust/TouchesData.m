//
//  TouchesData.m
//  Aico
//
//  Created by Yin Cheng on 7/27/12.
//  Copyright (c) 2012 cienet. All rights reserved.
//

#import "TouchesData.h"

@implementation TouchesPoint
@synthesize point = point_;

- (id)initWithPoint:(CGPoint)p
{
    self = [super init];
    if (self)
    {
        self.point = p;
    }
    return self;
}
- (void)dealloc
{
    [super dealloc];
}
@end

@implementation TouchesData
@synthesize brushType = brushType_;
@synthesize brushMode = brushMode_;
@synthesize brushRadius = brushRadius_;
@synthesize brushOpacity = brushOpacity_;
@synthesize pointArray = pointArray_;
@synthesize alpha = alpha_;

- (id)init
{
    self = [super init];
    if (self) 
    {
        pointArray_ = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)dealloc
{
    self.pointArray = nil;
    [super dealloc];
}

- (void)addLastPoint:(CGPoint)point
{
    TouchesPoint *tp = [[TouchesPoint alloc] initWithPoint:point];
    [self.pointArray addObject:tp];
    [tp release];
}
- (void)addPoint:(CGPoint)point index:(NSUInteger)index
{
    TouchesPoint *tp = [[TouchesPoint alloc] initWithPoint:point];
    [self.pointArray insertObject:tp atIndex:index];
    [tp release];
}
- (CGPoint)getLastPoint
{
    if ([self.pointArray count] <= 0) 
    {
        return CGPointZero;
    }
    else
    {
        return [[self.pointArray lastObject] point];
    }
}

- (CGPoint)getPointAtIndex:(NSUInteger)index
{
    if ([self.pointArray count] < index) 
    {
        return CGPointZero;
    }
    else
    {
        return [[self.pointArray objectAtIndex:index] point];
    }
}

- (NSInteger)countOfPoint
{
    return [self.pointArray count];
}
@end
