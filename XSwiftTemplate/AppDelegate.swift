//
//  AppDelegate.swift
//  OA
//
//  Created by X on 15/4/27.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

typealias anyblock = ()->Void
var backgroundSessionCompletionHandler:anyblock?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate{

    var window: UIWindow?
    var backgroundUpdateTask:UIBackgroundTaskIdentifier?
    var mapManager:BMKMapManager?
    
    func onMessageReceived(notification:NSNotification)
    {
        print("Message is received !!!!!")
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onMessageReceived(_:)), name: "CCPDidReceiveMessageNotification", object: nil)
        
        DataCache.Share
        Preloading.Share.getAdvImage()
        
        AdvImage?.clipsToBounds = true
        AdvImage?.layer.masksToBounds = true
        AdvImage?.contentMode = .ScaleAspectFill
        
//        //UMessage.startWithAppkey(UMAppKey, launchOptions: launchOptions)
//        
//        //UMessage.setLogEnabled(true)
//        //UMessage.setAutoAlert(false)
//        //UMessage.setBadgeClear(false)
        
        initCloudPush()
        
        let cacheSizeMemory = 64*1024*1024; // 64MB
        let cacheSizeDisk = 256*1024*1024; // 256MB
        
        let sharedCache = NSURLCache.init(memoryCapacity: cacheSizeMemory, diskCapacity: cacheSizeDisk, diskPath: "nsurlcache")
        
        NSURLCache.setSharedURLCache(sharedCache)
        

        if("appRunTimes".UserDefaultsValue() == nil)
        {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "showImage")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "ReceiveNotice")
            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "appRunTimes")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            RegistPushNotice()
            
            DataCache.Share.welcom.show = true
            
            let w = Int(sheight * UIScreen.mainScreen().scale)
            
            DataCache.Share.welcom.info = ["\(w)_1.jpg","\(w)_2.jpg","\(w)_3.jpg"]
            
            DataCache.Share.welcom.save()
            
        }
        else
        {
            let times:Int = "appRunTimes".UserDefaultsValue() as! Int
            NSUserDefaults.standardUserDefaults().setInteger(times+1, forKey: "appRunTimes")
            NSUserDefaults.standardUserDefaults().synchronize()

            if(!DataCache.Share.welcom.show)
            {
                Preloading.Share.getWelcomePic()
            }
            
            if("ReceiveNotice".UserDefaultsValue() as! Bool)
            {
                RegistPushNotice()
            }
  
        }
    
       
        mapManager=BMKMapManager()
        let res:Bool=mapManager!.start("wsMGrlpr7TSyESGHSutdPoK8", generalDelegate: nil)
        if(res)
        {
            //print("百度地图启动成功!!!")
        }
        else
        {
            //print("manager start failed!!!")
        }
        
        
        ShareSDK.registerApp("ccae6a09a59e")
 
        self.initShareSDK()

        XVerifyButton.Share().initSelf()
        
        DataCache.Share.readUrlDataCacheFromSandBox()
        
        Preloading.Share.getQuanCategory()
        Preloading.Share.getOAUser()
        
        application.setStatusBarHidden(true, withAnimation: .None)
        application.statusBarStyle = UIStatusBarStyle.LightContent

        position.Share().getLocation()
        position.Share().stop()
        
        let str="1\r\n2\r\n3\r\n4"
        let label=UILabel()
        label.frame = CGRectMake(0, 0, swidth-62, 0)
        label.font = UIFont.systemFontOfSize(16.0)
        
        let attributedString1:NSMutableAttributedString = NSMutableAttributedString(string: str)
        let paragraphStyle1:NSMutableParagraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle1.lineSpacing = 2.5
        
        attributedString1.addAttributes([NSParagraphStyleAttributeName:paragraphStyle1,NSKernAttributeName:0.0], range: NSMakeRange(0, (str as NSString).length))
        
        label.numberOfLines = 4
        label.attributedText = attributedString1
        label.sizeToFit()
        
        ContentMaxHeight = label.frame.size.height
        
        CloudPushSDK.handleLaunching(launchOptions)
        
        return true
    }
    
    func initCloudPush()
    {
        CloudPushSDK.asyncInit(AliAppKey, appSecret: AliAppMSecret) { (res) in
            
            if (res.success) {
                print("Push SDK init success, deviceId: \(CloudPushSDK.getDeviceId())")
            } else {
                print("Push SDK init failed, error: \(res.error)")
            }
        }
        
        CloudPushSDK.turnOnDebug()
    }
    
    func initShareSDK()
    {
 
        ShareSDK.connectQZoneWithAppKey(kQQ_Share_AppKey, appSecret: kQQ_Share_AppSecret)
        ShareSDK.connectQZoneWithAppKey(kQQ_Share_AppKey, appSecret: kQQ_Share_AppSecret, qqApiInterfaceCls: QQApiInterface.self, tencentOAuthCls: TencentOAuth.self)
        
        ShareSDK.connectQQWithAppId(kQQ_Share_AppKey, qqApiCls: QQApiInterface.self)
        ShareSDK.connectQQWithQZoneAppKey(kQQ_Share_AppKey, qqApiInterfaceCls: QQApiInterface.self, tencentOAuthCls: TencentOAuth.self)
        
        ShareSDK.connectTencentWeiboWithAppKey(kQQ_Share_AppKey, appSecret: kQQ_Share_AppSecret, redirectUri: "")
        ShareSDK.connectTencentWeiboWithAppKey(kQQ_Share_AppKey, appSecret: kQQ_Share_AppSecret, redirectUri: "", wbApiCls: nil)
        
        ShareSDK.connectSinaWeiboWithAppKey(kSinaWeiBo_Share_AppKey, appSecret: kSinaWeiBo_Share_AppSecret, redirectUri: kSinaWeiBo_RedirectUri)
        ShareSDK.connectSinaWeiboWithAppKey(kSinaWeiBo_Share_AppKey, appSecret: kSinaWeiBo_Share_AppSecret, redirectUri: kSinaWeiBo_RedirectUri, weiboSDKCls: WeiboSDK.self)
        
        //ShareSDK.connectWeChatWithAppId(kWX_Share_AppKey, wechatCls: WXApi.self)
        ShareSDK.connectWeChatWithAppId(kWX_Share_AppKey, appSecret: kWX_Share_AppSecret, wechatCls: WXApi.self)
        
        //ShareSDK.connectWeChatTimelineWithAppId(kWX_Share_AppKey, wechatCls: WXApi.self)
        ShareSDK.connectWeChatTimelineWithAppId(kWX_Share_AppKey, appSecret: kWX_Share_AppSecret, wechatCls: WXApi.self)
        
    }
    
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        CloudPushSDK.registerDevice(deviceToken) { (res) in
            
            if (res.success) {
                print("Register deviceToken success.")
            } else {
                print("Register deviceToken failed, error: \(res.error)")
            }
            
        }
        
        var str:NSString=deviceToken.description
        str=str.stringByReplacingOccurrencesOfString("<", withString: "")
        str=str.stringByReplacingOccurrencesOfString(">", withString: "")
        str=str.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        DataCache.Share.deviceToken=(str as String).md5
        
        ////UMessage.registerDeviceToken(deviceToken)
    }
    

    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        CloudPushSDK.handleReceiveRemoteNotification(userInfo)
        ////UMessage.didReceiveRemoteNotification(userInfo)
        
        print("userInfo 000: \(userInfo)")
        
        Preloading.Share.getMessage(Uid, username: Uname)
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        ////UMessage.didReceiveRemoteNotification(userInfo)
        
        print("userInfo 111: \(userInfo)")
        
        Preloading.Share.getMessage(Uid, username: Uname)
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("didFailToRegisterForRemoteNotificationsWithError error: \(error)")
    }
    
    func applicationWillResignActive(application: UIApplication) {
        
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        
        self.beingBackgroundUpdateTask()
        DataCache.Share.writeToSandBox()
        //print("后台运行中")
    }
    
    

    func applicationWillEnterForeground(application: UIApplication) {
       
        print("applicationWillEnterForeground !!!!")
        Preloading.Share.getMessage(Uid, username: Uname)
    }
  

    func applicationDidBecomeActive(application: UIApplication) {
        
        print("applicationDidBecomeActive !!!!")
        
        //Preloading.Share.getMessage(Uid, username: Uname)
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        return ShareSDK.handleOpenURL(url, wxDelegate: self)
        
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        return ShareSDK.handleOpenURL(url, sourceApplication: sourceApplication, annotation: annotation, wxDelegate: self)
    }
    
    func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
        
        backgroundSessionCompletionHandler = completionHandler
        
    }
    

    func  beingBackgroundUpdateTask()
    {
        backgroundUpdateTask=UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
            self.endBackgroundUpdateTask()
        })
    }
    
    func endBackgroundUpdateTask()
    {
        UIApplication.sharedApplication().endBackgroundTask(self.backgroundUpdateTask!)
        self.backgroundUpdateTask = UIBackgroundTaskInvalid
    }

    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

