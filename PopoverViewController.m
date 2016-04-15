//
//  PopoverViewController.m
//  GhostSKB
//
//  Created by 丁明信 on 16/4/6.
//  Copyright © 2016年 丁明信. All rights reserved.
//

#import "PopoverViewController.h"
#import "GHInputDefaultCellView.h"
#import "GHInputAddDefaultCellView.h"
#import "GHDefaultManager.h"

@interface PopoverViewController ()

@end

@implementation PopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _tableView.dataSource = self;
//    _tableView.delegate = self;
    _tableView.gridStyleMask = NSTableViewSolidHorizontalGridLineMask;
    _tableView.headerView = NULL;
    self->defaultKeyBoards = [[GHDefaultManager getInstance] getDefaultKeyBoards];
//    NSLog(@"len: %d", [self->defaultKeyBoards count]);
}

#pragma mark - table view datasource

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSInteger num = [self->defaultKeyBoards count] + 1;
//    return num;
    return 10;
}


// for view-based tableview
-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
//    if (row < [self->defaultKeyBoards count]) {
        GHInputDefaultCellView *view = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
        return view;
//    }
//    else {
//        GHInputAddDefaultCellView *view = [tableView makeViewWithIdentifier:@"BottomCell" owner:self];
//        return view;
//    }

}


#pragma mark - table view delegate


- (IBAction)onAddDefault:(id)sender {
    NSLog(@"onadd");
}

- (IBAction)onRemoveDefault:(id)sender {
    
    NSInteger row = [_tableView rowForView:(NSView *)sender];
    NSLog(@"on remove clicked, row:%d", row);
}
@end
