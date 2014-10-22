//
//  TZWebContentParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 12/1/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZWebContentParser.h"

@interface TZWebContentParser()

@property (nonatomic, assign) BOOL retry;

@end

@implementation TZWebContentParser {
	id <TZWebContentParserDelegate> _delegate;
    Class _parserClass;
	id _parser;
    NSString* _urlString;
    TZPageLoader* _pageLoader;
    NSInteger _timeout;
}

@synthesize retry = _retry;

- (NSMutableDictionary*)dataDict {
    NSMutableDictionary* dict;
    if ([_parser isKindOfClass:[TZHTMLParser class]]) {
        TZHTMLParser* parser = (TZHTMLParser*)_parser;
        dict = parser.dataDict;
    }
    else if ([_parser isKindOfClass:[TZXMLParser class]]) {
        TZXMLParser* parser = (TZXMLParser*)_parser;
        dict = parser.dataDict;
    }
    return dict;
}

- (NSURL*)URL {
    return _pageLoader.URL;
}
- (void)setURL:(NSString*)urlString {
    TZLog(@"%s: %@", __FUNCTION__, urlString);
    [_pageLoader setURL:urlString];
}

- (NSURLRequestCachePolicy)cachePolicy {
    return _pageLoader.cachePolicy;
}
- (void)setCachePolicy:(NSURLRequestCachePolicy)cachePolicy {
    TZLog(@"%s: %lu", __FUNCTION__, (unsigned long)cachePolicy);
    [_pageLoader setCachePolicy:cachePolicy];
}

- (NSTimeInterval)timeoutInterval {
    return _pageLoader.timeoutInterval;
}
- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
    TZLog(@"%s: %f", __FUNCTION__, timeoutInterval);
    [_pageLoader setTimeoutInterval:timeoutInterval - 0.1];
    _timeout = timeoutInterval;
}

- (BOOL)retry {
    return _retry;
}
- (void)setRetry:(BOOL)retry {
    _retry = retry;
}

- (Class)parserClass {
    return _parserClass;
}
- (void)setParserClass:(Class)parserClass {
    _parserClass = parserClass;
}

- (id <TZWebContentParserDelegate>)delegate {
	return _delegate;
}
- (void)setDelegate:(id <TZWebContentParserDelegate>)delegate {
	_delegate = delegate;
}

- (id)init {
    self = [super init];
    if (self) {
        _pageLoader = [[TZPageLoader alloc] init];
        [_pageLoader setDelegate:self];
        [self setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
        [self setTimeoutInterval:1];
        _retry = YES;
    }
    return self;
}
- (id)initWithURL:(NSString*)urlString {
    self = [self init];
    if (self) {
        [self setURL:urlString];
    }
    return self;
}
- (id)initWithURL:(NSString*)urlString andParser:(Class)parserClass {
    self = [self initWithURL:urlString];
    if (self) {
        [self setParserClass:parserClass];
    }
    return self;
}
- (id)initWithURL:(NSString*)urlString andParser:(Class)parserClass andDelegate:(id <TZWebContentParserDelegate>)delegate {
    self = [self initWithURL:urlString andParser:parserClass];
    if (self) {
        [self setDelegate:delegate];
    }
    return self;
}
- (id)initWithURL:(NSString*)urlString andParser:(Class)parserClass andDelegate:(id <TZWebContentParserDelegate>)delegate startParsing:(BOOL)startParsing {
    self = [self initWithURL:urlString andParser:parserClass andDelegate:delegate];
    if (self) {
        if (startParsing) {
            [self startParsing];
        }
    }
    return self;
}

- (void)startParsing {
    [_pageLoader startLoading];
    [self performSelector:@selector(checkTimeout) withObject:Nil afterDelay:0.1];
}

- (void)checkTimeout {
    //NSLog(@"TIMEOUT: %ld", (long)_timeout);
    _timeout -= 0.1;
    if (_timeout>0) {
        [self performSelector:@selector(checkTimeout) withObject:Nil afterDelay:0.1];
    }
    else {
        if (_timeout == -1) {
            [_delegate webContentParserDidEnd:self];
        }
        else {
            [_delegate webContentParserDidFail:self];
        }
    }
}

#pragma mark -
#pragma mark TZPageLoaderDelegate

- (void)pageLoaderDidFail:(TZPageLoader *)pageLoader {
    if (_retry) {
        _retry = NO;
        [_pageLoader startLoading];
        _timeout = _pageLoader.timeoutInterval + 0.1;
    }
    else {
        [_delegate webContentParserDidFail:self];
        _timeout = 0;
    }
}
- (void)pageLoaderDidEnd:(TZPageLoader *)pageLoader{
    _parser = [[_parserClass alloc] init];
    if ([_parser isKindOfClass:[TZHTMLParser class]]) {
        TZLog(@"%s: %@", __FUNCTION__, [_parserClass class]);
        _parser = [(TZHTMLParser*)_parser initWithData:pageLoader.data];
        [_parser setHTMLParserDelegate:self];
        [_parser parse];
    }
    else if ([_parser isKindOfClass:[TZXMLParser class]]) {
        TZLog(@"%s: %@", __FUNCTION__, [_parserClass class]);
        _parser = [(TZXMLParser*)_parser initWithData:pageLoader.data];
        [_parser setXMLParserDelegate:self];
        [_parser parse];
    }
}

#pragma mark -
#pragma mark TZHTMLParserDelegate

- (void)htmlParserDidFail:(TZHTMLParser *)htmlParser {
    TZLog(@"%s: %@", __FUNCTION__, htmlParser);
    _timeout = 0;
    [_delegate webContentParserDidFail:self];
}
- (void)htmlParserDidEnd:(TZHTMLParser *)htmlParser {
    TZLog(@"%s: %@", __FUNCTION__, htmlParser);
    _timeout = -1;
    [_delegate webContentParserDidEnd:self];
}

#pragma mark -
#pragma mark TZXMLParserDelegate

- (void)xmlParserDidFail:(TZXMLParser *)xmlParser {
    TZLog(@"%s: %@", __FUNCTION__, xmlParser);
    _timeout = 0;
    [_delegate webContentParserDidFail:self];
}
- (void)xmlParserDidEnd:(TZXMLParser *)xmlParser {
    TZLog(@"%s: %@", __FUNCTION__, xmlParser);
    _timeout = -1;
    [_delegate webContentParserDidEnd:self];
}

/*
#pragma mark -
#pragma mark TZWebContentParserDelegate
- (void)webContentParserDidFail:(TZWebContentParser *)webContentParser {
    
}
- (void)webContentParserDidEnd:(TZWebContentParser *)webContentParser {
 
}
- (void)isDone:(NSTimer *)theTimer {
    if (_timeout <= 0) {
        [theTimer invalidate];
        theTimer = Nil;
    }
}
*/

+ (NSMutableDictionary*)parseSynchronous:(NSString*)urlString andParser:(Class)parserClass andTimeout:(NSTimeInterval)timeout {
    TZWebContentParser *webContentParser = [[TZWebContentParser alloc] init];
    [webContentParser setURL:urlString];
    [webContentParser setParserClass:parserClass];
    [webContentParser setTimeoutInterval:timeout];
    //[webContentParser setDelegate:webContentParser];
    [webContentParser startParsing];
    /*
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:webContentParser
                                   selector:@selector(isDone:)
                                   userInfo:Nil
                                    repeats:YES];
    
    while (timer) {
        if (webContentParser->_timeout <= 0) {
            [timer invalidate];
            timer = Nil;
        }
    }
    */
    
    while (webContentParser->_timeout > 0) {;;}
    
    return webContentParser.dataDict;
}

+ (NSMutableDictionary*)parseSynchronous:(NSString*)urlString andParser:(Class)parserClass {
    return [TZWebContentParser parseSynchronous:urlString andParser:parserClass andTimeout:1];
}

@end
