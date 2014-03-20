//
//  TZ_bt_chat_PageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/16/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZ_bt_chat_PageParser.h"

@implementation TZ_bt_chat_PageParser {
    BOOL hasDocument;
    BOOL hasDownloads;
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
    hasDownloads = NO;
    hasRow = NO;
    hasColumn = NO;
    hasTorrent = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    if (hasDocument) {
        if (hasDownloads) {
            if (hasRow) {
                if (hasColumn) {
                    if (hasTorrent) {
                        
                    }
                    else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=13 && [[str substringToIndex:13] isEqualToString:@"download.php?"]) {
                        hasTorrent = YES;
                        TZLog(@"%s: a : Torrent", __FUNCTION__);
                        TZLog(@"attributes: %@", attributeDict);
                        [self.dataDict setObject:[NSString stringWithFormat:@"http://www.bt-chat.com/%@", str] forKey:@"Torrent"];
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
        else if ([elementName isEqualToString:@"table"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"all"]) {
            hasDownloads = YES;
            TZLog(@"%s: table : Downloads", __FUNCTION__);
            TZLog(@"attributes: %@", attributeDict);
        }
    }
    else if ([elementName isEqualToString:@"html"]) {
        hasDocument = YES;
        TZLog(@"%s: html : Document", __FUNCTION__);
    }
    
    /*
    if (hasDocument) {
        if (hasDownloads) {
            if (hasRow) {
                if (hasColumn) {
                    if (hasTorrent) {
                        
                    }
                }
            }
        }
    }
    */
}
-(void)parser:(DTHTMLParser *)parser didEndElement:(NSString *)elementName {
    
    if (hasDocument) {
        if (hasDownloads) {
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
                hasDownloads = NO;
                TZLog(@"%s: table : Downloads", __FUNCTION__);
            }
        }
        else if ([elementName isEqualToString:@"html"]) {
            hasDocument = NO;
            TZLog(@"%s: html : Document", __FUNCTION__);
        }
    }
}

@end
