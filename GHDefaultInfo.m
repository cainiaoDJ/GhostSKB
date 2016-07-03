//
//  GHDefaultInfo.m
//  GhostSKB
//
//  Created by 丁明信 on 7/3/16.
//  Copyright © 2016 丁明信. All rights reserved.
//


#import "GHDefaultInfo.h"

@implementation GHDefaultInfo
@synthesize appBundleId;
@synthesize appUrl;
@synthesize defaultInput;

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (id)initWithAppBundle:(NSString *)bundleId appUrl:(NSString *)url input:(NSString *)defaultInput {
    if (self = [super init]) {
        self.appUrl = url;
        self.defaultInput = defaultInput;
        self.appBundleId = bundleId;
    }
    
    return self;
}

@end