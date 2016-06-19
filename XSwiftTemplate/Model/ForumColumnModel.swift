//
//  ForumColumnModel.swift
//  lejia
//
//  Created by X on 15/10/14.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class ForumColumnModel: NSObject {

    var fid:Int = 0
    var name:String = ""
    var todayTotal:Int=0
    var fup:Int=0
    var lastpost:String=""
    var posts:Int=0
    var threads:Int=0
    var todayposts:Int=0
    var item:Array<ForumColumnModel>=[]
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
