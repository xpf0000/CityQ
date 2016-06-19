//
//  commonDelegate.swift
//  swiftTest
//
//  Created by X on 15/3/17.
//  Copyright (c) 2015年 swiftTest. All rights reserved.
//

import Foundation
import UIKit

@objc protocol commonDelegate:NSObjectProtocol{
    //回调方法
    
    optional func doSameThingWithObj(o:AnyObject?)
    optional func doSameThingWithFlag(flag:Int)
    optional func frameChange(frame:CGRect,flag:Int)
    optional func selectWithDict(dict:Dictionary<String,AnyObject>?,flag:Int)
}