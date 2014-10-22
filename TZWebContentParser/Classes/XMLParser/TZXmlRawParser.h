//
//  TZXmlRawParser.h
//  TZWebContentParser
//
//  Created by Simon Baur on 11/14/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZXMLParser.h"

@interface TZXmlRawParser : TZXMLParser <NSXMLParserDelegate>

-(id)initWithData:(NSData *)data;

@end
