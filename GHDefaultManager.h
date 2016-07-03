//
//  GHDefaultManager.h
//  GhostSKB
//
//  Created by 丁明信 on 4/10/16.
//  Copyright © 2016 丁明信. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GHDefaultManager : NSObject

+ (GHDefaultManager *)getInstance;
- (NSMutableArray *)getDefaultKeyBoards;
- (NSDictionary *)getDefaultKeyBoardsDict;
@end
