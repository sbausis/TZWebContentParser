//
//  TZ_torrentdownloads_PageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/15/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZ_torrentdownloads_PageParser.h"

@implementation TZ_torrentdownloads_PageParser {
    BOOL hasContent;
    
    BOOL hasDownload;
    BOOL hasEntry;
    BOOL hasLink;
    BOOL hasImage;
    
    BOOL hasLine;
    BOOL hasTitle;
    BOOL isTitle;
    BOOL hasMagnet;
    
    NSString *str;
}

#pragma mark -
#pragma mark NSHTMLParserDelegate

-(void)parserDidStartDocument:(DTHTMLParser *)parser {
    
    TZLog(@"%s", __FUNCTION__);
    self.dataDict = [[NSMutableDictionary alloc] init];
    
    hasContent = NO;
    
    hasDownload = NO;
    hasEntry = NO;
    hasLink = NO;
    hasImage = NO;
    
    hasLine = NO;
    hasTitle = NO;
    isTitle = NO;
    hasMagnet = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    if (hasContent) {
        if (hasDownload) {
            if (hasEntry) {
                if (hasLink) {
                    if (hasImage) {
                        
                    }
                    else if ([elementName isEqualToString:@"img"]) {
                        hasImage = YES;
                        TZLog(@"%s: img : Image", __FUNCTION__);
                        TZLog(@"attributes: %@", attributeDict);
                    }
                }
                else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=1 && [[str substringToIndex:1] isEqualToString:@"/"]) {
                    hasLink = YES;
                    TZLog(@"%s: a : Link", __FUNCTION__);
                    TZLog(@"attributes: %@", attributeDict);
                    [self.dataDict setObject:[NSString stringWithFormat:@"http://www.torrentdownloads.me%@", str] forKey:@"Torrent"];
                }
            }
            else if ([elementName isEqualToString:@"li"]) {
                hasEntry = YES;
                TZLog(@"%s: li : Entry", __FUNCTION__);
            }
        }
        else if ([elementName isEqualToString:@"ul"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"download"]) {
            hasDownload = YES;
            TZLog(@"%s: ul : Download", __FUNCTION__);
        }
        else if (hasLine) {
            if (hasTitle) {
                if (isTitle) {
                    
                }
                else if ([elementName isEqualToString:@"span"]) {
                    isTitle = YES;
                    TZLog(@"%s: span : Title2", __FUNCTION__);
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
            else if ([elementName isEqualToString:@"p"]) {
                hasTitle = YES;
                TZLog(@"%s: p : Title", __FUNCTION__);
            }
        }
        else if ([elementName isEqualToString:@"div"] && ([[attributeDict objectForKey:@"class"] isEqualToString:@"grey_bar1 back_none"] || [[attributeDict objectForKey:@"class"] isEqualToString:@"grey_bar1"])) {
            hasLine = YES;
            TZLog(@"%s: div : Line", __FUNCTION__);
        }
    }
    else if ([elementName isEqualToString:@"html"]) {
        hasContent = YES;
        TZLog(@"%s: html : Content", __FUNCTION__);
    }
    
    /*
    if (hasContent) {
        if (hasDownload) {
            if (hasEntry) {
                if (hasLink) {
                    if (hasImage) {
                        
                    }
                }
            }
        }
        else if (hasLine) {
            if (hasTitle) {
                if (isTitle) {
                    
                }
                else if (hasMagnet) {
                    
                }
            }
        }
    }
    */
}
-(void)parser:(DTHTMLParser *)parser didEndElement:(NSString *)elementName {
    
    if (hasContent) {
        if (hasDownload) {
            if (hasEntry) {
                if (hasLink) {
                    if (hasImage) {
                        if ([elementName isEqualToString:@"img"]) {
                            hasImage = NO;
                            TZLog(@"%s: img : Image", __FUNCTION__);
                        }
                    }
                    else if ([elementName isEqualToString:@"a"]) {
                        hasLink = NO;
                        TZLog(@"%s: a : Link", __FUNCTION__);
                    }
                }
                else if ([elementName isEqualToString:@"li"]) {
                    hasEntry = NO;
                    TZLog(@"%s: li : Entry", __FUNCTION__);
                }
            }
            else if ([elementName isEqualToString:@"ul"]) {
                hasDownload = NO;
                TZLog(@"%s: ul : Download", __FUNCTION__);
            }
        }
        else if (hasLine) {
            if (hasTitle) {
                if (isTitle) {
                    if ([elementName isEqualToString:@"span"]) {
                        isTitle = NO;
                        TZLog(@"%s: span : Title2", __FUNCTION__);
                    }
                }
                else if (hasMagnet) {
                    if ([elementName isEqualToString:@"a"]) {
                        hasMagnet = NO;
                        TZLog(@"%s: a : Magnet", __FUNCTION__);
                    }
                }
                else if ([elementName isEqualToString:@"p"]) {
                    hasTitle = NO;
                    TZLog(@"%s: p : Title", __FUNCTION__);
                }
            }
            else if ([elementName isEqualToString:@"div"]) {
                hasLine = NO;
                TZLog(@"%s: div : Line", __FUNCTION__);
            }
        }
        else if ([elementName isEqualToString:@"html"]) {
            hasContent = NO;
            TZLog(@"%s: html : Content", __FUNCTION__);
        }
    }
}

@end
