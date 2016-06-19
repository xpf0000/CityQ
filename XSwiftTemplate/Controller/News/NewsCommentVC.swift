//
//  NewsCommentVC.swift
//  chengshi
//
//  Created by X on 15/12/5.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

class NewsCommentVC: UITableViewController {

    lazy var model:NewsModel = NewsModel()
    @IBOutlet var table: UITableView!
    let html = HtmlView(frame: CGRectMake(0, 0, swidth, sheight-64))
    let httpHandle:XHttpHandle = XHttpHandle()
    lazy var heightArr:Dictionary<Int,CGFloat>=[:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.title = "新闻评论"

        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        self.table.tableFooterView=view1
        self.table.tableHeaderView=view1
        
        
        html.backgroundColor = "#f0f0f0".color
        self.view.addSubview(html)

        
        let url="http://101.201.169.38/city/news_Comment.php?id=\(self.model.id)&type=1"
        
        html.url = url
        html.show()
        
        html.block =
            {
                [weak self]
                (o)->Void in
                if(self == nil)
                {
                    return
                }
                
                if(o is Int)
                {
                    if((o as! Int) == 0)
                    {
                        
                        if #available(iOS 8.0, *) {
                            (self!.html.webView as! WKWebView).scrollView.setFooterRefresh({ () -> Void in

                                (self!.html.webView as! WKWebView).evaluateJavaScript("getComment()", completionHandler: { (obj, err) -> Void in

                                    
                                })
                                
                            })
                        }
                        
                    }
                }
                
                if(o is Dictionary<String,AnyObject>)
                {
                    let dic:Dictionary<String,AnyObject> = o as! Dictionary<String,AnyObject>
                    
                    if(dic["msg"] != nil)
                    {
                        let msg = dic["msg"] as! String
                        
                        if #available(iOS 8.0, *) {
                            
                            if(msg == "End")
                            {
                                (self!.html.webView as! WKWebView).scrollView.LoadedAll()
                                
                                (self!.html.webView as! WKWebView).scrollView.endFooterRefresh()
                            }
                            else if(msg == "RfreshSuccess")
                            {
                                (self!.html.webView as! WKWebView).scrollView.endFooterRefresh()
                            }

                        }
                        else
                        {
                            if(msg == "End")
                            {
                                (self!.html.webView as! UIWebView).scrollView.LoadedAll()
                                
                                (self!.html.webView as! UIWebView).scrollView.endFooterRefresh()
                            }
                            else if(msg == "RfreshSuccess")
                            {
                                (self!.html.webView as! UIWebView).scrollView.endFooterRefresh()
                            }

                        }
                        
                    }
                    
                }
                
                if(o is JSContext)
                {
                    let context = o as! JSContext
                    (self!.html.webView as! UIWebView).scrollView.setFooterRefresh({ () -> Void in
                        
                        context.evaluateScript("getComment()")
                        
                    })
                    
                }
                
        
        }

        
        
        
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.separatorInset=UIEdgeInsetsZero
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                cell.layoutMargins=UIEdgeInsetsZero
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        self.table.separatorInset=UIEdgeInsetsZero
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                self.table.layoutMargins=UIEdgeInsetsZero
            } else {
                // Fallback on earlier versions
            }
        }
    }

    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return httpHandle.listArr.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(self.httpHandle.listArr.count == 0)
        {
            return 0
        }
        
        if(heightArr[indexPath.row] == nil)
        {
            
            for i in self.heightArr.count..<self.httpHandle.listArr.count
            {
                let model:CommentModel = httpHandle.listArr[i] as! CommentModel
                
                let label=UILabel()
                label.font = UIFont(name: "HYQiHei", size: 17.0)
                label.frame = CGRectMake(0, 0, swidth-65, 1)
                label.numberOfLines = 0
                label.text = model.content
                label.sizeToFit()
                
                heightArr[i] = (label.frame.height+70)
            }
            
            return heightArr[indexPath.row]!
        }
        else
        {
            return heightArr[indexPath.row]!
        }

        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:NewsCommentCell = tableView.dequeueReusableCellWithIdentifier("NewsCommentCell") as! NewsCommentCell
        
        cell.model = httpHandle.listArr[indexPath.row] as! CommentModel
        
        cell.show()
        
        return cell
        
    }
    
    deinit
    {
        //print(NSStringFromClass(self.dynamicType)+" "+__FUNCTION__+" !!!!!!!!!")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
