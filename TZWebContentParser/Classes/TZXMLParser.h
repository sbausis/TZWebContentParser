//
//  TZXMLParser.h
//  TZWebContentParser
//
//  Created by Simon Baur on 11/18/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TZDebug.h"

@class TZXMLParser;

@protocol TZXMLParserDelegate <NSObject>

@optional
- (void)xmlParserDidFail:(TZXMLParser*)xmlParser;
- (void)xmlParserDidEnd:(TZXMLParser*)xmlParser;

@end

@interface TZXMLParser : NSXMLParser

-(NSMutableDictionary*)dataDict;
-(void)setDataDict:(NSMutableDictionary *)dataDict;

- (id <TZXMLParserDelegate>)xmlParserDelegate;
- (void)setXMLParserDelegate:(id <TZXMLParserDelegate>)xmlParserDelegate;

@end
