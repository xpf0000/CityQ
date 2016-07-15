//
//  NewsIndexView.swift
//  chengshi
//
//  Created by X on 15/10/19.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class NewsIndexView: UITableView,UITableViewDelegate,UITableViewDataSource{

    var banner:XBanner = XBanner(frame: CGRectMake(0, 0, swidth, swidth * 433.0 / 750.0 * screenFlag))
    
    var httpHandle:XHttpHandle=XHttpHandle()
    
    lazy var bannerArr:Array<XBannerModel>=[]
    
    var url = ""
    {
        didSet
        {
//            if url.has("News.getListGZ&")
//            {
//                httpHandle.modelClass=CardActivityModel.self
//            }
//            else
//            {
//                
//            }
            
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
            
            if bannerID == "103"
            {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(userChange), name: NoticeWord.LogoutSuccess.rawValue, object: nil)
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(userChange), name: NoticeWord.LoginSuccess.rawValue, object: nil)
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(userChange), name: NoticeWord.CardChanged.rawValue, object: nil)
            }
        }
    }
    
    func userChange()
    {
        httpHandle.url = "http://123.57.162.97/hfapi/Public/Found/?service=News.getListGZ&username=\(Uname)&page=[page]&perNumber=20"
        httpHandle.reSet()
        httpHandle.handle()
    }

    func initSelf()
    {
        banner.click
            {
                [weak self]
                (o)->Void in
                
                if(self != nil)
                {
                    let model=o.obj as! NewsModel
                    
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
        self.tableHeaderView=view1
        
        let footer=UIView()
        footer.frame = CGRectMake(0, 0, swidth, 49.0)
        footer.backgroundColor=UIColor.clearColor()
        self.tableFooterView=footer
        
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
        
        self.registerNib("NewsMorePicCell".Nib, forCellReuseIdentifier: "NewsMorePicCell")
        
        self.registerNib("CardShopsActivitysCell".Nib, forCellReuseIdentifier: "CardShopsActivitysCell")
        
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
            
            if self?.bannerID == "103"
            {
                if arr.count == 0
                {
                    self?.addNoGuanzhu()
                }
                else
                {
                    self?.viewWithTag(555)?.removeFromSuperview()
                }
                
            }
            
        }
        
    }
    
    func addNoGuanzhu()
    {
        if let v = self.viewWithTag(555) as? NoGuanzhuView
        {
            v.reSetTitle()
        }
        else
        {
            let v = NoGuanzhuView()
            self.addSubview(v)
            v.tag = 555
            v.frame = CGRectMake(0, 0, swidth, sheight-64.0-42.0*screenFlag-49.0)
            v.reSetTitle()
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
        
        let url = APPURL+"Public/Found/?service=News.getGuanggao&typeid="+bannerID
        
        XHttpPool.requestJson(url, body: nil, method: .GET) { (o) -> Void in
            
            if(o == nil)
            {
                return
            }

            for item in o!["data"]["info"].arrayValue
            {
                let model:XBannerModel=XBannerModel()
                model.imageURL =  item["picurl"].stringValue
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
               return swidth * 433.0 / 750.0 * screenFlag
            }
            else
            {
                return 0
            }
            
        }
        else
        {
            let m = self.httpHandle.listArr[indexPath.row-1] as! NewsModel
            
            if bannerID == "83"
            {
                if m.category_id == "98"
                {
                    return 166.0 * screenFlag
                }

            }
            else if bannerID == "106" || bannerID == "103"
            {
                return 170.0 * screenFlag
            }

            
            if m.picList.count >= 3
            {
                return 166.0 * screenFlag
            }
            else
            {
                return 110.0 * screenFlag
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
            
            if bannerID == "83"
            {
                if model.category_id == "98"
                {
                    let cell:NewsActivitysCell = tableView.dequeueReusableCellWithIdentifier("NewsActivitysCell", forIndexPath: indexPath) as! NewsActivitysCell
                    
                    cell.model = model
                    
                    return cell
                }
                
            }
            else if bannerID == "106" || bannerID == "103"
            {
                let cell:ActivitysCell = tableView.dequeueReusableCellWithIdentifier("ActivitysCell", forIndexPath: indexPath) as! ActivitysCell
                
                cell.model = model
                
                return cell

            }
            
            if model.picList.count >= 3
            {
                let cell:NewsMorePicCell = tableView.dequeueReusableCellWithIdentifier("NewsMorePicCell", forIndexPath: indexPath) as! NewsMorePicCell
                
                cell.model = model
                
                return cell
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
            let model = self.httpHandle.listArr[indexPath.row-1] as! NewsModel
            
            var isHuodong = false
            
            if bannerID == "103" || bannerID == "106"
            {
                isHuodong = true
            }
            else
            {
                if model.category_id == "98"
                {
                    isHuodong = true
                }
            }

            if isHuodong
            {
                let vc:CardActivitysInfoVC = "CardActivitysInfoVC".VC("Card") as! CardActivitysInfoVC
                vc.model.id = model.id
                vc.hidesBottomBarWhenPushed = true
                self.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let vc:NewsInfoVC = "NewsInfoVC".VC as! NewsInfoVC
                vc.model = model
                vc.hidesBottomBarWhenPushed = true
                self.viewController?.navigationController?.pushViewController(vc, animated: true)
                
                let cell=tableView.cellForRowAtIndexPath(indexPath)
                
                if cell is NewsListCell
                {
                    if(!DataCache.Share().newsViewedModel.has(vc.model.id))
                    {
                        DataCache.Share().newsViewedModel.add(vc.model.id)
                        
                        (cell as! NewsListCell).setHasSee()
                        
                        let url = APPURL+"Public/Found/?service=News.addView&id="+vc.model.id
                        
                        XHttpPool.requestJson(url, body: nil, method: .GET, block: {[weak self] (o) -> Void in
                            
                            
                            })
                        
                    }
                    
                }
            }
  
        }
  
    }
    
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
