//
//  SystemInfo.m
//  chengshi
//
//  Created by X on 16/4/28.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

#import "SystemInfo.h"

@implementation SystemInfo


// 获取当前设备可用内存(单位：MB）
+ (double)availableMemory
{
    
    NSRealMemoryAvailable();
    
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

@end
