//
//  TZDebug.h
//  TZWebContentParser
//
//  Created by Simon Baur on 12/12/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#ifndef TZWebContentParser_TZDebug_h
#define TZWebContentParser_TZDebug_h

#define TZDEBUG 1

#if TZDEBUG
#define TZLog(fmt, ...) NSLog(fmt, ##__VA_ARGS__)
#else
#define TZLog(fmt, ...)
#endif

#endif
