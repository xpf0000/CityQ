//
//  CardModel.swift
//  chengshi
//
//  Created by X on 16/6/10.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class CardModel: Reflect {

    var id = ""
    var color = "232323"
    var logo = ""
    var shopname = ""
    var type = ""
    var orlq = 0
    var tel = ""
    var address = ""
    var info = ""
    var shopid = ""
    var values = ""
    var hcmid = ""
    var cardnumber = ""
    var orvip = ""

}

class CardActivityModel: Reflect {
    
    var id=""
    var title=""
    var descrip=""
    var url=""
    var view=""
    var create_time = ""
    var name = ""
    var s_time = ""
    var e_time = ""
    
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
        
        if(key == "create_time" && value != nil)
        {
            if value?.doubleValue > 0
            {
                let date=NSDate(timeIntervalSince1970: value!.doubleValue)
                self.create_time = date.toStr("yyyy-MM-dd")!
                
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
        
        if(key == "e_time" && value != nil)
        {
            if value?.doubleValue > 0
            {
                let date=NSDate(timeIntervalSince1970: value!.doubleValue)
                self.e_time = date.toStr("yyyy-MM-dd")!
                
                return
            }
            
        }
        
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
}


