//
//  TZWebContent.h
//  TZWebContentParser
//
//  Created by Simon Baur on 11/18/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TZDebug.h"
#import "TZWebContentParser.h"

@class TZWebContent;

@protocol TZWebContentDelegate <NSObject>

@optional
- (void)webContentDidFail:(TZWebContent*)webContent;
- (void)webContentDidEnd:(TZWebContent*)webContent;

@end

@interface TZWebContent : NSObject <TZWebContentParserDelegate>

@property (nonatomic, readonly) Class parserClass;

- (NSMutableDictionary*)dataDict;

- (NSString*)URL;
- (void)setURL:(NSString*)urlString;

- (id <TZWebContentDelegate>)delegate;
- (void)setDelegate:(id <TZWebContentDelegate>)delegate;

- (id)init;
- (id)initWithURL:(NSString*)urlString;
- (id)initWithURL:(NSString*)urlString andDelegate:(id)delegate;

+ (NSMutableDictionary*)parseSynchronous:(NSString*)urlString andTimeout:(NSTimeInterval)timeout;
+ (NSMutableDictionary*)parseSynchronous:(NSString*)urlString;

@end
