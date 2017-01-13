//
//  UserModel.swift
//  chengshi
//
//  Created by X on 15/11/28.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

var Uid:String
{
    return DataCache.Share.userModel.uid
}

var Uname:String
{
    return DataCache.Share.userModel.username
}

var Umobile:String
{
    return DataCache.Share.userModel.mobile
}

class UserModel: Reflect {
    
    var uid=""
    
    var nickname=""
    var sex=""
    
    var username=""

    var headimage=""
    var openid=""
    var mobile=""
    var houseid=""
    var fanghaoid=""
    var house=MyHouseModel()
    var truename=""
    var louhaoid = ""
    var danyuanid = ""
    var birthday=""
    var address=""
    
    var hfb = "0"
    var qdday = ""
    var wqd = "0"
    var orqd = 0
    
    var token = ""
    
    var orwsinfo = ""
    var aihao = ""
    var qianming = ""
    
    func onIDChanged()
    {
        if uid != ""
        {
            CloudPushSDK.bindAccount(self.uid) { (res) in}
        }
        else
        {
            CloudPushSDK.unbindAccount({ (res) in})
        }

    }
    
    func registNotice()
    {
        onIDChanged()
        
        if token != ""
        {
            CloudPushSDK.addAlias(token, withCallback: { (res) in
                
            })
            
        }
    }
    
    func unRegistNotice()
    {
        CloudPushSDK.removeAlias(token) { (res) in}
    }

    
    func getUser()
    {
        if username == "" {
            valueChangeBlock?("User", UserModel())
            return
        }
        
        let url = "http://182.92.70.85/hfapi/Public/Found/?service=User.getUser&username=\(username)"
        let arr = ["mobile","orwsinfo","hfb","nickname","sex","headimage","birthday","aihao","qianming","houseid","fanghaoid","truename"]
        
        XHttpPool.requestJson(url, body: nil, method: .GET) { [weak self](o) in
            
            
            let m = UserModel.parse(json: o?["data"]["info"][0], replace: nil)
            
            for str in arr
            {
                self?.setValue(m.valueForKey(str), forKey: str)
            }
            
            self?.valueChangeBlock?("User",m)
            
            self?.save()
            
        }
        
        
    }

    
    func getHFB()
    {
        if uid == "" || username == "" {
            valueChangeBlock?("HFB", UserModel())
            return
        }
        
        let url = "http://182.92.70.85/hfapi/Public/Found/?service=jifen.getUinfo&uid=\(uid)&username=\(username)"
        let arr = ["qdday","hfb","orwsinfo","wqd","orqd"]
        
        XHttpPool.requestJson(url, body: nil, method: .GET) { [weak self](o) in
            
            
            let m = UserModel.parse(json: o?["data"]["info"][0], replace: nil)
            
            for str in arr
            {
                self?.setValue(m.valueForKey(str), forKey: str)
            }
            
            self?.valueChangeBlock?("HFB",m)
            
            self?.save()
            
        }
        
        
    }
    
    func save()
    {
        print(self)
        UserModel.delete(name: "userModel")
        UserModel.save(obj: self, name: "userModel")
    }
    

    func reSet()
    {
        uid=""
        
        nickname=""
        sex=""
        
        username=""
        
        headimage=""
        openid=""
        mobile=""
        houseid=""
        fanghaoid=""
        house=MyHouseModel()
        truename=""
        louhaoid = ""
        danyuanid = ""
        birthday=""
        address=""
        
        hfb = "0"
        qdday = ""
        wqd = "0"
        orqd = 0
        
        token = ""
        
        orwsinfo = ""
        aihao = ""
        qianming = ""
        
        self.save()
        
        onIDChanged()
        
    }
    
    func getUserHouse()
    {
        if uid == "" || username == "" || houseid == "" {return}
        
        let url=APPURL+"Public/Found/?service=User.getHouseList"
        let body = "uid=\(uid)&username=\(username)"
        XHttpPool.requestJson(url, body: body, method: .POST) { (o) -> Void in
            
            if o?["data"]["info"].arrayValue.count > 0
            {
                for item in o!["data"]["info"].arrayValue
                {
                    let model = MyHouseModel.parse(json: item, replace: nil)
                    if model.houseid == self.houseid
                    {
                        self.house = model
                    }
                }
            }
            
        }
        
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if(value == nil)
        {
            return
        }
        
        super.setValue(value, forKey: key)
        
        if key == "uid" || key == "username"
        {
            getUserHouse()
        }
        
        if key == "houseid"
        {
            getUserHouse()
        }
   
        if key == "birthday"
        {
            birthday = birthday.replace("0000-00-00", with: "")
        }
        
    }
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    
}
