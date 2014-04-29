//
//  CTAppDelegate.h
//  CollegeTickr
//
//  Created by Yan Zhang on 4/11/14.
//  Copyright (c) 2014 Yan Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "CTFBManager.h"

extern NSString *const FBSessionStateChangedNotification;
@class CTViewController;


@interface CTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CTViewController *viewController;
//@property (weak, nonatomic) id<FBLoggedInProtocol> delegate;



@end
