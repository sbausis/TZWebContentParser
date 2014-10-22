//
//  TZ_linuxtracker_PageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/16/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZ_linuxtracker_PageParser.h"

@implementation TZ_linuxtracker_PageParser {
    BOOL hasDocument;
    BOOL hasContent;
    BOOL hasTable;
    BOOL hasRow;
    BOOL hasColumn;
    BOOL hasTableO;
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
    hasTable = NO;
    hasRow = NO;
    hasColumn = NO;
    hasTableO = NO;
    hasTorrent = NO;
    hasMagnet = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    if (hasDocument) {
        if (hasContent) {
            if (hasTable) {
                if (hasRow) {
                    if (hasColumn) {
                        if (hasTableO) {
                            
                        }
                        else if ([elementName isEqualToString:@"table"]) {
                            hasTableO = YES;
                            TZLog(@"%s: table : TableO", __FUNCTION__);
                        }
                        else if (hasTorrent) {
                            
                        }
                        else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=23 && [[str substringToIndex:23] isEqualToString:@"index.php?page=download"]) {
                            hasTorrent = YES;
                            TZLog(@"%s: a : Torrent", __FUNCTION__);
                            TZLog(@"attributes: %@", attributeDict);
                            [self.dataDict setObject:[NSString stringWithFormat:@"http://linuxtracker.org/%@", str] forKey:@"Torrent"];
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
                    else if ([elementName isEqualToString:@"td"]) {
                        hasColumn = YES;
                        TZLog(@"%s: td : Column", __FUNCTION__);
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
        else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"b-content"] && [[attributeDict objectForKey:@"align"] isEqualToString:@"center"]) {
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
            if (hasTable) {
                if (hasRow) {
                    if (hasColumn) {
                        if (hasTableO) {
                            
                        }
                        else if (hasTorrent) {
                            
                        }
                        else if (hasMagnet) {
                            
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
        if (hasContent) {
            if (hasTable) {
                if (hasRow) {
                    if (hasColumn) {
                        if (hasTableO) {
                            if ([elementName isEqualToString:@"table"]) {
                                hasTableO = NO;
                                TZLog(@"%s: table : TableO", __FUNCTION__);
                            }
                        }
                        else if (hasTorrent) {
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
            else if ([elementName isEqualToString:@"div"]) {
                hasContent = NO;
                TZLog(@"%s: div : Content", __FUNCTION__);
            }
        }
        else if ([elementName isEqualToString:@"html"]) {
            hasDocument = NO;
            TZLog(@"%s: html : Document", __FUNCTION__);
        }
    }
}

@end
