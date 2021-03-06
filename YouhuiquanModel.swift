//
//  YouhuiquanModel.swift
//  chengshi
//
//  Created by X on 2016/10/24.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class YouhuiquanModel: Reflect {
    
    var id=""
    var money=""
    var s_time=""
    var e_time=""
    var s_money=""
    var orlq=0
    
    var s_time_unix = 0.00
    var e_time_unix = 0.00
    
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if(value == nil)
        {
            return
        }
        
        if(key == "s_time" && value != nil)
        {
            if value?.doubleValue > 0
            {
                let date=NSDate(timeIntervalSince1970: value!.doubleValue)
                self.s_time = date.toStr("yyyy-MM-dd")!
                s_time_unix = value!.doubleValue
                return
            }
            
        }
        
        if(key == "e_time" && value != nil)
        {
            if value?.doubleValue > 0
            {
                let date=NSDate(timeIntervalSince1970: value!.doubleValue)
                self.e_time = date.toStr("yyyy-MM-dd")!
                e_time_unix = value!.doubleValue
                return
            }
            
        }
        
        super.setValue(value, forKey: key)
    }


}
