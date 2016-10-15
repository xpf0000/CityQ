//
//  meetingIndexVC.swift
//  OA
//
//  Created by X on 15/5/8.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit

class OAAddressBookVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    
    var showBackButton:Bool=true
    var table=UITableView()
    let line:UIView=UIView()
    var searchView=UISearchBar()
    var searchArr:Array<OAAddressBookModel>=[]
    
    var letterArr:Dictionary<String,Array<OAAddressBookModel>> = [:]
    var unitArr:Array<OAAddressBookModel>=[]
    var chooseUnit = -1
    
    var type=0
    let segmentedControl = UISegmentedControl(items: ["所有人","部门","常用联系人"])
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.title="通讯录"
        self.navigationItem.hidesBackButton=true
        
        self.addBackButton()
        self.http()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func http()
    {
        let url=WapUrl+"/apioa/Public/OA/?service=Tel.getList"
        let body="dwid="+DataCache.Share.oaUserModel.dwid+"&uid="+DataCache.Share.oaUserModel.uid+"&username="+DataCache.Share.oaUserModel.username
        
        XHttpPool.requestJson(url, body: body, method: .POST) {[weak self] (o) -> Void in
            
            if(o?["data"]["info"].arrayValue.count > 0)
            {
                for item in o!["data"]["info"].arrayValue
                {
                    let model:OAAddressBookModel = OAAddressBookModel.parse(json: item, replace: nil)
                    
                    if(self?.letterArr[model.letter] == nil)
                    {
                        self?.letterArr[model.letter] = []
                        self?.letterArr[model.letter]?.append(model)
                    }
                    else
                    {
                        self?.letterArr[model.letter]?.append(model)
                    }
                    
                    
                }
                
                if(self?.type == 0)
                {
                    self?.table.reloadData()
                }
            }
            
        }
        
        
        
        
        let url1=WapUrl+"/apioa/Public/OA/?service=Tel.getListBybm"
        let body1="dwid="+DataCache.Share.oaUserModel.dwid+"&uid="+DataCache.Share.oaUserModel.uid+"&username="+DataCache.Share.oaUserModel.username
        
        XHttpPool.requestJson(url1, body: body1, method: .POST) {[weak self] (o) -> Void in
            
            if(o?["data"]["info"].arrayValue.count > 0)
            {
                for item in o!["data"]["info"].arrayValue
                {
                    let model:OAAddressBookModel = OAAddressBookModel.parse(json: item, replace: nil)
                    
                    self?.unitArr.append(model)
                    
                }
                
                if(self?.type == 1)
                {
                    self?.table.reloadData()
                }
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor="#f0f0f0".color

        
        self.addSearchBar()
        self.setTopButton()
        self.showTable()
        
    }
    
    func addSearchBar()
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
        let doneButton = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Done, target: self, action: #selector(OAAddressBookVC.dismissKeyBoard))
        topView.setItems([btnSpace,doneButton], animated: true)
        
        searchView.inputAccessoryView=topView
        
        self.view.addSubview(searchView)
    }
    
    func dismissKeyBoard()
    {
        self.view.endEditing(true)
    }
    
    func setTopButton()
    {
        
        segmentedControl.frame = CGRectMake(0,44,swidth,44);
        segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
        segmentedControl.setBackgroundImage("#ffffff".color?.image, forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        segmentedControl.setBackgroundImage("#ffffff".color?.image, forState: UIControlState.Selected, barMetrics: UIBarMetrics.Default)
        
        let choosedColor:UIColor="#4385f5".color!
        
        segmentedControl.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFontOfSize(16.5),NSForegroundColorAttributeName:blackTXT], forState: UIControlState.Normal)
        segmentedControl.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFontOfSize(16.5),NSForegroundColorAttributeName:choosedColor], forState: UIControlState.Selected)
        
        segmentedControl.setDividerImage("#ffffff".color?.image, forLeftSegmentState: UIControlState.Normal, rightSegmentState: UIControlState.Selected, barMetrics: UIBarMetrics.Default)
        segmentedControl.setDividerImage("#ffffff".color?.image, forLeftSegmentState: UIControlState.Selected, rightSegmentState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        
        segmentedControl.addTarget(self, action: #selector(OAAddressBookVC.chooseType(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        self.view.addSubview(segmentedControl)
        
        line.frame=CGRectMake(0, 44+44-2.0, swidth/3.0, 2.5)
        line.backgroundColor=choosedColor
        self.view.addSubview(line)
    }
    
    func chooseType(Seg:UISegmentedControl)
    {
        type=Seg.selectedSegmentIndex
        
        table.reloadData()
        let index=CGFloat(Seg.selectedSegmentIndex)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.line.frame=CGRectMake(swidth/3.0*index, 44+44.0-2.0, swidth/3.0, 2.5)
            
            }) { (finished) -> Void in
                
        }
        
        
    }
    
    func showTable()
    {
        table.frame=CGRectMake(0, 44+44, swidth, sheight-44-44-64)
        if(!showBackButton)
        {
            table.frame=CGRectMake(0, 44+44, swidth, sheight-44-44-64-49)
        }
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
    
    func chooseUnit(sender:UIButton)
    {
        let temp:Int = chooseUnit
        let index = sender.tag-200
        if(self.chooseUnit != index)
        {
            self.chooseUnit = index
        }
        else
        {
            self.chooseUnit = -1
        }
        
        self.table.beginUpdates()
        
        if(temp>=0)
        {
            table.reloadSections(NSIndexSet(index: temp), withRowAnimation: UITableViewRowAnimation.Automatic)
            
            let img:UIImageView? = table.viewWithTag(500+temp) as? UIImageView
            
            if(img != nil)
            {
                img?.revolve(0.25, angle: 0.0)
            }
            
            
        }
        if(chooseUnit>=0)
        {
            table.reloadSections(NSIndexSet(index: chooseUnit), withRowAnimation: UITableViewRowAnimation.Automatic)
            let img:UIImageView?=table.viewWithTag(500+chooseUnit) as? UIImageView
            
            if(img != nil)
            {
                img?.revolve(0.25, angle: 0.5)
            }
            
            
        }
        
        self.table.endUpdates()
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if(type < 2)
        {
            return 38.0
        }
        else
        {
            return 0.0
        }
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.frame = CGRectMake(0, 0, swidth, 38.0)
        view.backgroundColor=UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
        
        let label=UILabel()
        label.frame=CGRectMake(15, 0, swidth-15, 38.0)
        label.backgroundColor=UIColor.clearColor()
        label.font=UIFont.systemFontOfSize(18.0)
        label.textColor=UIColor.lightGrayColor()
        view.addSubview(label)
        
        if(type==0)
        {
            var i=0
            var str=""
            for (key,_) in self.letterArr
            {
                if(i == section)
                {
                    str = key
                    break
                }
                i += 1
            }
           label.text=str
        }
        else if(type==1)
        {
            label.text = self.unitArr[section].title
            
            let button=UIButton(type: .Custom)
            button.frame = CGRectMake(0, 0, swidth, 38.0)
            button.tag = 200+section
            button.addTarget(self, action: #selector(OAAddressBookVC.chooseUnit(_:)), forControlEvents: .TouchUpInside)

            view.addSubview(button)
            
            let img = UIImageView(image: "seeMore.png".image)
            img.frame = CGRectMake(10, 10, 18, 18)
            img.tag = 500+section
            view.addSubview(img)
            
            label.frame=CGRectMake(35, 0, swidth-35, 38.0)
            
            if(section == chooseUnit)
            {
                img.transform=CGAffineTransformMakeRotation(CGFloat(M_PI)*CGFloat(0.5))
            }
        }
        else
        {
            
        }

        return view
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if(type==0)
        {
            return self.letterArr.count
        }
        else if(type==1)
        {
            return self.unitArr.count
        }
        else
        {
            return 1
        }

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(type==0)
        {
            var i=0
            var count = 0
            for (_,value) in self.letterArr
            {
                if(i == section)
                {
                    count = value.count
                    break
                }
                i += 1
            }
            
            return count
        }
        else if(type==1)
        {
            if(section == self.chooseUnit)
            {
                return self.unitArr[section].memberList.count
            }
            else
            {
                return 0
            }
            
        }
        else if(type==2)
        {
            if(DataCache.Share.oaAddress.collect[DataCache.Share.oaUserModel.uid] == nil)
            {
                return 0
            }
            return DataCache.Share.oaAddress.collect[DataCache.Share.oaUserModel.uid]!.count
        }
        else if(type==3)
        {
            return searchArr.count
        }
        
        return 0
        
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
        
        var user:OAAddressBookModel=OAAddressBookModel()
        
        if(type==0)
        {
            
            var i=0
            for (_,value) in self.letterArr
            {
                if(i == indexPath.section)
                {
                    user=value[indexPath.row]
                    break
                }
                i += 1
            }

        }
        else if(type==1)
        {
            user = self.unitArr[indexPath.section].memberList[indexPath.row]
        }
        else if(type==2)
        {
            user = DataCache.Share.oaAddress.collect[DataCache.Share.oaUserModel.uid]![indexPath.row]
        }
        else if(type==3)
        {
            user=searchArr[indexPath.row]
        }
        
        let label = UILabel()
        label.frame=CGRectMake(15, 8, 44.0, 44.0)
        label.font=UIFont.boldSystemFontOfSize(18.0)
        label.text=user.truename.subStringToIndex(1)
        label.textColor=UIColor.whiteColor()
        label.textAlignment = .Center
        label.layer.cornerRadius = 22.0
        label.layer.masksToBounds = true
        label.backgroundColor = (user.truename+user.fullLetter+user.id).md5.subStringToIndex(6).color
        cell.contentView.addSubview(label)
        
        let title=UILabel()
        title.frame=CGRectMake(69, 0, swidth-69-40, 60.0)
        title.font=UIFont.systemFontOfSize(18.0)
        title.text=user.truename
        cell.contentView.addSubview(title)
        
        let img=UIImageView()
        img.frame=CGRectMake(swidth-30, (cell.frame.size.height-25)/2.0, 25, 25)
        img.image="b_arrow_icon.png".image
        cell.contentView.addSubview(img)
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        var user:OAAddressBookModel=OAAddressBookModel()
        
        if(type==0)
        {
            
            var i=0
            for (_,value) in self.letterArr
            {
                if(i == indexPath.section)
                {
                    user=value[indexPath.row]
                    break
                }
                i += 1
            }
            
        }
        else if(type==1)
        {
            user = self.unitArr[indexPath.section].memberList[indexPath.row]
        }
        else if(type==2)
        {
            user = DataCache.Share.oaAddress.collect[DataCache.Share.oaUserModel.uid]![indexPath.row]
        }
        else if(type==3)
        {
            user=searchArr[indexPath.row]
        }

        
        let vc = "OAAddressBookInfoVC".VC("OA") as! OAAddressBookInfoVC
        vc.model = user
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        
        
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText.length()>0)
        {
            if(table.frame.origin.y==88)
            {
                table.frame=CGRectMake(0, 44, swidth, sheight-44-64)
                if(!showBackButton)
                {
                    table.frame=CGRectMake(0, 44, swidth, sheight-44-64-49)
                }

            }
            
            type=3
            searchArr.removeAll(keepCapacity: false)
            
            for item in self.unitArr
            {
                if(item.title.has(searchText))
                {
                    self.searchArr += item.memberList
                    continue
                }
                for m in item.memberList
                {
                    if(m.truename.has(searchText) || m.letter.has(searchText.uppercaseString))
                    {
                        self.searchArr.append(m)
                    }
                }
            }
            
            table.reloadData()
            
        }
        else
        {
            type=Int(line.frame.origin.x/(swidth/3))
            
            table.frame=CGRectMake(0, 88, swidth, sheight-88-64)
            if(!showBackButton)
            {
                table.frame=CGRectMake(0, 88, swidth, sheight-88-64-49)
            }
            
            table.reloadData()
        }
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        self.view.endEditing(true)
    }
    
    func reload()
    {
        table.reloadData()
    }
    
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.table.endEditing(true)
        self.table.dataSource=nil
        self.table.delegate=nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if(self.type == 2)
        {
            self.table.reloadData()
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
       
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
