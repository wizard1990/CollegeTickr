//
//  CTPopupSegue.m
//  CollegeTickr
//
//  Created by wpliao on 2014/5/1.
//  Copyright (c) 2014年 Yan Zhang. All rights reserved.
//

#import "CTPopupSegue.h"
#import "AFPopupView.h"
#import "CTPopupDelegate.h"

@implementation CTPopupSegue

- (void)perform {
    id<CTPopupDelegate> souceVC = self.sourceViewController;
    [souceVC setPopUp:[AFPopupView popupWithView:[self.destinationViewController view]]];
    [[souceVC popUp] show];
    
    [[self sourceViewController] presentViewController:self.destinationViewController animated:NO completion:nil];
}

@end
