//
//  CTFBLogin.m
//  CollegeTickr
//
//  Created by Max Gu on 4/24/14.
//  Copyright (c) 2014 Yan Zhang. All rights reserved.
//

#import "CTFBLogin.h"

@implementation CTFBLogin

- (void) login
{
    NSLog(@"button clicked!");
    CTAppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    // If the user is authenticated, log out when the button is clicked.
    // If the user is not authenticated, log in when the button is clicked.
    if (FBSession.activeSession.isOpen) {
        NSLog(@"closing session");
        [appDelegate closeSession];
    } else {
        NSLog(@"opening session");
        // The user has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
}
@end
