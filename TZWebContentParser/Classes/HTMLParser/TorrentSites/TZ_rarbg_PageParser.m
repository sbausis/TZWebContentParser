//
//  TZ_rarbg_PageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/16/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZ_rarbg_PageParser.h"

@implementation TZ_rarbg_PageParser {
    BOOL hasDocument;
    BOOL hasTable;
    BOOL hasRow;
    BOOL hasColumn;
    BOOL hasContent;
    BOOL hasTableC;
    BOOL hasRowC;
    BOOL hasColumnC;
    BOOL hasTableD;
    BOOL hasRowD;
    BOOL hasColumnD;
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
    hasColumn = NO;
    hasContent = NO;
    hasTableC = NO;
    hasRowC = NO;
    hasColumnC = NO;
    hasTableD = NO;
    hasRowD = NO;
    hasColumnD = NO;
    hasTorrent = NO;
    hasMagnet = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    if (hasDocument) {
        if (hasTable) {
            if (hasRow) {
                if (hasColumn) {
                    if (hasContent) {
                        if (hasTableC) {
                            if (hasRowC) {
                                if (hasColumnC) {
                                    if (hasTableD) {
                                        if (hasRowD) {
                                            if (hasColumnD) {
                                                if (hasTorrent) {
                                                    
                                                }
                                                else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=13 && [[str substringToIndex:13] isEqualToString:@"/download.php"]) {
                                                    hasTorrent = YES;
                                                    TZLog(@"%s: a : Torrent", __FUNCTION__);
                                                    TZLog(@"attributes: %@", attributeDict);
                                                    [self.dataDict setObject:[NSString stringWithFormat:@"http://rarbg.com%@", str] forKey:@"Torrent"];
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
                                                hasColumnD = YES;
                                                TZLog(@"%s: td : ColumnD", __FUNCTION__);
                                            }
                                        }
                                        else if ([elementName isEqualToString:@"tr"]) {
                                            hasRowD = YES;
                                            TZLog(@"%s: tr : RowD", __FUNCTION__);
                                        }
                                    }
                                    else if ([elementName isEqualToString:@"table"]) {
                                        hasTableD = YES;
                                        TZLog(@"%s: table : TableD", __FUNCTION__);
                                    }
                                }
                                else if ([elementName isEqualToString:@"td"]) {
                                    hasColumnC = YES;
                                    TZLog(@"%s: td : ColumnC", __FUNCTION__);
                                }
                            }
                            else if ([elementName isEqualToString:@"tr"]) {
                                hasRowC = YES;
                                TZLog(@"%s: tr : RowC", __FUNCTION__);
                            }
                        }
                        else if ([elementName isEqualToString:@"table"]) {
                            hasTableC = YES;
                            TZLog(@"%s: table : TableC", __FUNCTION__);
                        }
                    }
                    else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"content-rounded"]) {
                        hasContent = YES;
                        TZLog(@"%s: div : Content", __FUNCTION__);
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
    else if ([elementName isEqualToString:@"html"]) {
        hasDocument = YES;
        TZLog(@"%s: html : Document", __FUNCTION__);
    }
    
    /*
    if (hasDocument) {
        if (hasTable) {
            if (hasRow) {
                if (hasColumn) {
                    if (hasContent) {
                        if (hasTableC) {
                            if (hasRowC) {
                                if (hasColumnC) {
                                    if (hasTableD) {
                                        if (hasRowD) {
                                            if (hasColumnD) {
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
                    if (hasContent) {
                        if (hasTableC) {
                            if (hasRowC) {
                                if (hasColumnC) {
                                    if (hasTableD) {
                                        if (hasRowD) {
                                            if (hasColumnD) {
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
                                                    hasColumnD = NO;
                                                    TZLog(@"%s: td : ColumnD", __FUNCTION__);
                                                }
                                            }
                                            else if ([elementName isEqualToString:@"tr"]) {
                                                hasRowD = NO;
                                                TZLog(@"%s: tr : RowD", __FUNCTION__);
                                            }
                                        }
                                        else if ([elementName isEqualToString:@"table"]) {
                                            hasTableD = NO;
                                            TZLog(@"%s: table : TableD", __FUNCTION__);
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
                                hasTableC = NO;
                                TZLog(@"%s: table : TableC", __FUNCTION__);
                            }
                        }
                        else if ([elementName isEqualToString:@"div"]) {
                            hasContent = NO;
                            TZLog(@"%s: div : Content", __FUNCTION__);
                        }
                    }
                    else if ([elementName isEqualToString:@"td"]) {
                        hasColumn = NO;
                        TZLog(@"%s: td : Column", __FUNCTION__);
                    }
                }
                else if ([elementName isEqualToString:@"tr"]) {
                    //hasRow = NO;
                    TZLog(@"%s: tr : Row", __FUNCTION__);
                }
            }
            else if ([elementName isEqualToString:@"table"]) {
                //hasTable = NO;
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
