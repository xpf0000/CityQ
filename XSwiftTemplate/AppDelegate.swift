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
        if let message = notification.object as? CCPSysMessage
        {
            let title = String.init(data: message.title, encoding: NSUTF8StringEncoding)
            
            let body = String.init(data: message.body, encoding: NSUTF8StringEncoding)
            
            print("Receive message title: \(title) | content: \(body)")
            
            if let str = title
            {
                if str == "账号在其它设备已登陆"
                {
                    if Uid != ""
                    {
                       NSNotificationCenter.defaultCenter().postNotificationName("AccountLogout", object: nil)
                    }
   
                }
                else
                {
                    Preloading.Share.getMessage(Uid, username: Uname)
                }
            }
            
            
        }
        
        
    }
    
    func onLogin(notification:NSNotification)
    {
        Preloading.Share.getMessage(Uid, username: Uname)
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        initLocalHtml()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onMessageReceived(_:)), name: "CCPDidReceiveMessageNotification", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onLogin(_:)), name: NoticeWord.LoginSuccess.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onLogin(_:)), name: NoticeWord.UpdateUserSuccess.rawValue, object: nil)
        
        XHttpPool.Debug = true
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
    
        initCloudPush()
        
    
        UMAnalyticsConfig.sharedInstance().appKey = "5693535e67e58e4b8e002114"
        MobClick.setLogEnabled(false)
        MobClick.startWithConfigure(UMAnalyticsConfig.sharedInstance())
        
        
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
        
        let man = ALBBMANAnalytics.getInstance()
        man.turnOffCrashHandler()
        man.initWithAppKey(AliAppKey, secretKey: AliAppMSecret)
        
//        let crashhandle = CrashHandle()
//        man.setCrashCaughtListener(crashhandle)
        
        CloudPushSDK.asyncInit(AliAppKey, appSecret: AliAppMSecret) { (res) in
            
            if (res.success) {
                
                print("CloudPushSDK.asyncInit success !!!!!!!!!!!!")
                
            } else {
                
            }
        }
        
        //CloudPushSDK.turnOnDebug()
    }
    
    func initShareSDK()
    {
        
        
        ShareSDK.registerApp("ccae6a09a59e", activePlatforms:[
            SSDKPlatformType.TypeSinaWeibo.rawValue,
            SSDKPlatformType.TypeWechat.rawValue,
            SSDKPlatformType.TypeQQ.rawValue],
                             onImport: { (platform : SSDKPlatformType) in
                                switch platform
                                {
                                case SSDKPlatformType.TypeSinaWeibo:
                                    ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                                case SSDKPlatformType.TypeWechat:
                                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                                case SSDKPlatformType.TypeQQ:
                                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                                default:
                                    break
                                }
                                
        }) { (platform : SSDKPlatformType, appInfo : NSMutableDictionary?) in
            
            switch platform
            {
            case SSDKPlatformType.TypeSinaWeibo:
                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                
                appInfo?.SSDKSetupSinaWeiboByAppKey(kSinaWeiBo_Share_AppKey, appSecret: kSinaWeiBo_Share_AppSecret, redirectUri: kSinaWeiBo_RedirectUri, authType: SSDKAuthTypeBoth)
                
                
            case SSDKPlatformType.TypeWechat:
                //设置微信应用信息
                appInfo?.SSDKSetupWeChatByAppId(kWX_Share_AppKey, appSecret: kWX_Share_AppSecret)
                
                
            case SSDKPlatformType.TypeQQ:
                //设置QQ应用信息
                appInfo?.SSDKSetupQQByAppId(kQQ_Share_AppKey, appKey: kQQ_Share_AppSecret, authType: SSDKAuthTypeBoth)
                
            default:
                break
            }
            
        }
        
        
    }
    
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        CloudPushSDK.registerDevice(deviceToken) { (res) in
            
            if (res.success) {
                
            } else {
                
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

        //Preloading.Share.getMessage(Uid, username: Uname)
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        CloudPushSDK.handleReceiveRemoteNotification(userInfo)
        
        ////UMessage.didReceiveRemoteNotification(userInfo)
        

        //Preloading.Share.getMessage(Uid, username: Uname)
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {

    }
    
    func applicationWillResignActive(application: UIApplication) {
        
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        
        self.beingBackgroundUpdateTask()
        DataCache.Share.writeToSandBox()
        //print("后台运行中")
    }
    
    

    func applicationWillEnterForeground(application: UIApplication) {
       
        Preloading.Share.getMessage(Uid, username: Uname)
    }
  

    func applicationDidBecomeActive(application: UIApplication) {
        
        //print("applicationDidBecomeActive !!!!!!!!!!")
        
        //NSNotificationCenter.defaultCenter().postNotificationName("applicationDidBecomeActive", object: nil)
        
        Preloading.Share.CheckToken()
        
        //Preloading.Share.getMessage(Uid, username: Uname)
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        return true
        
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        
        if url.host == "safepay"
        {
            AlipaySDK.defaultService().processOrderWithPaymentResult(url, standbyCallback: { (res) in
                
                XWaitingView.hide()
                
                print("resultStatus: \(res?["resultStatus"])")
                
                
                if let resultStatus = res?["resultStatus"] as? String
                {
                    if resultStatus == "9000"
                    {
                        XAlertView.show("支付成功", block: {
                            NSNotificationCenter.defaultCenter().postNotificationName("PaySuccess", object: nil)
                        })
                        
                        return
                    }
                }
                
                let str = res?["memo"] as? String ?? "支付失败"
                
                XAlertView.show(str, block: nil)
                
                NSNotificationCenter.defaultCenter().postNotificationName("PayFail", object: nil)
                
                print("pay result11: \(res)")
                
            })
        }
        
 
        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        if url.host == "safepay"
        {
            AlipaySDK.defaultService().processOrderWithPaymentResult(url, standbyCallback: { (res) in
                
                print("pay result000: \(res)")
                
            })
        }

        return  true
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
    
    
    
    func initLocalHtml()
    {
        print("-----------")
        
        let fm = NSFileManager.defaultManager()
        let tmpDirURL = NSURL.fileURLWithPath(NSTemporaryDirectory()).URLByAppendingPathComponent("www")
        
        if let p = tmpDirURL?.path
        {
            if !fm.fileExistsAtPath(p)
            {
                do
                {
                    let _ = try? fm.createDirectoryAtURL(tmpDirURL!, withIntermediateDirectories: true, attributes: nil)
                    
                    let _ = try? SSZipArchive.unzipFileAtPath("citytest.zip".path, toDestination: p, overwrite: true, password: nil, delegate: nil)
                    
                    print("解压缩成功 !!!!!!!!!")
                }
                catch
                {
                    print("解压失败 !!!!!!!!!")
                    ShowMessage("存储空间不足,请清理后再次使用")
                }


            }
            else{
                do
                {
                   let _ = try? SSZipArchive.unzipFileAtPath("citytest.zip".path, toDestination: p, overwrite: true, password: nil, delegate: nil)
                    
                    print("解压缩成功 !!!!!!!!!")
                }
                catch
                {
                    print("解压失败 !!!!!!!!!")
                    ShowMessage("存储空间不足,请清理后再次使用")
                }
                
            }
            
            
        }
        
        
        
        
        
    }
    
    

    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

