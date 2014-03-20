//
//  TZDownloadPages.h
//  TZWebContentParser
//
//  Created by Simon Baur on 1/11/14.
//  Copyright (c) 2014 Simon Baur. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSDictionary TZLink;
typedef NSDictionary TZLinkDownload;

@interface TZDownloadPages : NSObject


-(id)init __attribute__((unavailable("Must use initWithLink: / initWithUUID: instead.")));
-(id)initWithLink:(NSString*)link;
-(id)initWithUUID:(NSString*)uuid;

-(NSDate*)getAge;
-(NSString*)getTitle;
-(NSInteger)getLinkCount;

-(TZLink*)getLinkAtIndex:(NSInteger)i;
-(TZLink*)getLinkForServer:(NSString*)server;
-(NSString*)getLinkCategories:(TZLink*)link;
-(NSString*)getLinkServer:(TZLink*)link;
-(NSString*)getLinkTitle:(TZLink*)link;
-(NSString*)getLinkStyle:(TZLink*)link;
-(NSString*)getLinkURL:(TZLink*)link;
-(NSDate*)getLinkAge:(TZLink*)link;
-(NSString*)getLinkAge2:(TZLink*)link;

-(TZLinkDownload*)getLinkDownload:(TZLink*)link;
-(NSString*)getLinkDownloadTorrent:(TZLinkDownload*)lnkDownload;
-(NSString*)getLinkDownloadMagnet:(TZLinkDownload*)lnkDownload;

-(NSData*)getTorrentFile;

-(NSString*)getTorrentLink;
-(NSString*)getMagnetLink;

@end
