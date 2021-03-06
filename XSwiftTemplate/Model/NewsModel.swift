//
//  NewsModel.swift
//  chengshi
//
//  Created by X on 15/11/19.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class NewsSeeModel: Reflect {
    
    var idArr:Array<String>=[]

    func add(str:String)
    {
        idArr.append(str)
        
        NewsSeeModel.save(obj: self, name: "NewsViewed")
    }
    
    func has(str:String)->Bool
    {
        if(idArr.indexOf(str) != nil)
        {
            return true
        }
        
        return false
    }
    
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

class NewsPicModel: Reflect {
    
    var url = ""
}

class NewsModel: Reflect {

    
    var id=""
    var title=""
    var descrip=""
    var comment="0"
    var url=""
    var content=""
    var view=""
    var update_time=""
    var category_id = ""
    var create_time = ""
    var name = ""
    var s_time = ""
    var e_time = ""
    var picList:[NewsPicModel] = [];
    
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

        if(key == "update_time" && value != nil)
        {
            let date=NSDate(timeIntervalSince1970: value!.doubleValue)
            self.update_time = date.str!
            return
        }
        
        if(key == "create_time" && value != nil)
        {
            if value?.doubleValue > 0
            {
                let date=NSDate(timeIntervalSince1970: value!.doubleValue)
                self.create_time = date.str!
                
                return
            }
        
        }
        
        if(key == "s_time" && value != nil)
        {
            if value?.doubleValue > 0
            {
                let date=NSDate(timeIntervalSince1970: value!.doubleValue)
                self.s_time = date.toStr("yyyy-MM-dd")!
                
                return
            }
            
        }
        
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    
}
