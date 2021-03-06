//
//  JifenModel.swift
//  chengshi
//
//  Created by X on 2016/10/25.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class JifenRecordModel: Reflect {

    var jf=""
    var jfsy=""
    var create_time=""
    var shopname=""
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if(key == "create_time" && value != nil)
        {
            if value?.doubleValue > 0
            {
                let date=NSDate(timeIntervalSince1970: value!.doubleValue)
                self.create_time = date.toStr("yyyy-MM-dd HH:mm:ss")!
                
                return
            }
            
        }
        
        super.setValue(value, forKey: key)
    }
    
}
