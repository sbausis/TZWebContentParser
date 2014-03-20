//
//  TZHTMLParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/18/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZHTMLParser.h"

@interface TZHTMLParser()

@property (nonatomic, strong) NSMutableDictionary* dataDict;
@property (nonatomic, strong) id <TZHTMLParserDelegate> htmlParserDelegate;

@end

@implementation TZHTMLParser

@synthesize dataDict = _dataDict;
@synthesize htmlParserDelegate = _htmlParserDelegate;

-(NSMutableDictionary*)dataDict {
    return _dataDict;
}
-(void)setDataDict:(NSMutableDictionary *)dataDict {
    _dataDict = dataDict;
}

- (id <TZHTMLParserDelegate>)htmlParserDelegate {
    return _htmlParserDelegate;
}
- (void)setHTMLParserDelegate:(id <TZHTMLParserDelegate>)htmlParserDelegate {
    _htmlParserDelegate = htmlParserDelegate;
}

@end
