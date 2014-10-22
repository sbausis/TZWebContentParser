//
//  TZ_thepiratebay_PageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/15/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZ_thepiratebay_PageParser.h"

@implementation TZ_thepiratebay_PageParser {
    BOOL hasDocument;
    BOOL hasDownloads;
    BOOL hasMagnet;
    
    NSString *str;
}

#pragma mark -
#pragma mark NSHTMLParserDelegate

-(void)parserDidStartDocument:(DTHTMLParser *)parser {
    
    TZLog(@"%s", __FUNCTION__);
    self.dataDict = [[NSMutableDictionary alloc] init];
    
    hasDocument = NO;
    hasDownloads = NO;
    hasMagnet = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    if (hasDocument) {
        if (hasDownloads) {
            if (hasMagnet) {
                
            }
            else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=7 && [[str substringToIndex:7] isEqualToString:@"magnet:"]) {
                hasMagnet = YES;
                TZLog(@"%s: a : Magnet", __FUNCTION__);
                TZLog(@"attributes: %@", attributeDict);
                [self.dataDict setObject:[str copy] forKey:@"Magnet"];
            }
        }
        else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"download"]) {
            hasDownloads = YES;
            TZLog(@"%s: div : Downloads", __FUNCTION__);
            TZLog(@"attributes: %@", attributeDict);
        }
    }
    else if ([elementName isEqualToString:@"html"]) {
        hasDocument = YES;
        TZLog(@"%s: html : Document", __FUNCTION__);
    }
}
-(void)parser:(DTHTMLParser *)parser didEndElement:(NSString *)elementName {
    
    if (hasDocument) {
        if (hasDownloads) {
            if (hasMagnet) {
                if ([elementName isEqualToString:@"a"]) {
                    hasMagnet = NO;
                    TZLog(@"%s: a : Magnet", __FUNCTION__);
                }
            }
            else if ([elementName isEqualToString:@"div"]) {
                hasDownloads = NO;
                TZLog(@"%s: div : Downloads", __FUNCTION__);
            }
        }
        else if ([elementName isEqualToString:@"html"]) {
            hasDocument = NO;
            TZLog(@"%s: html : Document", __FUNCTION__);
        }
    }
}

@end

@implementation TZ_baymirror_PageParser

@end
