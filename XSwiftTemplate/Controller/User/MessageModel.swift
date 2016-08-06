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
    
   if let count = DataCache.Share.userMsg.users[Uid]?.count1
   {
        c += count
    }
    
    if let count = DataCache.Share.userMsg.users[Uid]?.count2
    {
        c += count
    }
    
    if let count = DataCache.Share.userMsg.users[Uid]?.count3
    {
        c += count
    }
    
    return c == 0 ? nil : "\(c)"
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
    
    var users:[String:UserMsgModel] = [:]
    
    func save()
    {
        UserMsgModel.save(obj: self, name: "UserMsgModel")
    }
    
}

class MessageModel: Reflect {

    var id=""
    var title=""
    var content=""
    var create_time=""

}
