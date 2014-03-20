//
//  TZ_fulldls_PageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/15/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZ_fulldls_PageParser.h"

@implementation TZ_fulldls_PageParser {
    BOOL hasDocument;
    BOOL hasTable;
    BOOL hasRow;
    BOOL hasColumn;
    BOOL hasFiles;
    BOOL hasTorrent;
    BOOL hasLink;
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
    hasColumn = NO;
    hasFiles = NO;
    hasTorrent = NO;
    hasLink = NO;
    hasMagnet = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    if (hasDocument) {
        if (hasTable) {
            if (hasRow) {
                if (hasColumn) {
                    if (hasFiles) {
                        if (hasTorrent) {
                            
                        }
                        else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=8 && [[str substringToIndex:8] isEqualToString:@"download"]) {
                            hasTorrent = YES;
                            TZLog(@"%s: a : Torrent", __FUNCTION__);
                            TZLog(@"attributes: %@", attributeDict);
                            [self.dataDict setObject:[NSString stringWithFormat:@"http://www.fulldls.com/%@", str] forKey:@"Torrent"];
                        }
                    }
                    else if ([elementName isEqualToString:@"span"] && [[attributeDict objectForKey:@"id"] isEqualToString:@"dwl"]) {
                        hasFiles = YES;
                        TZLog(@"%s: span : Files", __FUNCTION__);
                        TZLog(@"attributes: %@", attributeDict);
                    }
                    else if (hasLink) {
                        if (hasMagnet) {
                            
                        }
                        else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=7 && [[str substringToIndex:7] isEqualToString:@"magnet:"]) {
                            hasMagnet = YES;
                            TZLog(@"%s: a : Magnet", __FUNCTION__);
                            TZLog(@"attributes: %@", attributeDict);
                            [self.dataDict setObject:[str copy] forKey:@"Magnet"];
                        }
                    }
                    else if ([elementName isEqualToString:@"i"]) {
                        hasLink = YES;
                        TZLog(@"%s: i : Link", __FUNCTION__);
                    }
                }
                else if ([elementName isEqualToString:@"td"] && [[attributeDict objectForKey:@"id"] isEqualToString:@"bmidescr"]) {
                    hasColumn = YES;
                    TZLog(@"%s: td : Column", __FUNCTION__);
                    TZLog(@"attributes: %@", attributeDict);
                }
            }
            else if ([elementName isEqualToString:@"tr"]) {
                hasRow = YES;
                TZLog(@"%s: tr : Row", __FUNCTION__);
            }
        }
        else if ([elementName isEqualToString:@"table"] && [[attributeDict objectForKey:@"id"] isEqualToString:@"meth_big"]) {
            hasTable = YES;
            TZLog(@"%s: table : Table", __FUNCTION__);
            TZLog(@"attributes: %@", attributeDict);
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
                if (hasColumn) {
                    if (hasFiles) {
                        if (hasTorrent) {
                            
                        }
                    }
                    else if (hasLink) {
                        if (hasMagnet) {
                            
                        }
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
                if (hasColumn) {
                    if (hasFiles) {
                        if (hasTorrent) {
                            if ([elementName isEqualToString:@"a"]) {
                                hasTorrent = NO;
                                TZLog(@"%s: a : Torrent", __FUNCTION__);
                            }
                        }
                        else if ([elementName isEqualToString:@"span"]) {
                            hasFiles = NO;
                            TZLog(@"%s: span : Files", __FUNCTION__);
                        }
                    }
                    else if (hasLink) {
                        if (hasMagnet) {
                            if ([elementName isEqualToString:@"a"]) {
                                hasMagnet = NO;
                                TZLog(@"%s: a : Magnet", __FUNCTION__);
                            }
                        }
                        else if ([elementName isEqualToString:@"i"]) {
                            hasLink = NO;
                            TZLog(@"%s: i : Link", __FUNCTION__);
                        }
                    }
                    else if ([elementName isEqualToString:@"td"]) {
                        hasColumn = NO;
                        TZLog(@"%s: td : Column", __FUNCTION__);
                    }
                }
                else if ([elementName isEqualToString:@"tr"]) {
                    hasRow = NO;
                    TZLog(@"%s: tr : Row", __FUNCTION__);
                }
            }
            else if ([elementName isEqualToString:@"table"]) {
                hasTable = NO;
                TZLog(@"%s: table : Table", __FUNCTION__);
            }
        }
        else if ([elementName isEqualToString:@"html"]) {
            hasDocument = NO;
            TZLog(@"%s: html : Document", __FUNCTION__);
        }
    }
}

@end
