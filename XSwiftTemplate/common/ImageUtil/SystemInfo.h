//
//  SystemInfo.h
//  chengshi
//
//  Created by X on 16/4/28.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/sysctl.h>
#import <mach/mach.h>

@interface SystemInfo : NSObject

+ (double)availableMemory;

@end
