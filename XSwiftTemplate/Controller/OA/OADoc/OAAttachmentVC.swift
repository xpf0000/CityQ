//
//  OAAttachmentVC.swift
//  OA
//
//  Created by X on 15/5/20.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class OAAttachmentVC: UIViewController,UIWebViewDelegate{
    
    var model:OADocFileModel?
    var webView:UIWebView?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.title="附件详情"
        self.navigationItem.hidesBackButton=true
        
        self.addBackButton()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor=UIColor.whiteColor()
        
        self.view.showWaiting()
        
        var docs:NSString=(NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as Array)[0] as NSString
        
        docs=docs.stringByAppendingPathComponent(self.model!.url.md5+self.model!.url.fileName)
        
        let fileManager=NSFileManager()
        if(fileManager.fileExistsAtPath(docs as String))
        {
            self.showView()
            return
        }
        
        
        autoreleasepool { () -> () in
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                
                let request =  XHttpPool.getRequestWithUrl(self.model!.url, hasBody: false)
                
                if let data = request.synchRequest(self.model!.url, body: nil, method: .GET)
                {
                    data.writeToFile(docs as String, atomically: false)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.showView()
                        
                    })
                }
                
            })
            
        }
        
    }
    
    func showView()
    {
  
        var docs:NSString=(NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as Array)[0] as NSString
        docs=docs.stringByAppendingPathComponent(self.model!.url.md5+self.model!.url.fileName)
        
        let url=NSURL.fileURLWithPath(docs as String)
        let request=NSURLRequest(URL: url)
        webView = UIWebView()
        webView!.delegate=self
        webView!.frame=CGRectMake(0, 0, swidth, sheight-64)
        webView!.loadRequest(request)
        webView!.scrollView.showsHorizontalScrollIndicator=false;
        webView!.scrollView.showsVerticalScrollIndicator=false;
        webView?.sizeToFit()
        
        self.view.addSubview(webView!)
        self.view.sendSubviewToBack(webView!)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
     
        RemoveWaiting()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        
        RemoveWaiting()
        
        XAlertView.show("加载失败,请检查文件是否存在", block: nil)
    }
    
    deinit
    {
        webView!.delegate=nil
        webView=nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
