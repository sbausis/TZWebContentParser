//
//  TZAppDelegate.m
//  TZWebContentParserTest
//
//  Created by Simon Baur on 12/8/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZAppDelegate.h"

@implementation TZAppDelegate {
    NSArray* links;
}

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    if (!links) {
        links = [NSArray arrayWithObjects:
                 @"http://torrentz.eu/help",
                 @"http://torrentz.eu/feed?q=movies",
                 @"http://torrentz.eu/7250a43669eaf9bba8004acf3fe73d40068a2553",
                 @"http://bitsnoop.com/the-wolverine-2013-extended-1080p-b-q54632514.html",
                 @"http://www.torrentdownloads.me/torrent/1656351286/Pacific+Rim+2013+720p+WEB-DL+H264-PublicHD",
                 @"http://www.monova.org/torrent/6990499/Pacific.Rim.2013.720p.WEB-DL.H264-PublicHD.html",
                 @"http://www.torrentcrazy.com/torrent/8699333/pacific.rim.2013.720p.web-dl.h264-publichd",
                 @"http://www.torrentreactor.net/torrents/8354276/Pacific-Rim-2013-720p-WEB-DL-H264-PublicHD",
                 @"http://www.torrenthound.com/hash/dd19ca7c9d70c0bbea14bbf6c2b21d34f6546503/torrent-info/Drake--Thank-Me-Later-2010-MP3-Cov-Bubanee-Torrent--btjunkie",
                 @"http://www.houndmirror.com/hash/dd19ca7c9d70c0bbea14bbf6c2b21d34f6546503/torrent-info/Drake--Thank-Me-Later-2010-MP3-Cov-Bubanee-Torrent--btjunkie",
                 @"http://kickass.to/pacific-rim-2013-720p-web-dl-h264-publichd-t7951565.html",
                 @"http://kickmirror.com/the-wolverine-2013-extended-1080p-brrip-x264-yify-t8138507.html",
                 @"http://www.torrentfunk.com/torrent/6899681/pacific-rim-2013-720p-web-dl-h264-publichd.html",
                 @"http://www.seedpeer.me/details/6450029/Pacific.Rim.2013.720p.WEB-DL.H264-PublicHD.html",
                 @"http://www.yourbittorrent.com/torrent/4900745/pacific-rim-2013-720p-web-dl-h264-publichd.html",
                 @"http://www.torrents.net/torrent/4282842/Pacific.Rim.2013.720p.WEB-DL.H264-PublicHD/",
                 @"http://www.fulldls.com/torrent-movies-6005211.html",
                 @"http://www.limetorrents.com/Pacific-Rim-2013-720p-WEBDL-H264PublicHD-torrent-3292052.html",
                 @"https://archive.org/details/EthanSnyderkevinGiftjonLipscombalexWeber2013-08-31Scapescape2013At",
                 @"http://thepiratebay.sx/torrent/8983443",
                 @"http://baymirror.com/torrent/9158696",
                 @"http://www.torrentzap.com/torrent/2248647/Pacific+Rim+2013+720p+WEB-DL+H264-PublicHD",
                 @"http://extratorrent.cc/torrent/3239758/Pacific.Rim.2013.720p.WEB-DL.H264-PublicHD.html",
                 @"http://www.torlock.com/torrent/2581527/the-wolverine-2013.html",
                 @"http://www.vertor.com/torrents/3069057/This-Is-the-End-%282013%29-720p-BrRip-x264-YIFY",
                 @"http://1337x.org/torrent/638452/0/",
                 @"http://www.torrentbit.net/torrent/2737331/The+Big+Bang+Theory+S07E08+HDTV+x264-LOL%5Bettv%5D/",
                 @"http://rarbg.com/torrents/filmi/download/gl24dxa/torrent.html",
                 @"http://www.newtorrents.info/torrent/122413/The_Wolverine_(2013)_EXTENDED_1080p_BrRip_x264_-_YIFY.html?nopop=1",
                 @"http://www.bt-chat.com/details.php?id=181202",
                 @"http://publichd.se/index.php?page=torrent-details&id=ae9c029ecb9b457bb595c37664f1a763f8a9bb6a",
                 @"https://eztv.it/ep/49511/how-i-met-your-mother-s09e09-hdtv-x264-2hd/",
                 @"http://linuxtracker.org/index.php?page=torrent-details&id=21dd07e7c3c28cef50ac7b86f7a35514aa05b1d1",
                 nil];
    }
    [self testWebContent];
}

- (void)testWebContent {
    for (NSString* lnk in links) {
        TZWebContent *content = [[TZWebContent alloc] initWithURL:lnk andDelegate:self];
        if (content) {
            // ddd
        }
    }
}
-(void)webContentDidFail:(TZWebContent *)webContent {
    NSLog(@"TZWebContent failed for url:\"%@\"", webContent.URL);
}
-(void)webContentDidEnd:(TZWebContent *)webContent {
    NSLog(@"TZWebContent succeeded for url:\"%@\", data;%@", webContent.URL, webContent.dataDict);
}

- (NSURL *)applicationFilesDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"ch.0rca.TZWebContentParserTest"];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TZWebContentParserTest" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"TZWebContentParserTest.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    return [[self managedObjectContext] undoManager];
}

- (IBAction)saveAction:(id)sender {
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    // Save changes in the application's managed object context before the application terminates.
    
    if (!_managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

@end
