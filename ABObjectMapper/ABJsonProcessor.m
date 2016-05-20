//
//  ABJsonMapper.m
//
//  Created by Avery Bloom on 5/8/13.
//  Copyright (c) 2014 Avery Bloom. All rights reserved.
//

#import "ABJsonProcessor.h"
#import "NSObject+PropertySupport.h"
#import "ABModelMap.h"
#import <objc/runtime.h>
#import "ObjectiveResourceDateFormatter.h"
@implementation ABJsonProcessor


+(NSObject *)processData:(NSDictionary *)rawObject intoObjectClass:(Class)aClass
{
	
	if (![aClass isSubclassOfClass:[ABModelMap class]])
	{
		[NSException raise:@"Model Mapping Error" format:@"Attempting to processing into a non-ModelMap subclass %@ -- %@", NSStringFromClass(aClass), rawObject];
	}
	ABModelMap * newObject = [[aClass alloc] init];
	NSMutableDictionary *processedContent = [NSMutableDictionary dictionary];
	NSArray *propertyNames = [aClass propertyNames];
	NSDictionary *namesAndTypes = [aClass propertyNamesAndTypes];

	
	for (NSString *aKey in [newObject.mappingDictionary allKeys]) {
		NSObject * objectToSet = [rawObject objectForKey:aKey];
		NSString * propertyName = [newObject.mappingDictionary objectForKey:aKey];
		Class propertyClass = NSClassFromString([namesAndTypes objectForKey: propertyName]);
		
		//NSLog(@"Checking class Name - %@ for Property - %@", NSStringFromClass(propertyClass), propertyName);
		if (objectToSet != nil) {
			if ([propertyNames indexOfObject:propertyName]!= NSNotFound )
				 {
					
					NSObject* process = [newObject.processingDictionary objectForKey:aKey];
					NSString* arrayChildClassName = [newObject.classMappingDictionary objectForKey:propertyName];
					 
					 
					if (process != nil)
					{
						BOOL processWithModel = class_isMetaClass(object_getClass(process));
						BOOL processWithMapType = [process isKindOfClass:[NSNumber class]];
						BOOL processWithBlock =  (!processWithMapType && !processWithModel);
						
						
						
						//Processing with a specified block
						if ( processWithMapType)
						{
							objectToSet = [self processWithType:[(NSNumber *)process intValue] withObject:objectToSet];
							//NSLog(@"Process With Map Type %@", [(NSNumber *)process stringValue]);
						}else if (processWithBlock)
						{
							ProcessingBlock aBlock = (ProcessingBlock)process;
							objectToSet = aBlock(objectToSet);
							//NSLog(@"Process With Block");
							
						}
					}else if([propertyClass isSubclassOfClass:[ABModelMap class]])
					{
						if ([objectToSet isKindOfClass:[NSDictionary class]])
						{
							NSDictionary *dictToConvert = (NSDictionary *)objectToSet;

							objectToSet = [ABJsonProcessor processData:dictToConvert intoObjectClass:NSClassFromString([namesAndTypes objectForKey: propertyName])];
						}
						NSLog(@"Processing %@ Into Model %@", propertyName, NSStringFromClass(propertyClass));
						
					}else if (arrayChildClassName != nil)
					{
						NSDictionary *dictToConvert;

					
						NSArray * arrayObject = (NSArray *)objectToSet;
						NSMutableArray * processedArray = [NSMutableArray array];
						
						for (int i=0; i< arrayObject.count; i++) {
							dictToConvert = [arrayObject objectAtIndex:i];
							NSObject *processedObject = [ABJsonProcessor processData:dictToConvert intoObjectClass:NSClassFromString(arrayChildClassName)];
							[processedArray addObject:processedObject];
						}
						objectToSet = ([objectToSet isKindOfClass:[NSMutableArray class]])? processedArray : [NSArray arrayWithArray:processedArray];
					}else{
					}
					if ([self isClean:objectToSet])
					{
						[processedContent setObject:objectToSet forKey:propertyName];
					}

				 }else{
					 NSLog(@"Warning :: Invalid Property Name %@ set on target class %@", propertyName, NSStringFromClass(aClass));
				 }
		}else{
			NSLog(@"Tried to set nil object for property %@", propertyName);
		}
	}
	[newObject setProperties:processedContent];
	return newObject;
}
+(NSArray *)processArrayOfObjects:(NSArray *)objectArray withClass:(Class)aClass
{
	if (![aClass isSubclassOfClass:[ABModelMap class]]) {
		NSLog(@"Warning :: Invalid Property Name set on target class %@",  NSStringFromClass(aClass));
		return nil;
	}
	NSMutableArray *processedArray = [NSMutableArray array];
	for (int i=0; i<objectArray.count; i++) {
		NSObject *processedObject = [self processData:[objectArray objectAtIndex:i] intoObjectClass:[aClass class]];
		[processedArray addObject:processedObject];

	}
	return [NSArray arrayWithArray:processedArray];
}

+(id)processWithType:(ABModelMapType)aType withObject:(NSObject *)anObject
{
	
	switch (aType) {
		case ABMapToFloatNumber:
			if ([anObject isKindOfClass:[NSString class]])
			{
				anObject = [NSNumber numberWithFloat:[(NSString *) anObject floatValue]];
			}
			break;
		case ABMapRailsDateTimeToDate:
			if ([anObject isKindOfClass:[NSString class]])
			{
				anObject = [ObjectiveResourceDateFormatter parseDateTime:(NSString *)anObject];
			}
			
			break;
		case ABMapRailsDateToDate:
			if ([anObject isKindOfClass:[NSString class]])
			{
				anObject = [ObjectiveResourceDateFormatter parseDate:(NSString *)anObject];
			}
			
			break;
		case ABMapToBool:
			if (anObject != nil && ![anObject isMemberOfClass:[NSNull class]])
			{
				return @([(NSNumber *)anObject boolValue]);
			}else{
				return [NSNumber numberWithBool:NO];
			}
			
			break;
			
		default:
			break;
	}
	return anObject;
}

+(BOOL)isClean:(NSObject *)anObject
{
	return (anObject == nil || [anObject isMemberOfClass:[NSNull class]])? NO : YES;
}

@end
