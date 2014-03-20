//
//  TZHTMLParser.h
//  TZWebContentParser
//
//  Created by Simon Baur on 11/18/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSHTMLParser.h"
#import "TZDebug.h"

@class TZHTMLParser;

@protocol TZHTMLParserDelegate <NSObject>

@optional
- (void)htmlParserDidFail:(TZHTMLParser*)htmlParser;
- (void)htmlParserDidEnd:(TZHTMLParser*)htmlParser;

@end

@interface TZHTMLParser : NSHTMLParser

-(NSMutableDictionary*)dataDict;
-(void)setDataDict:(NSMutableDictionary *)dataDict;

- (id <TZHTMLParserDelegate>)htmlParserDelegate;
- (void)setHTMLParserDelegate:(id <TZHTMLParserDelegate>)htmlParserDelegate;

@end
