//
//  ForumListModel.swift
//  lejia
//
//  Created by X on 15/10/12.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class ForumListModel: NSObject {
    
    var attachment:Int = 0
    var author:String = ""
    var authorid:Int=0
    var count:Int=0
    var dateline:String=""
    var digest:Int=0
    var displayorder:Int=0
    var fid:Int=0
    var heats:Int=0
    var icon:Int=0
    var lastpost:String=""
    var lastposter:String=""
    var replies:Int=0
    var special:Int=0
    var stamp:Int = 0
    var subject:String=""
    var tid:Int=0
    var views:Int=0
    
    override required init() {
        
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }

}
