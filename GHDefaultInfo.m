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

- (void)saveToDefaultStorage {
    if (self.appUrl == NULL || self.appBundleId == NULL || self.defaultInput == NULL) {
        return;
    }
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    NSString *keyBoardDefaultInputKey = @"gh_default_keyboards";
    NSData *data = [prefs objectForKey:keyBoardDefaultInputKey];
    NSDictionary *retrievedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSMutableDictionary *keyBoardDefault = [[NSMutableDictionary alloc] initWithDictionary:retrievedDictionary];
    if (keyBoardDefault == NULL) {
        keyBoardDefault = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:self.appUrl, @"appUrl", self.defaultInput, @"defaultInput", self.appBundleId, @"appBundleId", nil];
    [keyBoardDefault setObject:info forKey:self.appBundleId];
    
    [prefs setObject:[NSKeyedArchiver archivedDataWithRootObject:(NSDictionary *)keyBoardDefault] forKey:keyBoardDefaultInputKey];
    BOOL ok = [prefs synchronize];
    
}

@end