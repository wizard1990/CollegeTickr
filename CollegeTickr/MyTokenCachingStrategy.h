//
//  MyTokenCachingStrategy.h
//  CollegeTickr
//
//  Created by Max Gu on 4/17/14.
//  Copyright (c) 2014 Yan Zhang. All rights reserved.
//

#import <FacebookSDK/FBSessionTokenCachingStrategy.h>

@interface MyTokenCachingStrategy : FBSessionTokenCachingStrategy

- (NSDictionary *) readData;
@end
