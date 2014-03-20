//
//  TZ_torrents_PageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/15/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZ_torrents_PageParser.h"

@implementation TZ_torrents_PageParser {
    BOOL hasDocument;
    BOOL hasContent;
    BOOL hasDownloads;
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
    hasDownloads = NO;
    hasTorrent = NO;
    hasMagnet = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    if (hasDocument) {
        if (hasContent) {
            if (hasDownloads) {
                if (hasTorrent) {
                    
                }
                else if ([elementName isEqualToString:@"a"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"btn2-download"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=29 && [[str substringToIndex:29] isEqualToString:@"http://www.torrents.net/down/"]) {
                    hasTorrent = YES;
                    TZLog(@"%s: a : Torrent", __FUNCTION__);
                    TZLog(@"attributes: %@", attributeDict);
                    [self.dataDict setObject:[str copy] forKey:@"Torrent"];
                }
                else if (hasMagnet) {
                    
                }
                else if ([elementName isEqualToString:@"a"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"btn2-download"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=7 && [[str substringToIndex:7] isEqualToString:@"magnet:"]) {
                    hasMagnet = YES;
                    TZLog(@"%s: a : Magnet", __FUNCTION__);
                    TZLog(@"attributes: %@", attributeDict);
                    [self.dataDict setObject:[str copy] forKey:@"Magnet"];
                }
            }
            else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"download-holder"]) {
                hasDownloads = YES;
                TZLog(@"%s: div : Downloads", __FUNCTION__);
                TZLog(@"attributes: %@", attributeDict);
            }
        }
        else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"holder"]) {
            hasContent = YES;
            TZLog(@"%s: div : Content", __FUNCTION__);
            TZLog(@"attributes: %@", attributeDict);
        }
    }
    else if ([elementName isEqualToString:@"html"]) {
        hasDocument = YES;
        TZLog(@"%s: html : Document", __FUNCTION__);
    }
    
    /*
    if (hasDocument) {
        if (hasContent) {
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
    
    if (hasDocument) {
        if (hasContent) {
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
                /*
                else if ([elementName isEqualToString:@"div"]) {
                    hasDownloads = NO;
                    TZLog(@"%s: div : Downloads", __FUNCTION__);
                }
                */
            }
            /*
            else if ([elementName isEqualToString:@"div"]) {
                hasContent = NO;
                TZLog(@"%s: div : Content", __FUNCTION__);
            }
            */
        }
        else if ([elementName isEqualToString:@"html"]) {
            hasDocument = NO;
            TZLog(@"%s: html : Document", __FUNCTION__);
        }
    }
}

@end
