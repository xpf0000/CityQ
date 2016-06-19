//
//  MyCollectModel.swift
//  chengshi
//
//  Created by X on 15/11/30.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyCollectModel: Reflect {
    
    var id=""
    var title=""
    var url=""
    
    var dict:Dictionary<String,Bool> = [:]
    

    func save()
    {
        MyCollectModel.delete(name: "MyCollectModel")
        MyCollectModel.save(obj: self, name: "MyCollectModel")
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
