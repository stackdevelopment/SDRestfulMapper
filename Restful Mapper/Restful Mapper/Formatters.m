#import "Formatters.h"

@implementation Formatters
static NSDateFormatter *dateFormatter;
static NSDateFormatter *eventDateFormatter;
static NSDateFormatter *eventEndDateFormatter;
static NSDateFormatter *eventDateShrotFormatter;
static NSDateFormatter *dealsDateQueryFormatter;
static NSDateFormatter *sectionDateFormatter;

+ (NSDateFormatter *)dateFormatter {
  if (!dateFormatter) {
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SZ"];
  }
  return dateFormatter;
}

+ (NSDateFormatter *)eventDateFormatter {
  if (!eventDateFormatter) {
    eventDateFormatter = [[NSDateFormatter alloc] init];
    [eventDateFormatter setDateFormat:@"EEE, MMM dd, h:mm a"];
    [eventDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
  }
  return eventDateFormatter;
}

+ (NSDateFormatter *)eventDateShortFormatter {
  if (!eventDateShrotFormatter) {
    eventDateShrotFormatter = [[NSDateFormatter alloc] init];
    [eventDateShrotFormatter setDateFormat:@"EEEE, MMMM d"];
    [eventDateShrotFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
  }
  return eventDateShrotFormatter;
}

+ (NSDateFormatter *)eventEndDateFormatter {
  if (!eventEndDateFormatter) {
    eventEndDateFormatter = [[NSDateFormatter alloc] init];
    [eventEndDateFormatter setDateFormat:@"h:mma"];
    [eventEndDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
  }
  return eventEndDateFormatter;
}

+ (NSDateFormatter *)dealsDateQueryFormatter {
  if (!dealsDateQueryFormatter) {
    dealsDateQueryFormatter = [[NSDateFormatter alloc] init];
    [dealsDateQueryFormatter setDateFormat:@"yyyy-MM-dd"];
    [dealsDateQueryFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
  }
  return dealsDateQueryFormatter;
}

+ (NSDateFormatter *)sectionDateFormatter {
  if (!sectionDateFormatter) {
    sectionDateFormatter = [[NSDateFormatter alloc] init];
    [sectionDateFormatter setDateFormat:@"MMMM dd, yyyy"];
    [sectionDateFormatter setTimeZone:[NSTimeZone localTimeZone]];
  }
  return sectionDateFormatter;
}
@end
