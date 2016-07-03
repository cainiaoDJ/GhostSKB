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
#import <Carbon/Carbon.h>
@interface AppDelegate ()


@end

@implementation AppDelegate
#pragma mark - App Life Cycle
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
//    [[NSNotificationCenter defaultCenter] addObserver:self forKeyPath:<#(nonnull NSString *)#> options:NSWorkspaceActiveSpaceDidChangeNotification context:NULL]
    
    
    NSNotificationCenter *nc = [[NSWorkspace sharedWorkspace] notificationCenter];
    [nc addObserver:self selector:@selector(handleAppActivateNoti:) name:NSWorkspaceDidActivateApplicationNotification object:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleGHAppSelectedNoti:) name:@"GH_APP_SELECTED" object:NULL];
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
    
    [statusItem.button setAction:@selector(onStatusItemSelected:)];
}

- (void) onStatusItemSelected:(id) sender {
    statusItemSelected = !statusItemSelected;
    [self showPopover:sender];
}

- (void)showPopover:(id)sender {
    NSStatusBarButton* button = statusItem.button;
    _statusBarButton = button;
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

- (void) handleAppActivateNoti:(NSNotification *)noti {
    NSRunningApplication *runningApp = (NSRunningApplication *)[noti.userInfo objectForKey:@"NSWorkspaceApplicationKey"];
    NSDictionary *defaultInput = [[GHDefaultManager getInstance] getDefaultKeyBoardsDict];
    NSString *bundleIdentifier = runningApp.bundleIdentifier;
    
    NSDictionary *info = [defaultInput objectForKey:bundleIdentifier];
    
    if (info != NULL) {
        [self changeInputSource:[[info objectForKey:@"defaultInput"] description]];
    }
}

- (void)changeInputSource:(NSString *)inputId
{
    NSMutableString *thisID;
    TISInputSourceRef inputSource = NULL;
    
    CFArrayRef availableInputs = TISCreateInputSourceList(NULL, false);
    NSUInteger count = CFArrayGetCount(availableInputs);
    for (int i = 0; i < count; i++) {
        inputSource = (TISInputSourceRef)CFArrayGetValueAtIndex(availableInputs, i);
        CFStringRef type = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceCategory);
        if (!CFStringCompare(type, kTISCategoryKeyboardInputSource, 0)) {
            thisID = (__bridge NSMutableString *)(TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID));
            if ([thisID isEqualToString:inputId]) {
                OSStatus err = TISSelectInputSource(inputSource);
                if (err) printf("Error %i\n", (int)err);
                break;
            }
        }
    }

}
- (void) handleGHAppSelectedNoti:(NSNotification *)noti {
    NSDictionary *userInfo = [noti userInfo];
    NSURL *appUrl = [userInfo objectForKey:@"appUrl"];
    //get forcus
    [[NSRunningApplication currentApplication] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
    //show popover
    [popover showRelativeToRect:_statusBarButton.bounds ofView:_statusBarButton preferredEdge:NSRectEdgeMaxY];
}

@end
