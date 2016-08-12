//
//  MessageModel.swift
//  chengshi
//
//  Created by X on 16/6/13.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

var UMsgCount : String?
{
    var c = 0
    
    c = UMsgCount1 + UMsgCount2 + UMsgCount3
    
    UIApplication.sharedApplication().applicationIconBadgeNumber = c
    
    return c == 0 ? nil : ""
}

var UMsgCount1: Int
{
    if let count = DataCache.Share.userMsg.users[Uid]?.count1
    {
        return count
    }
    return 0
}

var UMsgCount2: Int
{
    if let count = DataCache.Share.userMsg.users[Uid]?.count2
    {
        return count
    }
    return 0
}

var UMsgCount3: Int
{
    if let count = DataCache.Share.userMsg.users[Uid]?.count3
    {
        return count
    }
    return 0
}



class UserMsgModel:Reflect
{
    var count1 = 0
    var count2 = 0
    var count3 = 0
    
    var type1:[MessageModel] = []
    var type2:[MessageModel] = []
    var type3:[MessageModel] = []
    
    var viewed:[String] = []
    
    var users:[String:UserMsgModel] = [:]
    
    func removeViewed(o:MessageModel)->Bool
    {
        if let index = users[Uid]?.viewed.indexOf(o.id)
        {
           users[Uid]?.viewed.removeAtIndex(index)
            
            return true
        }
        
        return false
    }
    
    func addViewed(o:MessageModel)
    {
        if Uid == "" {return}
        if users[Uid]?.viewed.contains(o.id) == true {return}
        users[Uid]?.viewed.append(o.id)
        save()
    }
    
    func checkViewed(o:MessageModel)->Bool
    {
        if Uid == "" {return false}
        return users[Uid]!.viewed.contains(o.id)
    }
    
    func clear(type:Int)
    {
        if Uid == "" {return}
        
        if type == 1
        {
            for item in users[Uid]!.type1
            {
                removeViewed(item)
            }
            users[Uid]?.type1.removeAll(keepCapacity: false)
            
            users[Uid]?.count1 = 0
        }
        
        if type == 2
        {
            for item in users[Uid]!.type2
            {
                removeViewed(item)
            }
            users[Uid]?.type2.removeAll(keepCapacity: false)
            
            users[Uid]?.count2 = 0
        }
        
        if type == 3
        {
            for item in users[Uid]!.type3
            {
                removeViewed(item)
            }
            users[Uid]?.type3.removeAll(keepCapacity: false)
            
            users[Uid]?.count3 = 0
        }
        
        save()
        
    }
    
    func remove(o:MessageModel)
    {
        if Uid == "" {return}
        
        if let index = users[Uid]?.type1.indexOf(o)
        {
            users[Uid]?.type1.removeAtIndex(index)
            if !removeViewed(o)
            {
                
            }
        }
        
        if let index = users[Uid]?.type2.indexOf(o)
        {
            users[Uid]?.type2.removeAtIndex(index)
            
            if !removeViewed(o)
            {
                
            }
        }
        
        if let index = users[Uid]?.type3.indexOf(o)
        {
            users[Uid]?.type3.removeAtIndex(index)
            
            if !removeViewed(o)
            {
                
            }
        }
        
        save()
        
       
    }
    
    func save()
    {
        "MsgChange".postNotice()
        UserMsgModel.save(obj: self, name: "UserMsgModel")
    }
    
}

class MessageModel: Reflect {

    var id=""
    var title=""
    var content=""
    var create_time=""
    var xqname=""
    var shopname=""

}
