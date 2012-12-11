//
//  FolderViewController.h
//  Aico
//
//  Created by Wang Dean on 12-4-6.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageSplitViewController.h"

@interface FolderViewController : UIViewController <SetSplitView>
{
	NSInteger numImages;               //图片数量
    NSMutableArray *contentArray_;     //图片路径存放数组
    UIScrollView *backScrollView_;     //背景
    NSUInteger    whichClassCallfrom;  //标记量，记录是从插入图片还是主页过来 
}
@property(nonatomic,assign) NSInteger numImages;
@property(nonatomic,retain) NSMutableArray *contentArray;
@property(nonatomic,retain) IBOutlet UIScrollView *backScrollView;
@property(nonatomic,assign) NSUInteger    whichClassCallfrom;
@end
