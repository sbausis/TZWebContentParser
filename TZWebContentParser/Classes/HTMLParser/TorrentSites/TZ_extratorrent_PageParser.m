//
//  TZ_extratorrent_PageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/15/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZ_extratorrent_PageParser.h"

@implementation TZ_extratorrent_PageParser {
    BOOL hasDocument;
    BOOL hasTable;
    BOOL hasRow;
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
    hasTable = NO;
    hasRow = NO;
    hasDownloads = NO;
    hasTorrent = NO;
    hasMagnet = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    if (hasDocument) {
        if (hasTable) {
            if (hasRow) {
                if (hasDownloads) {
                    if (hasTorrent) {
                        
                    }
                    else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=18 && [[str substringToIndex:18] isEqualToString:@"/torrent_download/"]) {
                        hasTorrent = YES;
                        TZLog(@"%s: a : Torrent", __FUNCTION__);
                        TZLog(@"attributes: %@", attributeDict);
                        [self.dataDict setObject:[NSString stringWithFormat:@"http://extratorrent.cc%@", str] forKey:@"Torrent"];
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
                else if ([elementName isEqualToString:@"td"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"tabledata0"]) {
                    hasDownloads = YES;
                    TZLog(@"%s: td : Downloads", __FUNCTION__);
                    TZLog(@"attributes: %@", attributeDict);
                }
            }
            else if ([elementName isEqualToString:@"tr"]) {
                hasRow = YES;
                TZLog(@"%s: tr : Row", __FUNCTION__);
            }
        }
        else if ([elementName isEqualToString:@"table"]) {
            hasTable = YES;
            TZLog(@"%s: table : Table", __FUNCTION__);
        }
    }
    else if ([elementName isEqualToString:@"html"]) {
        hasDocument = YES;
        TZLog(@"%s: html : Document", __FUNCTION__);
    }
    
    /*
    if (hasDocument) {
        if (hasTable) {
            if (hasRow) {
                if (hasDownloads) {
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
    
    if (hasDocument) {
        if (hasTable) {
            if (hasRow) {
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
                    else if ([elementName isEqualToString:@"td"]) {
                        hasDownloads = NO;
                        TZLog(@"%s: td : Downloads", __FUNCTION__);
                    }
                    */
                }
                /*
                else if ([elementName isEqualToString:@"tr"]) {
                    hasRow = NO;
                    TZLog(@"%s: tr : Row", __FUNCTION__);
                }
                */
            }
            /*
            else if ([elementName isEqualToString:@"table"]) {
                hasTable = NO;
                TZLog(@"%s: table : Table", __FUNCTION__);
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
