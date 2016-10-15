//
//  PropertyNoticVC.swift
//  OA
//
//  Created by X on 15/4/27.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit

class PropertyNoticVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,commonDelegate{

    var searchView=UISearchBar()
    var table=UITableView()

    lazy var searchArr:Array<PropertyNoticeModel> = []
    var searchIng=false
    var dataArr:Array<PropertyNoticeModel> = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.title="小区公告"
        self.navigationItem.hidesBackButton=true
        
        self.addBackButton()

        self.http()
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func http()
    {
        let url=APPURL+"Public/Found/?service=Wuye.getNewsList"
        let body="uid=\(DataCache.Share.userModel.uid)&username=\(DataCache.Share.userModel.username)&houseid=\(DataCache.Share.userModel.house.houseid)"
        
        XHttpPool.requestJson(url, body: body, method: .POST) {[weak self] (o) -> Void in
            
            if let arr = o?["data"]["info"].arrayValue
            {
                for item in arr
                {
                    let model:PropertyNoticeModel = PropertyNoticeModel.parse(json: item, replace: nil)
                    self?.dataArr.append(model)
                }
                
                self?.table.reloadData()
            }

            
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor="#f0f0f0".color
        
        table.frame=CGRectMake(0, 44, swidth, sheight-44-64)

        self.showSelf()
        
    }
    
    func showSelf()
    {
        
        searchView.frame=CGRectMake(0, 0, swidth, 44)
        searchView.delegate=self
        searchView.backgroundColor=UIColor.whiteColor()
        //searchView.layer.borderWidth=0.5
        searchView.layer.borderColor=borderBGC.CGColor
        searchView.placeholder="输入关键词搜索"
        
        // 键盘添加一下Done按钮
        let topView:UIToolbar = UIToolbar(frame: CGRectMake(0, 0, swidth, 44))
        topView.barStyle=UIBarStyle.Default
        let btnSpace=UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Done, target: self, action: #selector(PropertyNoticVC.dismissKeyBoard))
        topView.setItems([btnSpace,doneButton], animated: true)
        
        searchView.inputAccessoryView=topView
        self.view.addSubview(searchView)
        
        table.dataSource=self
        table.delegate=self
        table.showsHorizontalScrollIndicator=false
        table.showsVerticalScrollIndicator=false
        let view=UIView()
        view.backgroundColor=UIColor.clearColor()
        
        table.tableFooterView=view
        table.tableHeaderView=view
        
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(table)
        
    }
    
    func dismissKeyBoard()
    {
        self.view.endEditing(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(self.searchIng)
        {
            return self.searchArr.count
        }
        
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellIdentifier="cell"
        
        let cell:UITableViewCell=tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath)
        
        for view in cell.contentView.subviews
        {
            view.removeFromSuperview()
        }
        
        var model:PropertyNoticeModel!
        
        if(searchIng)
        {
            model=searchArr[indexPath.row]
        }
        else
        {
            model=dataArr[indexPath.row]
        }
        
        let limg=UIImageView(image: "list_icon.png".image)
        limg.frame=CGRectMake(15.0, (60.0-26.0)/2.0, 26, 26)
        
        cell.contentView.addSubview(limg)
        
        let rimg=UIImageView()
        rimg.frame=CGRectMake(swidth-32, 20, 20, 20)
        rimg.image="go_arrow_icon.png".image
        cell.contentView.addSubview(rimg)
        
        let title=UILabel()
        title.frame=CGRectMake(51.0, 0, swidth-66-37, 34.0)
        title.font=UIFont.systemFontOfSize(18.0)
        title.text=model.title
        cell.contentView.addSubview(title)
        title.tag=20
        
        
        let time=UILabel()
        time.frame=CGRectMake(51.0, 34.0, swidth-66-37, 20.0)
        time.font=UIFont.systemFontOfSize(14.0)
        time.text=model.create_time
        time.textColor = "999999".color
        cell.contentView.addSubview(time)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

        var model:PropertyNoticeModel!
        if(searchIng)
        {
            model=searchArr[indexPath.row]
        }
        else
        {
            model=dataArr[indexPath.row]
        }
        
        
        
        let info=PropertyNoticeInfoVC()
        info.hidesBottomBarWhenPushed=true
        info.model = model
 
        self.navigationController?.pushViewController(info, animated: true)
        
        
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText.length()>0)
        {
            self.searchArr.removeAll(keepCapacity: false)
            self.searchIng = true
            
            for item in dataArr
            {
                if(item.title.has(searchText))
                {
                    self.searchArr.append(item)
                }
            }
            
        }
        else
        {
            self.searchIng = false
            self.searchArr.removeAll(keepCapacity: false)
        }
        
        self.table.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        self.view.endEditing(true)
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.view.endEditing(true)
        self.table.delegate=nil
        self.table.dataSource=nil
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
