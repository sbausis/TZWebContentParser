//
//  TZDownloadPages.m
//  TZWebContentParser
//
//  Created by Simon Baur on 1/11/14.
//  Copyright (c) 2014 Simon Baur. All rights reserved.
//

#import "TZDownloadPages.h"
#import <TZWebContentParser/TZWebContent.h>

#define BASE_URL @"http://torrentz.eu"
#define cleanSearchString(s) (NSString*)[[s stringByReplacingOccurrencesOfString:@" " withString:@"+"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
#define DATE_FORMAT @"EEE, dd MMM yyyy HH:mm:ss"

@interface TZDownloadPages() {
    NSDateFormatter* _dateFormatter;
    NSMutableDictionary* _cache;
    NSString* _link;
}

@property NSMutableDictionary* dict;

@end

@implementation TZDownloadPages

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
    if (self && link) {
        _link = link;
        self.dict = [TZWebContent parseSynchronous:link];
        //NSLog(@"%@", self.dict);
    }
    return self;
}
-(id)initWithUUID:(NSString*)uuid {
    if (uuid && [uuid length]<40) return Nil;
    self = [self initWithLink:[NSString stringWithFormat:@"%@/%@", BASE_URL, uuid]];
    return self;
}

-(NSDate*)getAge {
    NSString* dateStr = [self.dict objectForKey:@"Date"];
    return [self.dateFormatter dateFromString:dateStr];
}
-(NSString*)getTitle {
    return [self.dict objectForKey:@"File"];
}
-(NSInteger)getLinkCount {
    return [((NSArray*)[self.dict objectForKey:@"Downloads"]) count];
}

-(TZLink*)getLinkAtIndex:(NSInteger)i {
    TZLink* link;
    if ( i < [self getLinkCount] ) {
        link = [((NSArray*)[self.dict objectForKey:@"Downloads"]) objectAtIndex:i];
    }
    return link;
}
-(TZLink*)getLinkForServer:(NSString*)server {
    NSInteger i;
    NSInteger cnt = [self getLinkCount];
    for (i=0; i<cnt; i++) {
        TZLink* link = [self getLinkAtIndex:i];
        if ([[self getLinkServer:link] isEqualToString:server]) {
            return link;
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
-(NSString*)getLinkCategories:(TZLink*)link {
    return [self getValueFromDict:link ValueName:@"Categories"];
}
-(NSString*)getLinkServer:(TZLink*)link {
    return [self getValueFromDict:link ValueName:@"Server"];
}
-(NSString*)getLinkTitle:(TZLink*)link {
    return [self getValueFromDict:link ValueName:@"Title"];
}
-(NSString*)getLinkStyle:(TZLink*)link {
    return [self getValueFromDict:link ValueName:@"Style"];
}
-(NSString*)getLinkURL:(TZLink*)link {
    return [self getValueFromDict:link ValueName:@"Link"];
}
-(NSDate*)getLinkAge:(TZLink*)link {
    NSString* dateStr = [self getValueFromDict:link ValueName:@"Age"];
    return [self.dateFormatter dateFromString:dateStr];
}
-(NSString*)getLinkAge2:(TZLink*)link {
    return [self getValueFromDict:link ValueName:@"Age2"];
}

-(TZLinkDownload*)getLinkDownload:(TZLink*)link {
    NSString* server = [self getLinkServer:link];
    TZLinkDownload* lnkDownload;
    if ( (lnkDownload = [self.cache objectForKey:server]) ) {
        return lnkDownload;
    }
    
    NSString* url = [self getLinkURL:link];
    lnkDownload = [TZWebContent parseSynchronous:url andTimeout:2];
    if (lnkDownload) {
        [self.cache setObject:lnkDownload forKey:server];
    }
    else {
        NSLog(@"!!! FAIL !!! %@", url);
    }
    return lnkDownload;
}
-(NSString*)getLinkDownloadTorrent:(TZLinkDownload*)lnkDownload {
    NSString* torrentLink = [self getValueFromDict:lnkDownload ValueName:@"Torrent"];
    if ([torrentLink length]>=63 && [[torrentLink substringToIndex:23] isEqualToString:@"http://istoretor.com/t/"]) {
        NSString* hash = [[torrentLink substringFromIndex:23] substringToIndex:40];
        torrentLink = [NSString stringWithFormat:@"http://istoretor.com/fdown.php?hash=%@", hash];
    }
    else if ([torrentLink length]>40 && [[torrentLink substringToIndex:40] isEqualToString:@"http://extratorrent.cc/torrent_download/"]) {
        NSString* hash = [torrentLink substringFromIndex:40];
        torrentLink = [NSString stringWithFormat:@"http://extratorrent.cc/download/%@", hash];
    }
    return torrentLink;
}
-(NSString*)getLinkDownloadMagnet:(TZLinkDownload*)lnkDownload {
    NSString* magnetLink = [self getValueFromDict:lnkDownload ValueName:@"Magnet"];
    return magnetLink;
}

-(NSData*)getTorrentFile {
    NSData *data;
    NSInteger i;
    for (i=0; i<[self getLinkCount]; i++) {
        TZLink* link = [self getLinkAtIndex:i];
        if (link) {
            //NSLog(@"%ld %@ (%@) %@, %@ [%@] - %@", (long)i, [self getLinkTitle:link], [self getLinkServer:link], [self getLinkCategories:link], [self getLinkAge:link], [self getLinkAge2:link], [self getLinkStyle:link]);
            TZLinkDownload* download = [self getLinkDownload:link];
            if (download) {
                NSString* torrentURL = [self getLinkDownloadTorrent:download];
                NSLog(@"Torrent: %@", torrentURL);
                if (torrentURL) {
                    NSData* d = [[NSURLConnection class] sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:cleanSearchString(torrentURL)]] returningResponse:Nil error:Nil];
                    if (d) {
                        char bite[3];
                        [d getBytes:&bite length:3];
                        if ( bite[0]==0x64 && bite[1]==0x38 && bite[2]==0x3a ) {
                            data = d;
                            break;
                        }
                    }
                }
            }
        }
    }
    return data;
}

-(NSString*)getTorrentLink {
    NSString* torrentURL;
    NSInteger i;
    for (i=0; i<[self getLinkCount]; i++) {
        TZLink* link = [self getLinkAtIndex:i];
        if (link) {
            //NSLog(@"%ld %@ (%@) %@, %@ [%@] - %@", (long)i, [self getLinkTitle:link], [self getLinkServer:link], [self getLinkCategories:link], [self getLinkAge:link], [self getLinkAge2:link], [self getLinkStyle:link]);
            TZLinkDownload* download = [self getLinkDownload:link];
            if (download) {
                torrentURL = [self getLinkDownloadTorrent:download];
                NSLog(@"Torrent: %@", torrentURL);
                if (torrentURL) break;
            }
        }
    }
    return torrentURL;
}
-(NSString*)getMagnetLink {
    NSString* magnetURL;
    NSInteger i;
    for (i=0; i<[self getLinkCount]; i++) {
        TZLink* link = [self getLinkAtIndex:i];
        if (link) {
            //NSLog(@"%ld %@ (%@) %@, %@ [%@] - %@", (long)i, [self getLinkTitle:link], [self getLinkServer:link], [self getLinkCategories:link], [self getLinkAge:link], [self getLinkAge2:link], [self getLinkStyle:link]);
            TZLinkDownload* download = [self getLinkDownload:link];
            if (download) {
                magnetURL = [self getLinkDownloadMagnet:download];
                NSLog(@"Magnet: %@", magnetURL);
                if (magnetURL && [magnetURL length]>7 && [[magnetURL substringToIndex:7] isEqualToString:@"magnet:"]) break;
            }
        }
    }
    return magnetURL;
}

@end
