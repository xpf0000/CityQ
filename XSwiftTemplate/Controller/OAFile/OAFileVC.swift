//
//  OAFileVC.swift
//  OA
//
//  Created by X on 15/5/8.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit

class OAFileVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    
    var table=UITableView()
    let line:UIView=UIView()
    
    lazy var publicArr:Array<OAFileModel> = []
    lazy var privateArr:Array<OAFileModel> = []
    
    var type=0
    let segmentedControl = UISegmentedControl(items: ["公共文档","个人文档","已下载"])
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "DownLoadSuccess", name: "DownLoadSuccess", object: nil)
        
        self.title="文档"
        self.navigationItem.hidesBackButton=true
        
        self.addBackButton()
        self.http()
        
    }
    
    func DownLoadSuccess()
    {
        if(type == 2)
        {
            self.table.reloadData()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func http()
    {
        let url="http://101.201.169.38/apioa/Public/OA/?service=Files.getList&uid="+DataCache.Share().oaUserModel.uid+"&username="+DataCache.Share().oaUserModel.username
        
        XHttpPool.requestJson(url, body: nil, method: .POST) {[weak self] (o) -> Void in
            
            if(o?["data"]["info"].arrayValue.count > 0)
            {
                for item in o!["data"]["info"].arrayValue
                {
                    let model:OAFileModel = OAFileModel.parse(json: item, replace: nil)
                    model.open=true
                    self?.publicArr.append(model)
                }
                
                if(self?.type == 0)
                {
                    self?.table.reloadData()
                }
            }
            
        }
        
        
        
        
        let url1="http://101.201.169.38/apioa/Public/OA/?service=Files.getUserList&uid="+DataCache.Share().oaUserModel.uid+"&username="+DataCache.Share().oaUserModel.username
        
        XHttpPool.requestJson(url1, body: nil, method: .POST) {[weak self] (o) -> Void in
            
            if(o?["data"]["info"].arrayValue.count > 0)
            {
                for item in o!["data"]["info"].arrayValue
                {
                    let model:OAFileModel = OAFileModel.parse(json: item, replace: nil)
                    model.open = false
                    model.uid = DataCache.Share().oaUserModel.uid
                    self?.privateArr.append(model)
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
        
        self.setTopButton()
        self.showTable()
        
    }
    
    func setTopButton()
    {
        
        segmentedControl.frame = CGRectMake(0,0,swidth,44);
        segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
        segmentedControl.setBackgroundImage("#ffffff".color?.image, forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        segmentedControl.setBackgroundImage("#ffffff".color?.image, forState: UIControlState.Selected, barMetrics: UIBarMetrics.Default)
        
        let choosedColor:UIColor="#4385f5".color!
        
        segmentedControl.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFontOfSize(16.5),NSForegroundColorAttributeName:blackTXT], forState: UIControlState.Normal)
        segmentedControl.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFontOfSize(16.5),NSForegroundColorAttributeName:choosedColor], forState: UIControlState.Selected)
        
        segmentedControl.setDividerImage("#ffffff".color?.image, forLeftSegmentState: UIControlState.Normal, rightSegmentState: UIControlState.Selected, barMetrics: UIBarMetrics.Default)
        segmentedControl.setDividerImage("#ffffff".color?.image, forLeftSegmentState: UIControlState.Selected, rightSegmentState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        
        segmentedControl.addTarget(self, action: "chooseType:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.view.addSubview(segmentedControl)
        
        line.frame=CGRectMake(0, 44-2.0, swidth/3.0, 2.5)
        line.backgroundColor=choosedColor
        //self.view.addSubview(line)
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
        table.frame=CGRectMake(0, 44, swidth, sheight-44-64)
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
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(type==0)
        {
           return publicArr.count
        }
        else if(type==1)
        {
           return privateArr.count
            
        }
        else if(type==2)
        {
            return DataCache.Share().oaFile.userArr().count
        }
        
        return 0
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellIdentifier="cell"
        
        let cell:UITableViewCell=tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath)
        
        cell.contentView.removeAllSubViews()

        var user:OAFileModel!
        
        if(type==0)
        {
            user = publicArr[indexPath.row]
        }
        else if(type==1)
        {
            user = privateArr[indexPath.row]
        }
        else if(type==2)
        {
            user = DataCache.Share().oaFile.userArr()[indexPath.row]
        }
        
        let img = UIImageView()
        img.frame = CGRectMake(15, (80-38)/2, 38, 38)
        
        switch user.type
        {
            case "doc","docx":
                img.image = "icon_list_doc.png".image
                ""
            case "xls","xlsx" :
                img.image = "icon_list_excel.png".image
                ""
            case "pdf" :
                img.image = "icon_list_pdf.png".image
                ""
            case "ppt" :
                img.image = "icon_list_ppt.png".image
                ""
            case "txt" :
                img.image = "icon_list_txtfile.png".image
                ""
            default:
                img.image = "icon_list_unknown.png".image
                ""
        }
        
        cell.contentView.addSubview(img)
        
        
        let title=UILabel()
        title.frame=CGRectMake(65, 0, swidth-65-70, 80.0)
        title.font=UIFont.systemFontOfSize(16.0)
        title.text=user.name
        cell.contentView.addSubview(title)
        
        let downButton = XDownLoadView(frame: CGRectMake(swidth-60, (80-48)/2.0, 48, 48), url: user.url)
        downButton.tag = 100+indexPath.row
        cell.contentView.addSubview(downButton)
        
        downButton.down.customObj = user

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let downButton = tableView.viewWithTag(100+indexPath.row) as! XDownLoadView
        
        if(downButton.down.state == .Complete)
        {
            var user:OAFileModel!
            
            if(type==0)
            {
                user = publicArr[indexPath.row]
            }
            else if(type==1)
            {
                user = privateArr[indexPath.row]
            }
            else if(type==2)
            {
                user = DataCache.Share().oaFile.userArr()[indexPath.row]
            }
            
            let vc:OAFileInfoVC = OAFileInfoVC()
            vc.model = user
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            ShowMessage("请先下载文件")
        }
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if(type==2)
        {
            return true
        }
        
        return false
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(editingStyle==UITableViewCellEditingStyle.Delete)
        {
            
            let model:OAFileModel=DataCache.Share().oaFile.userArr()[indexPath.row]

            DataCache.Share().oaFile.del(model)

            table.reloadData()
            
        }
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
        
        (self.navigationController as? XNavigationController)?.removeRecognizer()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        (self.navigationController as? XNavigationController)?.setRecognizer()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}