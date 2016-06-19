//
//  PropertyPhoneVC.swift
//  chengshi
//
//  Created by X on 16/3/28.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class PropertyPhoneVC: UIViewController {

    let table=XTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = "F0F0F0".color
        self.title = "常用电话"
        self.addBackButton()
        
        table.frame = CGRectMake(0, 0, swidth, sheight-64)
        self.view.addSubview(table)
        
        table.httpHandle.url = "http://101.201.169.38/api/Public/Found/?service=Wuye.getTelList&uid=\(DataCache.Share().userModel.uid)&username=\(DataCache.Share().userModel.username)&houseid=\(DataCache.Share().userModel.house.houseid)"
        
        self.table.httpHandle.pageStr = "[page]"
        self.table.httpHandle.keys = ["data","info"]
        self.table.cellHeight = 80
        self.table.CellIdentifier = "PropertyPhoneCell"
        self.table.httpHandle.modelClass = PropertyPhoneModel.self
        self.table.show()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
