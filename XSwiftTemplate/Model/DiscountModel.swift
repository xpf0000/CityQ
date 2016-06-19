//
//  DiscountModel.swift
//  chengshi
//
//  Created by X on 15/11/23.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class DiscountModel: Reflect {
    
    var id=""
    var title=""
    var url=""
    var view=""
    var s_time=""
    var e_time=""
    var tel=""
    var address=""
    var content=""
    
    override func setValue(value: AnyObject?, forKey key: String) {
  
        if(value == nil)
        {
            return
        }
        
        if(key == "s_time" && value != nil)
        {
            let date=NSDate(timeIntervalSince1970: value!.doubleValue)
            self.s_time = date.toStr("yyyy-MM-dd")!
            return
        }
        
        if(key == "e_time" && value != nil)
        {
            let date=NSDate(timeIntervalSince1970: value!.doubleValue)
            self.e_time = date.toStr("yyyy-MM-dd")!
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    
}
