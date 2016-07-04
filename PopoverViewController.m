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
//#import "AppListController.h"
#import "GHDefaultInfo.h"

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

@interface PopoverViewController ()

@end

@implementation PopoverViewController

@synthesize appPopOver;
@synthesize defaultKeyBoards;
@synthesize availableInputMethods;

- (void)viewWillAppear {
    [super viewWillAppear];
//    NSLog(@"view will appear");
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"view did load");
    self.availableInputMethods = [[NSMutableArray alloc] initWithCapacity:1];
    [self getAlivibleInputMethods];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //    _tableView.gridStyleMask = NSTableViewSolidHorizontalGridLineMask;
    _tableView.headerView = NULL;
    self.defaultKeyBoards = [[GHDefaultManager getInstance] getDefaultKeyBoards];
    
    //init app popover
    self.appPopOver = [[NSPopover alloc] init];
    self.appPopOver.behavior = NSPopoverBehaviorTransient;
}

- (void) getAlivibleInputMethods {
    NSString *inputID;
    NSMutableString *thisID;
    CFArrayRef availableInputs = TISCreateInputSourceList(NULL, false);
    NSUInteger count = CFArrayGetCount(availableInputs);
    if (_inputIdInfo == NULL) {
        _inputIdInfo = [[NSMutableDictionary alloc] initWithCapacity:3];
    }
    for (int i = 0; i < count; i++) {
        TISInputSourceRef inputSource = (TISInputSourceRef)CFArrayGetValueAtIndex(availableInputs, i);
        CFStringRef type = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceCategory);
        if (!CFStringCompare(type, kTISCategoryKeyboardInputSource, 0)) {
            thisID = (__bridge NSMutableString *)(TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID));
            
            NSMutableString *inputName = (__bridge NSMutableString *)(TISGetInputSourceProperty(inputSource, kTISPropertyLocalizedName));
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[thisID description],@"id", [inputName description], @"inputName", nil];
            
            [self.availableInputMethods addObject:dict];
            [_inputIdInfo setObject:[NSString stringWithFormat:@"%d", i] forKey:[thisID description]];
        }
    }
    

}

#pragma mark - table view datasource

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSInteger num = [self.defaultKeyBoards count] + 1;
    return num;
}

// for view-based tableview
-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    if (row < [self.defaultKeyBoards count]) {
        GHInputAddDefaultCellView *view = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
        GHDefaultInfo *defaultInfo = [self.defaultKeyBoards objectAtIndex:row];
        
        if (defaultInfo.defaultInput == NULL) {
            NSString *defaultInputId = (NSString *)[[self.availableInputMethods objectAtIndex:0] objectForKey:@"id"];
            defaultInfo.defaultInput = defaultInputId;
        }
        
        if (defaultInfo.appUrl != NULL && defaultInfo.appBundleId != NULL){
            NSURL *appUrl = [NSURL fileURLWithPath:defaultInfo.appUrl];
            NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:[appUrl path]];
            NSBundle *appBundle =[NSBundle bundleWithPath:[appUrl path]];
            NSString *appName = [[NSFileManager defaultManager] displayNameAtPath: [appBundle bundlePath]];
            view.appName.stringValue = appName;
            view.appButton.image = icon;
        }
        else {
            view.appButton.image = NULL;
            view.appName.stringValue = @"";
        }

        
        view.row = row;
        if ([view.menu numberOfItems] <= 0) {
            for (int i=0; i<[self.availableInputMethods count]; i++) {
                NSDictionary *inputInfo = self.availableInputMethods[i];
                NSString *inputName = [inputInfo objectForKey:@"inputName"];
                NSMenuItem *item = [view.menu addItemWithTitle:inputName action:@selector(onInputSourceChange:) keyEquivalent:[[inputInfo objectForKey:@"id"] description]];
                item.representedObject = [NSString stringWithFormat:@"%ld",(long)row];
            }
        }
        int inputIndex = [[_inputIdInfo objectForKey:defaultInfo.defaultInput] intValue];
        [view.inputMethodsPopButon selectItemAtIndex:inputIndex];
        
        return view;
        
    }
    else {
        GHInputDefaultCellView *view = [tableView makeViewWithIdentifier:@"BottomCell" owner:self];
        
        return view;
    }

}


#pragma mark - table view delegate

#pragma mark - table view noditfication
-(void)tableViewSelectionDidChange:(NSNotification *)notification {
//    NSLog(@"%d",[[notification object] selectedRow]);
}

#pragma mark - IBoutlets Actions

- (IBAction)onAddDefault:(id)sender {
    BOOL hasEmptyEntry = [self checkEmptyEntryInList];
    if (hasEmptyEntry) {
        NSLog(@"有空列表项");
        return;
    }
    
    GHDefaultInfo *info = [[GHDefaultInfo alloc] init];
    [self.defaultKeyBoards addObject:info];
    [self.tableView reloadData];
}

- (IBAction)onRemoveDefault:(id)sender {
    NSInteger row = [_tableView rowForView:(NSView *)sender];
    GHDefaultInfo *info = [self.defaultKeyBoards objectAtIndex:row];
    
    [[GHDefaultManager getInstance] removeAppInputDefault:info.appBundleId];
    [self.defaultKeyBoards removeObjectAtIndex:row];
    [self.tableView reloadData];
}

- (IBAction)onAppButtonClick:(id)sender {
    
    NSButton *button = (NSButton *)sender;
    GHInputAddDefaultCellView *cellView = (GHInputAddDefaultCellView *)[button superview];
    _currentSelectRow = cellView.row;
    _currentSelectedCell = cellView;
    [self showOpenPanel];
}


- (IBAction)onInputSourcePopButtonClick:(id)sender {
}

#pragma mark - Other util functions

- (BOOL)checkEmptyEntryInList{
    for (GHDefaultInfo *info in self.defaultKeyBoards) {
        if (info.appBundleId == NULL) {
            return TRUE;
        }
    }
    return FALSE;
}

- (void)showAppListController:(id)sender {
    if ([self.appPopOver isShown]) {
        [self.appPopOver performClose:nil];
    }
    else {
        NSButton *button = (NSButton *)sender;
        [self.appPopOver showRelativeToRect:button.bounds ofView:button preferredEdge:NSRectEdgeMinX];
    }
}

- (void)showOpenPanel {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    NSArray *appDirs = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSLocalDomainMask, YES);
    NSString *appDir = [appDirs objectAtIndex:0];
    [panel setDirectoryURL:[NSURL URLWithString:appDir]];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:NO]; // yes if more than one dir is allowed
    
    NSInteger clicked = [panel runModal];
    
    if (clicked == NSFileHandlingPanelOKButton) {
        for (NSURL *url in [panel URLs]) {
            
            NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:[url path]];
            _currentSelectedCell.appButton.image = icon;
            NSBundle *selectedAppBundle =[NSBundle bundleWithURL:url];
            NSString *bundleIdentifier = [selectedAppBundle bundleIdentifier];
            NSString *appName = [[NSFileManager defaultManager] displayNameAtPath: [selectedAppBundle bundlePath]];
            _currentSelectedCell.appName.stringValue = appName;
            
            NSString *selectedInputId = [[_currentSelectedCell.inputMethodsPopButon selectedItem] keyEquivalent];
            
            GHDefaultInfo *info = [self.defaultKeyBoards objectAtIndex:_currentSelectRow];
            info.appUrl = [url path];
            info.appBundleId = bundleIdentifier;
            info.defaultInput = selectedInputId;
            [info saveToDefaultStorage];
            
            [self.defaultKeyBoards sortUsingComparator:^NSComparisonResult(id  _Nonnull a, id  _Nonnull b) {
                GHDefaultInfo *aInfo = (GHDefaultInfo *)a;
                GHDefaultInfo *bInfo = (GHDefaultInfo *)b;
                return [aInfo.appBundleId compare:bInfo.appBundleId];
            }];
            [self.tableView reloadData];

            // post application
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:url, @"appUrl", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GH_APP_SELECTED" object:NULL userInfo:userInfo];
            
            break;
        }
    }
}

-(void)onInputSourceChange:(id)sender {
    NSMenuItem *item = (NSMenuItem *)sender;
    NSInteger row = [[item.representedObject description] integerValue];
    GHDefaultInfo *info = [self.defaultKeyBoards objectAtIndex:row];
    info.defaultInput = [item keyEquivalent];
    [info saveToDefaultStorage];
}

- (IBAction)terminateSelf:(id)sender {
    [[NSApplication sharedApplication] terminate:self];
}
@end
