//
//  QWeiboAsyncApi.h
//  Aico
//
//  Created by chentao on 12-5-7.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QWeiboSyncApi.h"


@interface QWeiboAsyncApi : NSObject {

}

// 异步发起请求
- (NSURLConnection *)getRequestTokenWithConsumerKey:(NSString *)aConsumerKey 
                                     consumerSecret:(NSString *)aConsumerSecret 
                                           delegate:(id)aDelegate;

// 获取用户主页面微博的信息
- (NSURLConnection *)getHomeMsgWithConsumerKey:(NSString *)aConsumerKey
						 consumerSecret:(NSString *)aConsumerSecret 
						 accessTokenKey:(NSString *)aAccessTokenKey 
					  accessTokenSecret:(NSString *)aAccessTokenSecret 
							 resultType:(ResultType)aResultType 
							  pageFlage:(PageFlag)aPageFlag 
								nReqNum:(NSInteger)aReqNum 
							   delegate:(id)aDelegate;
// 发布一条微博信息到腾讯微博平台
- (NSURLConnection *)publishMsgWithConsumerKey:(NSString *)aConsumerKey 
						 consumerSecret:(NSString *)aConsumerSecret 
						 accessTokenKey:(NSString *)aAccessTokenKey 
					  accessTokenSecret:(NSString *)aAccessTokenSecret 
								content:(NSString *)aContent 
							  imageFile:(NSString *)aImageFile 
							 resultType:(ResultType)aResultType 
							   delegate:(id)aDelegate;
@end
