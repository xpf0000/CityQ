//
//  HtmlVC.swift
//  lejia
//
//  Created by X on 15/11/12.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit
import WebKit

class HtmlVC: UIViewController,UIWebViewDelegate ,WKNavigationDelegate,WKUIDelegate{

    var webView:UIView?
    var waiting:XWaitingView=XWaitingView(msg: "加载中...", flag: 0)
    var url=""
    var html:String=""
    
    func getHtml(u:String)
    {
//        XHttpPool.requestJson(u, data: nil, method: .GET) { (o) -> Void in
//            
//            if(o?["data"].dictionaryValue.count > 0)
//            {
//                self.html = o!["data"]["info"][0]["content"].stringValue
//                self.handleHtml()
//                self.show()
//            }
//            
//            
//            
//        }
        
        XHttpPool.requestDict(u, body: nil, method: .GET) { (o) -> Void in
            
            self.html = o["HTML"] as! String
            
            self.handleHtml()
            
            self.show()
        }
        
    }
    
    func handleHtml()
    {
        self.html.selfReplace("<header>", with: "<!-- <header>")
        self.html.selfReplace("</header>", with: "</header> -->")
        self.html.selfReplace("<input hidden=\"\" id=\"hidden1\"/>", with: "<!-- <input hidden=\"\" id=\"hidden1\"/>")
        self.html.selfReplace("<input hidden=\"\" id=\"hidden2\"/>", with: "<input hidden=\"\" id=\"hidden2\"/> -->")
        
        self.html.selfReplace("<input hidden=\"\" id=\"hidden3\"/>", with: "<!-- <input hidden=\"\" id=\"hidden3\"/>")
        self.html.selfReplace("<input hidden=\"\" id=\"hidden4\"/>", with: "<input hidden=\"\" id=\"hidden4\"/> -->")
        
        self.html.selfReplace("<footer", with: "<!-- <footer")
        self.html.selfReplace("</footer>", with: "</footer> -->")
        
    }
    
    func show()
    {
        if(webView == nil)
        {
            return
        }
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        //self.handleHtml()
        
        if #available(iOS 8.0, *) {
            webView = WKWebView()
            (webView as! WKWebView).UIDelegate=self
            (webView as! WKWebView).navigationDelegate=self
            webView?.frame=CGRectMake(0, 0, swidth, sheight)
            (webView as! WKWebView).scrollView.showsHorizontalScrollIndicator = false
            (webView as! WKWebView).scrollView.showsVerticalScrollIndicator = false
            
            
        } else {
            webView = UIWebView()
            webView?.frame=CGRectMake(0, 0, swidth, sheight)
            (webView as! UIWebView).delegate=self
            (webView as! UIWebView).scrollView.showsHorizontalScrollIndicator = false
            (webView as! UIWebView).scrollView.showsVerticalScrollIndicator = false
        }
        
        self.view.addSubview(webView!)
        self.view.addSubview(waiting)
        
        self.show()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        waiting.removeFromSuperview()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        waiting.removeFromSuperview()
    }
    
    @available(iOS 8.0, *)
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        
        waiting.removeFromSuperview()
    }
    
    @available(iOS 8.0, *)
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        waiting.removeFromSuperview()
        
    }


    deinit
    {
        if #available(iOS 8.0, *) {
            (webView as! WKWebView).UIDelegate=nil
            (webView as! WKWebView).navigationDelegate=nil
            (webView as! WKWebView).stopLoading()
            webView=nil
            
        } else {
            (webView as! UIWebView).delegate=nil
            (webView as! UIWebView).stopLoading()
            webView=nil
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
