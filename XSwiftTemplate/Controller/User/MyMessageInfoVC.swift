//
//  MyMessageInfoVC.swift
//  chengshi
//
//  Created by X on 16/6/13.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyMessageInfoVC: UIViewController,UITableViewDelegate,UITableViewDataSource{

    let table = XTableView()
    var inEditing = false
    var type = 1
    
    var btn:UIButton!
    
    func setData()
    {
        self.table.httpHandle.listArr.removeAll(keepCapacity: false)
        
        switch self.type {
        case 1:
            ""
            if let arr = DataCache.Share.userMsg.users[Uid]?.type1
            {
                self.table.httpHandle.listArr = arr
            }
            
            
        case 2:
            ""
            if let arr = DataCache.Share.userMsg.users[Uid]?.type2
            {
                self.table.httpHandle.listArr = arr
            }
            
        case 3:
            ""
            if let arr = DataCache.Share.userMsg.users[Uid]?.type3
            {
                self.table.httpHandle.listArr = arr
            }
            
        default:
            ""
        }
        
        self.table.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(setData), name: NoticeWord.MsgChange.rawValue, object: nil)
        
        btn = self.addNvButton(false, img: nil, title: "编辑") {[weak self] (btn) in
            if self == nil {return}
            
            if let b = self?.inEditing
            {
                if b
                {
                    self?.doDel()
                }
                
                btn.selected = !b
                self?.inEditing = !b
            }

            self?.table.reloadData()
        }
        
        btn.setTitle("编辑", forState: .Normal)
        btn.setTitle("删除", forState: .Selected)
        
        let bgColor = "F3F5F7".color
        self.view.backgroundColor = bgColor
        self.table.backgroundColor = bgColor
        self.view.addSubview(table)
        
        table.frame = CGRectMake(0, 0, swidth, sheight-64)
        
        table.registerNib("MyMessageInfoCell".Nib, forCellReuseIdentifier: "MyMessageInfoCell")
        
        table.registerNib("MyMessageInfoCellEdit".Nib, forCellReuseIdentifier: "MyMessageInfoCellEdit")
        
        table.CellIdentifier = "MyMessageInfoCell"
        
        table.cellHeight = 155
    
        table.separatorStyle = .None
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        
        table.delegate = self
        table.dataSource = self
        
        let v = UIView()
        v.backgroundColor = UIColor.clearColor()
        v.frame = CGRectMake(0, 0, swidth, 20)
        table.tableFooterView = v
        
        table.setHandle("", pageStr: "[page]", keys: ["data","info"], model: MessageModel.self, CellIdentifier: "MyMessageInfoCell")
        
        table.hideFootRefresh()
        table.hideHeadRefresh()
        
        setData()
        
        
        
    }
    
    func doDel()
    {
        for item in selectArr
        {
            DataCache.Share.userMsg.remove(table.httpHandle.listArr[item] as! MessageModel)
        }
        
        selectArr.removeAll(keepCapacity: false)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 155
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return table.httpHandle.listArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if inEditing
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("MyMessageInfoCellEdit", forIndexPath: indexPath) as! MyMessageInfoCellEdit
            
            cell.model = table.httpHandle.listArr[indexPath.row] as! MessageModel
            
            cell.checkbox.selected = selectArr.contains(indexPath.row)
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("MyMessageInfoCell", forIndexPath: indexPath) as! MyMessageInfoCell
            
            cell.model = table.httpHandle.listArr[indexPath.row] as! MessageModel
            
            return cell

        }
        
    }
    
    var selectArr:[Int] = []
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if inEditing
        {
            if let i = selectArr.indexOf(indexPath.row)
            {
                selectArr.removeAtIndex(i)
            }
            else
            {
                selectArr.append(indexPath.row)
            }
            
            table.reloadData()
        }
        else
        {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? MyMessageInfoCell
            {
                cell.toInfoVC()
            }
        }
        
        
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return !inEditing
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(editingStyle == UITableViewCellEditingStyle.Delete)
        {
            DataCache.Share.userMsg.remove(table.httpHandle.listArr[indexPath.row] as! MessageModel)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        (self.navigationController as? XNavigationController)?.removeRecognizer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        (self.navigationController as? XNavigationController)?.setRecognizer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}
