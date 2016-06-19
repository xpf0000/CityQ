//
//  ShopsListModel.swift
//  OA
//
//  Created by X on 15/8/27.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation

class ShopsListModel:NSObject
{
    var AreaCircle="";
    var ClassName="";
    var FatherClass=0;
    var Map_Latitude=0.0;
    var Map_Longitude=0.0;
    var SecondArea="";
    
    var SubClass=0;
    var area=0;
    var id=0;
    
    var isauth=0;
    var iscard=0;
    var isvip=0;
    
    var name="";
    var starnum=0;
    var type = 0;
    
    var url="";
    
    required override init()
    {
        super.init()
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        super.setValue(value, forKey: key)
        
        if(key=="starnum")
        {
            var starnm=0;
            starnm = self.starnum > 5 ? 5 : self.starnum;
            self.starnum=starnm;
            
        }
        
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
}
