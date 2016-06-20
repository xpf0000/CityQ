//
//  MyHouseModel.swift
//  lejia
//
//  Created by X on 15/10/27.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyHouseModel: Reflect {

    var uid=""
    var houseid=""
    var xiaoqu=""
    var louhao=""
    var fanghao=""
    var fanghaoid = ""
    var louceng = ""
    var danyuan = ""
    var quyu = ""
    var id=""
    var title=""
    var status = 0
    
    func checkStatus(showMsg:Bool)->Bool
    {
        if fanghaoid == "" {
            ShowMessage("请先添加房屋")
            return false
        }
        
        if status == 1 {return true}
        
        let url = APPURL+"Public/Found/?service=wuye.getshenhe&fanghaoid=\(fanghaoid)&uid=\(DataCache.Share().userModel.uid)"
        
        XHttpPool.requestJson(url, body: nil, method: .GET) { (o) -> Void in
            
            self.status = (o?["data"]["info"][0]["status"].stringValue.numberValue.integerValue)!
            
        }
        
        if showMsg
        {
            ShowMessage("该房屋暂未审核通过，请耐心等待")
        }
        
        return false
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

class PropertyNoticeModel:Reflect
{
    var id=""
    var title=""
    var content=""
    
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


class PhotePicModel:Reflect
{
    var url=""
}

class PropertyPhoteModel:Reflect
{
    var id=""
    var uid=""
    var content=""
    var type=""
    var create_time=""
    var picList:Array<PhotePicModel>=[]
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if(value == nil)
        {
            return
        }
        
        if(key == "create_time" && value != nil )
        {
            let date=NSDate(timeIntervalSince1970: NSTimeInterval(value as! String)!)
            
            self.create_time = date.toStr("yyyy-MM-dd HH:mm")!
            
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}


class PropertyPaymentModel:Reflect
{
    var id=""
    var snumber=""  //上月抄表数
    var bnumber=""  //本月抄表数
    var unumber=""  //使用数量
    var ymoney=""   //应缴金额
    var smoney=""   //实缴金额
    var yumoney=""  //余额
    var money=""
    var create_time=""
    var bak=""
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if(value == nil)
        {
            return
        }
        
        if(key == "create_time" && value != nil )
        {
            let date=NSDate(timeIntervalSince1970: NSTimeInterval(value as! String)!)
            
            self.create_time = date.toStr("yyyyMM")!
            
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}


class PropertyPhoneModel:Reflect
{
    var id=""
    var title=""
    var name=""
    var tel=""
    
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


class PropertyMsgModel:Reflect
{
    var id=""
    var content=""
    var create_time=""
    var xiaoqu = ""
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if(value == nil)
        {
            return
        }
        
        if(key == "create_time" && value != nil )
        {
            let date=NSDate(timeIntervalSince1970: NSTimeInterval(value as! String)!)
            
            self.create_time = date.toStr("yyyy-MM-dd HH:mm")!
            
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}


