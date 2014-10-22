//
//  TZXmlFeedParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/11/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZXmlFeedParser.h"

// Groups
#define XMLFEED_ELEMENT_NAME @"rss"
#define CHANNEL_ELEMENT_NAME @"channel"
#define ITEM_ELEMENT_NAME @"item"

// Channel Elements
#define TITLE_CHANNEL_ELEMENT_NAME @"title"
#define LINK_CHANNEL_ELEMENT_NAME @"link"
#define DESC_CHANNEL_ELEMENT_NAME @"description"
#define LANG_CHANNEL_ELEMENT_NAME @"language"
#define ATOM_CHANNEL_ELEMENT_NAME @"atom:link"

// Item Elements
#define TITLE_ITEM_ELEMENT_NAME @"title"
#define LINK_ITEM_ELEMENT_NAME @"link"
#define GUID_ITEM_ELEMENT_NAME @"guid"
#define PUBDATE_ITEM_ELEMENT_NAME @"pubDate"
#define CAT_ITEM_ELEMENT_NAME @"category"
#define DESC_ITEM_ELEMENT_NAME @"description"

// Description Attributes
#define SIZE_DESC_ITEM_ATTRIBUTE_NAME @"Size"
#define SEEDS_DESC_ITEM_ATTRIBUTE_NAME @"Seeds"
#define PEERS_DESC_ITEM_ATTRIBUTE_NAME @"Peers"
#define HASH_DESC_ITEM_ATTRIBUTE_NAME @"Hash"

@implementation TZXmlFeedParser {
    
    // Items
    NSMutableArray *items;
    
    BOOL startedDocument;
    
    // Groups
    BOOL hasXMLFeed;
    BOOL hasChannel;
    BOOL hasItem;
    
    // Channel Elements
    BOOL isChannelTitle;
    BOOL isChannelLink;
    BOOL isChannelDescription;
    BOOL isChannelLanguage;
    BOOL isChannelAtomLink;
    
    // Item Elements
    BOOL isItemTitle;
    BOOL isItemLink;
    BOOL isItemGuid;
    BOOL isItemPubDate;
    BOOL isItemCategory;
    BOOL isItemDescription;
    
}

+ (NSString*)getStringFromAttributeString:(NSString*)aString forAttribute:(NSString*)attribute withSeperator:(NSString*)seperator {
    NSString *newString = nil;
    NSString *search = [NSString stringWithFormat:@"%@%@", attribute, seperator];
    NSArray *arrayOfEntries = [aString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    for (NSString *str in arrayOfEntries) {
        if (newString == nil) {
            if ([str isEqualToString:search]) newString = @"";
        }
        else {
            if ([str rangeOfString:seperator].location!=NSNotFound) break;
            if ([newString length]) newString = [newString stringByAppendingFormat:@" %@", str];
            else newString = [newString stringByAppendingString:str];
        }
    }
    return newString;
}

#pragma mark -
#pragma mark NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    
    TZLog(@"%s:", __FUNCTION__);
    items = [[NSMutableArray alloc] init];
    self.dataDict = [[NSMutableDictionary alloc] init];
    
    startedDocument = YES;
    
    // Groups
    hasXMLFeed = NO;
    hasChannel = NO;
    hasItem = NO;
    
    // Channel Elements
    isChannelTitle = NO;
    isChannelLink = NO;
    isChannelDescription = NO;
    isChannelLanguage = NO;
    isChannelAtomLink = NO;
    
    // Item Elements
    isItemTitle = NO;
    isItemLink = NO;
    isItemGuid = NO;
    isItemPubDate = NO;
    isItemCategory = NO;
    isItemDescription = NO;
    
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
    attributes: (NSDictionary *)attributeDict {
    
    if (hasXMLFeed) {
        if (hasChannel) {
            if (hasItem) {
                if ([elementName isEqualToString:TITLE_ITEM_ELEMENT_NAME]) {
                    
                    isItemTitle = YES;
                    TZLog(@"%s: %@", __FUNCTION__, TITLE_ITEM_ELEMENT_NAME);
                }
                else if ([elementName isEqualToString:LINK_ITEM_ELEMENT_NAME]) {
                    
                    isItemLink = YES;
                    TZLog(@"%s: %@", __FUNCTION__, LINK_ITEM_ELEMENT_NAME);
                }
                else if ([elementName isEqualToString:GUID_ITEM_ELEMENT_NAME]) {
                    
                    isItemGuid = YES;
                    TZLog(@"%s: %@", __FUNCTION__, GUID_ITEM_ELEMENT_NAME);
                }
                else if ([elementName isEqualToString:PUBDATE_ITEM_ELEMENT_NAME]) {
                    
                    isItemPubDate = YES;
                    TZLog(@"%s: %@", __FUNCTION__, PUBDATE_ITEM_ELEMENT_NAME);
                }
                else if ([elementName isEqualToString:CAT_ITEM_ELEMENT_NAME]) {
                    
                    isItemCategory = YES;
                    TZLog(@"%s: %@", __FUNCTION__, CAT_ITEM_ELEMENT_NAME);
                }
                else if ([elementName isEqualToString:DESC_ITEM_ELEMENT_NAME]) {
                    
                    isItemDescription = YES;
                    TZLog(@"%s: %@", __FUNCTION__, DESC_ITEM_ELEMENT_NAME);
                }
            }
            else if ([elementName isEqualToString:ITEM_ELEMENT_NAME]) {
                
                hasItem = YES;
                TZLog(@"%s: %@", __FUNCTION__, ITEM_ELEMENT_NAME);
                [items addObject:[[NSMutableDictionary alloc] init]];
            }
            else if ([elementName isEqualToString:TITLE_CHANNEL_ELEMENT_NAME]) {
                
                isChannelTitle = YES;
                TZLog(@"%s: %@", __FUNCTION__, TITLE_CHANNEL_ELEMENT_NAME);
            }
            else if ([elementName isEqualToString:LINK_CHANNEL_ELEMENT_NAME]) {
                
                isChannelLink = YES;
                TZLog(@"%s: %@", __FUNCTION__, LINK_CHANNEL_ELEMENT_NAME);
            }
            else if ([elementName isEqualToString:DESC_CHANNEL_ELEMENT_NAME]) {
                
                isChannelDescription = YES;
                TZLog(@"%s: %@", __FUNCTION__, DESC_CHANNEL_ELEMENT_NAME);
            }
            else if ([elementName isEqualToString:LANG_CHANNEL_ELEMENT_NAME]) {
                
                isChannelLanguage = YES;
                TZLog(@"%s: %@", __FUNCTION__, LANG_CHANNEL_ELEMENT_NAME);
            }
            else if ([elementName isEqualToString:ATOM_CHANNEL_ELEMENT_NAME]) {
                
                isChannelAtomLink = YES;
                TZLog(@"%s: %@", __FUNCTION__, ATOM_CHANNEL_ELEMENT_NAME);
                TZLog(@"    attributes: %@", attributeDict);
                [self.dataDict addEntriesFromDictionary:attributeDict];
            }
        }
        else if ([elementName isEqualToString:CHANNEL_ELEMENT_NAME]) {
            
            hasChannel = YES;
            TZLog(@"%s: %@", __FUNCTION__, CHANNEL_ELEMENT_NAME);
        }
    }
    else if ([elementName isEqualToString:XMLFEED_ELEMENT_NAME]) {
        
        hasXMLFeed = YES;
        TZLog(@"%s: %@", __FUNCTION__, XMLFEED_ELEMENT_NAME);
        TZLog(@"    attributes: %@", attributeDict);
        [self.dataDict addEntriesFromDictionary:attributeDict];
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    NSString *newString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([newString length] > 0) {
        if (hasXMLFeed) {
            if (hasChannel) {
                if (hasItem) {
                    if (isItemTitle) {
                        TZLog(@"%s: for %@: %@", __FUNCTION__, TITLE_ITEM_ELEMENT_NAME, newString);
                        [(NSMutableDictionary*)[items objectAtIndex:[items count]-1] setObject:[newString copy] forKey:TITLE_ITEM_ELEMENT_NAME];
                    }
                    else if (isItemLink) {
                        TZLog(@"%s: for %@: %@", __FUNCTION__, LINK_ITEM_ELEMENT_NAME, newString);
                        [(NSMutableDictionary*)[items objectAtIndex:[items count]-1] setObject:[newString copy] forKey:LINK_ITEM_ELEMENT_NAME];
                    }
                    else if (isItemGuid) {
                        TZLog(@"%s: for %@: %@", __FUNCTION__, GUID_ITEM_ELEMENT_NAME, newString);
                        [(NSMutableDictionary*)[items objectAtIndex:[items count]-1] setObject:[newString copy] forKey:GUID_ITEM_ELEMENT_NAME];
                    }
                    else if (isItemPubDate) {
                        TZLog(@"%s: for %@: %@", __FUNCTION__, PUBDATE_ITEM_ELEMENT_NAME, newString);
                        [(NSMutableDictionary*)[items objectAtIndex:[items count]-1] setObject:[newString copy] forKey:PUBDATE_ITEM_ELEMENT_NAME];
                    }
                    else if (isItemCategory) {
                        TZLog(@"%s: for %@: %@", __FUNCTION__, CAT_ITEM_ELEMENT_NAME, newString);
                        [(NSMutableDictionary*)[items objectAtIndex:[items count]-1] setObject:[newString copy] forKey:CAT_ITEM_ELEMENT_NAME];
                    }
                    else if (isItemDescription) {
                        TZLog(@"%s: for %@: %@", __FUNCTION__, DESC_ITEM_ELEMENT_NAME, newString);
                        [(NSMutableDictionary*)[items objectAtIndex:[items count]-1] setObject:[newString copy] forKey:DESC_ITEM_ELEMENT_NAME];
                        [(NSMutableDictionary*)[items objectAtIndex:[items count]-1] setObject:[[self class] getStringFromAttributeString:newString forAttribute:SIZE_DESC_ITEM_ATTRIBUTE_NAME withSeperator:@":"] forKey:SIZE_DESC_ITEM_ATTRIBUTE_NAME];
                        [(NSMutableDictionary*)[items objectAtIndex:[items count]-1] setObject:[[self class] getStringFromAttributeString:newString forAttribute:SEEDS_DESC_ITEM_ATTRIBUTE_NAME withSeperator:@":"] forKey:SEEDS_DESC_ITEM_ATTRIBUTE_NAME];
                        [(NSMutableDictionary*)[items objectAtIndex:[items count]-1] setObject:[[self class] getStringFromAttributeString:newString forAttribute:PEERS_DESC_ITEM_ATTRIBUTE_NAME withSeperator:@":"] forKey:PEERS_DESC_ITEM_ATTRIBUTE_NAME];
                        [(NSMutableDictionary*)[items objectAtIndex:[items count]-1] setObject:[[self class] getStringFromAttributeString:newString forAttribute:HASH_DESC_ITEM_ATTRIBUTE_NAME withSeperator:@":"] forKey:HASH_DESC_ITEM_ATTRIBUTE_NAME];
                    }
                }
                else if (isChannelTitle) {
                    TZLog(@"%s: for %@: %@", __FUNCTION__, TITLE_CHANNEL_ELEMENT_NAME, string);
                    [self.dataDict setObject:[string copy] forKey:TITLE_CHANNEL_ELEMENT_NAME];
                }
                else if (isChannelLink) {
                    TZLog(@"%s: for %@: %@", __FUNCTION__, LINK_CHANNEL_ELEMENT_NAME, string);
                    [self.dataDict setObject:[string copy] forKey:LINK_CHANNEL_ELEMENT_NAME];
                }
                else if (isChannelDescription) {
                    TZLog(@"%s: for %@: %@", __FUNCTION__, DESC_CHANNEL_ELEMENT_NAME, string);
                    [self.dataDict setObject:[string copy] forKey:DESC_CHANNEL_ELEMENT_NAME];
                }
                else if (isChannelLanguage) {
                    TZLog(@"%s: for %@: %@", __FUNCTION__, LANG_CHANNEL_ELEMENT_NAME, string);
                    [self.dataDict setObject:[string copy] forKey:LANG_CHANNEL_ELEMENT_NAME];
                }
                else if (isChannelAtomLink) {
                    TZLog(@"%s: for %@: %@", __FUNCTION__, ATOM_CHANNEL_ELEMENT_NAME, string);
                    [self.dataDict setObject:[string copy] forKey:ATOM_CHANNEL_ELEMENT_NAME];
                }
            }
        }
    }
    
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if (hasXMLFeed) {
        if (hasChannel) {
            if (hasItem) {
                if ([elementName isEqualToString:ITEM_ELEMENT_NAME]) {
                    
                    hasItem = NO;
                    TZLog(@"%s: %@", __FUNCTION__, ITEM_ELEMENT_NAME);
                }
                else if ([elementName isEqualToString:TITLE_ITEM_ELEMENT_NAME]) {
                    
                    isItemTitle = NO;
                    TZLog(@"%s: %@", __FUNCTION__, TITLE_ITEM_ELEMENT_NAME);
                }
                else if ([elementName isEqualToString:LINK_ITEM_ELEMENT_NAME]) {
                    
                    isItemLink = NO;
                    TZLog(@"%s: %@", __FUNCTION__, LINK_ITEM_ELEMENT_NAME);
                }
                else if ([elementName isEqualToString:GUID_ITEM_ELEMENT_NAME]) {
                    
                    isItemGuid = NO;
                    TZLog(@"%s: %@", __FUNCTION__, GUID_ITEM_ELEMENT_NAME);
                }
                else if ([elementName isEqualToString:PUBDATE_ITEM_ELEMENT_NAME]) {
                    
                    isItemPubDate = NO;
                    TZLog(@"%s: %@", __FUNCTION__, PUBDATE_ITEM_ELEMENT_NAME);
                }
                else if ([elementName isEqualToString:CAT_ITEM_ELEMENT_NAME]) {
                    
                    isItemCategory = NO;
                    TZLog(@"%s: %@", __FUNCTION__, CAT_ITEM_ELEMENT_NAME);
                }
                else if ([elementName isEqualToString:DESC_ITEM_ELEMENT_NAME]) {
                    
                    isItemDescription = NO;
                    TZLog(@"%s: %@", __FUNCTION__, DESC_ITEM_ELEMENT_NAME);
                }
            }
            else if ([elementName isEqualToString:CHANNEL_ELEMENT_NAME]) {
                
                hasChannel = NO;
                TZLog(@"%s: %@", __FUNCTION__, CHANNEL_ELEMENT_NAME);
            }
            else if ([elementName isEqualToString:TITLE_CHANNEL_ELEMENT_NAME]) {
                
                isChannelTitle = NO;
                TZLog(@"%s: %@", __FUNCTION__, TITLE_CHANNEL_ELEMENT_NAME);
            }
            else if ([elementName isEqualToString:LINK_CHANNEL_ELEMENT_NAME]) {
                
                isChannelLink = NO;
                TZLog(@"%s: %@", __FUNCTION__, LINK_CHANNEL_ELEMENT_NAME);
            }
            else if ([elementName isEqualToString:DESC_CHANNEL_ELEMENT_NAME]) {
                
                isChannelDescription = NO;
                TZLog(@"%s: %@", __FUNCTION__, DESC_CHANNEL_ELEMENT_NAME);
            }
            else if ([elementName isEqualToString:LANG_CHANNEL_ELEMENT_NAME]) {
                
                isChannelLanguage = NO;
                TZLog(@"%s: %@", __FUNCTION__, LANG_CHANNEL_ELEMENT_NAME);
            }
            else if ([elementName isEqualToString:ATOM_CHANNEL_ELEMENT_NAME]) {
                
                isChannelAtomLink = NO;
                TZLog(@"%s: %@", __FUNCTION__, ATOM_CHANNEL_ELEMENT_NAME);
            }
        }
        else if ([elementName isEqualToString:XMLFEED_ELEMENT_NAME]) {
            
            hasXMLFeed = NO;
            TZLog(@"%s: %@", __FUNCTION__, XMLFEED_ELEMENT_NAME);
        }
    }
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if (hasXMLFeed || hasChannel || hasItem) {
        TZLog(@"%s: [%@] %@, %ld, %ld", __FUNCTION__, parser, parseError, (long)[parser lineNumber], (long)[parser columnNumber]);
    }
    startedDocument = NO;
}
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    TZLog(@"%s: [%@]", __FUNCTION__, parser);
    startedDocument = NO;
    [self.dataDict setObject:items forKey:ITEM_ELEMENT_NAME];
    //TZLog(@"array: %@ %lu", items, (unsigned long)[items count]);
    //TZLog(@"dict: %@ %lu %lu", self.dataDict, (unsigned long)[self.dataDict count], (unsigned long)[(NSMutableArray*)[self.dataDict objectForKey:ITEM_ELEMENT_NAME] count]);
    if ([self.dataDict count] > 0) {
        [self.xmlParserDelegate xmlParserDidEnd:self];
    }
    else {
        [self.xmlParserDelegate xmlParserDidFail:self];
    }
}

@end
