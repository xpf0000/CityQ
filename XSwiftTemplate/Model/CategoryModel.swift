//
//  CategoryModel.swift
//  chengshi
//
//  Created by X on 15/11/23.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class CategoryModel: Reflect {
    
    
    var id=""
    var title=""
    var url=""
    var name = ""
    
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

