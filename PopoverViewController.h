//
//  PopoverViewController.h
//  GhostSKB
//
//  Created by 丁明信 on 16/4/6.
//  Copyright © 2016年 丁明信. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>

@interface PopoverViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate> {
    NSMutableArray *defaultKeyBoards;
    NSPopover *appPopOver;
}

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSButton *addButton;
- (IBAction)onAddDefault:(id)sender;
- (IBAction)onRemoveDefault:(id)sender;
- (IBAction)onAppButtonClick:(id)sender;
- (IBAction)onInputSourcePopButtonClick:(id)sender;
@end
