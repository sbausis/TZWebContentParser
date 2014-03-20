//
//  TZ_torrentfunk_PageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/15/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZ_torrentfunk_PageParser.h"

@implementation TZ_torrentfunk_PageParser {
    BOOL hasDocument;
    BOOL hasContent;
    BOOL hasMain;
    BOOL hasDownloads;
    BOOL hasTable;
    BOOL hasRow;
    BOOL hasColumn;
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
    hasMain = NO;
    hasDownloads = NO;
    hasTable = NO;
    hasRow = NO;
    hasColumn = NO;
    hasTorrent = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    if (hasDocument) {
        if (hasContent) {
            if (hasMain) {
                if (hasDownloads) {
                    if (hasTable) {
                        if (hasRow) {
                            if (hasColumn) {
                                if (hasTorrent) {
                                    
                                }
                                else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=5 && [[str substringToIndex:5] isEqualToString:@"/tor/"]) {
                                    hasTorrent = YES;
                                    TZLog(@"%s: a : Torrent", __FUNCTION__);
                                    TZLog(@"attributes: %@", attributeDict);
                                    [self.dataDict setObject:[NSString stringWithFormat:@"http://www.torrentfunk.com%@", str] forKey:@"Torrent"];
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
                else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"itemscope"] isEqualToString:@"itemscope"]) {
                    hasDownloads = YES;
                    TZLog(@"%s: div : Downloads", __FUNCTION__);
                    TZLog(@"attributes: %@", attributeDict);
                }
            }
            else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"id"] isEqualToString:@"main"]) {
                hasMain = YES;
                TZLog(@"%s: div : Main", __FUNCTION__);
                TZLog(@"attributes: %@", attributeDict);
            }
        }
        else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"id"] isEqualToString:@"content"]) {
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
            if (hasMain) {
                if (hasDownloads) {
                    if (hasTable) {
                        if (hasRow) {
                            if (hasColumn) {
                                if (hasTorrent) {
                                    
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
            if (hasMain) {
                if (hasDownloads) {
                    if (hasTable) {
                        if (hasRow) {
                            if (hasColumn) {
                                if (hasTorrent) {
                                    if ([elementName isEqualToString:@"a"]) {
                                        hasTorrent = NO;
                                        TZLog(@"%s: a : Torrent", __FUNCTION__);
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
                        //hasDownloads = NO;
                        TZLog(@"%s: div : Downloads", __FUNCTION__);
                    }
                }
                else if ([elementName isEqualToString:@"div"]) {
                    //hasMain = NO;
                    TZLog(@"%s: div : Main", __FUNCTION__);
                }
            }
            else if ([elementName isEqualToString:@"div"]) {
                //hasContent = NO;
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
