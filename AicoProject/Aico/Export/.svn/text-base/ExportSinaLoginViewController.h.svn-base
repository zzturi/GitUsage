//
//  ExportSinaLoginViewController.h
//  Aico
//
//  Created by chen tao on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"

@interface ExportSinaLoginViewController : UIViewController <WBEngineDelegate, UIAlertViewDelegate>
{
    WBEngine *wbEngine_;                 //新浪微博数据处理       
    BOOL isExitCurrentCount_;            //是否是从退出跳转而来
}
@property(nonatomic,retain) WBEngine *wbEngine;
@property(nonatomic,assign) BOOL isExitCurrentCount;

/**
 * @brief 
 * 取消按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)cancelBtnPressed;

@end
