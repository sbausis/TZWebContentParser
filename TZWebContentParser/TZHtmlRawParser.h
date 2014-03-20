//
//  TZHtmlRawParser.h
//  WebContentParser
//
//  Created by Simon Baur on 11/14/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZHTMLParser.h"

@interface TZHtmlRawParser : TZHTMLParser <NSHTMLParserDelegate>

-(id)initWithData:(NSData *)data;

@end
