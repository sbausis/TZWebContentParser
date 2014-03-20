//
//  TZHtmlRawParser.m
//  WebContentParser
//
//  Created by Simon Baur on 11/14/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZHtmlRawParser.h"

@implementation TZHtmlRawParser {
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
#pragma mark NSHTMLParserDelegate

-(void)parserDidStartDocument:(DTHTMLParser *)parser {
    TZLog(@"%s:", __FUNCTION__);
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    TZLog(@"%s: %@ %@", __FUNCTION__, elementName, attributeDict);
}
-(void)parser:(DTHTMLParser *)parser foundCharacters:(NSString *)string {
    NSString *newString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([newString length] > 0) {
        TZLog(@"%s: %@", __FUNCTION__, string);
    }
}
-(void)parser:(DTHTMLParser *)parser foundComment:(NSString *)comment {
    NSString *newString = [comment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([newString length] > 0) {
        TZLog(@"%s: %@", __FUNCTION__, comment);
    }
}
-(void)parser:(DTHTMLParser *)parser foundCDATA:(NSData *)CDATABlock {
    TZLog(@"%s: %lu", __FUNCTION__, (unsigned long)[CDATABlock length]);
}
-(void)parser:(DTHTMLParser *)parser foundProcessingInstructionWithTarget:(NSString *)target data:(NSString *)data {
    TZLog(@"%s: %@ %lu", __FUNCTION__, target, (unsigned long)[data length]);
}
-(void)parser:(DTHTMLParser *)parser didEndElement:(NSString *)elementName {
    TZLog(@"%s: %@", __FUNCTION__, elementName);
}
-(void)parser:(DTHTMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    TZLog(@"%s: %@ line:%ld column:%ld", __FUNCTION__, parseError, (long)[parser lineNumber], (long)[parser columnNumber]);
    [errors addObject:[parseError copy]];
}
-(void)parserDidEndDocument:(DTHTMLParser *)parser {
    TZLog(@"%s: Errors: %lu %@", __FUNCTION__, (unsigned long)[errors count], errors);
    if ([self.dataDict count] > 0) {
        [self.htmlParserDelegate htmlParserDidEnd:self];
    }
    else {
        [self.htmlParserDelegate htmlParserDidFail:self];
    }
}

@end
