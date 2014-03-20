//
//  TZ_torrentzap_PageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/15/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZ_torrentzap_PageParser.h"

@implementation TZ_torrentzap_PageParser {
    BOOL hasDocument;
    BOOL hasDownloads;
    BOOL hasTorrent;
    BOOL hasMagnet;
    BOOL isMagnet;
    
    NSString *str;
}

#pragma mark -
#pragma mark NSHTMLParserDelegate

-(void)parserDidStartDocument:(DTHTMLParser *)parser {
    
    TZLog(@"%s", __FUNCTION__);
    self.dataDict = [[NSMutableDictionary alloc] init];
    
    hasDocument = NO;
    hasDownloads = NO;
    hasTorrent = NO;
    hasMagnet = NO;
    isMagnet = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    if (hasDocument) {
        if (hasDownloads) {
            if (hasTorrent) {
                
            }
            else if ([elementName isEqualToString:@"a"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"downloadLink"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=10 && [[str substringToIndex:10] isEqualToString:@"/download/"]) {
                hasTorrent = YES;
                TZLog(@"%s: a : Torrent", __FUNCTION__);
                TZLog(@"attributes: %@", attributeDict);
                [self.dataDict setObject:[NSString stringWithFormat:@"http://www.torrentzap.com%@", str] forKey:@"Torrent"];
            }
            else if (hasMagnet) {
                if (isMagnet) {
                    
                }
                else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=7 && [[str substringToIndex:7] isEqualToString:@"magnet:"]) {
                    isMagnet = YES;
                    TZLog(@"%s: a : Magnet2", __FUNCTION__);
                    TZLog(@"attributes: %@", attributeDict);
                    [self.dataDict setObject:[str copy] forKey:@"Magnet"];
                }
            }
            else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"magnetlink"]) {
                hasMagnet = YES;
                TZLog(@"%s: div : Magnet", __FUNCTION__);
                TZLog(@"attributes: %@", attributeDict);
            }
        }
        else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"downbuts"]) {
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
            if (hasTorrent) {
                
            }
            else if (hasMagnet) {
                if (isMagnet) {
                    
                }
            }
        }
    }
    */
}
-(void)parser:(DTHTMLParser *)parser didEndElement:(NSString *)elementName {
    
    if (hasDocument) {
        if (hasDownloads) {
            if (hasTorrent) {
                if ([elementName isEqualToString:@"a"]) {
                    hasTorrent = NO;
                    TZLog(@"%s: a : Torrent", __FUNCTION__);
                }
            }
            else if (hasMagnet) {
                if (isMagnet) {
                    if ([elementName isEqualToString:@"a"]) {
                        isMagnet = NO;
                        TZLog(@"%s: a : Magnet2", __FUNCTION__);
                    }
                }
                else if ([elementName isEqualToString:@"div"]) {
                    hasMagnet = NO;
                    TZLog(@"%s: div : Magnet", __FUNCTION__);
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
