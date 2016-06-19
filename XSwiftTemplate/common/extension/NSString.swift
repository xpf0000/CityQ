//
//  NSString.swift
//  rexian V1.0
//
//  Created by X on 15/11/13.
//  Copyright © 2015年 Apple. All rights reserved.
//

import Foundation
import UIKit

extension NSString{

    func replace(str1:String,with:String)->NSString
    {
        
        return self.stringByReplacingOccurrencesOfString(str1, withString: with)
    }
    
    //分割字符
    func split(s:String)->[String]{
        
        return self.componentsSeparatedByString(s)
        
    }
    //去掉左右空格
    func trim()->String{
        
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    //是否包含字符串
    func has(s:String)->Bool{
        if (self.rangeOfString(s).location >= 0) {
            return true
        }else{
            return false
        }
    }
    //是否包含前缀
    func hasBegin(s:String)->Bool{
        if self.hasPrefix(s) {
            return true
        }else{
            return false
        }
    }
    //是否包含后缀
    func hasEnd(s:String)->Bool{
        if self.hasSuffix(s) {
            return true
        }else{
            return false
        }
    }
    
    func isChinese()->Bool
    {
        return (self as String).isChinese()
    }
    
    
    //统计字节长度 一个汉字两个字节算
    var btyeLength:Int
    {
        return (self as String).btyeLength
    }
    
    
    var md5 : String{
        
        return (self as String).md5
    }
    
    func fileExistsInBundle()->Bool
    {
        return (self as String).fileExistsInBundle()
    }
    
    func fileExistsInPath()->Bool
    {
        return (self as String).fileExistsInPath()
    }
    
    var data:NSData?
        {
            return self.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    var path:String
        {
            return (self as String).path
    }
    
    var URL:NSURL?
        {
            return NSURL(string: self as String)
        }
    
    var urlRequest:NSURLRequest?
        {
            return (self as String).urlRequest
    }
    
    var image:UIImage?
        {
            return (self as String).image
    }
    
    var color:UIColor?
        {
            return (self as String).color
            
    }
    
    var date:NSDate?
        {
            return (self as String).date
    }
    
    func toDate(format:String)->NSDate?
    {
        return (self as String).toDate(format)
    }
    
    var fileType:String
        {
            return (self as String).fileType
    }
    
    var fileName:String
        {
            return (self as String).fileName
    }
    
    var VC:UIViewController
        {
            return board.instantiateViewControllerWithIdentifier(self as String)
    }
    
    func VC(p:Teamer)->UIViewController
    {
        let board:UIStoryboard=UIStoryboard(name: p.rawValue, bundle: nil)
        return board.instantiateViewControllerWithIdentifier(self as String)
    }
    
    var Nib:UINib
        {
            return UINib(nibName: self as String, bundle: nil)
    }
    
    var View:UIView
        {
            let arr:Array = NSBundle.mainBundle().loadNibNamed(self as String, owner: nil, options: nil)
            
            return arr[0] as! UIView 
    }
    
    func postNotice()
    {
        NSNotificationCenter.defaultCenter().postNotificationName(self as String, object: nil)
    }
    
    func UserDefaultsValue()->AnyObject?
    {
        return NSUserDefaults.standardUserDefaults().valueForKey(self as String)
    }
    
    var createModel: NSObject?
        {
            let temp = NSClassFromString(self as String)
                as? NSObject.Type
            
            if let type = temp {
                let my = type.init()
                
                return my
            }
            
            return nil
    }
    
    func match(str:RegularType)->Bool
    {
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",str.rawValue)
        
        if ((regextestmobile.evaluateWithObject(self) == true)
            )
        {
            return true
        }
        else
        {
            return false
        }
    }
    
}
