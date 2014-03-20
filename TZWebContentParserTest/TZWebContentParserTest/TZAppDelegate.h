//
//  TZAppDelegate.h
//  TZWebContentParserTest
//
//  Created by Simon Baur on 12/8/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <TZWebContentParser/TZWebContent.h>

@interface TZAppDelegate : NSObject <NSApplicationDelegate, TZWebContentDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
