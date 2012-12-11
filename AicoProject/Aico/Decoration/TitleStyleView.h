//
//  TitleStyleView.h
//  Aico
//
//  Created by 勇 周 on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FXLabel;

@interface TitleStyleView : UIView
{
    FXLabel*        label_;
    UIButton*       button_;
}

@property (nonatomic, retain) FXLabel* label;
@property (nonatomic, retain) UIButton* button;

@end
