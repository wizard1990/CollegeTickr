//
//  CTServiceManager.m
//  CollegeTickr
//
//  Created by Yan Zhang on 4/16/14.
//  Copyright (c) 2014 Yan Zhang. All rights reserved.
//

#import "CTServiceManager.h"

NSString* baseUrl = @"http://www.collegetickr.com/api/v1";

@interface CTServiceManager()
@property (nonatomic, strong) AFHTTPSessionManager *requestManager;
@property (nonatomic, strong) NSDictionary *errDict;
@end

@implementation CTServiceManager

+ (CTServiceManager*)manager
{
    static CTServiceManager *sharedInstance;
    @synchronized(self) {
        if (!sharedInstance) {
            sharedInstance = [[CTServiceManager alloc] init];
            return sharedInstance;
        }
    }
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _requestManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
        _requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ErrorCodeList" ofType:@"plist"];
        _errDict = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return self;
}

- (void)loginWithUserId:(NSString *)userId FBToken:(NSString *)token Completion:(void (^)(bool, NSError*))completion
{
    NSDictionary *para = @{@"id" : userId, @"token" : token};
    
    [_requestManager POST:@"/users" parameters:para success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if (completion) {
            NSString *errCode = [responseObject objectForKey:@"status"];
            if ([_errDict[errCode] isEqualToString:@"Success"]) {
                completion(YES, nil);
            }
            else {
                NSError* err = [NSError errorWithDomain:@"Login" code:[errCode integerValue] userInfo:@{@"detail": _errDict[errCode]}];
                completion(NO, err);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        if (completion) {
            completion(NO, error);
        }
    }];
}

- (void)retrieveFriendsFeed:(NSString *)userId Completion:(void(^)(NSArray* feeds, NSError* err)) completion
{
    NSDictionary *para = @{@"user_id": userId};
    NSString *url = [NSString stringWithFormat:@"/users/%@/feeds", userId];
    
    [_requestManager POST:url parameters:para success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if (completion) {
            NSString *errCode = [responseObject objectForKey:@"status"];
            if ([_errDict[errCode] isEqualToString:@"Success"]) {
                NSArray *arr = [responseObject objectForKey:@"feeds"];
                completion(arr, nil);
            }
            else {
                NSError* err = [NSError errorWithDomain:@"Login" code:[errCode integerValue] userInfo:@{@"detail": _errDict[errCode]}];
                completion(NO, err);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        if (completion) {
            completion(nil, error);
        }
    }];
}

@end
