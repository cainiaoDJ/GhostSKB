//
//  AppDelegate.m
//  testApp
//
//  Created by 丁明信 on 4/4/16.
//  Copyright © 2016 丁明信. All rights reserved.
//

#import "AppDelegate.h"
#import <AppKit/AppKit.h>
#import "PopoverViewController.h"
#import "GHDefaultManager.h"
@interface AppDelegate ()


@end

@implementation AppDelegate
#pragma mark - App Life Cycle
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
//    [[NSNotificationCenter defaultCenter] addObserver:self forKeyPath:<#(nonnull NSString *)#> options:NSWorkspaceActiveSpaceDidChangeNotification context:NULL]
    
    
    NSNotificationCenter *nc = [[NSWorkspace sharedWorkspace] notificationCenter];
    [nc addObserver:self selector:@selector(handleEvent:) name:NSWorkspaceDidActivateApplicationNotification object:NULL];
    [GHDefaultManager getInstance];
    
    [self initStatusItem];
    [self initPopover];
    
//    [self testShowApps];
    [self testAppFolderSearch];

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)awakeFromNib {
    [imenu setDelegate:self];
}

- (void)initPopover {
    popover = [[NSPopover alloc] init];
    popover.behavior = NSPopoverBehaviorTransient;
    popover.contentViewController = [[PopoverViewController alloc] init];
}
- (void)initStatusItem {
    statusItemSelected = false;
    NSString *imageName = @"ghost_dark_19";
    NSString *alternateImageName = @"ghost_light_19";
    NSImage *normalImage = [NSImage imageNamed:imageName];
    [normalImage setTemplate:YES];
    NSImage *alternateImage = [NSImage imageNamed:alternateImageName];
    [alternateImage setTemplate:YES];
    
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    statusItem.highlightMode = YES;
    statusItem.image = normalImage;
    statusItem.alternateImage = alternateImage;
    
//    statusItem.menu = self->imenu;
    
    [statusItem.button setAction:@selector(onStatusItemSelected:)];
}

- (void) onStatusItemSelected:(id) sender {
    statusItemSelected = !statusItemSelected;
    [self showPopover:sender];
}

- (void)showPopover:(id)sender {
    NSStatusBarButton* button = statusItem.button;
    if (popover.isShown) {
        [popover performClose:button];
    }
    else {
        //get forcus
        [[NSRunningApplication currentApplication] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
        //show popover
        [popover showRelativeToRect:button.bounds ofView:button preferredEdge:NSRectEdgeMaxY];
    }
}

- (void)testShowApps {
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSApplicationDirectory inDomains:NSLocalDomainMask];
    
    NSError *error = nil;
    NSArray *properties = [NSArray arrayWithObjects: NSURLLocalizedNameKey,
                           NSURLCreationDateKey, NSURLLocalizedTypeDescriptionKey, nil];
    
    NSArray *array = [[NSFileManager defaultManager]
                      contentsOfDirectoryAtURL:[urls objectAtIndex:0]
                      includingPropertiesForKeys:properties
                      options:(NSDirectoryEnumerationSkipsHiddenFiles)
                      error:&error];
    NSLog(@"application count :%ld", [array count]);
    NSLog(@"first applications :%@", [[array objectAtIndex:0] description]);
    for (NSURL *url in array) {
        NSLog(@"application: %@", [url description]);
    }
}

- (void)testAppFolderSearch {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSApplicationDirectory inDomains:NSLocalDomainMask];
    NSURL *directoryUrl = [urls objectAtIndex:0];
    NSArray *keys = [NSArray arrayWithObjects:NSURLIsApplicationKey, NSURLTypeIdentifierKey, NSURLLocalizedNameKey,nil];
    NSDirectoryEnumerator *enumerator = [fileManager
                                         enumeratorAtURL:directoryUrl
                                         includingPropertiesForKeys:keys
                                         options:(NSDirectoryEnumerationSkipsHiddenFiles)
                                         errorHandler:^BOOL(NSURL * _Nonnull url, NSError * _Nonnull error) {
                                             return YES;
                                         }];
    
    for (NSURL *url in enumerator) {
        NSError *error;
        NSNumber *isDirectory = nil;
        if (! [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
            
        }
        else if ([isDirectory boolValue]) {
            NSString *path = [url description];
            if (![path containsString:@"Contents"]
                && ![path containsString:@".framework"]
                && ![path containsString:@"lib"]
                && [[path pathExtension] isEqualToString:@"app"]) {
                NSLog(@"path :%@", path);
            }
        }
    }
}

- (void) handleEvent:(NSNotification *)noti {
    NSRunningApplication *runningApp = (NSRunningApplication *)[noti.userInfo objectForKey:@"NSWorkspaceApplicationKey"];
//    NSLog(@"%@", runningApp.bundleIdentifier);
}

@end
