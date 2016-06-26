//
//  MessageModel.swift
//  chengshi
//
//  Created by X on 16/6/13.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class UserMsgModel:Reflect
{
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
