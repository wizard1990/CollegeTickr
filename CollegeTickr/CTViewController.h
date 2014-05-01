//
//  CTViewController.h
//  CollegeTickr
//
//  Created by Yan Zhang on 4/11/14.
//  Copyright (c) 2014 Yan Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "CTAppDelegate.h"
#import "CTFBManager.h"

@class  CTUserModel;

@interface CTViewController : UIViewController<FBLoginViewDelegate,FBHandleLoginProtocol>

@property CTFBManager *fbLogin;

@property (nonatomic, strong) CTUserModel *user;

- (IBAction)authButton:(UIButton *)sender;

@end
