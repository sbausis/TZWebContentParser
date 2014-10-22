//
//  TZ_kickass_PageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/15/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZ_kickass_PageParser.h"

@implementation TZ_kickass_PageParser {
    BOOL hasContent;
    BOOL hasTable;
    BOOL hasRow;
    BOOL hasColumn;
    BOOL hasContainer;
    BOOL hasMagnet;
    BOOL hasTorrent;
    
    NSString *str;
}

#pragma mark -
#pragma mark NSHTMLParserDelegate

-(void)parserDidStartDocument:(DTHTMLParser *)parser {
    
    TZLog(@"%s", __FUNCTION__);
    self.dataDict = [[NSMutableDictionary alloc] init];
    
    hasContent = NO;
    hasTable = NO;
    hasRow = NO;
    hasColumn = NO;
    hasContainer = NO;
    hasMagnet = NO;
    hasTorrent = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    if (hasContent) {
        if (hasTable) {
            if (hasRow) {
                if (hasColumn) {
                    if (hasContainer) {
                        if (hasMagnet) {
                            
                        }
                        else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"title"]) && [str isKindOfClass:[NSString class]] && [str length]>6 && [[str substringToIndex:6] isEqualToString:@"Magnet"]) {
                            hasMagnet = YES;
                            TZLog(@"%s: a : Magnet", __FUNCTION__);
                            TZLog(@"attributes: %@", attributeDict);
                            [self.dataDict setObject:[[attributeDict objectForKey:@"href"] copy] forKey:@"Magnet"];
                        }
                        else if (hasTorrent) {
                            
                        }
                        else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"title"]) && [str isKindOfClass:[NSString class]] && [str length]>8 && [[str substringToIndex:8] isEqualToString:@"Download"]) {
                            hasTorrent = YES;
                            TZLog(@"%s: a : Torrent", __FUNCTION__);
                            TZLog(@"attributes: %@", attributeDict);
                            [self.dataDict setObject:[[attributeDict objectForKey:@"href"] copy] forKey:@"Torrent"];
                        }
                    }
                    else if ([elementName isEqualToString:@"div"] && (str = [attributeDict objectForKey:@"class"]) && [str isKindOfClass:[NSString class]] && [str length]>7 && [[str substringToIndex:7] isEqualToString:@"buttons"]) {
                        hasContainer = YES;
                        TZLog(@"%s: div : Container", __FUNCTION__);
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
        else if ([elementName isEqualToString:@"table"] && [[attributeDict objectForKey:@"id"] isEqualToString:@"mainDetailsTable"]) {
            hasTable = YES;
            TZLog(@"%s: table : Table", __FUNCTION__);
            TZLog(@"attributes: %@", attributeDict);
        }
    }
    else if ([elementName isEqualToString:@"html"]) {
        hasContent = YES;
        TZLog(@"%s: html : Content", __FUNCTION__);
    }
    
    /*
    if (hasContent) {
        if (hasTable) {
            if (hasRow) {
                if (hasColumn) {
                    if (hasContainer) {
                        if (hasMagnet) {
                            
                        }
                        else if (hasTorrent) {
                            
                        }
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
            if (hasRow) {
                if (hasColumn) {
                    if (hasContainer) {
                        if (hasMagnet) {
                            if ([elementName isEqualToString:@"a"]) {
                                hasMagnet = NO;
                                TZLog(@"%s: a : Magnet", __FUNCTION__);
                            }
                        }
                        else if (hasTorrent) {
                            if ([elementName isEqualToString:@"a"]) {
                                hasTorrent = NO;
                                TZLog(@"%s: a : Torrent", __FUNCTION__);
                            }
                        }
                        else if ([elementName isEqualToString:@"div"]) {
                            hasContainer = NO;
                            TZLog(@"%s: div : Container", __FUNCTION__);
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
            hasContent = NO;
            TZLog(@"%s: html : Content", __FUNCTION__);
        }
    }
}

@end

@implementation TZ_kickmirror_PageParser

@end
