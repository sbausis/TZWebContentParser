//
//  TZ_vertor_PageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/16/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZ_vertor_PageParser.h"

@implementation TZ_vertor_PageParser {
    BOOL hasDocument;
    BOOL hasDownloads;
    BOOL hasLine;
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
    hasDownloads = NO;
    hasLine = NO;
    hasTorrent = NO;
    hasMagnet = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    if (hasDocument) {
        if (hasDownloads) {
            if (hasLine) {
                if (hasTorrent) {
                    
                }
                else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=31 && [[str substringToIndex:31] isEqualToString:@"http://www.vertor.com/index.php"]) {
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
            else if ([elementName isEqualToString:@"li"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"bt"]) {
                hasLine = YES;
                TZLog(@"%s: li : Line", __FUNCTION__);
                TZLog(@"attributes: %@", attributeDict);
            }
        }
        else if ([elementName isEqualToString:@"ul"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"down_but"]) {
            hasDownloads = YES;
            TZLog(@"%s: ul : Downloads", __FUNCTION__);
            TZLog(@"attributes: %@", attributeDict);
        }
    }
    else if ([elementName isEqualToString:@"html"]) {
        hasDocument = YES;
        TZLog(@"%s: html : Document", __FUNCTION__);
    }
    
    /*
    if (hasDocument) {
        if (hasDownloads) {
            if (hasLine) {
                if (hasTorrent) {
                    
                }
                else if (hasMagnet) {
                    
                }
            }
        }
    }
    */
}
-(void)parser:(DTHTMLParser *)parser didEndElement:(NSString *)elementName {
    
    if (hasDocument) {
        if (hasDownloads) {
            if (hasLine) {
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
                else if ([elementName isEqualToString:@"li"]) {
                    hasLine = NO;
                    TZLog(@"%s: li : Line", __FUNCTION__);
                }
            }
            else if ([elementName isEqualToString:@"ul"]) {
                hasDownloads = NO;
                TZLog(@"%s: ul : Downloads", __FUNCTION__);
            }
        }
        else if ([elementName isEqualToString:@"html"]) {
            hasDocument = NO;
            TZLog(@"%s: html : Document", __FUNCTION__);
        }
    }
}

@end
