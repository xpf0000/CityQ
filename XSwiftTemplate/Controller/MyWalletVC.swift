//
//  MyWalletVC.swift
//  chengshi
//
//  Created by X on 16/6/21.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyWalletVC: UIViewController {

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
        
        
        let url = "http://123.57.162.97/hfapi/Public/Found/?service=Hyk.getUserMoneys&username=\(Uname)&page=[page]&perNumber=20&id=\(id)"
        
//        let url = "http://123.57.162.97/hfapi/Public/Found/?service=Hyk.getUserMoneys&username=\(DataCache.Share().userModel.username)&page=[page]&perNumber=20"
        
        table.frame = CGRectMake(0, 0, swidth, sheight-64.0)
        
        table.registerNib("MyWalletCell".Nib, forCellReuseIdentifier: "MyWalletCell")
        
        table.setHandle(url, pageStr: "[page]", keys: ["data","info"], model: WalletModel.self, CellIdentifier: "MyWalletCell")
        
        table.show()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }

}
