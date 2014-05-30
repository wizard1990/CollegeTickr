//
//  CTPopupDelegate.h
//  CollegeTickr
//
//  Created by wpliao on 2014/5/1.
//  Copyright (c) 2014年 Yan Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFPopupView.h"

@protocol CTPopupDelegate <NSObject>

@required
@property (strong, nonatomic) AFPopupView *popUp;

- (void)didDismissViewController:(UIViewController *)viewController;

@end
