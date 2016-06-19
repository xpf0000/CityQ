//
//  NewsIndexView.swift
//  chengshi
//
//  Created by X on 15/10/19.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class NewsIndexView: UITableView,UITableViewDelegate,UITableViewDataSource{

    var banner:XBanner = XBanner(frame: CGRectMake(0, 0, swidth, swidth * 433.0 / 750.0))
    
    var httpHandle:XHttpHandle=XHttpHandle()
    
    lazy var bannerArr:Array<XBannerModel>=[]
    
    var url = ""
    {
        didSet
        {
            httpHandle.url=url
            httpHandle.reSet()
            httpHandle.handle()
        }
    }
    
    var bannerID = ""
    {
        didSet
        {
            getBanner()
        }
    }

    func initSelf()
    {
        banner.block =
            {
                [weak self]
                (o)->Void in
                
                if(self != nil)
                {
                    let model=o as! NewsModel
                    
                    let vc:NewsInfoVC = "NewsInfoVC".VC as! NewsInfoVC
                    vc.model = model
                    vc.hidesBottomBarWhenPushed = true
                    
                    self?.viewController?.navigationController?.pushViewController(vc, animated: true)
                }
        }
        
        delegate = self
        dataSource = self
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        self.tableFooterView=view1
        self.tableHeaderView=view1
        
        self.separatorInset=UIEdgeInsetsZero
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                self.layoutMargins=UIEdgeInsetsZero
            } else {
                // Fallback on earlier versions
            }
        }
        
        httpHandle.pageStr="[page]"
        httpHandle.scrollView=self
        httpHandle.replace=["descrip":"description"]
        httpHandle.keys=["data","info"]
        httpHandle.modelClass=NewsModel.self
        
        self.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.registerNib("NewsListCell".Nib, forCellReuseIdentifier: "NewsListCell")
        
        self.registerNib("NewsActivitysCell".Nib, forCellReuseIdentifier: "NewsActivitysCell")
        
        self.registerNib("ActivitysCell".Nib, forCellReuseIdentifier: "ActivitysCell")
        
        self.setHeaderRefresh { [weak self] () -> Void in
 
            self?.getBanner()
            
            self?.httpHandle.reSet()
            
            self?.httpHandle.handle()
        }
        
        self.setFooterRefresh {[weak self] () -> Void in
            
            self?.httpHandle.handle()
        }
        
        self.hideFootRefresh()
        
        httpHandle.BeforeBlock {[weak self] (arr) in
            
            if self?.bannerID == "103" && arr.count == 0
            {
                self?.addNoGuanzhu()
            }
            
            if self?.url.has("News.getList&category_id=98") == true
            {
                if let list = arr as? [NewsModel]
                {
                    for item in list
                    {
                        item.category_id = "98"
                    }
                }
            }
        }
        
    }
    
    func addNoGuanzhu()
    {
        if self.viewWithTag(555) == nil
        {
            let v = NoGuanzhuView()
            self.addSubview(v)
            v.tag = 555
            v.frame = CGRectMake(0, 0, swidth, sheight-64.0-42.0*screenFlag-49.0)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initSelf()
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        initSelf()
    }
    
    func getBanner()
    {
        self.bannerArr.removeAll(keepCapacity: false)
        
        let url = "http://123.57.162.97/hfapi/Public/Found/?service=News.getGuanggao&typeid="+bannerID
        
        XHttpPool.requestJson(url, body: nil, method: .GET) { (o) -> Void in
            
            if(o == nil)
            {
                return
            }

            for item in o!["data"]["info"].arrayValue
            {
                let model:XBannerModel=XBannerModel()
                model.url =  item["picurl"].stringValue
                model.title=item["title"].stringValue
                
                let m = NewsModel()
                m.id = item["id"].stringValue
                m.url = item["url"].stringValue
                m.title = item["title"].stringValue
                
                model.obj = m

                self.bannerArr.append(model)
                
            }
            
            self.banner.arr = self.bannerArr
            self.beginUpdates()
            self.endUpdates()
            
        }
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row == 0)
        {
            cell.separatorInset=UIEdgeInsetsMake(0, swidth, 0, 0)
            if(IOS_Version>=8.0)
            {
                if #available(iOS 8.0, *) {
                    cell.layoutMargins=UIEdgeInsetsMake(0, swidth, 0, 0)
                } else {
                    // Fallback on earlier versions
                }
            }
            
            return
        }
        
        
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(indexPath.row == 0)
        {
            if(self.bannerArr.count > 0)
            {
               return swidth * 433.0 / 750.0
            }
            else
            {
                return 0
            }
            
        }
        else
        {
            let m = self.httpHandle.listArr[indexPath.row-1] as! NewsModel
            
            if m.category_id == "98"
            {
                if bannerID == "98"
                {
                    return 170.0
                }
                else
                {
                    return 166.0
                }
            }
            else
            {
                return 110.0
            }
            
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.httpHandle.listArr.count+1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(indexPath.row == 0)
        {
            let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            
            cell.clipsToBounds = true
            cell.layer.masksToBounds = true
            
            cell.contentView.removeAllSubViews()

            cell.contentView.addSubview(banner)
            
            return cell
        }
        else
        {
            let model = self.httpHandle.listArr[indexPath.row-1] as! NewsModel
            
            if model.category_id == "98"
            {
                if bannerID == "98"
                {
                    let cell:ActivitysCell = tableView.dequeueReusableCellWithIdentifier("ActivitysCell", forIndexPath: indexPath) as! ActivitysCell
                    
                    model.url = "http://img2.imgtn.bdimg.com/it/u=3856760675,2206224679&fm=21&gp=0.jpg"
                    cell.model = model
                    
                    return cell
                }
                else
                {
                    let cell:NewsActivitysCell = tableView.dequeueReusableCellWithIdentifier("NewsActivitysCell", forIndexPath: indexPath) as! NewsActivitysCell
                    
                    cell.model = model
                    
                    return cell
                    
                }
                
            }
            else
            {
                let cell:NewsListCell = tableView.dequeueReusableCellWithIdentifier("NewsListCell", forIndexPath: indexPath) as! NewsListCell
                
                cell.model = model
                
                return cell
            }
            
        }
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if(indexPath.row > 0)
        {
            let vc:NewsInfoVC = "NewsInfoVC".VC as! NewsInfoVC
            vc.model = self.httpHandle.listArr[indexPath.row-1] as! NewsModel
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
            
            let cell=tableView.cellForRowAtIndexPath(indexPath)
            
            if cell is NewsListCell
            {
                if(!DataCache.Share().newsViewedModel.has(vc.model.id))
                {
                    DataCache.Share().newsViewedModel.add(vc.model.id)
                    
                    (cell as! NewsListCell).setHasSee()
                    
                    let url = "http://101.201.169.38/api/Public/Found/?service=News.addView&id="+vc.model.id
                    
                    XHttpPool.requestJson(url, body: nil, method: .GET, block: {[weak self] (o) -> Void in
                        
                        
                    })
                    
                }

            }
  
        }
        
    }
    
    
    deinit
    {

    }
    
}
