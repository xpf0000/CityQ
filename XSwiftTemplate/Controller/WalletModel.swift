//
//  WalletModel.swift
//  chengshi
//
//  Created by X on 16/6/21.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class WalletModel: Reflect {
    
    var money=""
    var value=""
    var create_time=""
    var shopname=""
    var type=""
    
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
