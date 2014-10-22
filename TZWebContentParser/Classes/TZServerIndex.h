//
//  TZServerIndex.h
//  TZWebContentParser
//
//  Created by Simon Baur on 1/13/14.
//  Copyright (c) 2014 Simon Baur. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSDictionary TZServer;

@interface TZServerIndex : NSObject

-(id)init;

-(NSInteger)getServerCount;
-(NSInteger)getTotalPages;

-(TZServer*)getServerAtIndex:(NSInteger)i;
-(TZServer*)getServerForServer:(NSString*)server;
-(NSInteger)getServerPages:(TZServer*)server;
-(NSString*)getServerLink:(TZServer*)server;
-(NSString*)getServerQuery:(TZServer*)server;
-(NSString*)getServerStyle:(TZServer*)server;
-(NSString*)getServerTitle:(TZServer*)server;

@end
