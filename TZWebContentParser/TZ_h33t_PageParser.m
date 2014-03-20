//
//  TZ_h33t_PageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 1/19/14.
//  Copyright (c) 2014 Simon Baur. All rights reserved.
//

#import "TZ_h33t_PageParser.h"

@implementation TZ_h33t_PageParser {
    BOOL hasDocument;
    BOOL hasContent;
    BOOL hasTorrent;
    BOOL hasMagnet;
    
    NSString *str;
}

#pragma mark -
#pragma mark NSHTMLParserDelegate

-(void)parserDidStartDocument:(DTHTMLParser *)parser {
    
    TZLog(@"%s", __FUNCTION__);
    self.dataDict = [[NSMutableDictionary alloc] init];
    
    hasDocument = NO;
    hasContent = NO;
    hasTorrent = NO;
    hasMagnet = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    if (hasDocument) {
        if (hasContent) {
            if (hasTorrent) {
                
            }
            else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=19 && [[str substringToIndex:19] isEqualToString:@"http://h33t.to/get/"]) {
                hasTorrent = YES;
                TZLog(@"%s: a : Torrent", __FUNCTION__);
                TZLog(@"attributes: %@", attributeDict);
                [self.dataDict setObject:[str copy] forKey:@"Torrent"];
            }
            else if (hasMagnet) {
                
            }
            else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=7 && [[str substringToIndex:7] isEqualToString:@"magnet:"]) {
                hasMagnet = YES;
                TZLog(@"%s: a : Magnet", __FUNCTION__);
                TZLog(@"attributes: %@", attributeDict);
                [self.dataDict setObject:[str copy] forKey:@"Magnet"];
            }
        }
        else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"style"] isEqualToString:@"width:180; text-align:center; vertical-align:top;"]) {
            hasContent = YES;
            TZLog(@"%s: div : Content", __FUNCTION__);
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
        if (hasContent) {
            if (hasTorrent) {
                if ([elementName isEqualToString:@"a"]) {
                    hasTorrent = NO;
                    TZLog(@"%s: a : Torrent", __FUNCTION__);
                }
            }
            else if (hasMagnet) {
                if ([elementName isEqualToString:@"a"]) {
                    hasMagnet = NO;
                    TZLog(@"%s: a : Magnet", __FUNCTION__);
                }
            }
            else if ([elementName isEqualToString:@"div"]) {
                hasContent = NO;
                TZLog(@"%s: div : Content", __FUNCTION__);
            }
        }
        else if ([elementName isEqualToString:@"html"]) {
            hasDocument = NO;
            TZLog(@"%s: html : Document", __FUNCTION__);
        }
    }
}

@end