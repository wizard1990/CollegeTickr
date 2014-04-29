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
@property (readonly, nonatomic, strong) NSString *owner_id;
@property (readonly, nonatomic, strong) NSString *avatar_url;

- (instancetype)initWithCommentId: (NSInteger)comment_id withContent: (NSString *)content withOwnerId: (NSString *)owner_id andAvatarUrl:(NSString *)url;

@end
