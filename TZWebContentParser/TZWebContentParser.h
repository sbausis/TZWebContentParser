//
//  TZWebContentParser.h
//  TZWebContentParser
//
//  Created by Simon Baur on 12/1/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TZDebug.h"
#import "TZPageLoader.h"
#import "TZHTMLParser.h"
#import "TZXMLParser.h"

@class TZWebContentParser;

@protocol TZWebContentParserDelegate <NSObject>

@optional
- (void)webContentParserDidFail:(TZWebContentParser*)webContentParser;
- (void)webContentParserDidEnd:(TZWebContentParser*)webContentParser;

@end

@interface TZWebContentParser : NSObject <TZPageLoaderDelegate, TZHTMLParserDelegate, TZXMLParserDelegate, TZWebContentParserDelegate>

@property (nonatomic, readonly) BOOL retry;

- (NSMutableDictionary*)dataDict;

- (NSURL*)URL;
- (void)setURL:(NSString*)urlString;

- (NSURLRequestCachePolicy)cachePolicy;
- (void)setCachePolicy:(NSURLRequestCachePolicy)cachePolicy;

- (NSTimeInterval)timeoutInterval;
- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval;

- (BOOL)retry;
- (void)setRetry:(BOOL)retry;

- (Class)parserClass;
- (void)setParserClass:(Class)parserClass;

- (id <TZWebContentParserDelegate>)delegate;
- (void)setDelegate:(id <TZWebContentParserDelegate>)delegate;

- (id)init;
- (id)initWithURL:(NSString*)urlString;
- (id)initWithURL:(NSString*)urlString andParser:(Class)parserClass;
- (id)initWithURL:(NSString*)urlString andParser:(Class)parserClass andDelegate:(id <TZWebContentParserDelegate>)delegate;
- (id)initWithURL:(NSString*)urlString andParser:(Class)parserClass andDelegate:(id <TZWebContentParserDelegate>)delegate startParsing:(BOOL)startParsing;

- (void)startParsing;

+ (NSMutableDictionary*)parseSynchronous:(NSString*)urlString andParser:(Class)parserClass andTimeout:(NSTimeInterval)timeout;
+ (NSMutableDictionary*)parseSynchronous:(NSString*)urlString andParser:(Class)parserClass;

@end
