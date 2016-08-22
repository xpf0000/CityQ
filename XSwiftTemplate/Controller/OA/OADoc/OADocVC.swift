//
//  OADocVC.swift
//  OA
//
//  Created by X on 15/4/27.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit


class OADocVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,commonDelegate{
    var showBackButton:Bool=true
    var searchView=UISearchBar()
    var table=UITableView()
    var add=UIButton()
    var canAdd = 0
    var SendPower = ""
    lazy var searchArr:Array<OADocModel> = []
    var searchIng=false
    var dataArr:Array<OADocModel> = []
    lazy var addtag:Array<OAPowerModel> = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.title="公文列表"
        self.navigationItem.hidesBackButton=true
        
        self.addBackButton()
        
        
        add.frame=CGRectMake(10, 2, 25, 25);
        add.setBackgroundImage("add_icon_blue.png".image, forState: UIControlState.Normal)
        add.showsTouchWhenHighlighted = true
        add.addTarget(self, action: #selector(OADocVC.addMessage), forControlEvents: UIControlEvents.TouchUpInside)
        let rightitem=UIBarButtonItem(customView: add)
        self.navigationItem.rightBarButtonItem=rightitem;
        
        
        self.http()
        
    }
    
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func http()
    {
        let url=WapUrl+"/apioa/Public/OA/?service=Document.getList"
        let body="dwid="+DataCache.Share.oaUserModel.dwid+"&bmid="+DataCache.Share.oaUserModel.bmid+"&uid="+DataCache.Share.oaUserModel.uid+"&username="+DataCache.Share.oaUserModel.username

        XHttpPool.requestJson(url, body: body, method: .POST) {[weak self] (o) -> Void in

            if(o?["data"]["add"] != nil)
            {
                self?.canAdd = o!["data"]["add"].intValue
                
                for item in o!["data"]["addtag"].arrayValue
                {
                    let model:OAPowerModel = OAPowerModel()
                    model.name = item["name"].stringValue
                    model.value = item["value"].stringValue
                    self?.addtag.append(model)
                }
                
                if(o?["data"]["info"].arrayValue.count > 0)
                {
                    var list:Array<OADocModel> = []
                    for item in o!["data"]["info"].arrayValue
                    {
                        let model:OADocModel = OADocModel.parse(json: item, replace: nil)
                        
                        
                        if(DataCache.Share.oaDoc.arr[DataCache.Share.oaUserModel.uid] == nil)
                        {
                            DataCache.Share.oaDoc.arr[DataCache.Share.oaUserModel.uid]=[]
                        }
                        
                        list.append(model)
                        
                    }
                    
                    DataCache.Share.oaDoc.arr[DataCache.Share.oaUserModel.uid]! = list+DataCache.Share.oaDoc.arr[DataCache.Share.oaUserModel.uid]!
                    
                    DataCache.Share.oaDoc.save()
                }
                
//                if(self?.canAdd == 0)
//                {
//                    self?.add.enabled=false
//                    self?.add.hidden=true
//                }
//                else
//                {
//                    self?.add.enabled=true
//                    self?.add.hidden=false
//                }
                
                self?.table.reloadData()
            }
            
            
        }
    }
    
    func addMessage()
    {
        let add=OAAddMessageVC()
        add.addtag = self.addtag
        add.hidesBottomBarWhenPushed=true
        
        add.block = {
            [weak self]
            (o)->Void in
            
            self?.http()
            
        }
        
        self.navigationController?.pushViewController(add, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor="#f0f0f0".color
        
        table.frame=CGRectMake(0, 44, swidth, sheight-44-64)
        
        if(!showBackButton)
        {
            
            table.frame=CGRectMake(0, 44, swidth, sheight-44-64-49)
        }
        
        self.add.enabled=false
        self.add.hidden=true
        
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
        let doneButton = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Done, target: self, action: #selector(OADocVC.dismissKeyBoard))
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
        
        if(DataCache.Share.oaDoc.arr[DataCache.Share.oaUserModel.uid] == nil)
        {
            return 0
        }
        
        return DataCache.Share.oaDoc.arr[DataCache.Share.oaUserModel.uid]!.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellIdentifier="cell"
        
        let cell:UITableViewCell=tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath)
        
        for view in cell.contentView.subviews
        {
            view.removeFromSuperview()
        }
        
        var model:OADocModel!
        
        if(searchIng)
        {
            model=searchArr[indexPath.row]
        }
        else
        {
            model=DataCache.Share.oaDoc.arr[DataCache.Share.oaUserModel.uid]![indexPath.row]
        }
        
        
        
        let limg=UIImageView(image: "list_icon.png".image)
        limg.frame=CGRectMake(10.0, (75.0-32.0)/2.0, 32, 32)
        
        cell.contentView.addSubview(limg)
        
        let rimg=UIImageView()
        rimg.frame=CGRectMake(swidth-35, (75.0-25)/2, 25, 25)
        rimg.image="go_arrow_icon.png".image
        cell.contentView.addSubview(rimg)
        
        let title=UILabel()
        title.frame=CGRectMake(52, 10, swidth-52-35-10, 25)
        title.font=UIFont.systemFontOfSize(18.0)
        title.text=model.title
        cell.contentView.addSubview(title)
        title.tag=20
        
        let name=model.truename
        let time=NSDate(timeIntervalSince1970: NSTimeInterval(model.create_time)!).str
        
        let content=UILabel()
        content.frame=CGRectMake(53, 42, swidth-53-35-10, 20)
        content.font=UIFont.systemFontOfSize(14.5)
        content.textColor=UIColor.lightGrayColor()
        content.text=name+"  "+time!
        cell.contentView.addSubview(content)
        content.tag=21
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

        var model:OADocModel!
        if(searchIng)
        {
            model=searchArr[indexPath.row]
        }
        else
        {
            model=DataCache.Share.oaDoc.arr[DataCache.Share.oaUserModel.uid]![indexPath.row]
        }
        
        let infoVC=OADocInfoVC()
        infoVC.info=model
        infoVC.getContent()
        self.navigationController?.pushViewController(infoVC, animated: true)
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(editingStyle==UITableViewCellEditingStyle.Delete)
        {
            if(self.searchIng)
            {
                let model = self.searchArr[indexPath.row]
                let index = DataCache.Share.oaDoc.arr[DataCache.Share.oaUserModel.uid]!.indexOf(model)
                if(index != nil)
                {
                    DataCache.Share.oaDoc.arr[DataCache.Share.oaUserModel.uid]!.removeAtIndex(index!)
                }
                self.searchArr.removeAtIndex(indexPath.row)
                table.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                
            }
            else
            {
                DataCache.Share.oaDoc.arr[DataCache.Share.oaUserModel.uid]!.removeAtIndex(indexPath.row)
                DataCache.Share.oaDoc.save()
                table.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
            
        }
    }
    
    
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText.length()>0)
        {
            self.searchArr.removeAll(keepCapacity: false)
            self.searchIng = true
            
            if(DataCache.Share.oaDoc.arr[DataCache.Share.oaUserModel.uid] != nil)
            {
                for item in DataCache.Share.oaDoc.arr[DataCache.Share.oaUserModel.uid]!
                {
                    let time=NSDate(timeIntervalSince1970: NSTimeInterval(item.create_time)!).str
                    
                    if(item.truename.has(searchText) || item.title.has(searchText) || time!.has(searchText))
                    {
                        self.searchArr.append(item)
                    }
                    
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
        self.table.endEditing(true)
        self.table.delegate=nil
        self.table.dataSource=nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let tempVC=self.navigationController as! XNavigationController
        tempVC.removeRecognizer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        let tempVC=self.navigationController as! XNavigationController
        tempVC.setRecognizer()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}