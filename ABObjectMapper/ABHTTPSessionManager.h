//
//  ABHTTPSessionManager.h
//  Fugu
//
//  Created by Avery Bloom on 6/5/14.
//  Copyright (c) 2014 Home Team Productions. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "ABModelMap.h"
@interface ABHTTPSessionManager : AFHTTPSessionManager
+(ABHTTPSessionManager*)sharedManager;
+(void)setBaseUrl:(NSString *)baseUrl;
@property (nonatomic, copy) FailureBlock defaultRequestFailBlock;
@end
