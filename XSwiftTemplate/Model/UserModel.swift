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
    {
        didSet
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
    }
    
    var nickname=""
    var sex=""
    
    var username=""

    var headimage=""
    var password=""
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
    
    var hfb = ""
    var qdday = ""
    var wqd = ""
    var orqd = 0
    
    var token = ""
    
    func registNotice()
    {
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

    
    func getHFB()
    {
        if uid == "" || username == "" {
            valueChangeBlock?("hfb","0")
            valueChangeBlock?("wqd","0")
            return
        }
        
        let url = "http://182.92.70.85/hfapi/Public/Found/?service=jifen.getUinfo&uid=\(uid)&username=\(username)"
        
        XHttpPool.requestJson(url, body: nil, method: .GET) { [weak self](o) in
            
            if let str = o?["data"]["info"][0]["hfb"].string
            {
                self?.hfb = str
                self?.valueChangeBlock?("hfb",str)
            }
            
            if let str = o?["data"]["info"][0]["qdday"].string
            {
                self?.qdday = str
            }
            
            if let str = o?["data"]["info"][0]["wqd"].string
            {
                self?.wqd = str
                self?.valueChangeBlock?("wqd",str)
            }
            
            if let str = o?["data"]["info"][0]["orqd"].int
            {
                self?.orqd = str
                self?.valueChangeBlock?("orqd",str)
            }
    
        }
    }
    
    func save()
    {
        print(self)
        UserModel.delete(name: "userModel")
        UserModel.save(obj: self, name: "userModel")
    }
    
    func clone(m:UserModel)
    {
        uid = m.uid
        nickname = m.nickname
        sex = m.sex
        username = m.username
        headimage=m.headimage
        password=m.password
        openid=m.openid
        mobile=m.mobile
        houseid=m.houseid
        fanghaoid=m.fanghaoid
        house=m.house
        truename=m.truename
        louhaoid = m.louhaoid
        danyuanid = m.danyuanid
        birthday=m.birthday
        address=m.address
        token=m.token
    }
    
    func reSet()
    {
        uid = ""
        nickname = ""
        sex = ""
        username = ""
        headimage=""
        password=""
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
        token=""
        
        self.save()
        
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
   
    }
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    
}
