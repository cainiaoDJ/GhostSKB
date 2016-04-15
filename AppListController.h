//
//  AppListController.h
//  GhostSKB
//
//  Created by playcrab on 16/4/15.
//  Copyright © 2016年 丁明信. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>

@interface AppListController : NSViewController <NSTableViewDelegate, NSTableViewDataSource> {
}
@property (weak) IBOutlet NSTableView *appTable;

@end
