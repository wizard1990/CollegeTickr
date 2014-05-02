//
//  CTViewController.m
//  CollegeTickr
//
//  Created by Yan Zhang on 4/11/14.
//  Copyright (c) 2014 Yan Zhang. All rights reserved.
//

#import "CTViewController.h"
#import "CTUserModel.h"
#import "CTServiceManager.h"

@interface CTViewController ()

@end

@implementation CTViewController

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//	// Do any additional setup after loading the view, typically from a nib.
//    FBLoginView *loginView = [[FBLoginView alloc] init];
//    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 5);
//    loginView.readPermissions = @[@"basic_info", @"email", @"user_likes"];
//    [self.view addSubview:loginView];
//    NSLog(@"FBLoginView Added");
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    CTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (self.shouldAutoLogin) {
        BOOL isOpen = [[CTFBManager manager] openSessionWithAllowLoginUI:NO];
        if (!isOpen) {
            NSLog(@"Session not open!");
            [self logoutUI];
        }
    }
    else {
        [[CTFBManager manager] closeSession];
        [self logoutUI];
    }
    
    [CTFBManager manager].delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FB Delegate
// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}



- (IBAction)authButton:(UIButton *)sender {
    NSLog(@"button clicked!");
    [[CTFBManager manager] login];
    [self loginUI];
}

#pragma mark -
#pragma mark - FBHandleLoginProtocol

- (void)userDidFinishLoggingIn:(CTUserModel *)userInfo
{
    //get FB token
    NSString *token = @"CAAFZAiewJdZCUBAM9aBaIgiNOU963KoEyUs4dMMQc4bkqOGJ0K07lG289VGwuAZAXaXTsVSvdztQtZCPF1DYQ0hZBrQn4IuTK98IUOVusjGUZBlZAsFkgTpZCKkYRJzecyX1kv3JEMQpLhd5i6UKkrZC5oBt0e47GZCJ0GzZAhqZCV9y8QXgbBdynavhUhoEaZAIZC204ZD";
    
    NSLog(@"userDidFinishLoggingIn");
    
    [[CTServiceManager manager] loginWithUserId:userInfo.uid FBToken:token completion:^(bool isSucc, NSError *err) {
        if (isSucc) {
            NSLog(@"success");
            self.user = userInfo;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"unwindFromLoginSegue" sender:self];
            });
        }
        else {
            NSLog(@"fail");
            [self logoutUI];
        }
    }];
}

- (void)userFailedToLogIn
{
    
}

#pragma mark - Helper method

- (void)loginUI {
    [self.indicator startAnimating];
    self.loginButton.hidden = YES;
}

- (void)logoutUI {
    [self.indicator stopAnimating];
    self.loginButton.hidden = NO;
}

@end
