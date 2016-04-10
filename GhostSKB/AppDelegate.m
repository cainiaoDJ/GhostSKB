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
    [popover showRelativeToRect:button.bounds ofView:button preferredEdge:NSRectEdgeMaxY];
}


- (void) handleEvent:(NSNotification *)noti {
    NSRunningApplication *runningApp = (NSRunningApplication *)[noti.userInfo objectForKey:@"NSWorkspaceApplicationKey"];
    NSLog(@"%@", runningApp.bundleIdentifier);
}

#pragma mark - NSMenuDelegate

//-(void)menuNeedsUpdate:(NSMenu *)menu {
//    menu.title = @"hehe";
//    NSInteger n = [[menu itemArray] count];
//    NSLog(@"%d", n);
//    NSLog(@"menuNeedsUpdate");
//}

//-(void)menuWillOpen:(NSMenu *)menu {
//    NSLog(@"menuWillOpen");
//}
//
//-(void)menuDidClose:(NSMenu *)menu {
//    NSLog(@"menuDidClose");
//}
//
//-(NSInteger)numberOfItemsInMenu:(NSMenu *)menu {
//    return 7;
//}
//
//-(BOOL)menu:(NSMenu *)menu updateItem:(NSMenuItem *)item atIndex:(NSInteger)index shouldCancel:(BOOL)shouldCancel {
//    NSLog(@"hehehehheheh");
//    return YES;
//}
@end
