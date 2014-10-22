//
//  TZ_bitsnoop_PageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/16/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZ_bitsnoop_PageParser.h"

@implementation TZ_bitsnoop_PageParser {
    BOOL hasDocument;
    BOOL hasDownloads;
    BOOL hasMagnet;
    BOOL hasShortMagnet;
    BOOL hasTorrent;
    BOOL hasMirror;
    
    NSString *str;
    NSString *curr;
}

#pragma mark -
#pragma mark NSHTMLParserDelegate

-(void)parserDidStartDocument:(DTHTMLParser *)parser {
    
    TZLog(@"%s", __FUNCTION__);
    self.dataDict = [[NSMutableDictionary alloc] init];
    
    hasDocument = NO;
    hasDownloads = NO;
    hasMagnet = NO;
    hasShortMagnet = NO;
    hasTorrent = NO;
    hasMirror = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    curr = Nil;
    if (hasDocument) {
        if (hasDownloads) {
            if (hasMagnet) {
                
            }
            else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"title"]) && [str isKindOfClass:[NSString class]] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=7 && [[str substringToIndex:7] isEqualToString:@"magnet:"]) {
                hasMagnet = YES;
                TZLog(@"%s: a : Magnet", __FUNCTION__);
                TZLog(@"attributes: %@", attributeDict);
                curr = str;
            }
            else if (hasShortMagnet) {
                
            }
            else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=7 && [[str substringToIndex:7] isEqualToString:@"magnet:"]) {
                hasShortMagnet = YES;
                TZLog(@"%s: a : ShortMagnet", __FUNCTION__);
                TZLog(@"attributes: %@", attributeDict);
                curr = str;
            }
            else if (hasTorrent) {
                
            }
            else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"title"]) && [str isKindOfClass:[NSString class]] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=8 && [[str substringFromIndex:[str length]-8] isEqualToString:@".torrent"]) {
                hasTorrent = YES;
                TZLog(@"%s: a : Torrent", __FUNCTION__);
                TZLog(@"attributes: %@", attributeDict);
                curr = str;
            }
            else if (hasMirror) {
                
            }
            else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=8 && [[str substringFromIndex:[str length]-8] isEqualToString:@".torrent"]) {
                hasMirror = YES;
                TZLog(@"%s: a : Mirror", __FUNCTION__);
                TZLog(@"attributes: %@", attributeDict);
                curr = str;
            }
        }
        else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"id"] isEqualToString:@"dload"]) {
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
            else if (hasShortMagnet) {
                
            }
            else if (hasTorrent) {
                
            }
            else if (hasMirror) {
                
            }
        }
    }
    */
}
-(void)parser:(DTHTMLParser *)parser foundCharacters:(NSString *)string {
    str = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([str length] > 0) {
        if (curr) {
            if (hasMagnet && [str isEqualToString:@"Magnet Link"]) {
                TZLog(@"%s: Magnet: %@", __FUNCTION__, str);
                [self.dataDict setObject:[curr copy] forKey:@"Magnet"];
            }
            else if (hasShortMagnet && [str isEqualToString:@"short Magnet"]) {
                TZLog(@"%s: ShortMagnet: %@", __FUNCTION__, str);
                [self.dataDict setObject:[curr copy] forKey:@"Magnet2"];
            }
            else if (hasTorrent && [str isEqualToString:@"Download Torrent"]) {
                TZLog(@"%s: Torrent: %@", __FUNCTION__, str);
                [self.dataDict setObject:[curr copy] forKey:@"Torrent"];
            }
            else if (hasMirror && [str length]>=9 && [[str substringToIndex:6] isEqualToString:@"Mirror"]) {
                TZLog(@"%s: Mirror: %@", __FUNCTION__, str);
                [self.dataDict setObject:[curr copy] forKey:[NSString stringWithFormat:@"Torrent%@", [str substringFromIndex:[str length]-1]]];
            }
        }
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
            else if (hasShortMagnet) {
                if ([elementName isEqualToString:@"a"]) {
                    hasShortMagnet = NO;
                    TZLog(@"%s: a : ShortMagnet", __FUNCTION__);
                }
            }
            else if (hasTorrent) {
                if ([elementName isEqualToString:@"a"]) {
                    hasTorrent = NO;
                    TZLog(@"%s: a : Torrent", __FUNCTION__);
                }
            }
            else if (hasMirror) {
                if ([elementName isEqualToString:@"a"]) {
                    hasMirror = NO;
                    TZLog(@"%s: a : Mirror", __FUNCTION__);
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
