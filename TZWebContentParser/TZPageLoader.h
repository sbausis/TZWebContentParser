//
//  TZAsynchronousPageLoader.h
//  TZWebContentParser
//
//  Created by Simon Baur on 11/21/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TZDebug.h"

@class TZPageLoader;

@protocol TZPageLoaderDelegate <NSObject>

@optional
- (void)pageLoaderDidFail:(TZPageLoader*)pageLoader;
- (void)pageLoaderDidEnd:(TZPageLoader*)pageLoader;

@end

@interface TZPageLoader : NSObject

@property (nonatomic, readonly) float duration;
@property (nonatomic, readonly) NSError* error;
@property (nonatomic, readonly) NSData* data;
@property (nonatomic, readonly) NSURLResponse* response;

- (NSURL*)URL;
- (void)setURL:(NSString*)urlString;

- (NSURLRequestCachePolicy)cachePolicy;
- (void)setCachePolicy:(NSURLRequestCachePolicy)cachePolicy;

- (NSTimeInterval)timeoutInterval;
- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval;

- (id <TZPageLoaderDelegate>)delegate;
- (void)setDelegate:(id <TZPageLoaderDelegate>)delegate;

- (id)init;
- (id)initWithUrl:(NSString*)urlString;
- (id)initWithUrl:(NSString*)urlString andDelegate:(id <TZPageLoaderDelegate>)delegate;
- (id)initWithUrl:(NSString*)urlString andDelegate:(id <TZPageLoaderDelegate>)delegate startLoading:(BOOL)startLoading;

- (void)startLoading;

@end
