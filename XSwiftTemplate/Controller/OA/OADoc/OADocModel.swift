//
//  OADocModel.swift
//  chengshi
//
//  Created by X on 16/1/7.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class OADocFileModel:Reflect {
    
    var url=""
    var name=""
    
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

class OADocModel:Reflect {
    
    var id=""
    var truename=""
    var title=""
    var content=""
    var create_time=""
    var fileList:Array<OADocFileModel> = []
    var arr:Dictionary<String,Array<OADocModel>> = [:]
    
    func save()
    {
        OADocModel.delete(name: "OADocModel")
        OADocModel.save(obj: self, name: "OADocModel")
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
