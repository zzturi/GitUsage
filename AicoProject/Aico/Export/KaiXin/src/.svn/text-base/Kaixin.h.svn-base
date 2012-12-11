#import "KaixinLoginDialog.h"
#import "KaixinLocalLoginDialog.h"
#import "KaixinRequest.h"

@protocol KaixinSessionDelegate;

@interface Kaixin : NSObject<KaixinLoginDialogDelegate>{
  NSString* _accessToken;
  NSString* _refreshToken;
  NSDate* _expirationDate;
  id<KaixinSessionDelegate> _sessionDelegate;
  KaixinRequest* _request;
  KaixinDialog* _loginDialog;
  KaixinLocalLoginDialog* _localLoginDialog;
  KaixinDialog* _KaixinDialog;
  NSString* _appId;
  NSString* _kRedirectURL;
  NSString* _secretKey;
    
    id<KaixinRequestDelegate> delegate_;
}

@property(nonatomic, copy) NSString* accessToken;
@property(nonatomic, copy) NSString* refreshToken;
@property(nonatomic, copy) NSDate* expirationDate;
@property(nonatomic, assign) id<KaixinSessionDelegate> sessionDelegate;
@property(nonatomic, assign) id<KaixinRequestDelegate> delegate;
@property(nonatomic, retain) KaixinRequest* request;

- (id)initWithAppId:(NSString *)app_id reDirectURL:(NSString *)kRedirectURL secretKey:(NSString *)key;

- (void)authorizeDelegate:(id<KaixinSessionDelegate>)delegate;

- (void)authorizeWithKXAppAuth;

- (void)authorizeWithLocalLoginInView:(UIView*)parent;

- (void)logout:(id<KaixinSessionDelegate>)delegate;

- (KaixinRequest*)requestWithSeparateURL:(NSString*) requestURL 
                  andHttpMethod:(NSString *) StrHttpMethod
                  andDelegate:(id <KaixinRequestDelegate>)delegate;

- (KaixinRequest*)requestWithSeparateURL:(NSString*) requestURL 
                                  params:(NSDictionary*)requestParams
                           andHttpMethod:(NSString *) StrHttpMethod
                             andDelegate:(id <KaixinRequestDelegate>)delegate;

- (KaixinRequest*)requestByRefreshTokenHttpMethod:(NSString *) StrHttpMethod
                                      andDelegate:(id <KaixinRequestDelegate>)delegate;


- (void)dialog:(NSString *)action
   andDelegate:(id<KaixinDialogDelegate>)delegate;

- (void)dialog:(NSString *)action
     andParams:(NSMutableDictionary *)params
   andDelegate:(id <KaixinDialogDelegate>)delegate;

- (BOOL)isSessionValid;

- (UIView *)getRequestView;

@end

////////////////////////////////////////////////////////////////////////////////

/**
 * Your application should implement this delegate to receive session callbacks.
 */
@protocol KaixinSessionDelegate <NSObject>

@optional

/**
 * Called when the user successfully logged in.
 */
- (void)KaixinDidLogin;

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)KaixinDidNotLogin:(BOOL)cancelled;

/**
 * Called when the user logged out.
 */
- (void)KaixinDidLogout;

@end
