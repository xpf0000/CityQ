//
//  HtmlVC.swift
//  lejia
//
//  Created by X on 15/11/12.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit
import WebKit

let TmpDirURL = NSURL.fileURLWithPath(NSTemporaryDirectory()).URLByAppendingPathComponent("www")!.URLByAppendingPathComponent("citytest")

func CleanWebCache()
{
    /* 取得Library文件夹的位置*/
    let libraryDir=NSSearchPathForDirectoriesInDomains(.LibraryDirectory,.UserDomainMask, true)[0];
    /* 取得bundle id，用作文件拼接用*/
    
    print("libraryDir: \(libraryDir)")
    
    let bundleId  =  NSBundle.mainBundle().infoDictionary!["CFBundleIdentifier"]
    
    print("bundleId: \(bundleId)")
    /*
     * 拼接缓存地址，具体目录为App/Library/Caches/你的APPBundleID/fsCachedData
     */
    let webKitFolderInCachesfs = "\(libraryDir)/Caches/\(bundleId!)/fsCachedData"
    
    let cache = "\(libraryDir)/Caches/\(bundleId!)/WebKit"
    
    do
    {
        let _ = try? NSFileManager.defaultManager().removeItemAtPath(webKitFolderInCachesfs)
        let _ = try? NSFileManager.defaultManager().removeItemAtPath(cache)
    }
    
    
}



import JavaScriptCore

typealias JSHandleBlock = (String)->Void

class JSHandle:NSObject,XJSExports
{
    var block:JSHandleBlock?
    
    func onMsgChange(b:JSHandleBlock)
    {
        block = b
    }
    
    var msg:String = ""
    {
        didSet
        {
            block?(msg)
        }
    }
    
    func jsMessage(message: String) {
        
        msg = message
        
    }
    
    override init()
    {
        
    }
    
}



protocol XJSExports : JSExport {
    var msg: String { get set }
    func jsMessage(message: String) -> Void
}



class HtmlVC: UIViewController,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler{
    
    var webView:WKWebView?
    var url=""
    var html:String=""
    var baseUrl:NSURL?
    let handle = JSHandle()
    var isSub = false
    
    var inBoot = false
    
    var userinfo:SSDKUser?
    
    func msgChanged() {
        
        let json=handle.msg
        let data=json.dataUsingEncoding(NSUTF8StringEncoding)
        
        do
        {
            let dic:Dictionary<String,AnyObject>? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? Dictionary<String,AnyObject>
            
            if(dic != nil)
            {
                print("js msg000: \(dic)")
                handleMSG(dic)
            }
            
        }
        catch
        {
            print("js msg111: \(json)")
        }
    }
    
    func handleMSG(dic:Dictionary<String,AnyObject>?)
    {
        if let type = dic?["type"] as? String,let msg = dic?["msg"] as? String
        {
            if type == "0" && msg == "跳转签到规则"
            {
                let vc = HtmlVC()
                
                vc.baseUrl = TmpDirURL
                
                if let u = TmpDirURL?.URLByAppendingPathComponent("hfbguize.html")
                {
                    vc.url = "\(u)?id=6886"
                }
                
                vc.hidesBottomBarWhenPushed = true
                vc.title = "签到规则"
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            if type == "1" && msg == "兑换商品"
            {
                let vc = HtmlVC()
                
                vc.baseUrl = TmpDirURL
                
                if let u = TmpDirURL?.URLByAppendingPathComponent("duihuaninfo.html")
                {
                    vc.url = "\(u)?id=\(dic!["id"] as! String)&uid=\(Uid)&uname=\(Uname)"
                }
                
                vc.hidesBottomBarWhenPushed = true
                vc.title = "兑换详情"
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
            if type == "2" && msg == "开始兑换商品"
            {
                XWaitingView.show()
            }
            
            if type == "2" && msg == "商品兑换成功"
            {
                let id = dic!["id"] as! String
                XAlertView.show("兑换成功", block: {[weak self] in
                    
                    let vc = HtmlVC()
                    
                    vc.baseUrl = TmpDirURL
                    
                    if let u = TmpDirURL?.URLByAppendingPathComponent("duihuansuccess.html")
                    {
                        vc.url = "\(u)?id=\(id)"
                    }
                    
                    vc.hidesBottomBarWhenPushed = true
                    vc.title = "兑换详情"
                    
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                })
            }
            
            if type == "2" && msg == "商品兑换失败"
            {
                let info = dic!["info"] as! String
                XAlertView.show(info, block: nil)
            }
            
            
            if type == "3" && msg == "跳转怀府币商城"
            {
                let vc = "JifenCenterMainVC".VC("Jifen")
                
                vc.hidesBottomBarWhenPushed = true
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            if type == "4" && msg == "积分兑换"
            {
                XWaitingView.show()
            }
            
            if type == "4" && msg == "积分兑换成功"
            {
                XWaitingView.hide()
                XAlertView.show("积分兑换成功", block: {
                    [weak self] in
                    
                    let vc = HtmlVC()
                    
                    vc.baseUrl = TmpDirURL
                    
                    if let u = TmpDirURL?.URLByAppendingPathComponent("dhhfbsuccess.html")
                    {
                        let hfb = dic!["info"]!["hfb"] as! Int
                        let jifen = dic!["info"]!["jifen"]! as! Int
                        let sname = dic!["info"]!["sname"]! as! String
                        let time = dic!["info"]!["create_time"]! as! String
         
                        vc.url = "\(u)?hfb=\(hfb)&jifen=\(jifen)&sname=\(sname)&time=\(time)"
                    }
                    
                    vc.hidesBottomBarWhenPushed = true
                    vc.title = "兑换详情"
                    
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                })
                
                
            }
            
            if type == "4" && msg == "积分兑换失败"
            {
                XWaitingView.hide()
                XAlertView.show(dic!["info"] as! String, block: nil)
            }
            
            if type == "5" && msg == "跳转注册页面"
            {
                let bindtype = dic!["bindtype"] as! String
                var type = ""
                switch bindtype {
                case "新浪微博":
                    type = "1"
                case "微信":
                    type = "2"
                case "QQ":
                    type = "3"
                default:
                    ""
                }

                
                let vc:AuthBandPhoneVC = "AuthBandPhoneVC".VC("User") as! AuthBandPhoneVC
                vc.userinfo = userinfo
                vc.type = type
                
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
            if type == "5" && msg == "跳转绑定现有帐号页面"
            {
                
                let openid = dic!["openid"] as! String
                let bindtype = dic!["bindtype"] as! String
                var type = ""
                switch bindtype {
                case "新浪微博":
                    type = "1"
                case "微信":
                    type = "2"
                case "QQ":
                    type = "3"
                default:
                    ""
                }
                
                let vc = HtmlVC()
                
                vc.baseUrl = TmpDirURL
                
                if let u = TmpDirURL?.URLByAppendingPathComponent("loginBind.html")
                {
                    vc.url = "\(u)?openid=\(openid)&type=\(type)"
                }
                
                vc.hidesBottomBarWhenPushed = true
                vc.title = "登录绑定"
                
                self.navigationController?.pushViewController(vc, animated: true)
                
                
            }
            
             if type == "6" && msg == "跳转找回密码页面"
             {
                let vc = "FindBackPassVC".VC("User")
                
                vc.hidesBottomBarWhenPushed = true
                
                self.navigationController?.pushViewController(vc, animated: true)

            }
            
            
            if type == "6" && msg == "绑定登录"
            {
                
                XWaitingView.show()
                
                let account = dic!["account"] as! String
                let pass = dic!["pass"] as! String
                let openid = dic!["openid"] as! String
                let type = dic!["bindtype"] as! String
                
                let url=APPURL+"Public/Found/?service=User.openBD"
                let body="openid="+openid+"&type="+type+"&mobile="+account+"&password="+pass
                
                print("body: \(body)")
                
                XHttpPool.requestJson(url, body: body, method: .POST, block: { (res) in
                    
                    XWaitingView.hide()
                    print("res: \(res)")
                    
                    if let code = res?["data"]["code"].int
                    {
                        if code == 0
                        {
                            
                            DataCache.Share.userModel = UserModel.parse(json: res!["data"]["info"][0], replace: nil)
                            
                            DataCache.Share.userModel.save()
                            
                            DataCache.Share.userModel.registNotice()
                            DataCache.Share.userModel.getHFB()
                            NoticeWord.LoginSuccess.rawValue.postNotice()
                            
                            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                                
                                
                            })
                            
                            return
                            
                        }
                    }
                    
                    var msg = "绑定失败"
                    
                    if let str = res?["data"]["msg"].string
                    {
                            msg = str
                    }
                    
                    ShowMessage(msg)
                    
                    
                })
     
                
            }



            
            
            
        }
    }
    
    func show()
    {
        if(webView == nil)
        {
            return
        }
        
        if(self.url != "")
        {
            if let u = url.urlRequest
            {
                webView?.loadRequest(u)
            }
            
        }
        else if(self.html != "")
        {
            webView?.loadHTMLString(self.html, baseURL: baseUrl)
        }
    }
    
    func gotoBack()
    {
        RemoveWaiting()
        
        if isSub
        {
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        if webView?.canGoBack == true
        {
            webView?.goBack()
        }
    }
    
    func reload()
    {
        //CleanWebCache()
        
        if let currentURL = self.webView?.URL {
            let request = NSURLRequest(URL: currentURL)
            self.webView?.loadRequest(request)
        }
        else
        {
            webView?.loadRequest(url.urlRequest!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.view.backgroundColor = UIColor.whiteColor()
  
        handle.onMsgChange { [weak self](msg) in
            
            self?.msgChanged()
            
        }
        
        let config = WKWebViewConfiguration()
        let scriptHandle = WKUserContentController()
        scriptHandle.addScriptMessageHandler(self, name: "JSHandle")
        
        let per = WKPreferences()
        per.javaScriptCanOpenWindowsAutomatically = true
        per.javaScriptEnabled = true
        config.preferences = per
        config.userContentController = scriptHandle
        
        webView = WKWebView(frame: CGRectZero, configuration: config)
        
        webView?.UIDelegate=self
        webView?.navigationDelegate=self
        webView?.scrollView.showsHorizontalScrollIndicator = false
        webView?.scrollView.showsVerticalScrollIndicator = false
        
        
        webView?.opaque = false
        webView?.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(webView!)
        
        webView?.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(0.0)
            make.bottom.equalTo(0.0)
            make.trailing.equalTo(0.0)
            make.leading.equalTo(0.0)
        })
        
        
        self.show()
        
        webView?.scrollView.setHeaderRefresh({
            [weak self] in
            
            self?.reload()
            
            })
        
        
        
        
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        
        handle.msg = message.body as! String
        
    }
    
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        let url = "\(navigationAction.request.URL!)"
        
        if(url.has(WapUrl+"/city/news_info.php?id="))
        {
            if(url.has("&type="))
            {
                decisionHandler(.Allow)
            }
            else
            {
                decisionHandler(.Cancel)
                
                let id:String = url.replace(WapUrl+"/city/news_info.php?id=", with: "")
                
                let model:NewsModel = NewsModel()
                model.id = id
                let vc:NewsInfoVC = "NewsInfoVC".VC as! NewsInfoVC
                vc.model = model
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
            
            
        }
        else
        {
            if (!url.has("http://") && !url.has("https://") && !url.has(".html"))
            {
                UIApplication.sharedApplication().openURL(navigationAction.request.URL!)
                
                decisionHandler(WKNavigationActionPolicy.Cancel)
                
            } else {
                
                decisionHandler(WKNavigationActionPolicy.Allow)
                
            }

        }
 
        
    }
    
    @available(iOS 8.0, *)
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        
        RemoveWaiting()
        self.webView?.scrollView.endHeaderRefresh()
    }
    
    @available(iOS 8.0, *)
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        RemoveWaiting()
        self.webView?.scrollView.endHeaderRefresh()
        
    }
    
    
    
    func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: { (_) -> Void in
            
            completionHandler()
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func webView(webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: (Bool) -> Void) {
        
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: { (_) -> Void in
            // 点击完成后，可以做相应处理，最后再回调js端
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: { (_) -> Void in
            // 点击取消后，可以做相应处理，最后再回调js端
            completionHandler(false)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    
    func webView(webView: WKWebView, createWebViewWithConfiguration configuration: WKWebViewConfiguration, forNavigationAction navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        
        return nil
        
        
    }
    
    
    
    deinit
    {
        webView?.configuration.userContentController.removeScriptMessageHandlerForName("JSHandle")
        webView?.UIDelegate=nil
        webView?.navigationDelegate=nil
        webView?.stopLoading()
        webView=nil
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
}
