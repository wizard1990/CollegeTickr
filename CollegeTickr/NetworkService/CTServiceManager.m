//
//  CTServiceManager.m
//  CollegeTickr
//
//  Created by Yan Zhang on 4/16/14.
//  Copyright (c) 2014 Yan Zhang. All rights reserved.
//

#import "CTServiceManager.h"

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
        _requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}


@end
