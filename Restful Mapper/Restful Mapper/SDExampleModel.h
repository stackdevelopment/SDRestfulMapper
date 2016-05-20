

#import "ABModelMap.h"

@interface SDExampleModel : ABModelMap
@property (strong, nonatomic) NSNumber *ownerUserId; //
@property (strong, nonatomic) NSString *name; //
@property (strong, nonatomic) NSString *desc;//
@property (strong, nonatomic) NSString *venueName;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSNumber *updatesCount;
@property (strong, nonatomic) NSDate *startDate;//
@property (strong, nonatomic) NSDate *endDate;//
@property (strong, nonatomic) NSString *upstreamPicThumbUrl;
@property (strong, nonatomic) NSString *upstreamPicUrl;
@property (strong, nonatomic) NSDecimalNumber *latitude; //
@property (strong, nonatomic) NSDecimalNumber *longitude; //
@property (strong, nonatomic) NSDecimalNumber *distanceFromHere;
@property (strong, nonatomic) NSNumber *totalAttending;
@property (strong, nonatomic) NSNumber *totalCheckins;
@property (strong, nonatomic) NSString *distanceString;
@property (strong, nonatomic) CLLocation *eventLocation;
@property (nonatomic, strong) NSArray *anArray;
@property (nonatomic, strong) NSURL *mapUrl;
+(void)getEvents:(NSDictionary *)params successBlock:(SuccessBlock)successBlk failureBlock:(FailureBlock)failBlock;


+ (NSDictionary *)createQueryParamsWithDaysAhead:(NSUInteger)daysAhead andFilterString:(NSString *)filterString andLocation:(CLLocation *)location andStart:(NSDate *)start andLimit:(NSInteger)limit andOffset:(NSInteger)offset anotherArray:(NSArray *)anArray;


@end
