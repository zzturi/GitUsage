//
//  QWeiboSyncApi.h
//  Aico
//
//  Created by chentao on 12-5-7.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _ResultType {
	
	RESULTTYPE_XML, RESULTTYPE_JSON
	
}ResultType;

typedef enum _PageFlag {
	
	PAGEFLAG_FIRST, 
	PAGEFLAG_NEXT, 
	PAGEFLAG_LAST
	
}PageFlag;

@interface QWeiboSyncApi : NSObject {

}

//Get request token
- (NSString *)getRequestTokenWithConsumerKey:(NSString *)aConsumerKey 
							  consumerSecret:(NSString *)aConsumerSecret;

//Get access token
- (NSString *)getAccessTokenWithConsumerKey:(NSString *)aConsumerKey 
							 consumerSecret:(NSString *)aConsumerSecret 
							requestTokenKey:(NSString *)aRequestTokenKey
						 requestTokenSecret:(NSString *)aRequestTokenSecret 
									 verify:(NSString *)aVerify;

//Request timeline messages.
- (NSString *)getHomeMsgWithConsumerKey:(NSString *)aConsumerKey
						 consumerSecret:(NSString *)aConsumerSecret 
						 accessTokenKey:(NSString *)aAccessTokenKey 
					  accessTokenSecret:(NSString *)aAccessTokenSecret 
							 resultType:(ResultType)aResultType 
							  pageFlage:(PageFlag)aPageFlag 
								nReqNum:(NSInteger)aReqNum;

//Publish a message w/ or w/o image.
- (NSString *)publishMsgWithConsumerKey:(NSString *)aConsumerKey 
						 consumerSecret:(NSString *)aConsumerSecret 
						 accessTokenKey:(NSString *)aAccessTokenKey 
					  accessTokenSecret:(NSString *)aAccessTokenSecret 
								content:(NSString *)aContent 
							  imageFile:(NSString *)aImageFile 
							 resultType:(ResultType)aResultType;

@end
