//
//  AdjustMenuCell.m
//  Aico
//
//  Created by Mike on 12-4-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdjustMenuCell.h"
#import "UIColor+extend.h"

@implementation AdjustMenuCell
@synthesize imageView = imageView_;
@synthesize titleLabel = titleLabel_;
@synthesize separationView = separationView_;
@synthesize bgView = bgView_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
//    if (selected)
//    {
//        self.titleLabel.textColor = [UIColor redColor];
//    }
//    else
//    {
//        self.titleLabel.textColor = [UIColor getColor:@"999999"];
//    }

    // Configure the view for the selected state
}

- (void)dealloc
{
    self.imageView = nil;
    self.titleLabel = nil;
    self.separationView = nil;
    self.bgView = nil;
    [super dealloc];
}
@end
