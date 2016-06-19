//
//  PropertyMsgVC.swift
//  chengshi
//
//  Created by X on 16/3/28.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class PropertyMsgVC: UIViewController {
    
    let table=XTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = "F0F0F0".color
        self.title = "收件箱"
        self.addBackButton()
        
        table.frame = CGRectMake(0, 0, swidth, sheight-64)
        self.view.addSubview(table)
        
        
        table.httpHandle.url = "http://101.201.169.38/api/Public/Found/?service=Wuye.getUserNewsList&uid=\(DataCache.Share().userModel.uid)&username=\(DataCache.Share().userModel.username)"
        
        self.table.httpHandle.pageStr = "[page]"
        self.table.httpHandle.keys = ["data","info"]
        self.table.cellHeight = 100
        self.table.CellIdentifier = "PropertyMsgCell"
        self.table.httpHandle.modelClass = PropertyMsgModel.self
        self.table.show()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}
