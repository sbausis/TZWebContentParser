//
//  TZ_torrentreactor_PageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/15/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZ_torrentreactor_PageParser.h"

@implementation TZ_torrentreactor_PageParser {
    BOOL hasContent;
    BOOL hasButtons;
    BOOL hasDownloads;
    BOOL hasTorrent;
    BOOL hasMagnet;
}

#pragma mark -
#pragma mark NSHTMLParserDelegate

-(void)parserDidStartDocument:(DTHTMLParser *)parser {
    
    TZLog(@"%s", __FUNCTION__);
    self.dataDict = [[NSMutableDictionary alloc] init];
    
    hasContent = NO;
    hasButtons = NO;
    hasDownloads = NO;
    hasTorrent = NO;
    hasMagnet = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    if (hasContent) {
        if (hasButtons) {
            if (hasDownloads) {
                if (hasTorrent) {
                    
                }
                else if ([elementName isEqualToString:@"a"] && [[attributeDict objectForKey:@"id"] isEqualToString:@"download-url"]) {
                    hasTorrent = YES;
                    TZLog(@"%s: a : Torrent", __FUNCTION__);
                    TZLog(@"attributes: %@", attributeDict);
                    [self.dataDict setObject:[[attributeDict objectForKey:@"href"] copy] forKey:@"Torrent"];
                }
                else if (hasMagnet) {
                    
                }
                else if ([elementName isEqualToString:@"a"] && [[attributeDict objectForKey:@"id"] isEqualToString:@"download-magnet"]) {
                    hasMagnet = YES;
                    TZLog(@"%s: a : Magnet", __FUNCTION__);
                    TZLog(@"attributes: %@", attributeDict);
                    [self.dataDict setObject:[[attributeDict objectForKey:@"href"] copy] forKey:@"Magnet"];
                }
            }
            else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"btn-group"]) {
                hasDownloads = YES;
                TZLog(@"%s: div : Downloads", __FUNCTION__);
                TZLog(@"attributes: %@", attributeDict);
            }
        }
        else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"mrg"]) {
            hasButtons = YES;
            TZLog(@"%s: div : Buttons", __FUNCTION__);
            TZLog(@"attributes: %@", attributeDict);
        }
    }
    else if ([elementName isEqualToString:@"html"]) {
        hasContent = YES;
        TZLog(@"%s: html : Content", __FUNCTION__);
    }
    
    /*
    if (hasContent) {
        if (hasButtons) {
            if (hasDownloads) {
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
    
    if (hasContent) {
        if (hasButtons) {
            if (hasDownloads) {
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
                    hasDownloads = NO;
                    TZLog(@"%s: div : Downloads", __FUNCTION__);
                }
            }
            else if ([elementName isEqualToString:@"div"]) {
                hasButtons = NO;
                TZLog(@"%s: div : Buttons", __FUNCTION__);
            }
        }
        else if ([elementName isEqualToString:@"html"]) {
            hasContent = NO;
            TZLog(@"%s: html : Content", __FUNCTION__);
        }
    }
}

@end
