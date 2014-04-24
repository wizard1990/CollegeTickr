//
//  CTUserModel.h
//  CollegeTickr
//
//  Created by Max Gu on 4/24/14.
//  Copyright (c) 2014 Yan Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTUserModel : NSObject

@property (readonly, nonatomic, strong) NSString *uid;
@property (readonly, nonatomic, strong) NSString *firstName;
@property (readonly, nonatomic, strong) NSString *lastName;
@property (readonly, nonatomic, strong) NSString *location;


- (instancetype)initWithId: (NSString *)uid firstName: (NSString *)fn lastName: (NSString *)ln andLocation: (NSString *)location;

@end
