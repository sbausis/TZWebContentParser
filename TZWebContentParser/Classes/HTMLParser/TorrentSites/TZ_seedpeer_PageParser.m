//
//  TZ_seedpeer_PageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/15/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZ_seedpeer_PageParser.h"

@implementation TZ_seedpeer_PageParser {
    BOOL hasDocument;
    BOOL hasDownloads;
    BOOL hasTorrent;
    BOOL hasIcon;
    BOOL hasTitleT;
    BOOL hasSub;
    BOOL hasTitleM;
    BOOL hasMagnet;
    
    NSString *str;
}

#pragma mark -
#pragma mark NSHTMLParserDelegate

-(void)parserDidStartDocument:(DTHTMLParser *)parser {
    
    TZLog(@"%s", __FUNCTION__);
    self.dataDict = [[NSMutableDictionary alloc] init];
    
    hasDocument = NO;
    hasDownloads = NO;
    hasTorrent = NO;
    hasIcon = NO;
    hasTitleT = NO;
    hasSub = NO;
    hasTitleM = NO;
    hasMagnet = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    if (hasDocument) {
        if (hasDownloads) {
            if (hasTorrent) {
                if (hasIcon) {
                    
                }
                else if ([elementName isEqualToString:@"div"]) {
                    hasIcon = YES;
                    TZLog(@"%s: div : Icon", __FUNCTION__);
                }
                else if (hasTitleT) {
                    
                }
                else if ([elementName isEqualToString:@"span"]) {
                    hasTitleT = YES;
                    TZLog(@"%s: span : TitleT", __FUNCTION__);
                }
            }
            else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=10 && [[str substringToIndex:10] isEqualToString:@"/download/"]) {
                hasTorrent = YES;
                TZLog(@"%s: a : Torrent", __FUNCTION__);
                TZLog(@"attributes: %@", attributeDict);
                [self.dataDict setObject:[NSString stringWithFormat:@"http://www.seedpeer.me%@", str] forKey:@"Torrent"];
            }
            else if (hasSub) {
                if (hasTitleM) {
                    if (hasMagnet) {
                        
                    }
                    else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=7 && [[str substringToIndex:7] isEqualToString:@"magnet:"]) {
                        hasMagnet = YES;
                        TZLog(@"%s: a : Magnet", __FUNCTION__);
                        TZLog(@"attributes: %@", attributeDict);
                        [self.dataDict setObject:[str copy] forKey:@"Magnet"];
                    }
                }
                else if ([elementName isEqualToString:@"span"]) {
                    hasTitleM = YES;
                    TZLog(@"%s: span : TitleM", __FUNCTION__);
                }
            }
            else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"dTSub"]) {
                hasSub = YES;
                TZLog(@"%s: div : Sub", __FUNCTION__);
                TZLog(@"attributes: %@", attributeDict);
            }
        }
        else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"downloadTorrent"]) {
            hasDownloads = YES;
            TZLog(@"%s: div : Downloads", __FUNCTION__);
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
            if (hasTorrent) {
                if (hasIcon) {
                    
                }
                else if (hasTitleT) {
                    
                }
            }
            else if (hasSub) {
                if (hasTitleM) {
                    if (hasMagnet) {
                        
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
            if (hasTorrent) {
                if (hasIcon) {
                    if ([elementName isEqualToString:@"div"]) {
                        hasIcon = NO;
                        TZLog(@"%s: div : Icon", __FUNCTION__);
                    }
                }
                else if (hasTitleT) {
                    if ([elementName isEqualToString:@"span"]) {
                        hasTitleT = NO;
                        TZLog(@"%s: span : TitleT", __FUNCTION__);
                    }
                }
                else if ([elementName isEqualToString:@"a"]) {
                    hasTorrent = NO;
                    TZLog(@"%s: a : Torrent", __FUNCTION__);
                }
            }
            else if (hasSub) {
                if (hasTitleM) {
                    if (hasMagnet) {
                        if ([elementName isEqualToString:@"a"]) {
                            hasMagnet = NO;
                            TZLog(@"%s: a : Magnet", __FUNCTION__);
                        }
                    }
                    else if ([elementName isEqualToString:@"span"]) {
                        hasTitleM = NO;
                        TZLog(@"%s: span : TitleM", __FUNCTION__);
                    }
                }
                else if ([elementName isEqualToString:@"div"]) {
                    hasSub = NO;
                    TZLog(@"%s: div : Sub", __FUNCTION__);
                }
            }
            else if ([elementName isEqualToString:@"div"]) {
                hasDownloads = NO;
                TZLog(@"%s: div : Downloads", __FUNCTION__);
            }
        }
        else if ([elementName isEqualToString:@"html"]) {
            hasDocument = NO;
            TZLog(@"%s: html : Document", __FUNCTION__);
        }
    }
}

@end
