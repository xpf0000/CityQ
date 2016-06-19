//
//  addressBookInfoModel.swift
//  OA
//
//  Created by X on 15/5/16.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
class OAAddressBookModel:Reflect
{
    var id=""
    var truename=""
    var tel=""
    var mobile=""
    var email=""
    var qq=""
    var address=""
    var title=""
    var memberList:Array<OAAddressBookModel> = []
    var letter=""
    var fullLetter=""
    var collect:Dictionary<String,Array<OAAddressBookModel>> = [:]
    
    func save()
    {
        OAAddressBookModel.delete(name: "OAAddressBookModel")
        OAAddressBookModel.save(obj: self, name: "OAAddressBookModel")
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if(value == nil || value is NSNull)
        {
            return
        }
        
        if(key == "truename")
        {
            self.truename = value as! String
            
            let str:CFMutableString = NSMutableString(string: self.truename) as CFMutableString
            
            if(CFStringTransform(str, nil, kCFStringTransformMandarinLatin, false))
            {
                if(CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false))
                {
                    self.letter = (str as String).subStringToIndex(1).uppercaseString
                    self.fullLetter = (str as String).replace(" ", with: "")
                }
            }
            
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}