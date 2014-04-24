//
//  CTUserModel.m
//  CollegeTickr
//
//  Created by Max Gu on 4/24/14.
//  Copyright (c) 2014 Yan Zhang. All rights reserved.
//

#import "CTUserModel.h"

@interface CTUserModel()

@property (readwrite, nonatomic, strong) NSString *uid;
@property (readwrite, nonatomic, strong) NSString *firstName;
@property (readwrite, nonatomic, strong) NSString *lastName;
@property (readwrite, nonatomic, strong) NSString *location;

@end
@implementation CTUserModel

- (instancetype)initWithId: (NSString *)uid firstName: (NSString *)fn lastName: (NSString *)ln andLocation: (NSString *)location
{
    self = [super init];
    if(self)
    {
        _uid = uid;
        _firstName = fn;
        _lastName = ln;
        _location = location;
    }
    return self;
}

@end
