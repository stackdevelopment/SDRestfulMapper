//
//  ABJsonMapper.h
//
//  Created by Avery Bloom on 5/8/13.
//  Copyright (c) 2013 Avery Bloom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABJsonProcessor : NSObject
+(NSObject *)processData:(NSDictionary *)rawObject intoObjectClass:(Class)aClass;
+(NSArray *)processArrayOfObjects:(NSArray *)objectArray withClass:(Class)aClass;

@end
