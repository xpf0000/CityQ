//
//  WelcomeModel.swift
//  chengshi
//
//  Created by X on 15/12/26.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class WelcomeModel: Reflect {
    
    var show=false
    var info:Array<String> = []
    
    func reSet()
    {
        show=false
        info.removeAll(keepCapacity: false)
        info=[]
        
        WelcomeModel.delete(name: "Welcome")
        save()
    }
    
    func save()
    {
        WelcomeModel.save(obj: self, name: "Welcome")
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        if(value == nil)
        {
            return
        }
        
        super.setValue(value, forKey: key)
    }


}
