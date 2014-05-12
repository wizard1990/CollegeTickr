//
//  CTCommentModel.m
//  CollegeTickr
//
//  Created by Max Gu on 4/24/14.
//  Copyright (c) 2014 Yan Zhang. All rights reserved.
//

#import "CTCommentModel.h"

@implementation CTCommentModel

- (instancetype) initWithCommentId:(NSInteger)comment_id withContent:(NSString *)content withOwnerId:(NSString *)owner_id andAvatarUrl:(NSString *)url
{
    self = [super init];
    if(self)
    {
        _comment_id = comment_id;
        _content = content;
        _owner_id = owner_id;
        _avatar_url = url;
    }
    return self;
    
}
@end
