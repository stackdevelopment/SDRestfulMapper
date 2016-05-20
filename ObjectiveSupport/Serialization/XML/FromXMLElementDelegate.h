//
//  FromXMLElementDelegate.h
//  
//
//  Created by Ryan Daigle on 7/31/08.
//  Copyright 2008 yFactorial, LLC. All rights reserved.
//

@interface FromXMLElementDelegate : NSObject {
  id parsedObject;
	NSString *currentPropertyName;
  NSMutableString *contentOfCurrentProperty;
	NSMutableArray *unclosedProperties;
	NSString *currentPropertyType;
}

@property (nonatomic, strong) Class targetClass;
@property (nonatomic, strong) id parsedObject;
@property (nonatomic, strong) NSString *currentPropertyName;
@property (nonatomic, strong) NSMutableString *contentOfCurrentProperty;
@property (nonatomic, strong) NSMutableArray *unclosedProperties;
@property (nonatomic, strong) NSString *currentPropertyType;

+ (FromXMLElementDelegate *)delegateForClass:(Class)targetClass;

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
- (NSString *)convertElementName:(NSString *)anElementName;

@end
