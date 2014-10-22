//
//  TZ_yourbittorrent_PageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/15/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZ_yourbittorrent_PageParser.h"

@implementation TZ_yourbittorrent_PageParser {
    BOOL hasDocument;
    BOOL hasTable;
    BOOL hasRow;
    BOOL hasColumn;
    BOOL hasTorrent;
    BOOL hasTitle;
    
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
    hasTorrent = NO;
    hasTitle = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    if (hasDocument) {
        if (hasTable) {
            if (hasRow) {
                if (hasColumn) {
                    if (hasTorrent) {
                        if (hasTitle) {
                            
                        }
                        else if ([elementName isEqualToString:@"u"]) {
                            hasTitle = YES;
                            TZLog(@"%s: u : Title", __FUNCTION__);
                        }
                    }
                    else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=6 && [[str substringToIndex:6] isEqualToString:@"/down/"]) {
                        hasTorrent = YES;
                        TZLog(@"%s: a : Torrent", __FUNCTION__);
                        TZLog(@"attributes: %@", attributeDict);
                        [self.dataDict setObject:[NSString stringWithFormat:@"http://yourbittorrent.com%@", str] forKey:@"Torrent"];
                    }
                }
                else if ([elementName isEqualToString:@"td"] && (str = [attributeDict objectForKey:@"class"]) && [str isKindOfClass:[NSString class]] && [str length]>=3 && [[str substringToIndex:3] isEqualToString:@"alt"]) {
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
        else if ([elementName isEqualToString:@"table"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"table"]) {
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
                    if (hasTorrent) {
                        if (hasTitle) {
                            
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
                    if (hasTorrent) {
                        if (hasTitle) {
                            if ([elementName isEqualToString:@"u"]) {
                                hasTitle = NO;
                                TZLog(@"%s: u : Title", __FUNCTION__);
                            }
                        }
                        else if ([elementName isEqualToString:@"a"]) {
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
        else if ([elementName isEqualToString:@"html"]) {
            hasDocument = NO;
            TZLog(@"%s: html : Document", __FUNCTION__);
        }
    }
}

@end
