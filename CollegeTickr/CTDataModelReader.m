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
    NSString *userId = userData[@"id"];
    NSString *firstName = userData[@"first_name"];
    NSString *lastName = userData[@"last_name"];
    NSString *location = userData[@"location"][@"name"];
    return [[CTUserModel alloc] initWithId:userId firstName:firstName lastName:lastName andLocation:location];
}

+ (CTSecretModel *)getSecretModel:(NSDictionary *)secretData
{
    NSInteger secret_id = [secretData[@"id"] integerValue];
    NSString *content = secretData[@"content"];
    u_int32_t randomNum = arc4random() % 10;
    //NSInteger canvas_id = [secretData[@"canvas_id"] integerValue];
    NSInteger likes = [secretData[@"likes"] integerValue];
    return [[CTSecretModel alloc] initWithSecretId:secret_id canvasId:randomNum content:content andLikes:likes];
}

+ (CTCommentModel *)getCommentModel:(NSDictionary *)commentData
{
    NSInteger comment_id = [commentData[@"id"] integerValue];
    NSString* user_id = commentData[@"user_id"];
    NSString* content = commentData[@"detail"];
    NSString* avatar_url = commentData[@"avatar_url"];
    return [[CTCommentModel alloc] initWithCommentId:comment_id withContent:content withOwnerId:user_id andAvatarUrl:avatar_url];
}

@end
