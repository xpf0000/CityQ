//
//  JifenDetailVC.swift
//  chengshi
//
//  Created by X on 2016/10/20.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class JifenDetailVC: UIViewController {

    let table = XTableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.title = "明细列表"
        self.view.backgroundColor = APPBGColor
        self.view.addSubview(table)
        table.frame = CGRectMake(0, 0, swidth, sheight-64)
        table.backgroundColor = APPBGColor
        table.cellHeight = 64
        
        let url = APPURL+"Public/Found/?service=jifen.gethfblist&uid=\(Uid)&username=\(Uname)&page=[page]&pernumber=20"
        
        table.setHandle(url, pageStr: "[page]", keys: ["data","info"], model: HFBModel.self, CellIdentifier: "JifenDetailCell")
        
        table.show()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    


}
