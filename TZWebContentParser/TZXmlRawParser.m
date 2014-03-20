//
//  TZXmlRawParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/14/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZXmlRawParser.h"

@implementation TZXmlRawParser {
    NSMutableArray *errors;
}

-(id)initWithData:(NSData *)data {
    self = [super initWithData:data];
    if (self) {
        
        errors = [[NSMutableArray alloc] init];
        [self setDelegate:self];
    }
    
    return self;
}

#pragma mark -
#pragma mark NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    TZLog(@"%s:", __FUNCTION__);
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName attributes: (NSDictionary *)attributeDict {
    TZLog(@"%s: %@ %@ %@ %@", __FUNCTION__, elementName, namespaceURI, qName, attributeDict);
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSString *newString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([newString length] > 0) {
        TZLog(@"%s: %@", __FUNCTION__, string);
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    TZLog(@"%s: %@ %@ %@", __FUNCTION__, elementName, namespaceURI, qName);
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    TZLog(@"%s: %@ line:%ld column:%ld", __FUNCTION__, parseError, (long)[parser lineNumber], (long)[parser columnNumber]);
    [errors addObject:[parseError copy]];
}
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    TZLog(@"%s: Errors: %lu %@", __FUNCTION__, (unsigned long)[errors count], errors);
    if ([self.dataDict count] > 0) {
        [self.xmlParserDelegate xmlParserDidEnd:self];
    }
    else {
        [self.xmlParserDelegate xmlParserDidFail:self];
    }
}

@end
