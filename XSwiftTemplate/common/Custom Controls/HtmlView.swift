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

//typealias AnyBlock = (Any?)->Void

class HtmlView: UIView,UIWebViewDelegate ,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler{

    var webView:UIView?
    var url=""
    var html:String=""
    var block:AnyBlock?
    let handle = JSHandle()
    weak var context:JSContext?
    
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        if(newSuperview == nil)
        {
            (webView as! WKWebView).configuration.userContentController.removeScriptMessageHandlerForName("JSHandle")

        }
        
    }
    
    func handleMSG() {
        
        let json = handle.msg
        
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
            self.block?(json)
        }
    
    }
    
    func show()
    {
        if(webView == nil)
        {
            return
        }
        
        XWaitingView.show()
    
        if(self.url != "")
        {
            (webView as! WKWebView).loadRequest(url.urlRequest!)
        }
        else if(self.html != "")
        {
            (webView as! WKWebView).loadHTMLString(self.html, baseURL: nil)
        }

    }
    
    func initSelf()
    {

        handle.onMsgChange {[weak self] (msg) in
            
            self?.handleMSG()
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
        (webView as! WKWebView).UIDelegate=self
        (webView as! WKWebView).navigationDelegate=self
        webView?.frame=CGRectMake(0, 0, frame.size.width, frame.size.height)
        (webView as! WKWebView).scrollView.showsHorizontalScrollIndicator = false
        (webView as! WKWebView).scrollView.showsVerticalScrollIndicator = false
        
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
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        XWaitingView.hide()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        XWaitingView.hide()
        
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
        
        XWaitingView.hide()
    }
    
    @available(iOS 8.0, *)
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        
        XWaitingView.hide()
        
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
        
        handle.msg = message.body as! String
        
    }
    
    deinit
    {
        
        self.block = nil
        self.context = nil
        
        (webView as! WKWebView).configuration.userContentController.removeScriptMessageHandlerForName("JSHandle")
        (webView as! WKWebView).UIDelegate=nil
        (webView as! WKWebView).navigationDelegate=nil
        (webView as! WKWebView).stopLoading()
        webView=nil
    }
    
   

}
