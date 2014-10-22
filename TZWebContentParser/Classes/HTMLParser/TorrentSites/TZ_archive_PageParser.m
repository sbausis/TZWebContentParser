//
//  TZ_archive_PageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/16/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZ_archive_PageParser.h"

@implementation TZ_archive_PageParser {
    BOOL hasTorrent;
    
    NSString *str;
}

#pragma mark -
#pragma mark NSHTMLParserDelegate

-(void)parserDidStartDocument:(DTHTMLParser *)parser {
    
    TZLog(@"%s", __FUNCTION__);
    self.dataDict = [[NSMutableDictionary alloc] init];
    
    hasTorrent = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    if (hasTorrent) {
        
    }
    else if ([elementName isEqualToString:@"a"] && (str = [attributeDict objectForKey:@"href"]) && [str isKindOfClass:[NSString class]] && [str length]>=10 && [[str substringToIndex:10] isEqualToString:@"/download/"] && [[str substringFromIndex:[str length]-8] isEqualToString:@".torrent"]) {
        hasTorrent= YES;
        TZLog(@"%s: a : Torrent", __FUNCTION__);
        TZLog(@"attributes: %@", attributeDict);
        [self.dataDict setObject:[NSString stringWithFormat:@"https://archive.org%@", str] forKey:@"Torrent"];
    }
}
-(void)parser:(DTHTMLParser *)parser didEndElement:(NSString *)elementName {
    
    if (hasTorrent) {
        if ([elementName isEqualToString:@"a"]) {
            hasTorrent = NO;
            TZLog(@"%s: a : Torrent", __FUNCTION__);
        }
    }
}

@end
