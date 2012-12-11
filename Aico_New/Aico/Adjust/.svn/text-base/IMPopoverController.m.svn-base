//
//  IMPopoverController.m
//  DSM_iPad
//
//  Created by Wu Rongtao on 12-04-16.
//  Copyright 2012 cienet. All rights reserved.

#import "IMPopoverController.h"

@implementation IMWindow

@synthesize delegate = delegate_;

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.delegate touchesEnded:touches withEvent:event];
}

@end


//@interface IMPopoverController (Private)
//
//@property (nonatomic, retain) IMWindow *popOverWindow;
//
//@end


@implementation IMPopoverController

@synthesize popOverSize = popOverSize_;
@synthesize deletage = deletage_;
@synthesize popOverWindow = popOverWindow_;

/**
 * @brief 获取弹出视图窗口
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (UIWindow *) popOverWindow
{
	return popOverWindow_;
}

/**
 * @brief 设置弹出视图窗口
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void) setPopOverWindow:(IMWindow *) newValue
{
	if (popOverWindow_ != newValue)
	{
		[popOverWindow_ release];
		popOverWindow_ = [newValue retain];
	}
}

/**
 * @brief 初始化操作
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (id) initWithContentViewController:(UIViewController *) con
{
	if (self = [super init]) {
		
		self.popOverWindow = [[[IMWindow alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
		self.popOverWindow.windowLevel = UIWindowLevelAlert;
		self.popOverWindow.backgroundColor = [UIColor clearColor];
		self.popOverWindow.hidden = YES;
		self.popOverWindow.delegate = self;
		
		[self setContentViewController:con animated:NO];
	}
	return self;
}

/**
 * @brief 获取内容视图控制器
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (UIViewController *) contentViewController
{
	return contentViewController_;
}

/**
 * @brief 设置内容视图控制器
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void) setContentViewController:(UIViewController *) newCon animated:(BOOL) animated
{
	if (contentViewController_ != newCon) {
		[contentViewController_ release];
		contentViewController_ = [newCon retain];
	}
}

/**
 * @brief 弹出视图
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void) presentPopoverFromRect:(CGRect) rect inView:(UIView *) inView animated:(BOOL) animated
{
	UIWindow *mainWin = [[[UIApplication sharedApplication] delegate] window];
	CGRect newFrame = [mainWin convertRect:rect fromWindow:mainWin];
	[[self contentViewController].view setFrame:CGRectMake(newFrame.origin.x, newFrame.origin.y, self.popOverSize.width, self.popOverSize.height)];
	[self.popOverWindow addSubview:[self contentViewController].view];
	self.popOverWindow.hidden = NO;
	[self.popOverWindow makeKeyWindow];
}

/**
 * @brief 隐藏视图
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void) dismissPopoverAnimated:(BOOL) animated
{
	[self.popOverWindow resignKeyWindow];
	self.popOverWindow.hidden = YES;
}

/**
 * @brief touch事件隐藏视图
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //	[self dismissPopoverAnimated:YES];
    if ([[[touches anyObject] view] isKindOfClass:[IMWindow class]] )
    {
        [self dismissPopoverAnimated:YES];
    }
    
    if ([self.deletage respondsToSelector:@selector(dismissPopView)])
    {
        [self.deletage dismissPopView];
    }
}

/**
 * @brief 析构操作
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void) dealloc
{
	self.popOverWindow = nil;
    [contentViewController_ release],contentViewController_ = nil;
	[super dealloc];
}

@end
