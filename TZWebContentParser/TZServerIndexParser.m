//
//  TZServerIndexParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/11/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZServerIndexParser.h"

// Index Elements
#define STATS_INDEX_ELEMENT_NAME @"Stats"
#define SERVERS_INDEX_ELEMENT_NAME @"Servers"
#define PAGES_INDEX_ELEMENT_NAME @"Pages"

// Server Elements
#define ADDRESS_SERVER_ELEMENT_NAME @"Address"
#define SEARCH_SERVER_ELEMENT_NAME @"Search"
#define TITLE_SERVER_ELEMENT_NAME @"Title"
#define STYLE_SERVER_ELEMENT_NAME @"Style"
#define COUNT_SERVER_ELEMENT_NAME @"Count"

// HTML Elements
#define A_HTML_ELEMENT @"a"
#define DIV_HTML_ELEMENT @"div"
#define DL_HTML_ELEMENT @"dl"
#define DT_HTML_ELEMENT @"dt"
#define DD_HTML_ELEMENT @"dd"

@implementation TZServerIndexParser {
    
    NSMutableArray *servers;
    
    BOOL startedDocument;
    
    BOOL hasIndex;
    BOOL hasTotalPages;
    
    BOOL hasServer;
    BOOL hasDestination;
    BOOL hasTorrentCount;
    
    BOOL isAddress;
    BOOL isSiteSearch;
}

#pragma mark -
#pragma mark NSHTMLParserDelegate

-(void)parserDidStartDocument:(DTHTMLParser *)parser {
    
    TZLog(@"%s", __FUNCTION__);
    servers = [[NSMutableArray alloc] init];
    self.dataDict = [[NSMutableDictionary alloc] init];
    
    startedDocument = YES;
    
    hasIndex = NO;
    hasTotalPages = NO;
    
    hasServer = NO;
    hasDestination = NO;
    hasTorrentCount = NO;
    
    isAddress = NO;
    isSiteSearch = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    if (hasIndex) {
        if (hasServer) {
            if (hasDestination) {
                if ([elementName isEqualToString:A_HTML_ELEMENT]) {
                    isAddress = YES;
                    TZLog(@"%s: %@ : %@", __FUNCTION__, A_HTML_ELEMENT, ADDRESS_SERVER_ELEMENT_NAME);
                    TZLog(@"attributes: %@", attributeDict);
                    [(NSMutableDictionary*)[servers objectAtIndex:[servers count]-1] setObject:[attributeDict objectForKey:@"href"] forKey:ADDRESS_SERVER_ELEMENT_NAME];
                }
            }
            else if ([elementName isEqualToString:DT_HTML_ELEMENT]) {
                hasDestination = YES;
                TZLog(@"%s: %@ : %@", __FUNCTION__, DT_HTML_ELEMENT, ADDRESS_SERVER_ELEMENT_NAME);
                TZLog(@"attributes: %@", attributeDict);
                NSString* style = [attributeDict objectForKey:@"style"];
                NSRange start = [style rangeOfString:@"('"];
                NSRange stop = [style rangeOfString:@"')"];
                start.location = start.location+start.length;
                start.length = stop.location-start.location;
                style = [style substringWithRange:start];
                style = [NSString stringWithFormat:@"http://torrentz.eu%@", style];
                [(NSMutableDictionary*)[servers objectAtIndex:[servers count]-1] setObject:[style copy] forKey:STYLE_SERVER_ELEMENT_NAME];
                //[(NSMutableDictionary*)[servers objectAtIndex:[servers count]-1] setObject:[attributeDict objectForKey:@"style"] forKey:STYLE_SERVER_ELEMENT_NAME];
            }
            else if (hasTorrentCount) {
                if ([elementName isEqualToString:A_HTML_ELEMENT]) {
                    isSiteSearch = YES;
                    TZLog(@"%s: %@ : %@", __FUNCTION__, A_HTML_ELEMENT, SEARCH_SERVER_ELEMENT_NAME);
                    TZLog(@"attributes: %@", attributeDict);
                    NSString *addr = [NSString stringWithFormat:@"http://torrentz.eu%@", [attributeDict objectForKey:@"href"]];
                    [(NSMutableDictionary*)[servers objectAtIndex:[servers count]-1] setObject:addr forKey:SEARCH_SERVER_ELEMENT_NAME];
                }
            }
            else if ([elementName isEqualToString:DD_HTML_ELEMENT]) {
                hasTorrentCount = YES;
                TZLog(@"%s: %@ : %@", __FUNCTION__, DD_HTML_ELEMENT, COUNT_SERVER_ELEMENT_NAME);
            }
        }
        else if ([elementName isEqualToString:DL_HTML_ELEMENT]) {
            hasServer = YES;
            TZLog(@"%s: %@ : %@", __FUNCTION__, DL_HTML_ELEMENT, SERVERS_INDEX_ELEMENT_NAME);
            [servers addObject:[[NSMutableDictionary alloc] init]];
        }
        else if ([elementName isEqualToString:DIV_HTML_ELEMENT]) {
            hasTotalPages = YES;
            TZLog(@"%s: %@ : %@", __FUNCTION__, DIV_HTML_ELEMENT, PAGES_INDEX_ELEMENT_NAME);
        }
    }
    else if ([elementName isEqualToString:DIV_HTML_ELEMENT] && [[attributeDict objectForKey:@"class"] isEqualToString:@"index-stats"]) {
        hasIndex = YES;
        TZLog(@"%s: %@ : %@", __FUNCTION__, DIV_HTML_ELEMENT, STATS_INDEX_ELEMENT_NAME);
    }
}
-(void)parser:(DTHTMLParser *)parser foundCharacters:(NSString *)string {
    NSString *newString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([newString length] > 0) {
        if (hasIndex) {
            if (hasServer) {
                if (hasDestination && isAddress){
                    TZLog(@"%s: %@: %@", __FUNCTION__, ADDRESS_SERVER_ELEMENT_NAME, newString);
                    [(NSMutableDictionary*)[servers objectAtIndex:[servers count]-1] setObject:[newString copy] forKey:TITLE_SERVER_ELEMENT_NAME];
                }
                else if (hasTorrentCount && isSiteSearch) {
                    TZLog(@"%s: %@: %@", __FUNCTION__, SEARCH_SERVER_ELEMENT_NAME, newString);
                    NSNumber* count = [NSNumber numberWithInteger:[[newString stringByReplacingOccurrencesOfString:@"," withString:@""] integerValue]];
                    [(NSMutableDictionary*)[servers objectAtIndex:[servers count]-1] setObject:[count copy] forKey:COUNT_SERVER_ELEMENT_NAME];
                    //[(NSMutableDictionary*)[servers objectAtIndex:[servers count]-1] setObject:[newString copy] forKey:COUNT_SERVER_ELEMENT_NAME];
                }
                else {
                    TZLog(@"%s: %@: %@", __FUNCTION__, SERVERS_INDEX_ELEMENT_NAME, newString);
                }
            }
            else if (hasTotalPages) {
                TZLog(@"%s: %@: %@", __FUNCTION__, PAGES_INDEX_ELEMENT_NAME, newString);
                NSNumber* count = [NSNumber numberWithInteger:[[[newString substringFromIndex:13] stringByReplacingOccurrencesOfString:@"," withString:@""] integerValue]];
                [self.dataDict setObject:[count copy] forKey:PAGES_INDEX_ELEMENT_NAME];
                //[self.dataDict setObject:[newString copy] forKey:PAGES_INDEX_ELEMENT_NAME];
            }
            else {
                TZLog(@"%s: %@: %@", __FUNCTION__, STATS_INDEX_ELEMENT_NAME, newString);
                [self.dataDict setObject:[newString copy] forKey:STATS_INDEX_ELEMENT_NAME];
            }
        }
    }
}
-(void)parser:(DTHTMLParser *)parser didEndElement:(NSString *)elementName {
    if (hasIndex) {
        if (hasServer) {
            if (hasDestination){
                if (isAddress) {
                    if ([elementName isEqualToString:A_HTML_ELEMENT]) {
                        isAddress = NO;
                        TZLog(@"%s: %@ : %@", __FUNCTION__, A_HTML_ELEMENT, ADDRESS_SERVER_ELEMENT_NAME);
                    }
                }
                else if ([elementName isEqualToString:DT_HTML_ELEMENT]) {
                    hasDestination = NO;
                    TZLog(@"%s: %@ : %@", __FUNCTION__, DT_HTML_ELEMENT, ADDRESS_SERVER_ELEMENT_NAME);
                }
            }
            else if (hasTorrentCount) {
                if (isSiteSearch) {
                    if ([elementName isEqualToString:A_HTML_ELEMENT]) {
                        isSiteSearch = NO;
                        TZLog(@"%s: %@ : %@", __FUNCTION__, A_HTML_ELEMENT, SEARCH_SERVER_ELEMENT_NAME);
                    }
                }
                else if ([elementName isEqualToString:DD_HTML_ELEMENT]) {
                    hasTorrentCount = NO;
                    TZLog(@"%s: %@ : %@", __FUNCTION__, DD_HTML_ELEMENT, COUNT_SERVER_ELEMENT_NAME);
                }
            }
            else if ([elementName isEqualToString:DL_HTML_ELEMENT]) {
                hasServer = NO;
                TZLog(@"%s: %@ : %@", __FUNCTION__, DL_HTML_ELEMENT, SERVERS_INDEX_ELEMENT_NAME);
            }
        }
        else if (hasTotalPages) {
            if ([elementName isEqualToString:DIV_HTML_ELEMENT]) {
                hasTotalPages = NO;
                TZLog(@"%s: %@ : %@", __FUNCTION__, DIV_HTML_ELEMENT, PAGES_INDEX_ELEMENT_NAME);
            }
        }
        else if ([elementName isEqualToString:DIV_HTML_ELEMENT]) {
            hasIndex = NO;
            TZLog(@"%s: %@ : %@", __FUNCTION__, DIV_HTML_ELEMENT, STATS_INDEX_ELEMENT_NAME);
        }
    }
}
-(void)parser:(DTHTMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    TZLog(@"%s: [%@] %@, %ld, %ld", __FUNCTION__, parser, parseError, (long)[parser lineNumber], (long)[parser columnNumber]);
    startedDocument = NO;
}
-(void)parserDidEndDocument:(DTHTMLParser *)parser {
    TZLog(@"%s: [%@]", __FUNCTION__, parser);
    startedDocument = NO;
    NSArray *sortedArray;
    sortedArray = [servers sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSNumber *first = [(NSDictionary*)a objectForKey:@"Count"];
        NSNumber *second = [(NSDictionary*)b objectForKey:@"Count"];
        return [first isLessThanOrEqualTo:second];
    }];
    [self.dataDict setObject:sortedArray forKey:SERVERS_INDEX_ELEMENT_NAME];
    //[self.dataDict setObject:servers forKey:SERVERS_INDEX_ELEMENT_NAME];
    //TZLog(@"array: %@ %lu", servers, (unsigned long)[servers count]);
    //TZLog(@"dict: %@ %lu %lu", self.dataDict, (unsigned long)[self.dataDict count], (unsigned long)[(NSMutableArray*)[self.dataDict objectForKey:SERVERS_INDEX_ELEMENT_NAME] count]);
    if ([self.dataDict count] > 0) {
        [self.htmlParserDelegate htmlParserDidEnd:self];
    }
    else {
        [self.htmlParserDelegate htmlParserDidFail:self];
    }
}

@end
