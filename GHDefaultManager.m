//
//  GHDefaultManager.m
//  GhostSKB
//
//  Created by 丁明信 on 4/10/16.
//  Copyright © 2016 丁明信. All rights reserved.
//

#import "GHDefaultManager.h"
static GHDefaultManager *sharedGHDefaultManager = nil;

@implementation GHDefaultManager

-(id)init
{
    if (self = [super init]) {
        //do something;
        NSDictionary *keyBoardDefaults = [NSDictionary dictionaryWithObjectsAndKeys:nil, nil, nil];
        NSDictionary *appDefault = [NSDictionary dictionaryWithObjectsAndKeys: keyBoardDefaults, @"keyboards", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults: appDefault];
    }
    return self;
}

+ (GHDefaultManager *)getInstance
{
    static dispatch_once_t onceToken;
    //保证线程安全
    dispatch_once(&onceToken, ^{
        sharedGHDefaultManager = [[self alloc] init];
    });
    
    //这是不采用GCD的单例初始化方法
//    @synchronized(self)
//    {
//        if (sharedGHDefaultManager == nil)
//        {
//            sharedGHDefaultManager = [[self alloc] init];
//        }
//    }
    return sharedGHDefaultManager;
}

- (NSMutableArray *)getDefaultKeyBoards {
    NSDictionary *keyBoardDefault = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"keyboards"];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
    
    [keyBoardDefault enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
        NSLog(@"%@", key);
        [arr addObject:object];
    }];
    
    return arr;
}

@end
