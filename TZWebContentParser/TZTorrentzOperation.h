//
//  TZTorrentzOperation.h
//  TZWebContentParser
//
//  Created by Simon Baur on 12/5/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TZWebContent.h"

@interface TZTorrentzOperation : NSOperation <TZWebContentDelegate> {
    BOOL _executing;
    BOOL _finished;
    
    NSString* _connectionURL;
    TZWebContent* _webContent;
    NSDictionary* _dataDict;
}

@property NSString* name;

@property (nonatomic,readonly) NSError* error;
@property (nonatomic,readonly) NSString* connectionURL;
@property (nonatomic,readonly) TZWebContent* webContent;
@property (nonatomic,readonly) NSDictionary* dataDict;

- (id)initWithURL:(NSString*)url;
- (id)initWithURL:(NSString *)url andName:(NSString*)name;
- (id)initWithURL:(NSString *)url andName:(NSString*)name andObserver:(NSObject*)observer;

- (void)removeObserver:(NSObject*)observer;

@end
