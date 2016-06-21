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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBackButton()
        self.title = "我的钱包"
        
        self.view.addSubview(table)
        
        let url = "http://123.57.162.97/hfapi/Public/Found/?service=Hyk.getUserMoneys&username=\(DataCache.Share().userModel.username)&page=[page]&perNumber=20"
        
        table.frame = CGRectMake(0, 0, swidth, sheight-64.0)
        
        table.registerNib("MyWalletCell".Nib, forCellReuseIdentifier: "MyWalletCell")
        
        table.setHandle(url, pageStr: "[page]", keys: ["data","info"], model: WalletModel.self, CellIdentifier: "MyWalletCell")
        
        table.show()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }

}
