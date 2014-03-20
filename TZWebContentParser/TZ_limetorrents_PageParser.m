//
//  TZ_limetorrents_PageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/15/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZ_limetorrents_PageParser.h"

@implementation TZ_limetorrents_PageParser {
    BOOL hasDocument;
    BOOL hasTable;
    BOOL hasRow;
    BOOL hasColumn;
    BOOL isTable;
    BOOL hasContent;
    BOOL hasDownloads;
    BOOL hasTorrent;
    BOOL hasTitle;
    BOOL hasLink;
    
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
    isTable = NO;
    hasContent = NO;
    hasDownloads = NO;
    hasTorrent = NO;
    hasTitle = NO;
    hasLink = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    if (hasDocument) {
        if (hasTable) {
            if (hasRow) {
                if (hasColumn) {
                    if (isTable) {
                        
                    }
                    else if ([elementName isEqualToString:@"table"]) {
                        isTable = YES;
                        TZLog(@"%s: table : Table2", __FUNCTION__);
                    }
                    else if (hasContent) {
                        if (hasDownloads) {
                            if (hasTorrent) {
                                
                            }
                            else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=37 && [[str substringToIndex:37] isEqualToString:@"http://www.limetorrents.com/download/"]) {
                                hasTorrent = YES;
                                TZLog(@"%s: a : Torrent", __FUNCTION__);
                                TZLog(@"attributes: %@", attributeDict);
                                [self.dataDict setObject:[str copy] forKey:@"Torrent"];
                            }
                            else if (hasTitle) {
                                if (hasLink) {
                                    
                                }
                                else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=37 && [[str substringToIndex:37] isEqualToString:@"http://www.limetorrents.com/download/"]) {
                                    hasLink = YES;
                                    TZLog(@"%s: a : Link", __FUNCTION__);
                                    TZLog(@"attributes: %@", attributeDict);
                                    [self.dataDict setObject:[str copy] forKey:@"Torrent"];
                                }
                            }
                            else if ([elementName isEqualToString:@"p"]) {
                                hasTitle = YES;
                                TZLog(@"%s: p : Title", __FUNCTION__);
                            }
                        }
                        else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"dltorrent"]) {
                            hasDownloads = YES;
                            TZLog(@"%s: div : Downloads", __FUNCTION__);
                            TZLog(@"attributes: %@", attributeDict);
                        }
                    }
                    else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"downloadarea"]) {
                        hasContent = YES;
                        TZLog(@"%s: div : Content", __FUNCTION__);
                        TZLog(@"attributes: %@", attributeDict);
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
                        if (hasDownloads) {
                            if (hasTorrent) {
                                
                            }
                            else if (hasTitle) {
                                if (hasLink) {
                                    
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
                    if (isTable) {
                        if ([elementName isEqualToString:@"table"]) {
                            isTable = NO;
                            TZLog(@"%s: table : Table2", __FUNCTION__);
                        }
                    }
                    else if (hasContent) {
                        if (hasDownloads) {
                            if (hasTorrent) {
                                if ([elementName isEqualToString:@"a"]) {
                                    hasTorrent = NO;
                                    TZLog(@"%s: a : Torrent", __FUNCTION__);
                                }
                            }
                            else if (hasTitle) {
                                if (hasLink) {
                                    if ([elementName isEqualToString:@"a"]) {
                                        hasLink = NO;
                                        TZLog(@"%s: a : Link", __FUNCTION__);
                                    }
                                }
                                else if ([elementName isEqualToString:@"p"]) {
                                    hasTitle = NO;
                                    TZLog(@"%s: p : Title", __FUNCTION__);
                                }
                            }
                            else if ([elementName isEqualToString:@"div"]) {
                                hasDownloads = NO;
                                TZLog(@"%s: div : Downloads", __FUNCTION__);
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
