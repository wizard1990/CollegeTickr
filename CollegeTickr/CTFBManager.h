//
//  CTFBLogin.h
//  CollegeTickr
//
//  Created by Max Gu on 4/24/14.
//  Copyright (c) 2014 Yan Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CTUserModel;

@protocol FBHandleLoginProtocol <NSObject>
@required
- (void) userDidFinishLoggingIn : (CTUserModel *) userInfo;
- (void) userFailedToLogIn;
@end

@interface CTFBManager : NSObject

@property (weak, nonatomic) id<FBHandleLoginProtocol> delegate;
//@property (nonatomic, strong) MyTokenCachingStrategy *tokenCaching;
+ (CTFBManager *)manager;

- (void) login;
- (void) afterLaunchingApp;
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void) closeSession;
@end
