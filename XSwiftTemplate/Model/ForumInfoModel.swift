//
//  ForumInfoModel.swift
//  lejia
//
//  Created by X on 15/10/16.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class ForumInfoTitleModel:NSObject
{
    var replies:Int = 0
    var subject:String = ""
    var tid:Int = 0
    var views:Int = 0
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}

class ForumInfoItemsModel : NSObject{
    
    var info:String = ""
    var type:Int = 0
    var height:Int = 0
    var index:Int = 0
    var width:Int=0
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}


class ForumInfoModel: NSObject {

    var attachment:Int=0
    var author:String = ""
    var authorid:Int=0
    var count:Int=0
    var dateline:String = ""
    var fid:Int=0
    var message:Array<ForumInfoItemsModel> = []
    var pid:Int=0
    var position:Int=0
    var tid:Int=0
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
