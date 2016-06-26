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
    
    func http()
    {
        let url = "http://123.57.162.97/hfapi/Public/Found/?service=User.getMessagesList&uid=\(Uid)&username=\(Uname)&type=\(type)"
        
        XHttpPool.requestJson(url, body: nil, method: .POST) { (json) in
            
            if DataCache.Share().userMsg.users[Uid] == nil
            {
                DataCache.Share().userMsg.users[Uid]  = UserMsgModel()
            }

            
            if let arr = json?["data"]["info"].array
            {
                for item in arr
                {
                    let model =  MessageModel.parse(json: item, replace: nil)
                    
                    switch self.type {
                    case 1:
                        ""
                        DataCache.Share().userMsg.users[Uid]!.type1.append(model)
                    case 2:
                        ""
                        DataCache.Share().userMsg.users[Uid]!.type2.append(model)
                    case 3:
                        ""
                        DataCache.Share().userMsg.users[Uid]!.type3.append(model)
                    default:
                        ""
                    }
                    
                }
                
                DataCache.Share().userMsg.save()
                
                
                switch self.type {
                case 1:
                    ""
                    self.table.httpHandle.listArr = DataCache.Share().userMsg.users[Uid]!.type1
                    
                case 2:
                    ""
                    self.table.httpHandle.listArr = DataCache.Share().userMsg.users[Uid]!.type2
                    
                case 3:
                    ""
                    self.table.httpHandle.listArr = DataCache.Share().userMsg.users[Uid]!.type3
                    
                default:
                    ""
                }
                
                self.table.reloadData()
                
            }
            
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
        
        http()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

}
