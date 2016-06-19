//
//  HttpAnalysis.swift
//  chengshi
//
//  Created by X on 15/11/20.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class HttpAnalysis: NSObject {

    var autoReload=true
    var pageSize=20
    var page=1
    var end=false
    var url:String=""
    var pageStr=""
    var replace:Dictionary<String,String>?
    var modelClass:AnyClass!
    var block:AnyBlock?
    var afterBlock:AnyBlock?
    lazy var listArr:Array<AnyObject> = []
    lazy var keys:Array<String>=[]
    weak var scrollView:UIScrollView?
    weak var table:UITableView?
    weak var collection:UICollectionView?
    var running = false
    override init() {
        super.init()
    }
    
    init(url:String,table:UITableView,pageStr:String) {
        
        super.init()
        self.url=url
        self.table = table
        self.pageStr=pageStr
    }
    
    func reSet()
    {
        self.page=1
        self.end=false
    }
    
    func handle()
    {
        if(self.end || self.running)
        {
            return
        }
        
        self.running = true
        
        let url:String=self.url.replace(pageStr, with: "\(page)")
        
        XHttpPool.requestJson(url, body: nil, method: .GET) {[weak self] (o) -> Void in
            
            if(self == nil)
            {
                return
            }
            
            if(o?["data"].dictionaryValue.count > 0)
            {
                
                var temp:Array<AnyObject> = []
                
                var items=o
                
                for key in self!.keys
                {
                    items=items![key]
                }
                
                let info = items!.arrayValue
                if(info.count > 0)
                {
                    let elementModelType = self!.modelClass as! Reflect.Type
                    
                    for item in info
                    {
                         let elementModel = elementModelType.parse(json: item,replace: self!.replace)
                        
                        temp.append(elementModel)
                    }
                    
                    if(info.count < self!.pageSize)
                    {
                        self!.end = true
                    }
                }
                else
                {
                    self!.end = true
                }
                
                if(self!.page == 1)
                {
                    self!.listArr.removeAll(keepCapacity: false)
                }
                
                self!.listArr += temp
                
                self?.block?(nil)
                
                if(self!.autoReload)
                {
                    self!.table?.reloadData()
                    self!.collection?.reloadData()
                }
                
                self?.afterBlock?(nil)
                
                self!.page++

                if(self!.end)
                {
                    self!.table?.HasLoadAllDate()
                    self!.collection?.HasLoadAllDate()
                    self!.scrollView?.HasLoadAllDate()
                }
                self!.table?.endHeaderRefresh()
                self!.table?.endFooterRefresh()
                self!.table?.footRefreshShow()
                
                self!.collection?.endHeaderRefresh()
                self!.collection?.endFooterRefresh()
                self!.collection?.footRefreshShow()
                
                self!.scrollView?.endHeaderRefresh()
                self!.scrollView?.endFooterRefresh()
                self!.scrollView?.footRefreshShow()
                
            }
            else
            {
                self!.end = true
                self!.table?.footRefreshShow()
                self!.table?.HasLoadAllDate()
                self!.table?.endHeaderRefresh()
                self!.table?.endFooterRefresh()
                
                self!.collection?.footRefreshShow()
                self!.collection?.HasLoadAllDate()
                self!.collection?.endHeaderRefresh()
                self!.collection?.endFooterRefresh()
                
                self!.scrollView?.footRefreshShow()
                self!.scrollView?.HasLoadAllDate()
                self!.scrollView?.endHeaderRefresh()
                self!.scrollView?.endFooterRefresh()
                
                if(self!.page == 1)
                {
                    self!.listArr.removeAll(keepCapacity: false)
                    self!.table?.reloadData()
                    self!.collection?.reloadData()
                }
                
            }
          
            
            self?.running = false
            
        }
        
        
        
        
        
    }
    
    deinit
    {
        self.listArr.removeAll(keepCapacity: false)
        self.table = nil
        self.collection = nil
        self.scrollView = nil
    }
}
