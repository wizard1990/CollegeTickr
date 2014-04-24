//
//  CTCommentModel.m
//  CollegeTickr
//
//  Created by Max Gu on 4/24/14.
//  Copyright (c) 2014 Yan Zhang. All rights reserved.
//

#import "CTCommentModel.h"

@interface CTCommentModel()
@property (readwrite, nonatomic, assign) NSInteger comment_id;
@property (readwrite, nonatomic, strong) NSString *content;
@property (readwrite, nonatomic, assign) NSInteger secret_id;
@property (readwrite, nonatomic, assign) NSInteger owner_id;
@end

@implementation CTCommentModel

- (instancetype)initWithCommentId:(NSInteger)comment_id withContent:(NSString *)content withSecretId:(NSInteger)secret_id andOwnerId:(NSInteger)owner_id
{
    self = [super init];
    if(self)
    {
        _comment_id = comment_id;
        _content = content;
        _secret_id = secret_id;
        _owner_id = owner_id;
    }
    return self;
    
}
@end
