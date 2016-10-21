//
//  HFBModel.swift
//  chengshi
//
//  Created by X on 2016/10/20.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class HFBModel: Reflect {

    var id=""
    var hfb=""
    var hfbsy=""
    var name=""
    var create_time=""
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if(key == "create_time" && value != nil)
        {
            if value?.doubleValue > 0
            {
                let date=NSDate(timeIntervalSince1970: value!.doubleValue)
                self.create_time = date.toStr("yyyy-MM-dd")!
                
                return
            }
            
        }
        
        super.setValue(value, forKey: key)
    }
    
}
