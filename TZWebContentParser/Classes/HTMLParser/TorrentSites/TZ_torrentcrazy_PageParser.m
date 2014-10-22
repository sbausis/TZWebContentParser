//
//  TZ_torrentcrazy_PageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/15/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZ_torrentcrazy_PageParser.h"

@implementation TZ_torrentcrazy_PageParser {
    BOOL hasContent;
    BOOL hasTable;
    BOOL hasLine;
    BOOL hasTitle;
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
    
    hasContent = NO;
    hasTable = NO;
    hasLine = NO;
    hasTitle = NO;
    hasDownloads = NO;
    hasTorrent = NO;
    hasMagnet = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    if (hasContent) {
        if (hasTable) {
            if (hasLine) {
                if (hasTitle) {
                    
                }
                else if ([elementName isEqualToString:@"th"]) {
                    hasTitle = YES;
                    TZLog(@"%s: th : Title", __FUNCTION__);
                }
                else if (hasDownloads) {
                    if (hasTorrent) {
                        
                    }
                    else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=26 && [[str substringToIndex:26] isEqualToString:@"http://dl.torrentcrazy.com"]) {
                        hasTorrent = YES;
                        TZLog(@"%s: a : Torrent", __FUNCTION__);
                        TZLog(@"attributes: %@", attributeDict);
                        [self.dataDict setObject:[[attributeDict objectForKey:@"href"] copy] forKey:@"Torrent"];
                    }
                    else if (hasMagnet) {
                        
                    }
                    else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=7 && [[str substringToIndex:7] isEqualToString:@"magnet:"]) {
                        hasMagnet = YES;
                        TZLog(@"%s: a : Magnet", __FUNCTION__);
                        TZLog(@"attributes: %@", attributeDict);
                        [self.dataDict setObject:[[attributeDict objectForKey:@"href"] copy] forKey:@"Magnet"];
                    }
                }
                else if ([elementName isEqualToString:@"td"] && [[attributeDict objectForKey:@"id"] isEqualToString:@"dl-links"]) {
                    hasDownloads = YES;
                    TZLog(@"%s: td : Downloads", __FUNCTION__);
                    TZLog(@"attributes: %@", attributeDict);
                }
            }
            else if ([elementName isEqualToString:@"tr"]) {
                hasLine = YES;
                TZLog(@"%s: tr : Line", __FUNCTION__);
            }
        }
        else if ([elementName isEqualToString:@"table"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"info"]) {
            hasTable = YES;
            TZLog(@"%s: table : Table", __FUNCTION__);
            TZLog(@"attributes: %@", attributeDict);
        }
    }
    else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"box"]) {
        hasContent = YES;
        TZLog(@"%s: div : Content", __FUNCTION__);
        TZLog(@"attributes: %@", attributeDict);
    }
    
    /*
    if (hasContent) {
        if (hasTable) {
            if (hasLine) {
                if (hasTitle) {
                    
                }
                else if (hasDownloads) {
                    if (hasTorrent) {
                        
                    }
                    else if (hasMagnet) {
                        
                    }
                }
            }
        }
    }
    */
}
-(void)parser:(DTHTMLParser *)parser didEndElement:(NSString *)elementName {
    
    if (hasContent) {
        if (hasTable) {
            if (hasLine) {
                if (hasTitle) {
                    if ([elementName isEqualToString:@"th"]) {
                        hasTitle = NO;
                        TZLog(@"%s: th : Title", __FUNCTION__);
                    }
                }
                else if (hasDownloads) {
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
                    else if ([elementName isEqualToString:@"td"]) {
                        hasDownloads = NO;
                        TZLog(@"%s: td : Downloads", __FUNCTION__);
                    }
                }
                else if ([elementName isEqualToString:@"tr"]) {
                    hasLine = NO;
                    TZLog(@"%s: tr : Line", __FUNCTION__);
                }
            }
            else if ([elementName isEqualToString:@"table"]) {
                hasTable = NO;
                TZLog(@"%s: table : Table", __FUNCTION__);
            }
        }
        /*
        else if ([elementName isEqualToString:@"div"]) {
            hasContent = NO;
            TZLog(@"%s: div : Content", __FUNCTION__);
        }
        */
    }
}

@end
