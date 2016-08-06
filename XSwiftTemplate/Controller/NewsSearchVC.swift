//
//  NewsSearchVC.swift
//  chengshi
//
//  Created by X on 15/11/23.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class NewsSearchVC: XViewController ,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource{
    
    let searchTable = XTableView(frame: CGRectMake(0, 0, swidth, sheight-64.0), style: .Plain)
    
    var searchText = ""
        {
        didSet
        {
            searchbar.text = searchText
            let url=APPURL+"Public/Found/?service=News.search&keyword=\(searchText)&page=[page]&perNumber=20"
            
            searchTable.httpHandle.reSet()
            searchTable.httpHandle.url = url
            searchTable.httpHandle.handle()
            
        }
    }
    
    let searchbar:UISearchBar=UISearchBar()
    
    var block:AnyBlock?
    
    var classModel:CategoryModel?
    var searchIng=false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        searchTable.backgroundColor = UIColor.whiteColor()
        searchTable.frame = CGRectMake(0, 0, swidth, sheight-64)
        
        searchTable.keyboardDismissMode = .OnDrag
        searchTable.hideHeadRefresh()
        
        self.view.addSubview(searchTable)
        
        searchbar.delegate = self
        
        searchbar.layer.masksToBounds = true
        searchbar.frame=CGRectMake(10, 0, swidth-20, 44)
        
        if(searchbar.respondsToSelector(Selector("barTintColor")))
        {
            if(IOS_Version>=7.1)
            {
                //searchbar.searchTextPositionAdjustment
                searchbar.subviews[0].subviews[0].removeFromSuperview()
                searchbar.backgroundColor = UIColor.clearColor()
                
            }
            else
            {
                //searchbar.searchTextPositionAdjustment
                searchbar.subviews[0].subviews[0].removeFromSuperview()
                searchbar.backgroundColor = UIColor.clearColor()
                searchbar.barTintColor = UIColor.clearColor()
                
            }
        }
    
        searchTable.registerNib("NewsListCell".Nib, forCellReuseIdentifier: "NewsListCell")
        
        searchTable.registerNib("NewsActivitysCell".Nib, forCellReuseIdentifier: "NewsActivitysCell")
        
        
        searchTable.setHandle("", pageStr: "[page]", keys: ["data","info"], model: NewsModel.self, CellIdentifier: "NewsListCell")
        
        searchTable.httpHandle.replace=["descrip":"description"]
        
        searchTable.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0)
        if #available(iOS 8.0, *) {
            searchTable.layoutMargins=UIEdgeInsetsMake(0, 0, 0, 0)
        }
        
        searchTable.delegate = self
        searchTable.dataSource = self
 
        
        self.navigationController?.navigationBar.addSubview(searchbar)
        searchbar.becomeFirstResponder()
        self.searchIng = true
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        
        searchbar.setShowsCancelButton(true, animated: true)
        
        let arr=searchbar.subviews[0].subviews
        
        for view in arr
        {
            if(view is UIButton)
            {
                (view as! UIButton).enabled=true
                (view as! UIButton).setTitle("取消", forState: .Normal)
                (view as! UIButton).setTitleColor(UIColor.whiteColor(), forState: .Normal)
                break
            }
        }
        
        return true
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        searchbar.resignFirstResponder()
        self.view.endEditing(true)
        pop()
        
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchText = searchText
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchbar.resignFirstResponder()
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
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
        
        let m = searchTable.httpHandle.listArr[indexPath.row] as! NewsModel
        
        if m.category_id == "98"
        {
            return 166.0 * screenFlag
        }
        else
        {
            return 110 * screenFlag
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchTable.httpHandle.listArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let m = searchTable.httpHandle.listArr[indexPath.row] as! NewsModel
        
        if m.category_id == "98"
        {
            let cell:NewsActivitysCell = tableView.dequeueReusableCellWithIdentifier("NewsActivitysCell", forIndexPath: indexPath) as! NewsActivitysCell
            
            cell.model = m
            
            return cell
        }
        else
        {
            let cell:NewsListCell = tableView.dequeueReusableCellWithIdentifier("NewsListCell", forIndexPath: indexPath) as! NewsListCell
            
            cell.model = m
            
            return cell
            
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let vc:NewsInfoVC = "NewsInfoVC".VC as! NewsInfoVC
        vc.model = searchTable.httpHandle.listArr[indexPath.row] as! NewsModel
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
        let cell=tableView.cellForRowAtIndexPath(indexPath)
        
        if cell is NewsListCell
        {
            if(!DataCache.Share.newsViewedModel.has(vc.model.id))
            {
                DataCache.Share.newsViewedModel.add(vc.model.id)
                
                (cell as! NewsListCell).setHasSee()
                
                let url = APPURL+"Public/Found/?service=News.addView&id="+vc.model.id
                
                XHttpPool.requestJson(url, body: nil, method: .GET, block: {[weak self] (o) -> Void in
                    
                    
                    })
                
            }
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchbar.endEditing(true)
        searchbar.removeFromSuperview()
        
    }
    
    
    
    deinit
    {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
}
