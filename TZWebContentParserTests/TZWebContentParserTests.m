//
//  TZWebContentParserTests.m
//  TZWebContentParserTests
//
//  Created by Simon Baur on 12/8/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TZWebContent.h"
#import "TZWebContentParser.h"

@interface TZWebContentParserTests : XCTestCase <TZWebContentDelegate> {
    NSArray *links;
}

@end

@implementation TZWebContentParserTests

- (void)setUp {
    [super setUp];
    if (!links) {
        links = [NSArray arrayWithObjects:
                 @"http://torrentz.eu/help",
                 @"http://torrentz.eu/feed?q=movies",
                 @"http://torrentz.eu/7250a43669eaf9bba8004acf3fe73d40068a2553",
                 @"http://bitsnoop.com/the-wolverine-2013-extended-1080p-b-q54632514.html",
                 @"http://www.torrentdownloads.me/torrent/1656351286/Pacific+Rim+2013+720p+WEB-DL+H264-PublicHD",
                 @"http://www.monova.org/torrent/6990499/Pacific.Rim.2013.720p.WEB-DL.H264-PublicHD.html",
                 @"http://www.torrentcrazy.com/torrent/8699333/pacific.rim.2013.720p.web-dl.h264-publichd",
                 @"http://www.torrentreactor.net/torrents/8354276/Pacific-Rim-2013-720p-WEB-DL-H264-PublicHD",
                 @"http://www.torrenthound.com/hash/dd19ca7c9d70c0bbea14bbf6c2b21d34f6546503/torrent-info/Drake--Thank-Me-Later-2010-MP3-Cov-Bubanee-Torrent--btjunkie",
                 @"http://www.houndmirror.com/hash/dd19ca7c9d70c0bbea14bbf6c2b21d34f6546503/torrent-info/Drake--Thank-Me-Later-2010-MP3-Cov-Bubanee-Torrent--btjunkie",
                 @"http://kickass.to/pacific-rim-2013-720p-web-dl-h264-publichd-t7951565.html",
                 @"http://kickmirror.com/the-wolverine-2013-extended-1080p-brrip-x264-yify-t8138507.html",
                 @"http://www.torrentfunk.com/torrent/6899681/pacific-rim-2013-720p-web-dl-h264-publichd.html",
                 @"http://www.seedpeer.me/details/6450029/Pacific.Rim.2013.720p.WEB-DL.H264-PublicHD.html",
                 @"http://www.yourbittorrent.com/torrent/4900745/pacific-rim-2013-720p-web-dl-h264-publichd.html",
                 @"http://www.torrents.net/torrent/4282842/Pacific.Rim.2013.720p.WEB-DL.H264-PublicHD/",
                 @"http://www.fulldls.com/torrent-movies-6005211.html",
                 @"http://www.limetorrents.com/Pacific-Rim-2013-720p-WEBDL-H264PublicHD-torrent-3292052.html",
                 @"https://archive.org/details/EthanSnyderkevinGiftjonLipscombalexWeber2013-08-31Scapescape2013At",
                 @"http://thepiratebay.sx/torrent/8983443",
                 @"http://baymirror.com/torrent/9158696",
                 @"http://www.torrentzap.com/torrent/2248647/Pacific+Rim+2013+720p+WEB-DL+H264-PublicHD",
                 @"http://extratorrent.cc/torrent/3239758/Pacific.Rim.2013.720p.WEB-DL.H264-PublicHD.html",
                 @"http://www.torlock.com/torrent/2581527/the-wolverine-2013.html",
                 @"http://www.vertor.com/torrents/3069057/This-Is-the-End-%282013%29-720p-BrRip-x264-YIFY",
                 @"http://1337x.org/torrent/638452/0/",
                 @"http://www.torrentbit.net/torrent/2737331/The+Big+Bang+Theory+S07E08+HDTV+x264-LOL%5Bettv%5D/",
                 @"http://rarbg.com/torrents/filmi/download/gl24dxa/torrent.html",
                 @"http://www.newtorrents.info/torrent/122413/The_Wolverine_(2013)_EXTENDED_1080p_BrRip_x264_-_YIFY.html?nopop=1",
                 @"http://www.bt-chat.com/details.php?id=181202",
                 @"http://publichd.se/index.php?page=torrent-details&id=ae9c029ecb9b457bb595c37664f1a763f8a9bb6a",
                 @"https://eztv.it/ep/49511/how-i-met-your-mother-s09e09-hdtv-x264-2hd/",
                 @"http://linuxtracker.org/index.php?page=torrent-details&id=21dd07e7c3c28cef50ac7b86f7a35514aa05b1d1",
                 nil];
    }
}

- (void)tearDown {
    [super tearDown];
}

- (void)MyTestTZWebContentLink:(NSUInteger)i {
    NSString* lnk = [links objectAtIndex:i];
    TZWebContent *content = [[TZWebContent alloc] initWithURL:lnk andDelegate:self];
    if (!content) {
        XCTFail(@"TZWebContent failed for url:\"%@\"", lnk);
    }
}
-(void)webContentDidFail:(TZWebContent *)webContent {
    XCTFail(@"TZWebContent failed for url:\"%@\"", webContent.URL);
}
-(void)webContentDidEnd:(TZWebContent *)webContent {
    NSLog(@"TZWebContent succeeded for url:\"%@\", data;%@", webContent.URL, webContent.dataDict);
}

- (void)testTZWebContentLink0 {
    [self MyTestTZWebContentLink:0];
}
- (void)testTZWebContentLink1 {
    [self MyTestTZWebContentLink:1];
}
- (void)testTZWebContentLink2 {
    [self MyTestTZWebContentLink:2];
}
- (void)testTZWebContentLink3 {
    [self MyTestTZWebContentLink:3];
}
- (void)testTZWebContentLink4 {
    [self MyTestTZWebContentLink:4];
}
- (void)testTZWebContentLink5 {
    [self MyTestTZWebContentLink:5];
}
- (void)testTZWebContentLink6 {
    [self MyTestTZWebContentLink:6];
}
- (void)testTZWebContentLink7 {
    [self MyTestTZWebContentLink:7];
}
- (void)testTZWebContentLink8 {
    [self MyTestTZWebContentLink:8];
}
- (void)testTZWebContentLink9 {
    [self MyTestTZWebContentLink:9];
}
- (void)testTZWebContentLink10 {
    [self MyTestTZWebContentLink:10];
}
- (void)testTZWebContentLink11 {
    [self MyTestTZWebContentLink:11];
}
- (void)testTZWebContentLink12 {
    [self MyTestTZWebContentLink:12];
}
- (void)testTZWebContentLink13 {
    [self MyTestTZWebContentLink:13];
}
- (void)testTZWebContentLink14 {
    [self MyTestTZWebContentLink:14];
}
- (void)testTZWebContentLink15 {
    [self MyTestTZWebContentLink:15];
}
- (void)testTZWebContentLink16 {
    [self MyTestTZWebContentLink:16];
}
- (void)testTZWebContentLink17 {
    [self MyTestTZWebContentLink:17];
}
- (void)testTZWebContentLink18 {
    [self MyTestTZWebContentLink:18];
}
- (void)testTZWebContentLink19 {
    [self MyTestTZWebContentLink:19];
}
- (void)testTZWebContentLink20 {
    [self MyTestTZWebContentLink:20];
}
- (void)testTZWebContentLink21 {
    [self MyTestTZWebContentLink:21];
}
- (void)testTZWebContentLink22 {
    [self MyTestTZWebContentLink:22];
}
- (void)testTZWebContentLink23 {
    [self MyTestTZWebContentLink:23];
}
- (void)testTZWebContentLink24 {
    [self MyTestTZWebContentLink:24];
}
- (void)testTZWebContentLink25 {
    [self MyTestTZWebContentLink:25];
}
- (void)testTZWebContentLink26 {
    [self MyTestTZWebContentLink:26];
}
- (void)testTZWebContentLink27 {
    [self MyTestTZWebContentLink:27];
}
- (void)testTZWebContentLink28 {
    [self MyTestTZWebContentLink:28];
}
- (void)testTZWebContentLink29 {
    [self MyTestTZWebContentLink:29];
}
- (void)testTZWebContentLink30 {
    [self MyTestTZWebContentLink:30];
}
- (void)testTZWebContentLink31 {
    [self MyTestTZWebContentLink:31];
}
- (void)testTZWebContentLink32 {
    [self MyTestTZWebContentLink:32];
}

@end
