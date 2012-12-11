//
//  XMLUtils.m
//  Celery
//
//  Created by Yewberry on 11-5-26.
//  Copyright 2011 Huawei. All rights reserved.
//

#import "XMLUtils.h"


@implementation XMLUtils

+ (GDataXMLDocument*) initDocumentWithFile:(NSString *)fileName {
	NSString *path = fileName;//[XMLUtils dataFilePath:fileName withSaveFlag:NO];
	
	NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:path];
    NSError *error;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc]
							  initWithData:xmlData
								   options:0
									 error:&error] autorelease];
    [xmlData release];
    
	if(doc == nil){ return nil; }
	return doc;
}

+ (GDataXMLDocument*) initDocumentWithString:(NSString *)str {
	NSError *error;
	GDataXMLDocument *doc = [[[GDataXMLDocument alloc]
							  initWithXMLString:str
										options:0
										  error:&error] autorelease];
	if(doc == nil){ return nil; }
	return doc;
}

+ (GDataXMLDocument*) initDocumentWithData:(NSData *)xmlData {
    NSError *error;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc]
							 initWithData:xmlData
							 options:0
							 error:&error] autorelease];
	if(doc == nil){ return nil; }
	return doc;	
}

+ (void) writeToFile:(NSString *) fileName withDoc:(GDataXMLDocument*) doc {
	NSString *filePath = [XMLUtils dataFilePath:fileName withSaveFlag:YES];
	NSData *xmlData = doc.XMLData;
	[xmlData writeToFile:filePath atomically:YES];
}

+ (NSString *) stringValueOfChild:(GDataXMLElement *)parentElem forName:(NSString *)childName
{
	NSArray *arr = [parentElem elementsForName:childName];
	if (arr.count > 0) {
		GDataXMLElement *el = (GDataXMLElement *) [arr objectAtIndex:0];
		return el.stringValue;
	}
	
	return nil;
}

+ (void) addAttributeToElement:(GDataXMLElement *)elem withName:(NSString *)attrName andValue:(NSString *)attrValue
{
	GDataXMLNode *attr = [GDataXMLNode attributeWithName:attrName stringValue:attrValue];
	[elem addAttribute:attr];
}

+ (NSString *) dataFilePath:(NSString *)fileName withSaveFlag:(BOOL)forSave {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
														 NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [[documentsDirectory
							   stringByAppendingPathComponent:fileName] stringByAppendingFormat:@".xml"];
	
    if (forSave || 
        [[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        return documentsPath;
    } else {
        return [[NSBundle mainBundle] pathForResource:fileName ofType:@"xml"];
    }
	
}

@end
