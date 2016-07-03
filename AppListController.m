//
//  AppListController.m
//  GhostSKB
//
//  Created by playcrab on 16/4/15.
//  Copyright © 2016年 丁明信. All rights reserved.
//

#import "AppListController.h"

@interface AppListController ()

@end

@implementation AppListController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - tableview datasource and delegate

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return 10;
}


-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return nil;
}

@end
