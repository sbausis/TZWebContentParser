//
//  TZ_torrenthound_PageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/16/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZ_torrenthound_PageParser.h"

@implementation TZ_torrenthound_PageParser {
    BOOL hasDocument;
    BOOL hasContent;
    BOOL hasDownloads;
    BOOL hasTorrent;
    
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
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    if (hasDocument) {
        if (hasContent) {
            if (hasDownloads) {
                if (hasTorrent) {
                    
                }
                else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=9 && [[str substringToIndex:9] isEqualToString:@"/torrent/"]) {
                    hasTorrent = YES;
                    TZLog(@"%s: a : Torrent", __FUNCTION__);
                    TZLog(@"attributes: %@", attributeDict);
                    if ([[self className] isEqualToString:@"TZ_houndmirror_PageParser"]) {
                        [self.dataDict setObject:[NSString stringWithFormat:@"http://www.houndmirror.com%@", str] forKey:@"Torrent"];
                    }
                    else {
                        [self.dataDict setObject:[NSString stringWithFormat:@"http://www.torrenthound.com%@", str] forKey:@"Torrent"];
                    }
                }
            }
            else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"id"] isEqualToString:@"torrent"]) {
                hasDownloads = YES;
                TZLog(@"%s: div : Downloads", __FUNCTION__);
                TZLog(@"attributes: %@", attributeDict);
            }
        }
        else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"id"] isEqualToString:@"pcontent"]) {
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
                else if ([elementName isEqualToString:@"div"]) {
                    hasDownloads = NO;
                    TZLog(@"%s: div : Downloads", __FUNCTION__);
                }
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

@implementation TZ_houndmirror_PageParser

@end