//
//  TZTorrentzOperation.m
//  TZWebContentParser
//
//  Created by Simon Baur on 12/5/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZTorrentzOperation.h"

@implementation TZTorrentzOperation

@synthesize name = _name;

@synthesize error = _error;
@synthesize connectionURL = _connectionURL;
@synthesize webContent = _webContent;
@synthesize dataDict = _dataDict;

- (id)initWithURL:(NSString*)url {
    NSLog(@"%s", __FUNCTION__);
    
    self = [super init];
    if(self) {
        _connectionURL = [url copy];
    }
    return self;
}

- (id)initWithURL:(NSString *)url andName:(NSString*)name {
    self = [self initWithURL:url];
    if (self) {
        [self setName:name];
    }
    return self;
}

- (id)initWithURL:(NSString *)url andName:(NSString*)name andObserver:(NSObject*)observer {
    self = [self initWithURL:url andName:name];
    if (self) {
        [self addObserver:observer forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:Nil];
    }
    return self;
}

- (void)removeObserver:(NSObject*)observer {
    [self removeObserver:observer forKeyPath:@"isFinished"];
}

- (void)done {
    NSLog(@"%s", __FUNCTION__);
    
    if(_webContent) {
        _webContent = nil;
    }
    
    NSLog(@"%s, %@", __FUNCTION__, _dataDict);
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    _executing = NO;
    _finished  = YES;
    [self didChangeValueForKey:@"isFinished"];
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)canceled {
    NSLog(@"%s", __FUNCTION__);
    
    _error = [[NSError alloc] initWithDomain:@"TZTorrentzOperation" code:123 userInfo:nil];
    [self done];
}

- (void)start {
    NSLog(@"%s", __FUNCTION__);
    
    /*
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(start)
                               withObject:nil waitUntilDone:NO];
        return;
    }
    */
    if( _finished || [self isCancelled] ) { [self done]; return; }
    
    [self willChangeValueForKey:@"isExecuting"];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    _webContent = [[TZWebContent alloc] initWithURL:_connectionURL andDelegate:self];
}

#pragma mark -
#pragma mark Overrides

- (BOOL)isConcurrent {
    NSLog(@"%s", __FUNCTION__);
    
    return YES;
}

- (BOOL)isExecuting {
    NSLog(@"%s", __FUNCTION__);
    
    return _executing;
}

- (BOOL)isFinished {
    NSLog(@"%s", __FUNCTION__);
    
    return _finished;
}

#pragma mark -
#pragma mark TZWebContentDelegate

-(void)webContentDidFail:(TZWebContent *)webContent {
    NSLog(@"%s", __FUNCTION__);
    
    if([self isCancelled]) {
        [self canceled];
        return;
    }
    else {
        _dataDict = nil;
        [self done];
    }
}
-(void)webContentDidEnd:(TZWebContent *)webContent {
    NSLog(@"%s", __FUNCTION__);
    
    if([self isCancelled]) {
        [self canceled];
        return;
    }
    else {
        _dataDict = [NSDictionary dictionaryWithDictionary:webContent.dataDict];
        [self done];
    }
}

@end
