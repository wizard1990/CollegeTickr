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

- (void)loginWithUserId:(NSString *)userId FBToken:(NSString *)token Completion:(void(^)(bool isSucc, NSError* err)) completion;

- (void)retrieveFriendsFeed:(NSString *)userId Completion:(void(^)(NSArray* feeds, NSError* err)) completion;

@end
