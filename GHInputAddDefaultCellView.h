//
//  GHInputAddDefaultCellView.h
//  GhostSKB
//
//  Created by 丁明信 on 4/10/16.
//  Copyright © 2016 丁明信. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GHInputAddDefaultCellView : NSTableCellView

@property(nonatomic, assign) NSInteger row;

@property(nonatomic, retain) IBOutlet NSTextField* appName;
@property(nonatomic, retain) IBOutlet NSPopUpButton* inputMethodsPopButon;
@property(nonatomic, retain) IBOutlet NSButton* appButton;
@end
