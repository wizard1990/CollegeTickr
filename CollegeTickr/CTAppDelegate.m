//
//  CTAppDelegate.m
//  CollegeTickr
//
//  Created by Yan Zhang on 4/11/14.
//  Copyright (c) 2014 Yan Zhang. All rights reserved.
//

#import "CTAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MyTokenCachingStrategy.h"

NSString *const FBSessionStateChangedNotification =
@"com.example.TokenCacheHowTo:FBSessionStateChangedNotification";

@interface CTAppDelegate ()
@property (nonatomic, strong) MyTokenCachingStrategy *tokenCaching;
@end

@implementation CTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
//    [FBLoginView class];
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        // If there's one, just open the session silently, without showing the user the login UI
        NSLog(@"FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded, CACHED TOKEN FOUND!");
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



#pragma mark - fb

//// Logged-in user experience.  Only triggered with FB Button!
//- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
//    NSLog(@"loginViewShowingLoggedInUser has been called, user has logged in.  Place holder for any additional code please put it here");
//}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
//        [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
//            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
//                [self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
//                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
//        [self userLoggedOut];
    }
}

- (void) userLoggedIn {
    NSLog(@"loginViewShowingLoggedInUser has been called, user has logged in.  Place holder for any additional code please put it here");
    
    [self getUserInfo];

}


/*
 * Opens a Facebook session and optionally shows the login UX.   //version w/o caching token
 */
//- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
//    return [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
//                                              allowLoginUI:allowLoginUI
//                                         completionHandler:^(FBSession *session,
//                                                             FBSessionState state,
//                                                             NSError *error) {
//                                             [self sessionStateChanged:session
//                                                                 state:state
//                                                                 error:error];
//                                         }];
//}
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    BOOL openSessionResult = NO;
    // Set up token strategy, if needed
    if (nil == _tokenCaching) {
        _tokenCaching = [[MyTokenCachingStrategy alloc] init];
    }
    // Initialize a session object with the tokenCacheStrategy
    FBSession *session = [[FBSession alloc] initWithAppID:nil
                                              permissions:@[@"basic_info"]
                                          urlSchemeSuffix:nil
                                       tokenCacheStrategy:_tokenCaching];
    // If showing the login UI, or if a cached token is available,
    // then open the session.
    if (allowLoginUI || session.state == FBSessionStateCreatedTokenLoaded) {
        // For debugging purposes log if cached token was found
        if (session.state == FBSessionStateCreatedTokenLoaded) {
            NSLog(@"Cached token found.");
        }
        // Set the active session
        [FBSession setActiveSession:session];
        // Open the session.
        [session openWithBehavior:FBSessionLoginBehaviorUseSystemAccountIfPresent
                completionHandler:^(FBSession *session,
                                    FBSessionState state,
                                    NSError *error) {
                    [self sessionStateChanged:session
                                        state:state
                                        error:error];
                }];
        // Return the result - will be set to open immediately from the session
        // open call if a cached token was previously found.
        openSessionResult = session.isOpen;
    }
    

    
    return openSessionResult;
}


- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}
/*
 * If we have a valid session at the time of openURL call, we handle
 * Facebook transitions by passing the url argument to handleOpenURL
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (NSDictionary *)getUserInfo {
    __block NSDictionary *userInfo;
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            //            NSLog(@"user info: %@", result);
            //            __block NSDictionary *userInfo = [(NSArray *)[result data] objectAtIndex:0];
            userInfo = result;
            //
            
            NSLog(@"Dictionary: %@", [userInfo description]);

        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
        }
    }];
    NSLog(@"Dictionary: %@", [userInfo description]);

    return userInfo;
}

@end
