//
//  CTServiceManager.h
//  CollegeTickr
//
//  Created by Yan Zhang on 4/16/14.
//  Copyright (c) 2014 Yan Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTServiceManager : NSObject

+ (CTServiceManager *)manager;

- (void)loginWithUserId:(NSString *)userId FBToken:(NSString *)token completion:(void(^)(bool isSucc, NSError* err))completion;

- (void)retrieveFriendsFeed:(NSString *)userId atPage:(NSInteger)page completion:(void(^)(NSArray* feeds, NSError* err))completion;

- (void)postFromUser:(NSString *)user_id content:(NSString *)content canvas:(NSInteger)canvas_id completion: (void(^)(NSDictionary* post, NSError* err))completion;

- (void)fetchComments:(NSInteger)post_id completion:(void(^)(NSArray *comments, NSError* err))completion;

- (void)submitComment:(NSInteger)post_id fromUser:(NSString *)user_id withContent:(NSString *)content completion:(void(^)(bool isSucc, NSError* err))completion;

- (void)likesSecret:(NSInteger)post_id byUser:(NSString *)user_id completion:(void(^)(bool isSucc, NSError* err))completion;

- (void)cancelLikesSecret:(NSInteger)post_id byUser:(NSString *)user_id completion:(void(^)(bool isSucc, NSError* err))completion;

@end
