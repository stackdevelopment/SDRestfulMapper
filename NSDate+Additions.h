//
//  NSDate+Additions.h
//  h2
//
//  Created by Avery Bloom on 3/18/14.
//  Copyright (c) 2014 Plaor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)

+ (NSDate *)dateFromRailsString:(NSString*)dateString;
+ (NSDate *)dateFromString:(NSString *)dateString
                withFormat:(NSString *)dateFormat;
+ (NSString*)humanTimeDifferenceString:(NSDate *)otherDate;
+ (NSString*)humanTimeDifferenceString:(NSDate *)otherDate madeExplicit:(BOOL)doExplicit;

@end
