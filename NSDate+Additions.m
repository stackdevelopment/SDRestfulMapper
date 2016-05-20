//
//  NSDate+Additions.m
//  h2
//
//  Created by Avery Bloom on 3/18/14.
//  Copyright (c) 2014 Plaor. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

+ (NSDate *)dateFromRailsString:(NSString*)dateString
{
    return [NSDate dateFromString:dateString withFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss' +0000'"];
}

+ (NSDate *)dateFromString:(NSString *)dateString
                withFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc]
                        initWithLocaleIdentifier:@"en_US_POSIX"];
    
    [dateFormatter setLocale:locale];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:dateFormat];
    
    return [dateFormatter dateFromString:dateString];
}

+ (NSString*)humanTimeDifferenceString:(NSDate *)otherDate{
	return [self humanTimeDifferenceString:otherDate madeExplicit:NO];
}

+ (NSString*)humanTimeDifferenceString:(NSDate *)otherDate madeExplicit:(BOOL)doExplicit
{
	NSDate * now = [NSDate date];
	BOOL isInThePast  = [otherDate mt_isOnOrBefore:now];
	int mins;
	int hours;
	int days;
	int weeks;
	NSString *humanString;
	
	if (isInThePast) {
		mins = abs((int)[otherDate mt_minutesUntilDate:now]);
		hours = abs((int)[otherDate mt_hoursUntilDate:now]);
		days = abs((int)[otherDate mt_daysUntilDate:now]);
		weeks = abs((int)[otherDate mt_weeksUntilDate:now]);
	}else{
		mins = abs((int)[otherDate mt_minutesSinceDate:now]);
		hours = abs((int)[otherDate mt_hoursSinceDate:now]);
		days = abs((int)[otherDate mt_daysSinceDate:now]);
		weeks = abs((int)[otherDate mt_weeksSinceDate:now]);
	}
	if (mins <1) {
		humanString = @"now";//[NSString stringWithFormat:@"%dm", mins];
	}else if (mins < 60) {
		
		humanString = [NSString stringWithFormat:@"%dm", mins];
	}else if ( hours <24) {
		humanString = [NSString stringWithFormat:@"%dh", hours];
	}else if (days < 7)
	{
		humanString = [NSString stringWithFormat:@"%dd", days];
		
	}else if (weeks >0)
	{
		humanString = [NSString stringWithFormat:@"%dw", weeks];
	}
	
	if (doExplicit) {
		humanString = (isInThePast && ![humanString isEqualToString:@"now"]) ? [NSString stringWithFormat:@"%@ ago", humanString] : [NSString stringWithFormat:@"in %@", humanString];
		
	}
	return humanString;
	
}
@end
