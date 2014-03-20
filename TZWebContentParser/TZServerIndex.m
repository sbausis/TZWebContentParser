//
//  TZServerIndex.m
//  TZWebContentParser
//
//  Created by Simon Baur on 1/13/14.
//  Copyright (c) 2014 Simon Baur. All rights reserved.
//

#import "TZServerIndex.h"
#import <TZWebContentParser/TZWebContent.h>

@interface TZServerIndex()

@property NSMutableDictionary* dict;

@end

@implementation TZServerIndex

@synthesize dict = dict;

-(id)init {
    self = [super init];
    if (self) {
        self.dict = [TZWebContent parseSynchronous:@"http://torrentz.eu/help"];
        NSLog(@"%@", self.dict);
    }
    return self;
}

-(NSInteger)getServerCount {
    return [((NSArray*)[self.dict objectForKey:@"Servers"]) count];
}
-(NSInteger)getTotalPages {
    return [(NSNumber*)[self.dict objectForKey:@"Pages"] integerValue];
}

-(TZServer*)getServerAtIndex:(NSInteger)i {
    TZServer* server;
    if ( i < [self getServerCount] ) {
        server = [((NSArray*)[self.dict objectForKey:@"Servers"]) objectAtIndex:i];
    }
    return server;
}
-(TZServer*)getServerForServer:(NSString*)serverTitle {
    NSInteger i;
    NSInteger cnt = [self getServerCount];
    for (i=0; i<cnt; i++) {
        TZServer* server = [self getServerAtIndex:i];
        if ([[self getServerTitle:server] isEqualToString:serverTitle]) {
            return server;
        }
    }
    return Nil;
}
-(NSString*)getValueFromDict:(NSDictionary*)link ValueName:(NSString*)val {
    NSString* value;
    if (link) {
        value = [link objectForKey:val];
    }
    return value;
}
-(NSInteger)getServerPages:(TZServer*)server {
    NSNumber* value;
    if (link) {
        value = [server objectForKey:@"Count"];
    }
    return [value integerValue];
}
-(NSString*)getServerLink:(TZServer*)server {
    return [self getValueFromDict:server ValueName:@"Address"];
}
-(NSString*)getServerQuery:(TZServer*)server {
    return [self getValueFromDict:server ValueName:@"Search"];
}
-(NSString*)getServerStyle:(TZServer*)server {
    return [self getValueFromDict:server ValueName:@"Style"];
}
-(NSString*)getServerTitle:(TZServer*)server {
    return [self getValueFromDict:server ValueName:@"Title"];
}

@end
