//
//  CTSecretModel.m
//  CollegeTickr
//
//  Created by Max Gu on 4/24/14.
//  Copyright (c) 2014 Yan Zhang. All rights reserved.
//

#import "CTSecretModel.h"

@implementation CTSecretModel

-(instancetype)initWithSecretId:(NSInteger)secret_id canvasId:(NSInteger)canvas_id content:(NSString *)content andLikes:(NSInteger)likes
{
    self = [super init];
    if(self)
    {
        _secret_id = secret_id;
        _canvas_id = canvas_id;
        _content = content;
        _likes = likes;
    }
    return self;
}
@end
