//
//  CardJifenRecordVC.swift
//  chengshi
//
//  Created by X on 16/6/21.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class CardJifenRecordVC: UIViewController {
    
    let table = XTableView()
    
    var id = "0"
    
    var ctitle = "我的钱包"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let color = "F3F5F7".color
        
        self.addBackButton()
        self.title = ctitle
        self.view.backgroundColor = color
        table.backgroundColor = color
        table.separatorStyle = .None
        self.view.addSubview(table)
        
        
        let url = APPURL + "Public/Found/?service=hyk.getCardjf&username=\(Uname)&page=[page]&perNumber=20&id=\(id)"
        
        table.frame = CGRectMake(0, 0, swidth, sheight-64.0)
        
        table.setHandle(url, pageStr: "[page]", keys: ["data","info"], model: JifenRecordModel.self, CellIdentifier: "MyJifenRecordCell")
        
        table.show()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
}
