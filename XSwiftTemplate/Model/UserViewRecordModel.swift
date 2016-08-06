//
//  UserViewRecordModel.swift
//  chengshi
//
//  Created by X on 16/3/24.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class UserViewRecordModel: Reflect {

    var uid = ""
    var id=""
    
    var arr:[UserViewRecordModel] = []
  
    func add(id:String)
    {
        let model = UserViewRecordModel()
        model.uid = DataCache.Share.userModel.uid
        model.id = id
        self.arr.append(model)
        self.save()
    }
    
    func has(id:String)->Bool
    {
        for item in self.arr
        {
            if item.id == id && item.uid == DataCache.Share.userModel.uid
            {
                return true
            }
        }
        
        return false
    }
    
    func save()
    {
        UserViewRecordModel.delete(name: "UserViewRecordModel")
        UserViewRecordModel.save(obj: self, name: "UserViewRecordModel")
    }

}
