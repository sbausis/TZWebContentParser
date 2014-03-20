//
//  NSHTMLParser.h
//  NSHTMLParser
//
//  Created by Simon Baur on 11/14/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "DTHTMLParser.h"

@protocol NSHTMLParserDelegate <DTHTMLParserDelegate>

@end

@interface NSHTMLParser : DTHTMLParser

-(id)initWithData:(NSData *)data;

@end
