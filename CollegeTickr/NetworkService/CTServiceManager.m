//
//  CTServiceManager.m
//  CollegeTickr
//
//  Created by Yan Zhang on 4/16/14.
//  Copyright (c) 2014 Yan Zhang. All rights reserved.
//

#import "CTServiceManager.h"

NSString* baseUrl = @"";

@interface CTServiceManager()
@property (nonatomic, strong) AFHTTPSessionManager *requestManager;
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
    }
    return self;
}

- (void)loginWithUserId:(NSString *)userId FBToken:(NSString *)token Completion:(void (^)(bool))completion
{
    NSDictionary *para = @{@"id" : userId, @"token" : token};
    _requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [_requestManager POST:@"/users" parameters:para success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if (completion) {
            if ([[responseObject objectForKey:@"status"]  isEqual: @(200)]) {
                completion(YES);
            }
            else completion(NO);
        }
        else {
            //todo::error handler
            if (completion) {
                completion(NO);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        if (completion) {
            completion(NO);
        }
    }];
}

@end
