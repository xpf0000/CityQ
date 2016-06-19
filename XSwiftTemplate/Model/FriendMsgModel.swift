//
//  FriendMsgModel.swift
//  chengshi
//
//  Created by X on 15/12/9.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class FriendMsgModel:Reflect{
    
    var content=""
    var create_time=""
    var dpic=""
    var did=""
    var nickname=""
    var headimage=""
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if(value == nil)
        {
            return
        }
        
        if(key == "create_time" && value != nil )
        {
            let date=NSDate(timeIntervalSince1970: NSTimeInterval(value as! String)!)
            
            let gregorian:NSCalendar=NSCalendar(calendarIdentifier: NSGregorianCalendar)!
            
            let unitFlags:NSCalendarUnit = [.NSDayCalendarUnit, .NSYearCalendarUnit, .NSMonthCalendarUnit]
            
            let comps=gregorian.components(unitFlags, fromDate: date)
            let comps1=gregorian.components(unitFlags, fromDate: NSDate())
            
            
            if(comps.year != comps1.year)
            {
                self.create_time = date.str!
            }
            else
            {
                if(comps.day == comps1.day && comps.month == comps1.month)
                {
                    self.create_time = date.toStr("HH:mm")!
                }
                else
                {
                    self.create_time = date.toStr("MM-dd HH:mm")!
                }
            }
            
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }

}
