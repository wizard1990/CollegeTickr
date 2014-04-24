//
//  CTServiceManager.m
//  CollegeTickr
//
//  Created by Yan Zhang on 4/16/14.
//  Copyright (c) 2014 Yan Zhang. All rights reserved.
//

#import "CTServiceManager.h"

NSString* baseUrl = @"http://www.collegetickr.com";

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

- (void)loginWithUserId:(NSString *)userId FBToken:(NSString *)token completion:(void (^)(bool, NSError*))completion
{
    NSDictionary *para = @{@"id" : userId, @"token" : token};
    
    [_requestManager POST:@"/api/v1/users" parameters:para success:^(NSURLSessionDataTask *task, id responseObject) {
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

- (void)retrieveFriendsFeed:(NSString *)userId atPage:(NSInteger)page completion:(void(^)(NSArray* feeds, NSError* err)) completion
{
    NSDictionary *para = @{@"user_id": userId, @"page": @(page)};
    NSString *url = [NSString stringWithFormat:@"/api/v1/users/%@/feeds", userId];
    
    [_requestManager GET:url parameters:para success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if (completion) {
            NSString *errCode = [responseObject objectForKey:@"status"];
            if ([_errDict[errCode] isEqualToString:@"Success"]) {
                NSArray *arr = [responseObject objectForKey:@"feeds"];
                completion(arr, nil);
            }
            else {
                NSError* err = [NSError errorWithDomain:@"Feeds" code:[errCode integerValue] userInfo:@{@"detail": _errDict[errCode]}];
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

- (void)postFromUser:(NSString *)user_id content:(NSString *)content canvas:(NSInteger)canvas_id completion:(void (^)(NSDictionary* post, NSError *))completion
{
    NSDictionary *para = @{@"user_id" : user_id, @"content" : content, @"canvas_id" : @(canvas_id)};
    [_requestManager POST:@"/api/v1/posts" parameters:para success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if (completion) {
            NSString *errCode = [responseObject objectForKey:@"status"];
            if ([_errDict[errCode] isEqualToString:@"Success"]) {
                NSDictionary *post = @{@"id":[responseObject objectForKey:@"id"], @"content":[responseObject objectForKey:@"content"], @"canvas_id":[responseObject objectForKey:@"canvas_id"]};
                completion(post, nil);
            }
            else {
                NSError* err = [NSError errorWithDomain:@"Posts" code:[errCode integerValue] userInfo:@{@"detail": _errDict[errCode]}];
                completion(nil, err);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        if (completion) {
            completion(nil, error);
        }
    }];
}

- (void)fetchComments:(NSInteger)post_id completion:(void (^)(NSArray *, NSError *))completion
{
    NSDictionary *para = @{@"id" : @(post_id)};
    NSString *url = [NSString stringWithFormat:@"/api/v1/posts/%@/comments", @(post_id)];
    [_requestManager GET:url parameters:para success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if (completion) {
            NSString *errCode = [responseObject objectForKey:@"status"];
            if ([_errDict[errCode] isEqualToString:@"Success"]) {
                NSArray *arr = [responseObject objectForKey:@"comments"];
                completion(arr, nil);
            }
            else {
                NSError* err = [NSError errorWithDomain:@"Comments" code:[errCode integerValue] userInfo:@{@"detail": _errDict[errCode]}];
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

- (void)submitComment:(NSInteger)post_id fromUser:(NSString *)user_id withContent:(NSString *)content completion:(void (^)(bool, NSError *))completion
{
    
}

@end
