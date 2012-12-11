//
//  NetworkManager.h
//  iPhoneDSM
//
//  Created by Maserati on 11-6-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIProgressDelegate.h"
#import "Reachability.h"


@interface NetworkManager: NSObject  <ASIHTTPRequestDelegate, ASIProgressDelegate>{
@private
    NSOperationQueue *requestQueue_;
    NSMutableArray *requestList_;
    Reachability  *hostReach_;
    NetworkStatus hostStatus_;
}

@property (retain) NSOperationQueue *requestQueue;
@property (nonatomic, retain)Reachability *hostReach;
@property (nonatomic, assign)NetworkStatus hostStatus;


/**
 * @brief  创建单例和获取单例的方法
 *
 * @param [in] 
 * @param [out] 返回单例本身
 * @return
 * @note 
 */
+ (NetworkManager *)sharedNetworkManager;

/**
 * @brief  添加网络请求
 *
 * @param [in] 
 * @param [out] 
 * @return
 * @note 
 */
- (void) issueHttpRequest:(ASIHTTPRequest *)aRequest;

/**
 * @brief  根据请求id取消某个请求
 *
 * @param [in] 
 * @param [out] 
 * @return
 * @note 
 */
- (void) cancelHttpRequest:(NSInteger)aRequestId;

/**
 * @brief  取消所有请求
 *
 * @param [in] 
 * @param [out] 
 * @return
 * @note 
 */
- (void) cancelAllHttpRequest;
@end
