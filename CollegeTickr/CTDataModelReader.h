//
//  CTDataModelReader.h
//  CollegeTickr
//
//  Created by Yan Zhang on 4/24/14.
//  Copyright (c) 2014 Yan Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTUserModel.h"
#import "CTSecretModel.h"
#import "CTCommentModel.h"

@interface CTDataModelReader : NSObject
+ (CTUserModel *)getUserModel:(NSDictionary*) userData;
+ (CTSecretModel *)getSecretModel:(NSDictionary*) secretData;
+ (CTCommentModel *)getCommentModel:(NSDictionary*) commentData;
@end
