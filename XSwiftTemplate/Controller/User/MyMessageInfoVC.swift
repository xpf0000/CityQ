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
    {
        didSet
        {
                
        }
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
        
        table.cellHeight = 170
    
        table.separatorStyle = .None
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        
        let v = UIView()
        v.backgroundColor = UIColor.clearColor()
        v.frame = CGRectMake(0, 0, swidth, 20)
        table.tableFooterView = v
        
        let url = "http://123.57.162.97/hfapi/Public/Found/?service=User.getMessagesList&uid=\(DataCache.Share().userModel.uid)&username=\(DataCache.Share().userModel.username)&type=\(type)"
        
        table.setHandle(url, pageStr: "[page]", keys: ["data","info"], model: MessageModel.self, CellIdentifier: "MyMessageInfoCell")
        
        table.show()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

}
