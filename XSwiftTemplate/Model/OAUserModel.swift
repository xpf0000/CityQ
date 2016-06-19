//
//  OAUserModel.swift
//  OA
//
//  Created by X on 15/5/14.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation

class OAUserModel:Reflect
{
    var uid=""
    var username=""
    var truename=""
    var sex=""
    var jgid=""
    var dwid=""
    var bmid=""
    var dw=""
    var bm=""
    var tel=""
    var mobile=""
    var address=""
    var qq=""
    var email=""
    var pass=""
    
    func save()
    {
        OAUserModel.delete(name: "OAUserModel")
        OAUserModel.save(obj: self, name: "OAUserModel")
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



