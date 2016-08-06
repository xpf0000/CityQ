//
//  MyMessageInfoVC.swift
//  chengshi
//
//  Created by X on 16/6/13.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyMessageInfoVC: UIViewController {

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
        
        let v = UIView()
        v.backgroundColor = UIColor.clearColor()
        v.frame = CGRectMake(0, 0, swidth, 20)
        table.tableFooterView = v
        
        table.setHandle("", pageStr: "[page]", keys: ["data","info"], model: MessageModel.self, CellIdentifier: "MyMessageInfoCell")
        
        table.hideFootRefresh()
        table.hideHeadRefresh()
        
        setData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

}
