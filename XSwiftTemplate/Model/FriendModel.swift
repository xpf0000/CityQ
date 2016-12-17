//
//  FriendModel.swift
//  chengshi
//
//  Created by X on 15/11/24.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class FriendPicModel: Reflect {
    
    var width:CGFloat=0
    var height:CGFloat=0
    var url=""
    var imagesize=""
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if(value == nil)
        {
            return
        }
        
        if(key == "imagesize" && value != nil && (value as! String) != "")
        {
            let arr=(value as! String).split("\"")
            width=CGFloat(Int(arr[1])!)
            height=CGFloat(Int(arr[3])!)
        }

        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
}

class FriendZanModel: Reflect {
    
    var nickname=""
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if(value == nil)
        {
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
}

class FriendCommentModel: Reflect {
    
    var id=""
    var uid=""
    var tnickname=""
    var content=""
    var nickname=""
    var headimage=""
    var create_time=""
    var sex=""
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if(value == nil || value is NSNull)
        {
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
}



class FriendModel: Reflect {
    
    var id=""
    var cid=""
    var qid=""
    var descrip=""
    var comment=""
    var zan=""
    var create_time=""
    var category_id=""
    var title=""
    var nickname=""
    var picList:Array<FriendPicModel> = []
    var zanList:Array<FriendZanModel> = []
    var commentList:Array<FriendCommentModel> = []
    var content=""
    var url=""
    var headimage=""
    var uid=""
    var width:CGFloat=0.0
    var height:CGFloat=0.0
    var view=""
    var location=""
    var orzan=0
    var sex=""
    var all = false
    var username=""
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if(value == nil)
        {
            return
        }
        
        if(key == "description")
        {
            self.descrip = value as! String
            return
        }
        
        if(key == "location" && (value as? String) == "null")
        {
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    
}
