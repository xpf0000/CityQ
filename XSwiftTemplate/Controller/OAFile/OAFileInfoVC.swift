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

class OAFileInfoVC: UIViewController,UIWebViewDelegate{
    
    var model:OAFileModel!
    var webView:UIWebView?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.navigationItem.hidesBackButton=true
        
        self.addBackButton()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = model.name
        
        self.view.backgroundColor=UIColor.whiteColor()
        
        self.view.showWaiting()
        
        let savePath = (localPath as NSString).stringByAppendingPathComponent(model.url.md5+"."+model.url.fileType)

        if(savePath.fileExistsInPath())
        {
            self.showView(savePath)
            return
        }
        else
        {
            RemoveWaiting()
            ShowMessage("本地文档不存在,请先下载文档")
        }
        
        
    }
    
    func showView(path:String)
    {

        let url=NSURL.fileURLWithPath(path)
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
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
        RemoveWaiting()
        
        let alert=XAlertView(msg: "加载失败,请检查文件是否存在", flag: -4)
        self.view.addSubview(alert)
    }
    
    deinit
    {
        webView!.stopLoading()
        webView!.delegate=nil
        webView=nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}