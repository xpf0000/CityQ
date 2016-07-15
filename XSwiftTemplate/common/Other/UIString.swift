//
//  UIString.swift
//  swiftTest
//
//  Created by X on 15/3/9.
//  Copyright (c) 2015年 swiftTest. All rights reserved.
//

import Foundation

class UIString {
    
    class func checkUserName(str:String)->Bool
    {
        let str="^[A-Za-z0-9\\u4E00-\\u9FA5_]+$"
        let check:NSPredicate=NSPredicate(format:"SELF MATCHES %@",str)

        if(check.evaluateWithObject(str))
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    class func timeSinceNow(time:String,flag:Int)->String
    {
        var str:String=""
        let dateFormatter:NSDateFormatter=NSDateFormatter()
        
        if time.length() == 10
        {
            dateFormatter.dateFormat="yyyy-MM-dd"
        }
        else if(time.length() == 16)
        {
            dateFormatter.dateFormat="yyyy-MM-dd HH:mm"
        }
        else
        {
            dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        }
        
        
        let date:NSDate=dateFormatter.dateFromString(time)!
        let gregorian:NSCalendar=NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        
        let unitFlags:NSCalendarUnit = [.NSDayCalendarUnit, .NSHourCalendarUnit, .NSMinuteCalendarUnit, .NSSecondCalendarUnit]
        var comps:NSDateComponents?
        switch(flag)
        {
        case 0:
            comps=gregorian.components(unitFlags, fromDate: date, toDate: NSDate(), options: [])
        case 1:
            comps=gregorian.components(unitFlags, fromDate: NSDate(), toDate: date, options: [])
        default:
            return ""
        }
        
        if(comps?.day>1)
        {
            return "\(comps!.day)天"
        }
        
        if(comps?.hour==0)
        {
            if(comps?.minute>=1)
            {
                str="\(comps!.minute)分钟"
            }
            else if(comps?.minute>=0 && comps?.second>0)
            {
                str="\(comps!.second)秒"
            }
        }
        else if(comps?.hour>0)
        {
            str="\(comps!.hour)小时";
        }
        
        return str;
    }
    
    
    class func timeSinceNow(time:NSDate,flag:Int)->String
    {
        var str:String=""
        let date:NSDate=time.formart()
        let gregorian:NSCalendar=NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        
        let unitFlags:NSCalendarUnit = [.NSDayCalendarUnit, .NSHourCalendarUnit, .NSMinuteCalendarUnit, .NSSecondCalendarUnit]
        var comps:NSDateComponents?
        switch(flag)
        {
        case 0:
            comps=gregorian.components(unitFlags, fromDate: date, toDate: NSDate().formart(), options: [])
        case 1:
            comps=gregorian.components(unitFlags, fromDate: NSDate().formart(), toDate: date, options: [])
        default:
            return ""
        }
        
        if(comps?.day>1)
        {
            return "\(comps?.day)天"
        }
        
        if(comps?.hour==0)
        {
            if(comps?.minute>=1)
            {
                str="\(comps?.minute)分钟"
            }
            else if(comps?.minute>=0 && comps?.second>0)
            {
                str="\(comps?.second)秒"
            }
        }
        else if(comps?.hour>0)
        {
            str="\(comps?.hour)小时";
        }
        
        return str;
    }
    
    class func handleNumber(str:String)->String
    {
        var result:String=""
        
        let s=str.substringToIndex(str.startIndex.advancedBy(1))
        switch(str.length())
        {
        case 4:
            result="\(s)千"
        case 5:
            result="\(s)万"
        case 6:
            result="\(s)十万"
        case 7:
            result="\(s)百万"
        case 8:
            result="\(s)千万"
        case 9:
            result="\(s)亿"
        case 10:
            result="\(s)十亿"
        case 11:
            result="\(s)百亿"
        case 12:
            result="\(s)千亿"
        default:
            result=str
        }
        
        return result
    }
    
}
