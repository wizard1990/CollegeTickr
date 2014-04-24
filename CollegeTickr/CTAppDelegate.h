//
//  CTAppDelegate.h
//  CollegeTickr
//
//  Created by Yan Zhang on 4/11/14.
//  Copyright (c) 2014 Yan Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

extern NSString *const FBSessionStateChangedNotification;
@class CTViewController;

@protocol FBLoggedInProtocol <NSObject>
@required
- (void) userDidFinishLoggingIn : (NSDictionary*) userInfo;
- (void) userFailedToLogIn;
@end

@interface CTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CTViewController *viewController;
@property (weak, nonatomic) id<FBLoggedInProtocol> delegate;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void) closeSession;


@end
