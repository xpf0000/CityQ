//
//  Preloading.swift
//  swiftTest
//
//  Created by X on 15/3/10.
//  Copyright (c) 2015年 swiftTest. All rights reserved.
//

import Foundation

class Preloading: NSObject{
    
    var picCount=0
    var picArr:Array<String>=[]
    
    class func Share() ->Preloading! {
        
        struct Once {
            static var token:dispatch_once_t = 0
            static var dataCenterObj:Preloading! = nil
        }
        dispatch_once(&Once.token, {
            Once.dataCenterObj = Preloading()
        })
        return Once.dataCenterObj
    }
    
    func getWelcomePic()
    {
        
        let url=APPURL+"Public/Found/?service=News.getQidong"
        
        XHttpPool.requestJson(url, body: nil, method: .GET) { (o) -> Void in
            
//            if(o?["data"]["info"].arrayValue.count > 0)
//            {
//                var fileArr:Array<String> = []
//                var has=0
//                let count=o!["data"]["info"].arrayValue.count
//                for item in o!["data"]["info"].arrayValue
//                {
//                    let PicUrl=item["url"].stringValue
//                    DataCache.Share().welcom.info.append(PicUrl)
//                    let downLoad:CacheItem = HttpPool.Share().cacheItem(PicUrl)
//                    downLoad.block = {
//                        (o)->Void in
//                        if(o is String)
//                        {
//                            fileArr.append(PicUrl)
//                            if(fileArr.count == count)
//                            {
//                                DataCache.Share().welcom.show = true
//                                DataCache.Share().welcom.save()
//                            }
//                            
//                        }
//                        
//                    }
//                    
//                    var filePath:String?
//                    filePath=downLoad.download(PicUrl, showImage: true)
//                    if(filePath != nil)
//                    {
//                        has++
//                        fileArr.append(PicUrl)
//                        if(fileArr.count == count && has != count)
//                        {
//                            DataCache.Share().welcom.show = true
//                            DataCache.Share().welcom.save()
//                        }
//                        
//                    }
//                    
//                }
//            }
//            
        }
        
        
    }
    
    func getQuanCategory()
    {
        DataCache.Share().quanCategory.removeAll(keepCapacity: false)
        let url=APPURL+"Public/Found/?service=Quan.getCategory"
        
        XHttpPool.requestJsonAutoConnect(url, body: nil, method: .GET) { (o) -> Void in
            
            if(o?["data"].dictionaryValue.count > 0)
            {
                
                for item in o!["data"]["info"].arrayValue
                {
                    let model:CategoryModel = CategoryModel.parse(json: item, replace: nil)
                    DataCache.Share().quanCategory.append(model)
                    
                }
            }
            
        }

    }
    
    func getOAUser()
    {
        if(DataCache.Share().oaUserModel.uid == "")
        {
            return
        }
        
        let u=DataCache.Share().oaUserModel.username
        let p=DataCache.Share().oaUserModel.pass
        
        if(u == "" || p == "")
        {
            DataCache.Share().oaUserModel = OAUserModel()
            DataCache.Share().oaUserModel.save()
            UMessage.removeAllTags({ (obj, remain, error) -> Void in
                
            })
            return
        }
        
        let url="http://101.201.169.38/apioa/Public/OA/?service=User.login&username="+u+"&password="+p
        
        XHttpPool.requestJson(url, body: nil, method: .GET) {(o) -> Void in
            
            if(o?["data"]["info"].arrayValue.count>0 && o?["data"]["code"].intValue == 0)
            {
                DataCache.Share().oaUserModel = OAUserModel.parse(json: o!["data"]["info"][0], replace: nil)
                DataCache.Share().oaUserModel.pass = p
                DataCache.Share().oaUserModel.save()
                
                SetUMessageTag()

                return
            }
            
            DataCache.Share().oaUserModel = OAUserModel()
            DataCache.Share().oaUserModel.save()
            
            UMessage.removeAllTags({ (obj, remain, error) -> Void in
                
            })
        }
    }
    
    
    
    
    func dataToImage(data:NSData?,hash:Int)->UIImage?
    {
        var result:UIImage?
        
        if let d = data{
            
            let type = ImageTypeForData(d)
            
            if type == .GIF
            {
                result = UIImage(data: d)
                XImageGifPlayer(hash: hash, data: d, img: AdvImage!).rePlay()
            }
            else if type == .WEBP
            {
                //result = UIImage(webPData: d)
            }
            else
            {
                result = UIImage(data: d)
            }
            
        }
        
        return result
    }
    
    func getAdvImage()
    {
        let url = APPURL+"Public/Found/?service=News.getGuanggao&typeid=94"
        var image:UIImage?
        
        let path:NSString = NSString(string: XImageSavePath)
        
        XHttpPool.requestJsonAutoConnect(url, body: nil, method: .GET) {[weak self] (o) -> Void in
            
            if let str = o?["data"]["info"][0]["picurl"].string
            {
                let savePath = path.stringByAppendingPathComponent("\(str.hash)")
                
                if XImageUtil.FileManager.fileExistsAtPath(savePath)
                {
                    autoreleasepool {
                        
                        dispatch_async(IOQueue, { () -> Void in
                            
                            if let data =  NSData(contentsOfFile: savePath)
                            {
                                image = self?.dataToImage(data, hash: str.hash)
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                AdvImage?.image = image
                                AdvImage?.alpha = 0.0
                                
                                UIView.animateWithDuration(0.25, animations: { () -> Void in
                                    AdvImage?.alpha = 1.0
                                })
                                
                            })
                            
                        })
                        
                    }
                    
                    return
                }
                
                
                let downloader:XImageDownLoader = XImageUtil.Share.createTask(str)
                
                let complete:XImageCompleteBlock = {
                    [weak self](url,image,data)->Void in
                    if self == nil {return}
                    
                    AdvImage?.image = image
                    AdvImage?.alpha = 0.0
                    
                    UIView.animateWithDuration(0.25, animations: { () -> Void in
                        AdvImage?.alpha = 1.0
                    })
                    
                }
                
                let model = XImgCompleteModel()
                model.block = complete
                
                downloader.complete.append(model)
                downloader.createTask()
                downloader.startDownLoad()
                
            }
            
        }
    }
    

}

