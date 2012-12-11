//
//  AdjustClipViewController.m
//  Aico
//
//  Created by Wu RongTao on 12-3-29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdjustClipViewController.h"
#import "ImageScrollViewController.h"


@implementation AdjustClipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [imageScrollVC_ release],imageScrollVC_ = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageScrollVC_ = [[ImageScrollViewController alloc] init];
    [self.view insertSubview:imageScrollVC_.view atIndex:0];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [imageScrollVC_ release],imageScrollVC_ = nil;
    [super viewDidUnload];    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
