//
//  MessageModel.swift
//  chengshi
//
//  Created by X on 16/6/13.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MessageModel: Reflect {

    var id=""
    var title=""
    var content=""
    var create_time=""
    
    var type1:[MessageModel] = []
    var type2:[MessageModel] = []
    var type3:[MessageModel] = []
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if(key == "create_time" && value != nil)
        {
            if value?.doubleValue > 0
            {
                let date=NSDate(timeIntervalSince1970: value!.doubleValue)
                self.create_time = date.toStr("yyyy年MM月dd号")!
                
                return
            }
            
        }
        
        super.setValue(value, forKey: key)
    }
}
