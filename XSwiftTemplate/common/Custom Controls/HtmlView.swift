//
//  HtmlView.swift
//  chengshi
//
//  Created by X on 15/11/21.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//
//  js和原生交互类   js适用于UIWebView WKWebView Android  js代码:
//function sendMessage(str)
//    {
//        try    {
//            window.webkit.messageHandlers.JSHandle.postMessage(JSON.stringify({'msg':str}));
//        }
//        catch  (e)
//        {
//            try
//                {
//                    APP.jsMessage(JSON.stringify({'msg':str}));
//            }
//            catch(e)
//            {
//                window.android.runAndroidMethod(JSON.stringify({'msg':str}));
//            }
//            
//        }
//        
//}
//
//
//
//

import UIKit
import WebKit
import JavaScriptCore

class JSHandle:NSObject,XJSExports
{
    dynamic var msg:String = ""
    
    @objc static func jsMessage(message: String) {
        
        Share().msg = message
        
    }
    
    override init()
    {
        
    }
    
    class func Share() ->JSHandle! {
        
        struct Once {
            static var token:dispatch_once_t = 0
            static var dataCenterObj:JSHandle! = nil
        }
        dispatch_once(&Once.token, {
            Once.dataCenterObj = JSHandle.init()
        })
        return Once.dataCenterObj
    }

}



@objc protocol XJSExports : JSExport {
    var msg: String { get set }
    static func jsMessage(message: String) -> Void
}

//typealias AnyBlock = (Any?)->Void

class HtmlView: UIView,UIWebViewDelegate ,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler{

    var webView:UIView?
    var waiting:XWaitingView=XWaitingView(msg: "加载中...", flag: 0)
    var url=""
    var html:String=""
    var block:AnyBlock?
    weak var context:JSContext?
    
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        if(newSuperview == nil)
        {
            if #available(iOS 8.0, *) {
                (webView as! WKWebView).configuration.userContentController.removeScriptMessageHandlerForName("JSHandle")
            }

        }
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if(keyPath == "msg")
        {
            
            let json=JSHandle.Share().msg
            let data=json.dataUsingEncoding(NSUTF8StringEncoding)
            
            do
            {
                let dic:Dictionary<String,AnyObject>? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? Dictionary<String,AnyObject>
                
                if(dic != nil)
                {
                    self.block?(dic)
                }
                
            }
            catch
            {
                self.block?(JSHandle.Share().msg)
            }
            
            
        }
    }
    
    func show()
    {
        if(webView == nil)
        {
            return
        }
        
        self.viewController?.view.addSubview(waiting)
        
        if #available(iOS 8.0, *) {
            
            if(self.url != "")
            {
                (webView as! WKWebView).loadRequest(url.urlRequest!)
            }
            else if(self.html != "")
            {
                (webView as! WKWebView).loadHTMLString(self.html, baseURL: nil)
            }
            
            
        } else {
            
            if(self.url != "")
            {
                (webView as! UIWebView).loadRequest(url.urlRequest!)
            }
            else if(self.html != "")
            {
                (webView as! UIWebView).loadHTMLString(self.html, baseURL: nil)
            }
        }
    }
    
    func initSelf()
    {
        JSHandle.Share().addObserver(self, forKeyPath: "msg", options: .New, context: nil)
        
        if #available(iOS 8.0, *) {
            
            let config = WKWebViewConfiguration()
            let scriptHandle = WKUserContentController()
            scriptHandle.addScriptMessageHandler(self, name: "JSHandle")
            
            let per = WKPreferences()
            per.javaScriptCanOpenWindowsAutomatically = true
            per.javaScriptEnabled = true
            config.preferences = per
            config.userContentController = scriptHandle

            webView = WKWebView(frame: CGRectZero, configuration: config)
            (webView as! WKWebView).UIDelegate=self
            (webView as! WKWebView).navigationDelegate=self
            webView?.frame=CGRectMake(0, 0, frame.size.width, frame.size.height)
            (webView as! WKWebView).scrollView.showsHorizontalScrollIndicator = false
            (webView as! WKWebView).scrollView.showsVerticalScrollIndicator = false
            
        } else {
            webView = UIWebView()
            webView?.frame=CGRectMake(0, 0, frame.size.width, frame.size.height)
            (webView as! UIWebView).delegate=self
            (webView as! UIWebView).scrollView.showsHorizontalScrollIndicator = false
            (webView as! UIWebView).scrollView.showsVerticalScrollIndicator = false
            
        }
        
        self.addSubview(webView!)
        
        webView!.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(0.0)
            make.bottom.equalTo(0.0)
            make.leading.equalTo(0.0)
            make.trailing.equalTo(0.0)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initSelf()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initSelf()
        
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        waiting.removeFromSuperview()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        waiting.removeFromSuperview()
        
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "WebKitCacheModelPreferenceKey")
        NSUserDefaults.standardUserDefaults().synchronize()
    context=webView.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as? JSContext

        context?.setObject(JSHandle.self, forKeyedSubscript: "APP")
        
        if(self.block != nil)
        {
            self.block!(context)
        }
  
    }
    
    @available(iOS 8.0, *)
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        
        waiting.removeFromSuperview()
    }
    
    @available(iOS 8.0, *)
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        waiting.removeFromSuperview()
        
        if(self.block != nil)
        {
            self.block!(0)
        }
        
        
    }
    
    
    
    @available(iOS 8.0, *)
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        //waiting.removeFromSuperview()
    }
    
    @available(iOS 8.0, *)
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        let url = "\(navigationAction.request.URL!)"

        if(url.has("http://101.201.169.38/city/news_info.php?id="))
        {
            if(url.has("&type="))
            {
                decisionHandler(.Allow)
            }
            else
            {
                decisionHandler(.Cancel)
                
                let id:String = url.replace("http://101.201.169.38/city/news_info.php?id=", with: "")

                let model:NewsModel = NewsModel()
                model.id = id
                let vc:NewsInfoVC = "NewsInfoVC".VC as! NewsInfoVC
                vc.model = model
                vc.hidesBottomBarWhenPushed = true
                self.viewController?.navigationController?.pushViewController(vc, animated: true)
                
            }
            
            
            
        }
        else
        {
            decisionHandler(.Allow)
        }
        
    }
    
    
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
 
        return true
    }
    
    @available(iOS 8.0, *)
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        
        
        JSHandle.Share().msg = message.body as! String
        
    }
    
    deinit
    {
        
        self.block = nil
        self.context = nil
        JSHandle.Share().removeObserver(self, forKeyPath: "msg")
        if #available(iOS 8.0, *) {
            (webView as! WKWebView).configuration.userContentController.removeScriptMessageHandlerForName("JSHandle")
            (webView as! WKWebView).UIDelegate=nil
            (webView as! WKWebView).navigationDelegate=nil
            (webView as! WKWebView).stopLoading()
            webView=nil
            
        } else {
            (webView as! UIWebView).delegate=nil
            (webView as! UIWebView).loadHTMLString("", baseURL: nil)
            (webView as! UIWebView).stopLoading()
            webView=nil
        }
        
    }
    
   

}
