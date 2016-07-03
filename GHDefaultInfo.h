//
//  GHDefaultInfo.h
//  GhostSKB
//
//  Created by 丁明信 on 7/3/16.
//  Copyright © 2016 丁明信. All rights reserved.
//

#ifndef GHDefaultInfo_h
#define GHDefaultInfo_h

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface GHDefaultInfo : NSObject 

@property (nonatomic, strong) NSString* appUrl;
@property (nonatomic, strong) NSString* appBundleId;
@property (nonatomic, strong) NSString* defaultInput;

- (id)initWithAppBundle:(NSString *)bundleId appUrl:(NSString *)url input:(NSString *)defaultInput;
- (void)saveToDefaultStorage;

@end

#endif /* GHDefaultInfo_h */
