//
//  OAMessageModel.swift
//  chengshi
//
//  Created by X on 16/1/7.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class OAMessageModel:Reflect {
    
    var id=""
    var truename=""
    var title=""
    var content=""
    var create_time=""
    var arr:Dictionary<String,Array<OAMessageModel>> = [:]
    
    func save()
    {
        OAMessageModel.delete(name: "OAMessageModel")
        OAMessageModel.save(obj: self, name: "OAMessageModel")
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
