//
//  ABJsonProcessor.h
//
//  Created by Avery Bloom on 5/9/13.
//  Copyright (c) 2013 Avery Bloom. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ABJsonProcessor;

@interface ABModelMap : NSObject
typedef NSObject* (^ ProcessingBlock)(id anObject);
typedef void(^ SuccessBlock)(id responseObject);
typedef void(^ FailureBlock)(NSError *error);

typedef enum {
	ABMapToFloatNumber,
	ABMapToBool,
	ABMapRailsDateToDate,
	ABMapRailsDateTimeToDate,
	ABMapRailsDateTimeZoneToDate
	
			 } ABModelMapType;

@property (nonatomic, strong) NSMutableDictionary *processingDictionary;
@property (nonatomic, strong) NSMutableDictionary *mappingDictionary;
@property (nonatomic, strong) NSMutableDictionary *classMappingDictionary;

@property (nonatomic, strong) NSNumber *objectId;
@property (nonatomic, strong) NSDate *createdOn;
@property (nonatomic, strong) NSDate *updatedAt;

-(void)setupMapping;
-(void)mapRawKey:(NSString *)aKey toPropertyName:(NSString *)aProperty withBlock:(ProcessingBlock)aBlock;
-(void)mapRawKey:(NSString *)aKey toPropertyName:(NSString *)aProperty;
-(void)mapRawKey:(NSString *)aKey toPropertyName:(NSString *)aProperty mapKey:(ABModelMapType)mapKey;
-(void)mapRawKeyOfArray:(NSString *)aKey ofClass:(Class)aClass toPropertyName:(NSString *)aProperty;


//Remote Data Methods. 
+(NSString *)relativePathComponent;
+(NSString *)absolutePath;
+(void)getAllFromRemoteWithParams:(NSDictionary *)params successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failBlock;
+(void)getFromRemoteAtPath:(NSString *)remotePath withParams:(NSDictionary *)params successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failBlock;

+(void)postToRemotePath:(NSString *)remotePath withParams:(NSDictionary *)params successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failBlock;


+(void)getOneFromRemoteWithKey:(NSNumber*)key withParams:(NSDictionary *)params successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failBlock;

//For added convenience
+(NSURL *)baseURL;

+(NSString *)pathForOne:(NSNumber *)key;
+(NSString *)pathForAll;

-(void)mapRawKeysToCamelizedPropertyNames:(NSArray *)keyArray checkKeys:(BOOL)doCheck;


@end
