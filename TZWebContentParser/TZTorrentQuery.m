//
//  TZTorrentQuery.m
//  TZWebContentParser
//
//  Created by Simon Baur on 1/11/14.
//  Copyright (c) 2014 Simon Baur. All rights reserved.
//

#import "TZTorrentQuery.h"
#import <TZWebContentParser/TZWebContent.h>

#define BASE_URL @"http://torrentz.eu"
#define cleanSearchString(s) (NSString*)[[s stringByReplacingOccurrencesOfString:@" " withString:@"+"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
#define DATE_FORMAT @"EEE, dd MMM yyyy HH:mm:ss zzzz"

@interface TZTorrentQuery() {
    NSDateFormatter* _dateFormatter;
    NSMutableDictionary* _cache;
}

@property NSMutableDictionary* dict;

@end

@implementation TZTorrentQuery

@synthesize dict = dict;

-(NSDateFormatter*)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:DATE_FORMAT];
    }
    return _dateFormatter;
}
- (void)setDateFormatter:(NSDateFormatter*)dateFormatter {
    _dateFormatter = dateFormatter;
}

-(NSMutableDictionary*)cache {
    if (!_cache) {
        _cache = [[NSMutableDictionary alloc] init];
    }
    return _cache;
}
- (void)setCache:(NSMutableDictionary*)cache {
    _cache = cache;
}

-(id)initWithLink:(NSString*)link {
    self = [super init];
    if (self) {
        self.dict = [TZWebContent parseSynchronous:link];
        NSLog(@"%@", self.dict);
    }
    return self;
}
-(id)initWithQuery:(NSString*)query {
    NSLog(@"QUERY %@", query);
    if (query) {
        self = [self initWithLink:[NSString stringWithFormat:@"%@/feed?q=%@", BASE_URL, cleanSearchString(query)]];
    }
    return self;
}

-(void)setLink:(NSString*)link {
    self.dict = [TZWebContent parseSynchronous:link];
    NSLog(@"%@", self.dict);
}
-(void)setQuery:(NSString*)query {
    [self setLink:[NSString stringWithFormat:@"%@/feed?q=%@", BASE_URL, cleanSearchString(query)]];
}

-(NSString*)getDescription {
    return [self.dict objectForKey:@"description"];
}
-(NSString*)getURL {
    return [self.dict objectForKey:@"href"];
}
-(NSString*)getLink {
    return [self.dict objectForKey:@"link"];
}
-(NSString*)getTitle {
    return [self.dict objectForKey:@"title"];
}
-(NSInteger)getItemCount {
    return [((NSArray*)[self.dict objectForKey:@"item"]) count];
}

-(TZItem*)getItemAtIndex:(NSInteger)i {
    TZItem* item;
    if ( i < [self getItemCount] ) {
        item = [((NSArray*)[self.dict objectForKey:@"item"]) objectAtIndex:i];
    }
    return item;
}
-(TZItem*)getItemForUUID:(NSString*)uuid {
    NSInteger i;
    NSInteger cnt = [self getItemCount];
    for (i=0; i<cnt; i++) {
        TZItem* item = [self getItemAtIndex:i];
        if ([[self getItemUUID:item] isEqualToString:uuid]) {
            return item;
        }
    }
    return Nil;
}
-(NSString*)getValueFromDict:(NSDictionary*)link ValueName:(NSString*)val {
    NSString* value;
    if (link) {
        value = [link objectForKey:val];
    }
    return value;
}
-(NSString*)getItemUUID:(TZItem*)item {
    return [self getValueFromDict:item ValueName:@"Hash"];
}
-(NSString*)getItemPeers:(TZItem*)item {
    return [self getValueFromDict:item ValueName:@"Peers"];
}
-(NSString*)getItemSeeds:(TZItem*)item {
    return [self getValueFromDict:item ValueName:@"Seeds"];
}
-(NSString*)getItemSize:(TZItem*)item {
    return [self getValueFromDict:item ValueName:@"Size"];
}
-(NSString*)getItemCategories:(TZItem*)item {
    return [self getValueFromDict:item ValueName:@"category"];
}
-(NSString*)getItemUUIDLink:(TZItem*)item {
    return [self getValueFromDict:item ValueName:@"guid"];
}
-(NSString*)getItemLink:(TZItem*)item {
    return [self getValueFromDict:item ValueName:@"link"];
}
-(NSDate*)getItemAge:(TZItem*)item {
    NSString* dateStr = [self getValueFromDict:item ValueName:@"pubDate"];
    return [self.dateFormatter dateFromString:dateStr];
}
-(NSString*)getItemTitle:(TZItem*)item {
    return [self getValueFromDict:item ValueName:@"title"];
}

-(TZDownloadPages*)getItemDownload:(TZItem*)item {
    TZDownloadPages* itemDownload;
    NSString* url = [self getItemUUIDLink:item];
    if ( (itemDownload = [self.cache objectForKey:url]) ) {
        return itemDownload;
    }
    
    itemDownload = [[TZDownloadPages alloc] initWithLink:url];
    if (itemDownload) {
        NSLog(@"!!! SUCCESS !!! %@", url);
        [self.cache setObject:itemDownload forKey:url];
    }
    else {
        NSLog(@"!!! FAIL !!! %@", url);
    }
    return itemDownload;
}
-(TZDownloadPages*)getItemDownloadFromCache:(TZItem*)item {
    TZDownloadPages* itemDownload;
    NSString* url = [self getItemUUIDLink:item];
    itemDownload = [self.cache objectForKey:url];
    return itemDownload;
}
@end
