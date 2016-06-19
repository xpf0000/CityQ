//
//  NSObject.swift
//  lejia
//
//  Created by X on 15/11/4.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import Foundation
import UIKit


extension NSObject{
    
    func checkNull()->Bool
    {
        var r = false
        if let text = self.valueForKey("text") as? String
        {
            if(text.trim() != "")
            {
                r = true
            }
        }
        
        if !r
        {
            if self is UIView
            {
                (self as! UIView).shake()
            }
        }
        
        return r
    }
    
    
    func checkPhone()->Bool
    {
        var r = false
        if let text = self.valueForKey("text") as? String
        {
            if(text.match(.Phone))
            {
                r = true
            }
        }
        
        if !r
        {
            if self is UIView
            {
                (self as! UIView).endEdit()
                ShowMessage("手机号码格式有误")
            }
        }
        
        return r
        
    }
    
    func checkEmail()->Bool
    {
        var r = false
        if let text = self.valueForKey("text") as? String
        {
            if(text.match(.Email))
            {
                r = true
            }
        }
        
        if !r
        {
            if self is UIView
            {
                (self as! UIView).endEdit()
                ShowMessage("邮箱格式有误")
            }
        }
        
        return r
        
    }
    
    func checkLength(min:Int,max:Int)->Bool
    {
        var r = false
        if let text = self.valueForKey("text") as? String
        {
            if(text.trim().checkLength(min, max: max))
            {
                r = true
            }
        }
        
        return r
    }
    
    func checkLength(str:String,min:Int,max:Int)->Bool
    {
        var r = false
        if let text = self.valueForKey("text") as? String
        {
            if(text.trim().checkLength(min, max: max))
            {
                r = true
            }
        }
        
        if !r
        {
            if self is UIView
            {
                (self as! UIView).endEdit()
                ShowMessage(str+"长度为\(min)至\(max)位")
            }
        }
        
        return r
    }
    
    
}
