//
//  ABJsonProcessor.m
//
//  Created by Avery Bloom on 5/9/13.
//  Copyright (c) 2013 Avery Bloom. All rights reserved.
//

#import "ABModelMap.h"
#import "ABJsonProcessor.h"
#import "NSString+InflectionSupport.h"
#import "NSObject+PropertySupport.h"
#import "ABHTTPSessionManager.h"
@implementation ABModelMap

-(id)init
{
	self = [super init];
	if (self)
	{
		self.mappingDictionary = [NSMutableDictionary dictionary];
		self.processingDictionary = [NSMutableDictionary dictionary];
		self.classMappingDictionary = [NSMutableDictionary dictionary];
		[self mapRawKey:@"id" toPropertyName:@"objectId"];
		[self mapRawKey:@"created_on" toPropertyName:@"createdOn" mapKey:ABMapRailsDateTimeToDate];
		[self mapRawKey:@"updated_at" toPropertyName:@"updatedAt" mapKey:ABMapRailsDateTimeToDate];
	
		[self setupMapping];
	}
	return self;
}
-(void)setupMapping
{
	[NSException raise:@"Mapping Error" format:@"Impropper Mapping!  Subclass of JsonProcessor not overriding setupMapping"];
}
-(void)mapRawKeysToCamelizedPropertyNames:(NSArray *)keyArray checkKeys:(BOOL)doCheck
{
	NSArray *propertyNames = (doCheck) ? [[self class] propertyNames] : nil;

	for (NSString *aKey in keyArray) {
		NSString *camelizedPropertyName = [aKey camelize];
		if (doCheck) {
			if ([propertyNames indexOfObject:camelizedPropertyName]== NSNotFound) {
				NSLog(@"WARNING!!! No known property name %@ in object %@", camelizedPropertyName, NSStringFromClass([self class]));
			}
		}
		[self mapRawKey:aKey toPropertyName:camelizedPropertyName];
	}
}

//Sets the processor to be an NSNumber of the enum mapKey
-(void)mapRawKey:(NSString *)aKey toPropertyName:(NSString *)aProperty mapKey:(ABModelMapType)mapKey
{
	if (aProperty == nil && aKey != nil) {
		aProperty = [aKey camelize];
	}
	[self mapRawKey:aKey toPropertyName:aProperty withProcessor:@(mapKey)];
}

//Sets the map key with a nil processor
-(void)mapRawKey:(NSString *)aKey toPropertyName:(NSString *)aProperty {
	[self mapRawKey:aKey toPropertyName:aProperty withProcessor:nil];
}

-(void)mapRawKeyOfArray:(NSString *)aKey ofClass:(Class)aClass toPropertyName:(NSString *)aProperty  {
	if (![aClass isSubclassOfClass:[ABModelMap class]])
	{
		[NSException raise:@"Mapping Error" format:@"Impropper Mapping! You can only aap an Array of with ABModelMap subclass"];
	}
	aProperty = (aProperty == nil) ? [aKey camelize] : aProperty;
	
	[self mapRawKey:aKey toPropertyName:aProperty withProcessor:nil];
	[self mapArrayPropertyName:aProperty withChildClass:aClass];
}

/*//Sets the map key with a class as a processor
-(void)mapRawKey:(NSString *)aKey toPropertyName:(NSString *)aProperty withClass:(Class)aClass
{
	if (![aClass isSubclassOfClass:[ABModelMap class]])
	{
		[NSException raise:@"Mapping Error" format:@"Impropper Mapping!  Must map a subclass of ABModelMap"];
	}
	[self mapRawKey:aKey toPropertyName:aProperty withProcessor:aClass];
}*/

-(void)mapRawKey:(NSString *)aKey toPropertyName:(NSString *)aProperty withBlock:(ProcessingBlock)aBlock
{
	[self mapRawKey:aKey toPropertyName:aProperty withProcessor:aBlock];
}

-(void)mapArrayPropertyName:(NSString *)aProperty withChildClass:(Class)aClass
{
	if (aClass != nil)
	{
		[_classMappingDictionary setObject:NSStringFromClass(aClass) forKey:aProperty];
	}else{
		[NSException raise:@"Mapping Error" format:@"Impropper Mapping! Setting a nil child class to array property"];
	}
}

//Does the actual assignment
-(void)mapRawKey:(NSString *)aKey toPropertyName:(NSString *)aProperty withProcessor:(id)aProcessor
{
	[_mappingDictionary setObject:aProperty forKey:aKey];
	if (aProcessor != nil)
	{
		[_processingDictionary setObject:aProcessor forKey:aKey];
	}else{
		//NSLog(@"Bad Map");
	}
}

#pragma mark Data Acquisition Methods
+(NSString *)relativePathComponent{
	return nil;
}

+(NSString *)absolutePath{
	return nil;
}

+(NSURL *)baseURL
{
	return [ABHTTPSessionManager sharedManager].baseURL;
}

+(void)getAllFromRemoteWithParams:(NSDictionary *)params successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failBlock{
	[self getFromRemoteAtPath:nil withParams:params successBlock:successBlock failureBlock:failBlock];
}

+(void)getFromRemoteAtPath:(NSString *)remotePath withParams:(NSDictionary *)params successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failBlock{
	
	ABHTTPSessionManager *manager = [ABHTTPSessionManager sharedManager];
	if (remotePath == nil) {
		remotePath = [self pathForAll];
	}
	
	if (remotePath == nil) {
		[NSException raise:@"ABModelMap Error" format:@"Either AbsolutePath needs to be set up in the subclass, or the AFHTTPRequestOperationManager base URL and this class relativePath must be set"];
	}
	[manager GET:remotePath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
		successBlock(responseObject);

	} failure:^(NSURLSessionDataTask *task, NSError *error) {
		manager.defaultRequestFailBlock(error);
		NSLog(@"Error loading Remote Path: %@", remotePath);
		failBlock(error);

	}];
	
	
}
+(void)postToRemotePath:(NSString *)remotePath withParams:(NSDictionary *)params successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failBlock{
	ABHTTPSessionManager *manager = [ABHTTPSessionManager sharedManager];
	if (remotePath == nil) {
		remotePath = [self pathForAll];
	}
	
	if (remotePath == nil) {
		[NSException raise:@"ABModelMap Error" format:@"Either AbsolutePath needs to be set up in the subclass, or the AFHTTPRequestOperationManager base URL and this class relativePath must be set"];
	}
	[manager POST:remotePath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
		successBlock(responseObject);
		
	} failure:^(NSURLSessionDataTask *task, NSError *error) {
		manager.defaultRequestFailBlock(error);

		NSLog(@"Error loading Remote Path: %@", remotePath);
		
		failBlock(error);
		
	}];

}
+(NSString *)pathForOne:(NSNumber *)key
{
	ABHTTPSessionManager *manager = [ABHTTPSessionManager sharedManager];
	NSString *remotePath = nil;

		if (manager.baseURL != nil && [self relativePathComponent] != nil) {
			NSURL *fullURL =[manager.baseURL URLByAppendingPathComponent:[self relativePathComponent]];
			fullURL = [fullURL URLByAppendingPathComponent:[key stringValue]];
			remotePath = [fullURL absoluteString];
		}else{
			NSURL *fullURL =[NSURL URLWithString:[self absolutePath]];
			fullURL = [fullURL URLByAppendingPathComponent:[key stringValue]];
			remotePath = [fullURL absoluteString];
		}
	
	return remotePath;
}

+(NSString *)pathForAll{
	NSString *remotePath = nil;
	
	ABHTTPSessionManager *manager = [ABHTTPSessionManager sharedManager];

	if (manager.baseURL != nil && [self relativePathComponent] != nil) {
		NSURL *fullURL =[manager.baseURL URLByAppendingPathComponent:[self relativePathComponent]];
		remotePath = [fullURL absoluteString];
	}else{
		remotePath = [[self class] absolutePath];
	}
	return remotePath;
}

+(void)getOneFromRemoteWithKey:(NSNumber*)key withParams:(NSDictionary *)params successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failBlock{
	[self getFromRemoteAtPath:[self pathForOne:key] withParams:params successBlock:successBlock failureBlock:failBlock];

}

@end
