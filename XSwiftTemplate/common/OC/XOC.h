//
//  XOC.h
//  lejia
//
//  Created by X on 15/10/17.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XOC : NSObject

+ (id) classFromName:(NSString*)name;
+ (UIViewController *)activityViewController;

@end
