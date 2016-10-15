//
//  OAFileModel.swift
//  chengshi
//
//  Created by X on 16/1/30.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class OAFileModel: Reflect {
    
    var id = ""
    var name = ""
    var url = ""
    var path = ""
    var type = ""
    var uid = ""
    var open = true
    var arr:Array<OAFileModel> = []
    
    func userArr()->Array<OAFileModel>
    {
        return arr.filter{ item in
            
            return item.open || item.uid==DataCache.Share.oaUserModel.uid
            
        }
    }
    
    func save()
    {
        OAFileModel.delete(name: "OAFileModel")
        OAFileModel.save(obj: self, name: "OAFileModel")
    }
    
    func del(model:OAFileModel)
    {
        var i = 0
        for item in self.arr
        {
            if(model.id == item.id)
            {
                self.arr.removeAtIndex(i)
                
                
                let savePath = (localPath as NSString).stringByAppendingPathComponent(model.url.md5+"."+model.url.fileType)

                let fileManager=NSFileManager()
                if(fileManager.fileExistsAtPath(savePath as String))
                {
                    do
                    {
                        try fileManager.removeItemAtPath(savePath as String)
                    }
                    catch
                    {
                        
                    }
                    
                }

                self.save()
                
                XDownLoadManager.Share.refresh(model.url)
                
                return
            }
            
            i += 1
        }
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if(value == nil || value is NSNull)
        {
            return
        }
        
        if(key == "url")
        {
            self.type = (value as! String).fileType.lowercaseString
        }
        
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    

}
