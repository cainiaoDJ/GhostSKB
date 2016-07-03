//
//  AppDelegate.h
//  testApp
//
//  Created by 丁明信 on 4/4/16.
//  Copyright © 2016 丁明信. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate> {
    @private
    NSStatusBarButton *_statusBarButton;
    @public
    NSStatusItem *statusItem;
    BOOL statusItemSelected;
    NSPopover* popover;
    __weak IBOutlet NSMenu *imenu;
}

@end

