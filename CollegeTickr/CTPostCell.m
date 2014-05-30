//
//  CTPostCell.m
//  CollegeTickr
//
//  Created by wpliao on 2014/4/29.
//  Copyright (c) 2014年 Yan Zhang. All rights reserved.
//

#import "CTPostCell.h"

@implementation CTPostCell

- (void)cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view
{
    CGRect rectInSuperview = [tableView convertRect:self.frame toView:view];
    
    float distanceFromCenter = CGRectGetHeight(view.frame)/2 - CGRectGetMinY(rectInSuperview);
    float difference = CGRectGetHeight(self.parallaxImageView.frame) - CGRectGetHeight(self.frame);
    float move = (distanceFromCenter / CGRectGetHeight(view.frame)) * difference;
    
    CGRect imageRect = self.parallaxImageView.frame;
    imageRect.origin.y = -(difference/2)+move;
    self.parallaxImageView.frame = imageRect;
}

@end
