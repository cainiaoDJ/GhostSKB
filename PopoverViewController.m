//
//  PopoverViewController.m
//  GhostSKB
//
//  Created by 丁明信 on 16/4/6.
//  Copyright © 2016年 丁明信. All rights reserved.
//

#import "PopoverViewController.h"
#import "GHInputDefaultCellView.h"
#import "GHDefaultManager.h"

@interface PopoverViewController ()

@end

@implementation PopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.gridStyleMask = NSTableViewSolidHorizontalGridLineMask;
    _tableView.headerView = NULL;
    self->defaultKeyBoards = [[GHDefaultManager getInstance] getDefaultKeyBoards];
    NSLog(@"len: %d", [self->defaultKeyBoards count]);
}

#pragma mark - table view datasource

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSInteger num = [self->defaultKeyBoards count] + 1;
//    return num;
    return 10;
}


// 这个方法是提供给cell-based tableview的
//-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
//    NSTextField *result = [tableView makeViewWithIdentifier:@"myView" owner:self];
//    if (result == nil) {
//        result = [[NSTextField alloc] initWithFrame: NSMakeRect(0, 0, 100, 30)];
//        result.identifier = @"myView";
//    }
//    result.stringValue = [NSString stringWithFormat:@"row %ld", row];
//    return result;
//}

// for view-based tableview
-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSView *view = nil;
//    if (row < [self->defaultKeyBoards count]) {
        view = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
        if (view == nil) {
//            view = [[GHInputDefaultCellView alloc] init];
//            view.identifier = @"MainCell";
        }
//    }
    
//    if (row == [self->defaultKeyBoards count]) {
//        view = [tableView makeViewWithIdentifier:@"BottomCell" owner:self];
//    }
    return view;
}


#pragma mark - table view delegate


@end
