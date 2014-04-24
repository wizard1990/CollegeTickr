//
//  CTCommentModel.h
//  CollegeTickr
//
//  Created by Max Gu on 4/24/14.
//  Copyright (c) 2014 Yan Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTCommentModel : NSObject

@property (readonly, nonatomic, assign) NSInteger comment_id;
@property (readonly, nonatomic, strong) NSString *content;
@property (readonly, nonatomic, assign) NSInteger secret_id;
@property (readonly, nonatomic, assign) NSInteger owner_id;

- (instancetype)initWithCommentId: (NSInteger)comment_id withContent: (NSString *)content withSecretId: (NSInteger)secret_id andOwnerId: (NSInteger)owner_id;

@end
