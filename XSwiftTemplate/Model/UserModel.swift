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
            setUMessageTag()
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
    
    func save()
    {
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
        password = ""
        openid=""
        mobile=""
        houseid=""
        fanghaoid=""
        house=MyHouseModel()
        truename=""
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
    
    func getUserMsg()
    {
        if uid == "" || username == ""{return}
        
        Preloading.Share.getMessage(uid,username: username)
    }
    
    func setUMessageTag()
    {
        UMessage.removeAllTags({ (obj, remain, error) -> Void in
            
        })
        
        UMessage.addTag("all") { (response, remain, error) -> Void in
            
        }
        
        if uid != ""
        {
            UMessage.addTag(uid) { (response, remain, error) -> Void in
                
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
            getUserMsg()
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