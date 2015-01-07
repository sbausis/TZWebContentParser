//
//  TZWebContent.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/18/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZWebContent.h"

#import "TZXmlFeedParser.h"
#import "TZServerIndexParser.h"
#import "TZDownloadPageParser.h"

#import "TZTorrentSitesParser.h"

@interface TZWebContent()

@property (nonatomic, strong) Class parserClass;

@end

@implementation TZWebContent {
    NSArray *_knownPages;
    NSString* _urlString;
    id <TZWebContentDelegate> _delegate;
    TZWebContentParser *_parser;
}

@synthesize parserClass = _parserClass;

- (NSMutableDictionary*)dataDict {
    return _parser.dataDict;
}

- (NSString*)URL {
    return _urlString;
}
- (void)setURL:(NSString*)urlString {
    TZLog(@"%s: %@", __FUNCTION__, urlString);
    _urlString = urlString;
    
    _parserClass = Nil;
    for (NSArray *currentPage in _knownPages) {
        if (currentPage != Nil && _parserClass == Nil) {
            NSString *currentURL = [currentPage objectAtIndex:0];
            NSUInteger stringLength = [currentURL length];
            if ([urlString length] >= stringLength && [[urlString substringToIndex:stringLength] isEqualToString:currentURL]) {
                _parserClass = (Class)[currentPage objectAtIndex:1];
                break;
            }
        }
    }
}

- (id <TZWebContentDelegate>)delegate {
	return _delegate;
}
- (void)setDelegate:(id <TZWebContentDelegate>)delegate {
    TZLog(@"%s: %@", __FUNCTION__, delegate);
	_delegate = delegate;
}

- (id)init {
    self = [super init];
    if (self) {
        _knownPages = [NSArray arrayWithObjects:
                      //
                      [NSArray arrayWithObjects:@"http://torrentz.eu/help", [TZServerIndexParser class], nil],
                       [NSArray arrayWithObjects:@"http://torrentz.eu/feed?q=", [TZXmlFeedParser class], nil],
                       [NSArray arrayWithObjects:@"http://torrentz.eu/feedA?q=", [TZXmlFeedParser class], nil],
                      [NSArray arrayWithObjects:@"http://torrentz.eu/", [TZDownloadPageParser class], nil],
                      //
                      [NSArray arrayWithObjects:@"http://bitsnoop.com", [TZ_bitsnoop_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://www.torrentdownloads.me", [TZ_torrentdownloads_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://www.monova.org", [TZ_monova_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://www.torrentcrazy.com", [TZ_torrentcrazy_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://www.torrentreactor.net", [TZ_torrentreactor_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://www.torrenthound.com", [TZ_torrenthound_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://www.houndmirror.com", [TZ_houndmirror_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://kickass.to", [TZ_kickass_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://kickmirror.com", [TZ_kickmirror_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://www.torrentfunk.com", [TZ_torrentfunk_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://www.seedpeer.me", [TZ_seedpeer_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://www.yourbittorrent.com", [TZ_yourbittorrent_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://www.torrents.net", [TZ_torrents_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://www.fulldls.com", [TZ_fulldls_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://www.limetorrents.com", [TZ_limetorrents_PageParser class], nil],
                      [NSArray arrayWithObjects:@"https://archive.org", [TZ_archive_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://thepiratebay.sx", [TZ_thepiratebay_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://baymirror.com", [TZ_baymirror_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://www.torrentzap.com", [TZ_torrentzap_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://extratorrent.cc", [TZ_extratorrent_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://www.torlock.com", [TZ_torlock_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://www.vertor.com", [TZ_vertor_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://1337x.org", [TZ_1337x_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://www.torrentbit.net", [TZ_torrentbit_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://rarbg.com", [TZ_rarbg_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://www.newtorrents.info", [TZ_newtorrents_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://www.bt-chat.com", [TZ_bt_chat_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://publichd.se", [TZ_publichd_PageParser class], nil],
                      [NSArray arrayWithObjects:@"https://eztv.it", [TZ_eztv_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://linuxtracker.org", [TZ_linuxtracker_PageParser class], nil],
                      [NSArray arrayWithObjects:@"http://h33t.to", [TZ_h33t_PageParser class], nil],
                      nil];
    }
    return self;
}

- (id)initWithURL:(NSString*)urlString {
    self = [self init];
    if (self) {
        [self setURL:urlString];
        if (_parserClass == Nil) return Nil;
    }
    return self;
}

- (id)initWithURL:(NSString*)urlString andDelegate:(id)delegate {
    self = [self initWithURL:urlString];
    if (self) {
        [self setDelegate:delegate];
        [self getContent];
    }
    return self;
}

- (void)getContent {
    TZLog(@"%s [%@] for URL:%@", __FUNCTION__, [_parserClass className], _urlString);
    _parser = [[TZWebContentParser alloc] initWithURL:_urlString andParser:_parserClass andDelegate:self startParsing:YES];
}

#pragma mark -
#pragma mark TZWebContentParserDelegate

- (void)webContentParserDidFail:(TZWebContentParser *)webContentParser {
    TZLog(@"%s: %@", __FUNCTION__, webContentParser);
    [_delegate webContentDidFail:self];
}
- (void)webContentParserDidEnd:(TZWebContentParser *)webContentParser {
    TZLog(@"%s: %@", __FUNCTION__, webContentParser);
    [_delegate webContentDidEnd:self];
}

+ (NSMutableDictionary*)parseSynchronous:(NSString*)urlString andTimeout:(NSTimeInterval)timeout {
    TZWebContent *webContent = [[TZWebContent alloc] initWithURL:urlString];
    if (webContent) {
        return [TZWebContentParser parseSynchronous:webContent->_urlString andParser:webContent->_parserClass andTimeout:timeout];
    }
    return Nil;
}

+ (NSMutableDictionary*)parseSynchronous:(NSString*)urlString {
    return [TZWebContent parseSynchronous:urlString andTimeout:2];
}

@end
