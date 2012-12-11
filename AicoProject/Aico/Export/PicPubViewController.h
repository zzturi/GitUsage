//
//  PicPubViewController.h
//  Aico
//
//  Created by chen tao on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBSendView.h"

@interface PicPubViewController : UIViewController <WBSendViewDelegate, UITextFieldDelegate>
{
    UIImage *srcImage_;
    
    UITextField *titleText_;
    UIButton *insertPicBtn_;
    UIButton *pubPicBtn_;
    UIImageView *imageView_;
    
    NSString *fileUrl_;       // 存储图片的路径
    
    NSString *appKey_;
	NSString *appSecret_;
	NSString *tokenKey_;
	NSString *tokenSecret_;
    
    NSURLConnection *connection_; 
    NSMutableData *responseData_;
    
    NSInteger type_;
}
@property(nonatomic, retain) UIImage *srcImage;
@property (retain, nonatomic) IBOutlet UITextField *titleText;
@property(retain, nonatomic) IBOutlet UIButton *insertPicBtn;
@property(retain, nonatomic) IBOutlet UIButton *pubPicBtn;
@property(retain, nonatomic) IBOutlet UIImageView *imageView;

@property(copy, nonatomic) NSString *fileUrl;
@property(nonatomic, copy) NSString *appKey;
@property(nonatomic, copy) NSString *appSecret;
@property(nonatomic, copy) NSString *tokenKey;
@property(nonatomic, copy) NSString *tokenSecret;
@property(nonatomic, assign) NSInteger type;

/**
 * @brief 
 * 取消按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)cancelBtnPressed:(id)sender;


// 向微博发布图片
- (IBAction)publishMsg:(id)sender;
@end
