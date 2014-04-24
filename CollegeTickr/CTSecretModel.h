//
//  CTSecretModel.h
//  CollegeTickr
//
//  Created by Max Gu on 4/24/14.
//  Copyright (c) 2014 Yan Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTSecretModel : NSObject

@property(readonly, nonatomic, strong) NSString *content;
@property(readonly, nonatomic, assign) NSInteger secret_id;
@property(readonly, nonatomic, assign) NSInteger canvas_id;
@property(readonly, nonatomic, assign) NSInteger likes;

- (instancetype)initWithSecretId: (NSInteger)secret_id canvasId: (NSInteger)canvas_id content: (NSString *)content andLikes: (NSInteger)likes;

@end
