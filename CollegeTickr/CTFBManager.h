//
//  CTFBLogin.h
//  CollegeTickr
//
//  Created by Max Gu on 4/24/14.
//  Copyright (c) 2014 Yan Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "CTAppDelegate.h"
#import "MyTokenCachingStrategy.h"

@protocol FBLoggedInProtocol <NSObject>
@required
- (void) userDidFinishLoggingIn : (NSDictionary*) userInfo;
- (void) userFailedToLogIn;
@end

@interface CTFBManager : NSObject

@property (weak, nonatomic) id<FBLoggedInProtocol> delegate;
//@property (nonatomic, strong) MyTokenCachingStrategy *tokenCaching;
+ (CTFBManager *)manager;

- (void) login;
- (void) afterLaunchingApp;
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void) closeSession;
@end
