//
//  pchHeader.swift
//  swiftTest
//
//  Created by X on 15/3/3.
//  Copyright (c) 2015年 swiftTest. All rights reserved.
//

import UIKit
import ImageIO

//开发人员 主要用于分故事板

enum Teamer : String{
    case xpf="main"
    case zlf="zlf"
    case cwb="cwb"
}

enum NoticeWord : String{
    
    case UpDateFriendCell="UpDateFriendCell"
    case FriendPostSuccess="FriendPostSuccess"
    case LoginSuccess="LoginSuccess"
    case LogoutSuccess="LogoutSuccess"
    case UpdateUserSuccess="UpdateUserSuccess"
    case CardChanged="CardChanged"
    case MsgChange="MsgChange"
    
}

typealias AnyBlock = (Any?)->Void
typealias XNoBlock = ()->Void

let screenScale=UIScreen.mainScreen().scale
let swidth=UIScreen.mainScreen().bounds.size.width
let sheight=UIScreen.mainScreen().bounds.size.height

let IOS_Version=((UIDevice.currentDevice().systemVersion) as NSString).doubleValue

var TempPath:String
{
    let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
    
    let cache=(paths[0] as NSString).stringByAppendingPathComponent("XCache")
    
    if(!cache.fileExistsInPath())
    {
        try! NSFileManager.defaultManager().createDirectoryAtPath(cache, withIntermediateDirectories: true, attributes: nil)
    }
    
    return cache
}

let yearSecond=60*60*24*30*12
let PI:CGFloat=3.14159265358979323846
let HttpPoolCount:Int=20
let picOutTime=864000

let WhiteDefaultIMG = UIColor.whiteColor().image

let UMAppKey:String="5693535e67e58e4b8e002114"
let UMAppMSecret:String="54cgb77veilksfrwqsq4pwj6zgv1p88z"

let board=UIStoryboard(name: "main", bundle: nil)

let jumpAnim:JumpAnimator=JumpAnimator(type: AnimatorType.Default)

var topHeight:CGFloat=0.0

let APPBlueColor:UIColor = "21adfd".color!
let APPBGColor:UIColor = "F3F5F7".color!
let PageBGColor = "f8f8f8".color!
let APPBlackColor = "333333".color!
let APPMiddleColor = "666666".color!
let APPGrayColor = "999999".color!

let grayBGC:UIColor = "#f6f6f6".color!
let borderBGC:UIColor = "#ebe9e9".color!
let blueTXT:UIColor = "#1facfc".color!
let lightGrayTXT:UIColor = "#cccccc".color!
let darkGrayTXT:UIColor = "#797979".color!
let titleTXT:UIColor = "#333333".color!
let blackTXT:UIColor="#232323".color!
let greenBGC:UIColor="#02cc95".color!
//let 腾讯蓝:UIColor = "#2b61c0".color!

enum 腾讯颜色 : String{
    
    case 图标蓝 = "#2b61c0"
    case 标题灰 = "#8e8e8e"
    case 标题黑 = "#141414"
    case 已读灰 = "#999999"
    case 未读灰 = "#74787b"
    case 昵称蓝 = "#2f66a8"
}


var serverPath="http://101.201.169.38/test"


func ShowMessage(str:String)
{
    UIApplication.sharedApplication().keyWindow?.addSubview(XMessage.Share())
    
    XMessage.Share().showMessage(str)
}

func GetPhoto(delegate:XPhotoDelegate?,vc:UIViewController,maxNum:UInt,block:AnyBlock?)
{
    XPhotoChoose.Share().vc = vc
    XPhotoChoose.Share().block = block
    XPhotoChoose.Share().delegate = delegate
    XPhotoChoose.Share().maxNum = maxNum
    UIApplication.sharedApplication().keyWindow?.addSubview(XPhotoChoose.Share())
}


func RemoveWaiting()
{
    XWaitingView.Share().removeFromSuperview()
}

func RegistUMessage()
{
    if #available(iOS 8.0, *) {
        let settings:UIUserNotificationSettings=UIUserNotificationSettings(forTypes: [.Badge,.Alert,.Sound], categories: nil)
    
        UMessage.registerRemoteNotificationAndUserNotificationSettings(settings)
        
    } else {
        
        UMessage.registerForRemoteNotificationTypes([.Badge,.Alert,.Sound])
    }

}

func SetUMessageTag()
{
    UMessage.removeAllTags({ (obj, remain, error) -> Void in
        
    })
    
    UMessage.addTag(DataCache.Share.oaUserModel.uid) { (response, remain, error) -> Void in
        
    }
    
    UMessage.addTag(DataCache.Share.oaUserModel.dwid) { (response, remain, error) -> Void in
    }
    
    UMessage.addTag(DataCache.Share.oaUserModel.bmid) { (response, remain, error) -> Void in
    }
    
    UMessage.addTag(DataCache.Share.oaUserModel.jgid) { (response, remain, error) -> Void in
    }
}

var ContentMaxHeight:CGFloat = 0.0

let APPURL="http://101.201.169.38/hfapi/"


let BaseHtml = "<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n" +
    "<head>\r\n" +
    "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />\r\n" +
    "<meta http-equiv=\"Cache-Control\" content=\"no-cache\" />\r\n" +
    "<meta content=\"telephone=no\" name=\"format-detection\" />\r\n" +
    "<meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0\">\r\n" +
    "<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />\r\n" +
    "<title>活动简介</title>\r\n" +
    "<style>\r\n" +
    "body {background-color: #ffffff}\r\n" +
    "table {border-right:1px dashed #D2D2D2;border-bottom:1px dashed #D2D2D2}\r\n" +
    "table td{border-left:1px dashed #D2D2D2;border-top:1px dashed #D2D2D2}\r\n" +
    "img {width:100%;height: auto}\r\n" +
    "</style>\r\n</head>\r\n<body>\r\n"+"[XHTMLX]"+"\r\n</body>\r\n</html>"

