//
//  CTPostViewController.h
//  CollegeTickr
//
//  Created by wpliao on 2014/4/29.
//  Copyright (c) 2014年 Yan Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CTSecretModel;
@class CTUserModel;

@interface CTPostViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CTUserModel *user;
@property (strong, nonatomic) CTSecretModel *secret;

@end
