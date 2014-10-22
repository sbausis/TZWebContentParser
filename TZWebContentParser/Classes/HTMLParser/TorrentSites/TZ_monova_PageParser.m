//
//  TZ_monova_PageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/15/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZ_monova_PageParser.h"

@implementation TZ_monova_PageParser {
    BOOL hasContent;
    BOOL hasDownloads;
    
    BOOL hasTorrent;
    BOOL hasMagnet;
    BOOL hasDHT;
    
    NSString *str;
}

#pragma mark -
#pragma mark NSHTMLParserDelegate

-(void)parserDidStartDocument:(DTHTMLParser *)parser {
    
    TZLog(@"%s", __FUNCTION__);
    self.dataDict = [[NSMutableDictionary alloc] init];
    
    hasContent = NO;
    hasDownloads = NO;
    
    hasTorrent = NO;
    hasMagnet = NO;
    hasDHT = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    if (hasContent) {
        if (hasDownloads) {
            if (hasTorrent) {
                
            }
            else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=21 && [[str substringToIndex:21] isEqualToString:@"http://www.monova.org"]) {
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
            else if (hasDHT) {
                
            }
            else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=4 && [[str substringToIndex:4] isEqualToString:@"dht:"]) {
                hasDHT = YES;
                TZLog(@"%s: a : DHT", __FUNCTION__);
                TZLog(@"attributes: %@", attributeDict);
                [self.dataDict setObject:[str copy] forKey:@"DHT"];
            }
        }
        else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"id"] isEqualToString:@"downloadbox"]) {
            hasDownloads = YES;
            TZLog(@"%s: div : Downloads", __FUNCTION__);
            TZLog(@"attributes: %@", attributeDict);
        }
    }
    else if ([elementName isEqualToString:@"html"]) {
        hasContent = YES;
        TZLog(@"%s: html : Content", __FUNCTION__);
    }
    
    /*
    if (hasContent) {
        if (hasDownloads) {
            if (hasTorrent) {
                
            }
            else if (hasMagnet) {
                
            }
            else if (hasDHT) {
                
            }
        }
    }
    */
}
-(void)parser:(DTHTMLParser *)parser didEndElement:(NSString *)elementName {
    
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
            else if (hasDHT) {
                if ([elementName isEqualToString:@"a"]) {
                    hasDHT = NO;
                    TZLog(@"%s: a : DHT", __FUNCTION__);
                }
            }
            else if ([elementName isEqualToString:@"div"]) {
                hasDownloads = NO;
                TZLog(@"%s: div : Downloads", __FUNCTION__);
            }
        }
        else if ([elementName isEqualToString:@"html"]) {
            hasContent = NO;
            TZLog(@"%s: html : Content", __FUNCTION__);
        }
    }
}

@end
