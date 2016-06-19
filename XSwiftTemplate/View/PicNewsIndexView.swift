//
//  PicNewsIndexView.swift
//  chengshi
//
//  Created by X on 15/11/20.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class PicNewsIndexView: UIView,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var table: UITableView!
    var httpHandle:XHttpHandle=XHttpHandle()
    var nid=0
    var hasLoaded = false

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        self.table.tableFooterView=view1
        self.table.tableHeaderView=view1
        
        self.table.separatorInset=UIEdgeInsetsMake(0, swidth, 0, 0)
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                self.layoutMargins=UIEdgeInsetsMake(0, swidth, 0, 0)
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    
    func XHorizontalViewNowIndex(index: Int) {
        
        if !hasLoaded
        {
            hasLoaded=true
            self.table.beginHeaderRefresh()
        }
    }
    
    func show()
    {
        httpHandle.url="http://101.201.169.38/api/Public/Found/?service=News.getList&category_id=\(nid)&page=[page]&perNumber=20"
        httpHandle.pageStr="[page]"
        httpHandle.scrollView=self.table
        httpHandle.replace=["descrip":"description"]
        httpHandle.keys=["data","info"]
        httpHandle.modelClass=NewsModel.self
        
        self.table.registerNib("PicNewsIndexCell".Nib, forCellReuseIdentifier: "PicNewsIndexCell")
        
        self.table.setHeaderRefresh { [weak self] () -> Void in
            
            if(self == nil)
            {
                return
            }
            
            self!.httpHandle.end = false
            self!.httpHandle.page = 1
            
            self!.httpHandle.handle()
        }
        
        
        
        self.table.setFooterRefresh {[weak self] () -> Void in
            
            self!.httpHandle.handle()
        }
        
        self.table.hideFootRefresh()
        
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.separatorInset=UIEdgeInsetsMake(0, swidth, 0, 0)
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                cell.layoutMargins=UIEdgeInsetsMake(0, swidth, 0, 0)
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return (swidth-16)*0.75+16.0
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.httpHandle.listArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:PicNewsIndexCell = tableView.dequeueReusableCellWithIdentifier("PicNewsIndexCell", forIndexPath: indexPath) as! PicNewsIndexCell
        
        cell.model = self.httpHandle.listArr[indexPath.row] as! NewsModel
        
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        let vc:PicNewsInfoVC = "PicNewsInfoVC".VC as! PicNewsInfoVC
        vc.model = self.httpHandle.listArr[indexPath.row] as! NewsModel
        vc.hidesBottomBarWhenPushed = true
        
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }

    
    deinit
    {
        
    }
}
