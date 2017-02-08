//
//  CrashHandle.m
//  chengshi
//
//  Created by 徐鹏飞 on 2017/1/20.
//  Copyright © 2017年 XSwiftTemplate. All rights reserved.
//

#import "CrashHandle.h"

@implementation CrashHandle

- (NSDictionary *)onCrashCaught:(NSString *)pCrashReason CallStack:(NSString *)callStack {
    NSMutableDictionary *ltmpDict = [NSMutableDictionary dictionary];
    
    NSLog(@"pCrashReason: %@",pCrashReason);
    
    [ltmpDict setObject:callStack forKey:pCrashReason];
    return ltmpDict;
}

@end
