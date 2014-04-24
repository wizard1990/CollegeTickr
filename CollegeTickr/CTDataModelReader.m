//
//  CTDataModelReader.m
//  CollegeTickr
//
//  Created by Yan Zhang on 4/24/14.
//  Copyright (c) 2014 Yan Zhang. All rights reserved.
//

#import "CTDataModelReader.h"

@implementation CTDataModelReader

+ (CTUserModel *)getUserModel:(NSDictionary *)userData
{
    NSString *fristName = userData[@"first_name"];
    NSString *lastName = userData[@"last_name"];
    NSString *location = userData[@"location"][@"name"];
    return [[CTUserModel alloc] init];
}

+ (CTSecretModel *)getSecretModel:(NSDictionary *)secretData
{
    NSInteger secret_id = [secretData[@"id"] integerValue];
    NSString *content = secretData[@"content"];
    NSInteger canvas_id = [secretData[@"canvas_id"] integerValue];
    NSInteger likes = [secretData[@"likes"] integerValue];
    return [[CTSecretModel alloc] init];
}

+ (CTCommentModel *)getCommentModel:(NSDictionary *)commentData
{
    NSInteger comment_id = [commentData[@"id"] integerValue];
    NSString* user_id = commentData[@"user_id"];
    NSString* content = commentData[@"content"];
    NSString* avatar_url = commentData[@"avatar_url"];
    return [[CTCommentModel alloc] init];
}

@end
