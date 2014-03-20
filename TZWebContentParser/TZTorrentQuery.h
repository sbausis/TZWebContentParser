//
//  TZTorrentQuery.h
//  TZWebContentParser
//
//  Created by Simon Baur on 1/11/14.
//  Copyright (c) 2014 Simon Baur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TZDownloadPages.h"

typedef NSDictionary TZItem;

@interface TZTorrentQuery : NSObject

-(id)init __attribute__((unavailable("Must use initWithLink: / initWithQuery: instead.")));
-(id)initWithLink:(NSString*)link;
-(id)initWithQuery:(NSString*)query;

-(void)setLink:(NSString*)link;
-(void)setQuery:(NSString*)query;

-(NSString*)getDescription;
-(NSString*)getURL;
-(NSString*)getLink;
-(NSString*)getTitle;
-(NSInteger)getItemCount;

-(TZItem*)getItemAtIndex:(NSInteger)i;
-(TZItem*)getItemForUUID:(NSString*)uuid;
-(NSString*)getItemUUID:(TZItem*)item;
-(NSString*)getItemPeers:(TZItem*)item;
-(NSString*)getItemSeeds:(TZItem*)item;
-(NSString*)getItemSize:(TZItem*)item;
-(NSString*)getItemCategories:(TZItem*)item;
-(NSString*)getItemUUIDLink:(TZItem*)item;
-(NSString*)getItemLink:(TZItem*)item;
-(NSDate*)getItemAge:(TZItem*)item;
-(NSString*)getItemTitle:(TZItem*)item;

-(TZDownloadPages*)getItemDownload:(TZItem*)item;
-(TZDownloadPages*)getItemDownloadFromCache:(TZItem*)item;

@end
