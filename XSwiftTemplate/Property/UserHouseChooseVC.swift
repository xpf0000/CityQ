//
//  OAMessageVC.swift
//  OA
//
//  Created by X on 15/4/27.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit


class UserHouseChooseVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,commonDelegate{

    var pid="0"
    var type="1"
    var index = "0"
    var searchView=UISearchBar()
    var table=UITableView()
    lazy var searchArr:Array<MyHouseModel> = []
    var searchIng=false
    var dataArr:Array<MyHouseModel> = []
    
    weak var pushVC:HouseChooseTableVC?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.navigationItem.hidesBackButton=true
        
        self.addBackButton()

        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func http()
    {
        XWaitingView.Share().black()
        self.view.showWaiting()
        
        let url=APPURL+"Public/Found/?service=Common.getHouseList&pid=\(pid)&type=\(type)"
        
        XHttpPool.requestJson(url, body: nil, method: .POST) {[weak self] (o) -> Void in
            
            RemoveWaiting()
            
            if let arr = o?["data"]["info"].arrayValue
            {
                for item in arr
                {
                    let model:MyHouseModel = MyHouseModel.parse(json: item, replace: nil)
                    self?.dataArr.append(model)
                }
                
                self?.table.reloadData()
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.http()
        
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
        let doneButton = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Done, target: self, action: #selector(UserHouseChooseVC.dismissKeyBoard))
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
        
        return self.dataArr.count
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
        
        var model:MyHouseModel!
        
        if(searchIng)
        {
            model=searchArr[indexPath.row]
        }
        else
        {
            model=dataArr[indexPath.row]
        }
        
        
        let title=UILabel()
        title.frame=CGRectMake(15, 0, swidth-30, 60)
        title.font=UIFont.systemFontOfSize(18.0)
        title.text=model.title
        cell.contentView.addSubview(title)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    
        var model:MyHouseModel!
        
        if(searchIng)
        {
            model=searchArr[indexPath.row]
        }
        else
        {
            model=dataArr[indexPath.row]
        }

        switch index
        {
        case "0":
            ""
            self.pushVC?.model1 = model
            self.pushVC?.model2 = nil
            self.pushVC?.model3 = nil
            self.pushVC?.model4 = nil
            self.pushVC?.model5 = nil
            self.pushVC?.model6 = nil
            
        case "1":
            ""
            self.pushVC?.model2 = model
            self.pushVC?.model3 = nil
            self.pushVC?.model4 = nil
            self.pushVC?.model5 = nil
            self.pushVC?.model6 = nil
            
        case "2":
            ""
            self.pushVC?.model3 = model
            self.pushVC?.model4 = nil
            self.pushVC?.model5 = nil
            self.pushVC?.model6 = nil
            
        case "3":
            ""
            self.pushVC?.model4 = model
            self.pushVC?.model5 = nil
            self.pushVC?.model6 = nil
            
        case "4":
            ""
            self.pushVC?.model5 = model
            self.pushVC?.model6 = nil
            
        case "5":
            ""
            self.pushVC?.model6 = model
            
        default:
            ""
        }
        
        self.pushVC?.showChoose()
        self.navigationController?.popViewControllerAnimated(true)
        
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
        RemoveWaiting()
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.table.endEditing(true)
        self.table.delegate=nil
        self.table.dataSource=nil
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
