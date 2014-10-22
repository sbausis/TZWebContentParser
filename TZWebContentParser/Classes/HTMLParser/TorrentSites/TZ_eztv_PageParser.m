//
//  TZ_eztv_PageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/16/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZ_eztv_PageParser.h"

@implementation TZ_eztv_PageParser {
    BOOL hasDocument;
    BOOL hasContent;
    BOOL hasRowC;
    BOOL hasColumnC;
    BOOL hasTable;
    BOOL hasRow;
    BOOL hasColumn;
    BOOL hasTorrent;
    BOOL hasMagnet;
    
    NSString *str;
    NSString *curr;
}

#pragma mark -
#pragma mark NSHTMLParserDelegate

-(void)parserDidStartDocument:(DTHTMLParser *)parser {
    
    TZLog(@"%s", __FUNCTION__);
    self.dataDict = [[NSMutableDictionary alloc] init];
    
    hasDocument = NO;
    hasContent = NO;
    hasRowC = NO;
    hasColumnC = NO;
    hasTable = NO;
    hasRow = NO;
    hasColumn = NO;
    hasTorrent = NO;
    hasMagnet = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    if (hasDocument) {
        if (hasContent) {
            if (hasRowC) {
                if (hasColumnC) {
                    if (hasTable) {
                        if (hasRow) {
                            if (hasColumn) {
                                if (hasTorrent) {
                                    
                                }
                                else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"class"]) && [str isKindOfClass:[NSString class]] && [str length]>=8 && [[str substringToIndex:8] isEqualToString:@"download"] && (curr = [attributeDict objectForKey:@"href"]) && [curr isKindOfClass:[NSString class]]) {
                                    hasTorrent = YES;
                                    TZLog(@"%s: a : Torrent", __FUNCTION__);
                                    TZLog(@"attributes: %@", attributeDict);
                                    if ([[str substringFromIndex:[str length]-1] isEqualToString:@"1"]) {
                                        [self.dataDict setObject:[curr copy] forKey:@"Torrent"];
                                    }
                                    else {
                                        [self.dataDict setObject:[curr copy] forKey:[NSString stringWithFormat:@"Torrent%@", [str substringFromIndex:[str length]-1]]];
                                    }
                                }
                                else if (hasMagnet) {
                                    
                                }
                                else if ([elementName isEqualToString:@"a"] && [[attributeDict objectForKey:@"title"] isEqualToString:@"Magnet Link"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=7 && [[str substringToIndex:7] isEqualToString:@"magnet:"]) {
                                    hasMagnet = YES;
                                    TZLog(@"%s: a : Magnet", __FUNCTION__);
                                    TZLog(@"attributes: %@", attributeDict);
                                    [self.dataDict setObject:[str copy] forKey:@"Magnet"];
                                }
                            }
                            else if ([elementName isEqualToString:@"td"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"section_post_header"]) {
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
                    else if ([elementName isEqualToString:@"table"]) {
                        hasTable = YES;
                        TZLog(@"%s: table : Table", __FUNCTION__);
                    }
                }
                else if ([elementName isEqualToString:@"td"]) {
                    hasColumnC = YES;
                    TZLog(@"%s: td : ColumnC", __FUNCTION__);
                    TZLog(@"attributes: %@", attributeDict);
                }
            }
            else if ([elementName isEqualToString:@"tr"]) {
                hasRowC = YES;
                TZLog(@"%s: tr : RowC", __FUNCTION__);
            }
        }
        else if ([elementName isEqualToString:@"table"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"episode_columns_holder"]) {
            hasContent = YES;
            TZLog(@"%s: table : Content", __FUNCTION__);
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
            if (hasRowC) {
                if (hasColumnC) {
                    if (hasTable) {
                        if (hasRow) {
                            if (hasColumn) {
                                if (hasTorrent) {
                                    
                                }
                                else if (hasMagnet) {
                                    
                                }
                            }
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
            if (hasRowC) {
                if (hasColumnC) {
                    if (hasTable) {
                        if (hasRow) {
                            if (hasColumn) {
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
                                    //hasColumn = NO;
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
                    else if ([elementName isEqualToString:@"td"]) {
                        hasColumnC = NO;
                        TZLog(@"%s: td : ColumnC", __FUNCTION__);
                    }
                }
                else if ([elementName isEqualToString:@"tr"]) {
                    hasRowC = NO;
                    TZLog(@"%s: tr : RowC", __FUNCTION__);
                }
            }
            else if ([elementName isEqualToString:@"table"]) {
                hasContent = NO;
                TZLog(@"%s: table : Content", __FUNCTION__);
            }
        }
        else if ([elementName isEqualToString:@"html"]) {
            hasDocument = NO;
            TZLog(@"%s: html : Document", __FUNCTION__);
        }
    }
}

@end
