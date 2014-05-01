//
//  CTPostViewController.h
//  CollegeTickr
//
//  Created by wpliao on 2014/4/17.
//  Copyright (c) 2014年 Yan Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASOTwoStateButton.h"
#import "ASOBounceButtonViewDelegate.h"
#import "CTBounceMenuView.h"

@interface CTMainViewController : UITableViewController <ASOBounceButtonViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet ASOTwoStateButton *menuButton;
@property (strong, nonatomic) CTBounceMenuView *menuItemView;

@end
