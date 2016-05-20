#import <Foundation/Foundation.h>

@interface Formatters : NSObject
+ (NSDateFormatter *)dateFormatter;
+ (NSDateFormatter *)eventDateFormatter;
+ (NSDateFormatter *)eventDateShortFormatter;
+ (NSDateFormatter *)eventEndDateFormatter;
+ (NSDateFormatter *)dealsDateQueryFormatter;
+ (NSDateFormatter *)sectionDateFormatter;
@end
