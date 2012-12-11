//
//  TitleStyleView.m
//  Aico
//
//  Created by 勇 周 on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TitleStyleView.h"
#import "FXLabel.h"

@implementation TitleStyleView

@synthesize label   = label_;
@synthesize button  = button_;

- (id)initWithFrame:(CGRect)frame styleType:(NSInteger)type
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        label_ = [[FXLabel alloc] initWithFrame:frame];
        label_.frame = self.bounds;
        
        button_ = [UIButton buttonWithType:UIButtonTypeCustom];
        button_.backgroundColor = [UIColor clearColor];
        button_.frame = self.bounds;
        
        [self addSubview:label_];
        [self addSubview:button_];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [label_ release];
    [button_ release];
    [super dealloc];
}

@end
