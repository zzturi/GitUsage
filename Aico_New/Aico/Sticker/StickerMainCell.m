//
//  StickerMainCell.m
//  Aico
//
//  Created by Yincheng on 12-5-7.
//  Copyright (c) 2012年 x. All rights reserved.
//

#import "StickerMainCell.h"

@implementation StickerMainCell
@synthesize imageView = imageView_;
@synthesize titleLabel = titleLabel_;
@synthesize separatorLineImgView = separatorLineImgView_;

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

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
}

- (void)dealloc
{
    self.imageView = nil;
    self.titleLabel = nil;
    self.separatorLineImgView = nil;
    [super dealloc];
}

@end
