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
    
    var type = 1
    
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
        
        self.addNvButton(false, img: nil, title: "清空") {[weak self] (btn) in
            if self == nil {return}
            DataCache.Share.userMsg.clear(self!.type)
            self?.table.httpHandle.listArr.removeAll(keepCapacity: false)
            self?.table.reloadData()
        }
        
        let bgColor = "F3F5F7".color
        self.view.backgroundColor = bgColor
        self.table.backgroundColor = bgColor
        self.view.addSubview(table)
        
        table.frame = CGRectMake(0, 0, swidth, sheight-64)
        
        table.registerNib("MyMessageInfoCell".Nib, forCellReuseIdentifier: "MyMessageInfoCell")
        
        table.CellIdentifier = "MyMessageInfoCell"
        
        table.cellHeight = 155
    
        table.separatorStyle = .None
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        
        table.Delegate(self)
        table.DataSource(self)
        
        let v = UIView()
        v.backgroundColor = UIColor.clearColor()
        v.frame = CGRectMake(0, 0, swidth, 20)
        table.tableFooterView = v
        
        table.setHandle("", pageStr: "[page]", keys: ["data","info"], model: MessageModel.self, CellIdentifier: "MyMessageInfoCell")
        
        table.hideFootRefresh()
        table.hideHeadRefresh()
        
        setData()
        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(editingStyle == UITableViewCellEditingStyle.Delete)
        {
            DataCache.Share.userMsg.remove(table.httpHandle.listArr[indexPath.row] as! MessageModel)
            table.httpHandle.listArr.removeAtIndex(indexPath.row)
            
            table.reloadData()
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
    

}
