//
//  XMLUtils.h
//  Celery
//
//  Created by Yewberry on 11-5-26.
//  Copyright 2011 Huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface XMLUtils : NSObject {

}

+ (GDataXMLDocument*) initDocumentWithFile:(NSString *) fileName;
+ (GDataXMLDocument*) initDocumentWithString:(NSString *) str;
+ (GDataXMLDocument*) initDocumentWithData:(NSData *) xmlData;

+ (void) writeToFile:(NSString *) fileName withDoc:(GDataXMLDocument*)doc;

+ (NSString *) stringValueOfChild:(GDataXMLElement *)parentElem forName:(NSString *) childName; 
+ (void) addAttributeToElement:(GDataXMLElement *)elem withName:(NSString *)attrName andValue:(NSString *)attrValue;

+ (NSString *) dataFilePath:(NSString *)fileName withSaveFlag:(BOOL)forSave;

@end
