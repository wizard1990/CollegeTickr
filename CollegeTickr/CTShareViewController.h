//
//  CTShareViewController.h
//  CollegeTickr
//
//  Created by wpliao on 2014/4/22.
//  Copyright (c) 2014年 Yan Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CTUserModel;

@interface CTShareViewController : UIViewController<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) CTUserModel *user;
@property (nonatomic, strong) NSString *post;

@end
