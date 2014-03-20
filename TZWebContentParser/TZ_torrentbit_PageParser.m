//
//  TZ_torrentbit_PageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/16/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZ_torrentbit_PageParser.h"

@implementation TZ_torrentbit_PageParser {
    BOOL hasDocument;
    BOOL hasTable;
    BOOL hasRow;
    BOOL hasColumn;
    BOOL hasTableO;
    BOOL hasTableX;
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
    hasTable = NO;
    hasRow = NO;
    hasColumn = NO;
    hasTableO = NO;
    hasTableX = NO;
    hasDownloads = NO;
    hasTorrent = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    if (hasDocument) {
        if (hasTable) {
            if (hasRow) {
                if (hasColumn) {
                    if (hasTableO) {
                        if (hasTableX) {
                            
                        }
                        else if ([elementName isEqualToString:@"table"]) {
                            hasTableX = YES;
                            TZLog(@"%s: table : TableX", __FUNCTION__);
                        }
                    }
                    else if ([elementName isEqualToString:@"table"]) {
                        hasTableO = YES;
                        TZLog(@"%s: table : TableO", __FUNCTION__);
                    }
                    else if (hasDownloads) {
                        if (hasTorrent) {
                            
                        }
                        else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=5 && [[str substringToIndex:5] isEqualToString:@"/get/"]) {
                            hasTorrent= YES;
                            TZLog(@"%s: a : Torrent", __FUNCTION__);
                            TZLog(@"attributes: %@", attributeDict);
                            [self.dataDict setObject:[NSString stringWithFormat:@"http://www.torrentbit.net%@", str] forKey:@"Torrent"];
                        }
                    }
                    else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"id"] isEqualToString:@"dloptions"]) {
                        hasDownloads = YES;
                        TZLog(@"%s: div : Downloads", __FUNCTION__);
                        TZLog(@"attributes: %@", attributeDict);
                    }
                }
                else if ([elementName isEqualToString:@"td"] && [[attributeDict objectForKey:@"id"] isEqualToString:@"main"]) {
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
    else if ([elementName isEqualToString:@"html"]) {
        hasDocument = YES;
        TZLog(@"%s: html : Document", __FUNCTION__);
    }
    
    /*
    if (hasDocument) {
        if (hasTable) {
            if (hasRow) {
                if (hasColumn) {
                    if (hasTableO) {
                        if (hasTableX) {
     
                        }
                    }
                    else if (hasDownloads) {
                        if (hasTorrent) {
                            
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
                    if (hasTableO) {
                        if (hasTableX) {
                            if ([elementName isEqualToString:@"table"]) {
                                hasTableX = NO;
                                TZLog(@"%s: table : TableX", __FUNCTION__);
                            }
                        }
                        else if ([elementName isEqualToString:@"table"]) {
                            hasTableO = NO;
                            TZLog(@"%s: table : TableO", __FUNCTION__);
                        }
                    }
                    else if (hasDownloads) {
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
