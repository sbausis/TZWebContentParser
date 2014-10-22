//
//  TZ_thepiratebay_PageParser.h
//  TZWebContentParser
//
//  Created by Simon Baur on 11/15/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZHtmlRawParser.h"

@interface TZ_thepiratebay_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>

@end

@interface TZ_baymirror_PageParser : TZ_thepiratebay_PageParser

@end
