//
//  ABHTTPSessionManager.m
//  Fugu
//
//  Created by Avery Bloom on 6/5/14.
//  Copyright (c) 2014 Home Team Productions. All rights reserved.
//

#import "ABHTTPSessionManager.h"

@implementation ABHTTPSessionManager
static NSString * BASEURL = nil;

+(ABHTTPSessionManager*)sharedManager {
    static ABHTTPSessionManager *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
		NSURL *base = [NSURL URLWithString:BASEURL];
		NSLog(@"CHecking Base Url %@", BASEURL);

        __instance = [[ABHTTPSessionManager alloc]initWithBaseURL:base];
    });
    return __instance;
}
+(void)setBaseUrl:(NSString *)baseUrl
{
	BASEURL = baseUrl;
	NSLog(@"CHecking Base Url %@", BASEURL);
}
@end
