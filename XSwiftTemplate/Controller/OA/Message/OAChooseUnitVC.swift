//
//  OAChooseUnitVC.swift
//  OA
//
//  Created by X on 15/5/15.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit

class OAChooseUnitVC: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    var table=UITableView()
    var delegate:commonDelegate?
    var block:AnyBlock?
    var selectInt = -1
    lazy var addtag:Array<OAPowerModel> = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.title="接收部门"
        self.navigationItem.hidesBackButton=true
        
        self.addBackButton()
        
        let submitButton=UIButton()
        submitButton.frame=CGRectMake(10, 2, 50, 25);
        submitButton.setTitle("确定", forState: UIControlState.Normal)
        submitButton.setTitleColor(腾讯颜色.图标蓝.rawValue.color, forState: UIControlState.Normal)
        submitButton.showsTouchWhenHighlighted = true
        submitButton.addTarget(self, action: #selector(OAChooseUnitVC.submit), forControlEvents: UIControlEvents.TouchUpInside)
        let rightItem=UIBarButtonItem(customView: submitButton)
        self.navigationItem.rightBarButtonItem=rightItem;
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func back()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func submit()
    {
        self.block?(selectInt)
        self.delegate?.selectWithDict!(["selectPeople":selectInt], flag: 8)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor="#f0f0f0".color
        
        
        
        showTable()
    }
    
    
    
    func showTable()
    {
        table.frame=CGRectMake(0, 0, swidth, sheight-64)
        table.dataSource=self
        table.delegate=self
        table.showsHorizontalScrollIndicator=false
        table.showsVerticalScrollIndicator=false
        let view=UIView()
        view.backgroundColor=UIColor.clearColor()
        
        table.tableFooterView=view
        table.tableHeaderView=view
        
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //table.setEditing(true, animated: true)
        
        self.view.addSubview(table)
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.addtag.count
        
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
        
        let label=UILabel()
        label.frame=CGRectMake(20, 0, swidth-40, 60.0)
        
        label.font=UIFont.systemFontOfSize(20.0)
        
        label.text=addtag[indexPath.row].name
        
        cell.contentView.addSubview(label)
        
        cell.accessoryType = UITableViewCellAccessoryType.None
        
        if(indexPath.row == selectInt)
        {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let cell=tableView.cellForRowAtIndexPath(indexPath)!
        
        if(selectInt >= 0)
        {
            let cell1 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: selectInt, inSection: 0))
            cell1?.accessoryType = .None
        }
        
        
        if (cell.accessoryType == UITableViewCellAccessoryType.None) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark;
            
            selectInt = indexPath.row
            
        } else
        {
            cell.accessoryType = UITableViewCellAccessoryType.None;
            selectInt = -1
        }
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
