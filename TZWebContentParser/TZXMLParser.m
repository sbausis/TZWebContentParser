//
//  TZXMLParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/18/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZXMLParser.h"

@interface TZXMLParser()

@property (nonatomic, strong) NSMutableDictionary* dataDict;
@property (nonatomic, strong) id <TZXMLParserDelegate> xmlParserDelegate;

@end

@implementation TZXMLParser

@synthesize dataDict = _dataDict;
@synthesize xmlParserDelegate = _xmlParserDelegate;

-(NSMutableDictionary*)dataDict {
    return _dataDict;
}
-(void)setDataDict:(NSMutableDictionary *)dataDict {
    _dataDict = dataDict;
}

- (id <TZXMLParserDelegate>)xmlParserDelegate {
    return _xmlParserDelegate;
}
- (void)setXMLParserDelegate:(id <TZXMLParserDelegate>)xmlParserDelegate {
    _xmlParserDelegate = xmlParserDelegate;
}

@end
