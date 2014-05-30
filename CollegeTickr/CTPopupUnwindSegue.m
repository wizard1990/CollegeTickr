//
//  CTPopupUnwindSegue.m
//  CollegeTickr
//
//  Created by wpliao on 2014/5/1.
//  Copyright (c) 2014年 Yan Zhang. All rights reserved.
//

#import "CTPopupUnwindSegue.h"
#import "CTPopupDelegate.h"

@implementation CTPopupUnwindSegue

- (void)perform {
    id<CTPopupDelegate> destVC = self.destinationViewController;
    [[destVC popUp] hide];
    //[destVC setPopUp:nil];
}

@end
