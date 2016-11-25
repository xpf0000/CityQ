//
//  DataCache.swift
//  swiftTest
//
//  Created by X on 15/3/3.
//  Copyright (c) 2015年 swiftTest. All rights reserved.
//

import Foundation
import UIKit

class DataCache: NSObject {
    var dataDictCache:Dictionary<String,NSObject>=[:]
    var serverTimeInterval:Double=123456.0
    var Cache:Dictionary<String,NSObject>=[:]
    var calendarArr:Array<Array<Dictionary<String,AnyObject>>>=[]
    var deviceToken:String=""
    dynamic var cityID:String=""
    dynamic var cityName:String="衡水"
    lazy var welcom:WelcomeModel = WelcomeModel()
    var cityDict:Array<Dictionary<String,AnyObject>> = []
    lazy var quanCategory:Array<CategoryModel> = []
    lazy var cardCategory:[CategoryModel] = []

    lazy var newsCollect:MyCollectModel = MyCollectModel()
    
    lazy var userModel:UserModel = UserModel()
    lazy var oaUserModel:OAUserModel = OAUserModel()
    lazy var oaMessage:OAMessageModel = OAMessageModel()
    lazy var oaAddress:OAAddressBookModel = OAAddressBookModel()
    lazy var oaDoc:OADocModel = OADocModel()
    lazy var oaFile:OAFileModel = OAFileModel()
    
    lazy var userMsg:UserMsgModel = UserMsgModel()
    
    lazy var newsViewedModel:NewsSeeModel = NewsSeeModel()
    
    lazy var jigouViewRecord:UserViewRecordModel = UserViewRecordModel()
    
    static let Share = DataCache()
    
    private override init() {
        super.init()
        self.addObserver(self, forKeyPath: "cityID", options: .New, context: nil)
        
        cityID = "cityID".UserDefaultsValue()==nil ? "" : "cityID".UserDefaultsValue() as! String
        cityName = "cityName".UserDefaultsValue()==nil ? "" : "cityName".UserDefaultsValue() as! String
        
        if let model = UserMsgModel.read(name: "UserMsgModel") as? UserMsgModel
        {
            userMsg = model
        }
        
        let model = UserModel.read(name: "userModel")
        if(model != nil)
        {
            userModel = model as! UserModel
            //self.getUserInfo()
            userModel.getHFB()
        }

        let model1 = NewsSeeModel.read(name: "NewsViewed")
        if(model1 != nil)
        {
            newsViewedModel = model1 as! NewsSeeModel
        }
        
        let model2 = WelcomeModel.read(name: "Welcome")
        if(model2 != nil)
        {
             welcom = model2 as! WelcomeModel
        }
        
        let model3 = OAUserModel.read(name: "OAUserModel")
        if(model3 != nil)
        {
            oaUserModel = model3 as! OAUserModel
        }
        
        let model4 = OAMessageModel.read(name: "OAMessageModel")
        if(model4 != nil)
        {
            oaMessage = model4 as! OAMessageModel
        }
        
        let model5 = OAAddressBookModel.read(name: "OAAddressBookModel")
        if(model5 != nil)
        {
            oaAddress = model5 as! OAAddressBookModel
        }
        
        let model6 = OADocModel.read(name: "OADocModel")
        if(model6 != nil)
        {
            oaDoc = model6 as! OADocModel
        }
        
        let model7 = MyCollectModel.read(name: "MyCollectModel")
        if(model7 != nil)
        {
            newsCollect = model7 as! MyCollectModel
        }
        
        let model8 = OAFileModel.read(name: "OAFileModel")
        if(model8 != nil)
        {
            oaFile = model8 as! OAFileModel
        }
 
        if let model = UserViewRecordModel.read(name: "UserViewRecordModel")
        {
            jigouViewRecord = model as! UserViewRecordModel
        }
        
    }
    
    func getUserInfo()
    {
        var url=APPURL+"Public/Found/?service=User.login"
        let p = userModel.password
        let u = userModel.mobile
        var body="password="+p+"&mobile="+u
        
        if(userModel.openid != "")
        {
            url=APPURL+"Public/Found/?service=User.openLogin"
            body="openid="+userModel.openid
        }

        let h = self.userModel.house
        
        XHttpPool.requestJson(url, body: body, method: .POST) { (o) -> Void in

            self.userModel.reSet()
            
            if(o?["data"].dictionaryValue.count > 0)
            {
                if(o!["data"]["code"].intValue == 0 && o?["data"]["info"].arrayValue.count > 0)
                {
                    
                    self.userModel = UserModel.parse(json: o!["data"]["info"][0], replace: nil)
                    
                    self.userModel.password = p
                    self.userModel.house = h
                    DataCache.Share.userModel.save()
                    NoticeWord.UpdateUserSuccess.rawValue.postNotice()
                }
                
            }
            
        }
    }
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if(keyPath == "cityID")
        {
            NSUserDefaults.standardUserDefaults().setValue(cityID, forKey: "cityID")
            NSUserDefaults.standardUserDefaults().setValue(cityName, forKey: "cityName")
            NSUserDefaults.standardUserDefaults().synchronize()
            
        }
    }
    
    func addDataCache(cacheurl:String!,cacheData:Dictionary<String,AnyObject>,time:Double)->Void
    {
  
        let dateFormatter=NSDateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        
        let date=dateFormatter.stringFromDate(NSDate(timeIntervalSinceNow:time))
        
        var tempdict:Dictionary<String,NSObject>=Dictionary<String,NSObject>()
        tempdict["URL"]=cacheurl
        tempdict["DATA"]=cacheData
        tempdict["outTime"]=date
 
        dataDictCache[cacheurl]=tempdict
        writeToSandBox()
    }
    
    func searchData(url:String)->Dictionary<String,NSObject>?
    {
        var tempdict:Dictionary<String,NSObject>?
        tempdict=(dataDictCache[url]) as? Dictionary<String,NSObject>
        
        if((tempdict) != nil)
        {
            if(tempdict?.count==0)
            {
                return nil
            }
            
            let dateFormatter=NSDateFormatter()
            dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
            
            let date:String=tempdict!["outTime"] as! String
            
            switch(NSDate().compare(dateFormatter.dateFromString(date)!))
            {
            case NSComparisonResult.OrderedSame:
                break
            case NSComparisonResult.OrderedAscending:
                return (tempdict!["DATA"]! as! Dictionary)
                //break
            case NSComparisonResult.OrderedDescending:
                dataDictCache.removeValueForKey(url)
                break
            }
        }
        
        return nil
    }
    
    func writeToSandBox()->Void
    {
        let temp:NSDictionary=NSDictionary(dictionary: dataDictCache)
        let temp1:NSDictionary=NSDictionary(dictionary: Cache)

        
        let userDefaults:NSUserDefaults=NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey("UrlDataCache")
        userDefaults.setObject(temp, forKey: "UrlDataCache")
        userDefaults.removeObjectForKey("Cache")
        userDefaults.setObject(temp1, forKey: "Cache")

        userDefaults.synchronize()
    }
    
    func readUrlDataCacheFromSandBox()->Void
    {
        let userDefaults:NSUserDefaults=NSUserDefaults.standardUserDefaults()
        if(userDefaults.dictionaryForKey("UrlDataCache") != nil)
        {
            dataDictCache=(userDefaults.dictionaryForKey("UrlDataCache")) as! Dictionary<String,NSObject>
            
            for (key,value) in dataDictCache
            {
                
                var item=value as! Dictionary<String,NSObject>
                item=item["DATA"] as! Dictionary<String,NSObject>
                if(item["DownloadEndDate"] == nil)
                {
                    dataDictCache.removeValueForKey(key)
                }
            }
        }
 
    }
    
  
    
}
