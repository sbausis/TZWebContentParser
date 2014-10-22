//
//  TZ_publichd_PageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/16/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZ_publichd_PageParser.h"

@implementation TZ_publichd_PageParser {
    BOOL hasDocument;
    BOOL hasWrapper;
    BOOL hasContent;
    BOOL hasTable;
    BOOL hasRow;
    BOOL hasColumn;
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
    hasWrapper = NO;
    hasContent = NO;
    hasTable = NO;
    hasRow = NO;
    hasColumn = NO;
    hasTorrent = NO;
    hasMagnet = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    if (hasDocument) {
        if (hasWrapper) {
            if (hasContent) {
                if (hasTable) {
                    if (hasRow) {
                        if (hasColumn) {
                            if (hasTorrent) {
                                
                            }
                            else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=8 && [[str substringFromIndex:[str length]-8] isEqualToString:@".torrent"]) {
                                hasTorrent = YES;
                                TZLog(@"%s: a : Torrent", __FUNCTION__);
                                TZLog(@"attributes: %@", attributeDict);
                                [self.dataDict setObject:[str copy] forKey:@"Torrent"];
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
                else if ([elementName isEqualToString:@"table"] && [[attributeDict objectForKey:@"id"] isEqualToString:@"torrmain"]) {
                    hasTable = YES;
                    TZLog(@"%s: table : Table", __FUNCTION__);
                    TZLog(@"attributes: %@", attributeDict);
                }
            }
            else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"id"] isEqualToString:@"details_box_content"]) {
                hasContent = YES;
                TZLog(@"%s: div : Content", __FUNCTION__);
                TZLog(@"attributes: %@", attributeDict);
            }
        }
        else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"id"] isEqualToString:@"details_box_wrapper"]) {
            hasWrapper = YES;
            TZLog(@"%s: div : Wrapper", __FUNCTION__);
            TZLog(@"attributes: %@", attributeDict);
        }
    }
    else if ([elementName isEqualToString:@"html"]) {
        hasDocument = YES;
        TZLog(@"%s: html : Document", __FUNCTION__);
    }
    
    /*
    if (hasDocument) {
        if (hasWrapper) {
            if (hasContent) {
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
    */
}
-(void)parser:(DTHTMLParser *)parser didEndElement:(NSString *)elementName {
    
    if (hasDocument) {
        if (hasWrapper) {
            if (hasContent) {
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
                    //hasContent = NO;
                    TZLog(@"%s: div : Content", __FUNCTION__);
                }
            }
            else if ([elementName isEqualToString:@"div"]) {
                //hasWrapper = NO;
                TZLog(@"%s: div : Wrapper", __FUNCTION__);
            }
        }
        else if ([elementName isEqualToString:@"html"]) {
            hasDocument = NO;
            TZLog(@"%s: html : Document", __FUNCTION__);
        }
    }
}

@end
