//
//  CTPostCell.h
//  CollegeTickr
//
//  Created by wpliao on 2014/4/29.
//  Copyright (c) 2014年 Yan Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTPostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *parallaxImageView;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

- (void)cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view;

@end
