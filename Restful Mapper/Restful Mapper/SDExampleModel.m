
#import "SDExampleModel.h"
#import "ABJsonProcessor.h"
#import "Formatters.h"

@implementation SDExampleModel

-(void)setupMapping
{
    [self mapArrayOfRawKeysToPropertyWithSameName:@[@"name",
                                                    @"address",
                                                    @"latitude",
                                                    @"longitude"]];
    
    [self mapRawKey:@"description" toPropertyName:@"desc"];
    [self mapRawKey:@"venue_name" toPropertyName:@"venueName"];
    [self mapRawKey:@"user_id" toPropertyName:@"ownerUserId"];
    [self mapRawKey:@"start" toPropertyName:@"startDate" mapKey:ABMapRailsDateTimeToDate];
    [self mapRawKey:@"end" toPropertyName:@"endDate" mapKey:ABMapRailsDateTimeToDate];
    [self mapRawKey:@"upstream_pic_url" toPropertyName:@"upstreamPicUrl"];
    [self mapRawKeyOfArray:@"test_array" ofClass:[SDAnotherClass class] toPropertyName:@"anArray"];
}

-(void)postParse:(NSDictionary *)rawObject
{
       //Do something fun
}

+(NSString *)relativePathComponent
{
    return @"events.json";
}

+(void)getEvents:(NSDictionary *)params successBlock:(SuccessBlock)successBlk failureBlock:(FailureBlock)failBlock
{
    [self getAllFromRemoteWithParams:params successBlock:^(id responseObject) {
        
        NSArray *events = [ABJsonProcessor processArrayOfObjects:responseObject withClass:[SDExampleModel class]];
        NSLog(@"Got some Events! %@", events);
        successBlk(events);
        
    } failureBlock:^(NSError *error) {
        NSLog(@"Error loading Events!");
        failBlock(error);

    }];
}

+ (NSDictionary *)createQueryParamsWithDaysAhead:(NSUInteger)daysAhead andFilterString:(NSString *)filterString andLocation:(CLLocation *)location andStart:(NSDate *)start andLimit:(NSInteger)limit andOffset:(NSInteger)offset anotherArray:(NSArray *)anArray {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (filterString != nil) {
        [params setObject:[filterString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"filter_string"];
    }
    if (start != nil) {
        [params setObject:[[Formatters dateFormatter] stringFromDate:start] forKey:@"start"];
    }
    if (daysAhead) {
        [params setObject:[NSNumber numberWithUnsignedInteger:daysAhead] forKey:@"days_ahead"];
    }
    if (location != nil) {
        [params setObject:[NSNumber numberWithDouble:location.coordinate.latitude] forKey:@"latitude"];
        [params setObject:[NSNumber numberWithDouble:location.coordinate.longitude] forKey:@"longitude"];
        [params setObject: [NSNumber numberWithBool:YES] forKey:@"nearby_query"];
    }
    if (limit) {
        [params setObject:[NSNumber numberWithInteger:limit] forKey:@"limit"];
    }
    if (offset) {
        [params setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    }
    if (anArray != nil && anArray.count > 0) {
        // AFNetworking will expand this to be an_array[]=an_Array&a_name=[]anItem2,
        // which is understood by Rails to be an array
        NSMutableArray *items = [NSMutableArray array];
        for (SDAnotherClass *anItem in items) {
            [items addObject:anItem.name];
        }
        params[@"names"] = items;
        NSLog(@"Searching for item %@", items);
    }
    
    return params;
}

@end
