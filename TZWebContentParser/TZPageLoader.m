//
//  TZAsynchronousPageLoader.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/21/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZPageLoader.h"

#define USER_AGENT @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/536.30.1 (KHTML, like Gecko) Version/6.0.5 Safari/536.30.1"

@interface TZPageLoader()

@property (nonatomic, assign) float duration;
@property (nonatomic, strong) NSError* error;
@property (nonatomic, strong) NSData* data;
@property (nonatomic, strong) NSURLResponse* response;

@end

@implementation TZPageLoader {
	id <TZPageLoaderDelegate> _delegate;
    NSMutableURLRequest* _request;
    NSOperationQueue* _queue;
    NSDate* _startDate;
}

@synthesize duration;
@synthesize error;
@synthesize data;
@synthesize response;

- (NSURL*)URL {
    return _request.URL;
}
- (void)setURL:(NSString*)urlString {
    TZLog(@"%s: %@", __FUNCTION__, urlString);
    [_request setURL:[NSURL URLWithString:urlString]];
}

- (NSURLRequestCachePolicy)cachePolicy {
    return _request.cachePolicy;
}
- (void)setCachePolicy:(NSURLRequestCachePolicy)cachePolicy {
    TZLog(@"%s: %lu", __FUNCTION__, (unsigned long)cachePolicy);
    [_request setCachePolicy:cachePolicy];
}

- (NSTimeInterval)timeoutInterval {
    return _request.timeoutInterval;
}
- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
    TZLog(@"%s: %f", __FUNCTION__, timeoutInterval);
    [_request setTimeoutInterval:timeoutInterval];
}

- (id <TZPageLoaderDelegate>)delegate {
	return _delegate;
}
- (void)setDelegate:(id <TZPageLoaderDelegate>)delegate {
    TZLog(@"%s: %@", __FUNCTION__, delegate);
	_delegate = delegate;
}

- (id)init {
    self = [super init];
    if (self) {
        _request = [[NSMutableURLRequest alloc] init];
        [_request addValue:USER_AGENT forHTTPHeaderField:@"User-Agent"];
        _queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (id)initWithUrl:(NSString*)urlString {
    self = [self init];
    if (self) {
        [self setURL:urlString];
        [self setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
        [self setTimeoutInterval:1];
    }
    return self;
}

- (id)initWithUrl:(NSString*)urlString andDelegate:(id <TZPageLoaderDelegate>)delegate {
    self = [self initWithUrl:urlString];
    if (self) {
        [self setDelegate:delegate];
    }
    return self;
}

- (id)initWithUrl:(NSString*)urlString andDelegate:(id <TZPageLoaderDelegate>)delegate startLoading:(BOOL)startLoading {
    self = [self initWithUrl:urlString andDelegate:delegate];
    if (self) {
        if (startLoading) {
            [self startLoading];
        }
    }
    return self;
}

- (void)startLoading {
    TZLog(@"%s", __FUNCTION__);
    
    _startDate = [NSDate date];
    [NSURLConnection sendAsynchronousRequest:_request queue:_queue completionHandler:^(NSURLResponse *r, NSData *d, NSError *e) {
        
        TZLog(@"%s:", __FUNCTION__);
        self.response = r;
        self.data = d;
        self.error = e;
        self.duration = [[NSDate date] timeIntervalSinceDate:_startDate];
        
        if ([d length] > 0 && e == nil)
            [self receivedData:d];
        else if ([d length] == 0 && e == nil)
            [self emptyReply];
        else if (e != nil && e.code == NSURLErrorTimedOut)
            [self timedOut];
        else if (e != nil)
            [self downloadError:e];
    }];
}

- (void)receivedData:(NSData*)connectionData {
    TZLog(@"%s: %lu", __FUNCTION__, (unsigned long)[connectionData length]);
    [_delegate pageLoaderDidEnd:self];
}
- (void)emptyReply {
    TZLog(@"%s: Nothing was downloaded.", __FUNCTION__);
    [_delegate pageLoaderDidFail:self];
}
- (void)timedOut {
    TZLog(@"%s: Connection timed Out.", __FUNCTION__);
    [_delegate pageLoaderDidFail:self];
}
- (void)downloadError:(NSError*)connectionError {
    TZLog(@"%s: %@", __FUNCTION__, connectionError);
    [_delegate pageLoaderDidFail:self];
}


@end
