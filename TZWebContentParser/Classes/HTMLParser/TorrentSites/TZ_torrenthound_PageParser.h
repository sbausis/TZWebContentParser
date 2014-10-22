//
//  TZ_torrenthound_PageParser.h
//  TZWebContentParser
//
//  Created by Simon Baur on 11/16/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZHtmlRawParser.h"

@interface TZ_torrenthound_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>

@end

@interface TZ_houndmirror_PageParser : TZ_torrenthound_PageParser

@end
