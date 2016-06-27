//
//  datePicker.swift
//  OA
//
//  Created by X on 15/5/5.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit

typealias datePickerBlock = (String?)->Void

class datePicker:UIView
{
 
    var Type:Int=0
    var Flag:Int=0
    let datePicker=UIDatePicker()
    var delegate:commonDelegate?
    var block:datePickerBlock?
    var dateFormat:String = ""
    var minDate:NSDate?
    var maxDate:NSDate?
    //type 0 日期 1 时间
    
    func block(block:datePickerBlock)
    {
        self.block = block
    }
        
    init(frame:CGRect,type:Int,flag:Int)
    {
        super.init(frame: frame)
        Type=type
        Flag=flag
        self.frame=CGRectMake(0, sheight, swidth, 316)
        self.backgroundColor=UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        datePicker.frame=CGRectMake(0, 40, swidth, 276)
        if(type==0)
        {
            datePicker.datePickerMode=UIDatePickerMode.Date
        }
        else if(type==1)
        {
            datePicker.datePickerMode=UIDatePickerMode.Time
            datePicker.minuteInterval = 5
        }
        else if(type==2)
        {
            datePicker.datePickerMode=UIDatePickerMode.DateAndTime
            datePicker.minuteInterval = 5
        }
    
        datePicker.date=NSDate()
        
        self.addSubview(datePicker)
        
        let view=UIView(frame: CGRectMake(0, 0, swidth, 40))
        view.backgroundColor=UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
        
        let okButton=UIButton(frame: CGRectMake(swidth-50, 6, 40, 28))
        okButton.setTitle("确定", forState: UIControlState.Normal)
        okButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        okButton.addTarget(self, action: #selector(hidden(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        okButton.tag=5
        view.addSubview(okButton)
        
        let cButton=UIButton(frame: CGRectMake(10, 6, 40, 28))
        cButton.setTitle("取消", forState: UIControlState.Normal)
        cButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        cButton.addTarget(self, action: #selector(hidden(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cButton.tag=6
        view.addSubview(cButton)
        
        self.addSubview(view)
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        if(newSuperview == nil)
        {
            let frame=CGRectMake(0, sheight, swidth, 316)
            self.frame = frame
        }
    }
    
    func show()
    {
        if(minDate != nil)
        {
            datePicker.minimumDate = minDate
        }
        if(maxDate != nil)
        {
            datePicker.maximumDate = maxDate
        }
        
        let frame:CGRect=CGRectMake(0, sheight-316, swidth, 316)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.frame=frame
            
            }) { (finished) -> Void in
        }
        
    }
    
    func hidden(sender:UIButton)
    {
        let frame=CGRectMake(0, sheight, swidth, 316)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.frame=frame
            
        }) { (finished) -> Void in
            
            if(self.frame.origin.y==sheight)
            {
                self.removeFromSuperview()
                if(sender.tag==5)
                {
                    let date=self.datePicker.date
                    let dateFormatter:NSDateFormatter=NSDateFormatter()
                    
                    if(self.Type==0)
                    {
                        dateFormatter.dateFormat="yyyy-MM-dd"
                    }
                    else if(self.Type==1)
                    {
                        dateFormatter.dateFormat="HH:mm"
                    }
                    else if(self.Type==2)
                    {
                        dateFormatter.dateFormat="yyyy-MM-dd HH:mm"
                    }
                    
                    if(self.dateFormat != "")
                    {
                        dateFormatter.dateFormat=self.dateFormat
                    }
                    
                    let dateStr=dateFormatter.stringFromDate(date)
                    
                    if(self.block != nil)
                    {
                        self.block!(dateStr)
                    }
                    
                    self.delegate?.selectWithDict!(["Date":dateStr], flag: self.Flag)
                }
                else
                {
                    self.delegate?.selectWithDict!(nil, flag: self.Flag)
                }
                
            }
            
        }
        
        
    }
    
    deinit
    {
        self.block = nil
        self.delegate = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
