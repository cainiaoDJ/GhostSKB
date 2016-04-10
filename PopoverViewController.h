//
//  PopoverViewController.h
//  GhostSKB
//
//  Created by 丁明信 on 16/4/6.
//  Copyright © 2016年 丁明信. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <AppKit/NSTableView.h>
#import <AppKit/NSTableCellView.h>
#import <AppKit/NSTableColumn.h>
#import <AppKit/NSTableRowView.h>

@interface PopoverViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate> {
    NSMutableArray *defaultKeyBoards;
}

@property (weak) IBOutlet NSTableView *tableView;
@end
