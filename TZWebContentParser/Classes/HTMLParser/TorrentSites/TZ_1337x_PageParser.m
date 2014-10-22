//
//  TZ_1337x_PageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/15/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZ_1337x_PageParser.h"

@implementation TZ_1337x_PageParser {
    BOOL hasDocument;
    BOOL hasDownloads;
    BOOL hasMagnet;
    BOOL hasTorrent;
    
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
    hasTorrent = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    if (hasDocument) {
        if (hasDownloads) {
            if (hasMagnet) {
                
            }
            else if ([elementName isEqualToString:@"a"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"magnetDw"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=7 && [[str substringToIndex:7] isEqualToString:@"magnet:"]) {
                hasMagnet = YES;
                TZLog(@"%s: a : Magnet", __FUNCTION__);
                TZLog(@"attributes: %@", attributeDict);
                [self.dataDict setObject:[str copy] forKey:@"Magnet"];
            }
            else if (hasTorrent) {
                
            }
            else if ([elementName isEqualToString:@"a"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"torrentDw"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=28 && [[str substringToIndex:28] isEqualToString:@"http://torcache.net/torrent/"]) {
                hasTorrent = YES;
                TZLog(@"%s: a : Torrent", __FUNCTION__);
                TZLog(@"attributes: %@", attributeDict);
                [self.dataDict setObject:[str copy] forKey:@"Torrent"];
            }
        }
        else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"torrentInfoBtn"]) {
            hasDownloads = YES;
            TZLog(@"%s: div : Downloads", __FUNCTION__);
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
            if (hasMagnet) {
                
            }
            else if (hasTorrent) {
                
            }
        }
    }
    */
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
            else if (hasTorrent) {
                if ([elementName isEqualToString:@"a"]) {
                    hasTorrent = NO;
                    TZLog(@"%s: a : Torrent", __FUNCTION__);
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
