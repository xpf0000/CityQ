//
//  MyMessageVC.swift
//  chengshi
//
//  Created by X on 16/6/13.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyMessageVC: UITableViewController {
    
    @IBOutlet var txt1: UILabel!
    
    @IBOutlet var txt2: UILabel!
    
    @IBOutlet var txt3: UILabel!
    

    @IBOutlet var table: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        http()
    }
    
    func http()
    {
        
        
        let url = "http://123.57.162.97/hfapi/Public/Found/?service=User.getMessagesCount&uid=\(DataCache.Share().userModel.uid)&username=\(DataCache.Share().userModel.username)&type=1"
        
        XHttpPool.requestJson(url, body: nil, method: .POST) { (json) in
            
            if let count = json?["data"]["info"][0]["count"].int
            {
                if count > 0
                {
                    self.txt1.text = "\(count)"
                }
            }
            
        }
        
        let url1 = "http://123.57.162.97/hfapi/Public/Found/?service=User.getMessagesCount&uid=\(DataCache.Share().userModel.uid)&username=\(DataCache.Share().userModel.username)&type=2"
        
        XHttpPool.requestJson(url1, body: nil, method: .POST) { (json) in
            
            if let count = json?["data"]["info"][0]["count"].int
            {
                if count > 0
                {
                    self.txt2.text = "\(count)"
                }
            }
            
        }

        
        let url2 = "http://123.57.162.97/hfapi/Public/Found/?service=User.getMessagesCount&uid=\(DataCache.Share().userModel.uid)&username=\(DataCache.Share().userModel.username)&type=3"
        
        XHttpPool.requestJson(url2, body: nil, method: .POST) { (json) in
            
            if let count = json?["data"]["info"][0]["count"].int
            {
                if count > 0
                {
                    self.txt3.text = "\(count)"
                }
            }
            
        }


        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的消息"
        self.addBackButton()

        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        table.tableFooterView=view1
        table.tableHeaderView=view1

    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0)
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                cell.layoutMargins=UIEdgeInsetsMake(0, 0, 0, 0)
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        self.table.separatorInset=UIEdgeInsetsZero
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                self.table.layoutMargins=UIEdgeInsetsZero
            } else {
                // Fallback on earlier versions
            }
        }
        
        let h = txt1.superview!.frame.size.height / 2.0
        
        txt1.superview!.layer.masksToBounds = true
        txt1.superview!.layer.cornerRadius = h
        
        txt2.superview!.layer.masksToBounds = true
        txt2.superview!.layer.cornerRadius = h
        
        txt3.superview!.layer.masksToBounds = true
        txt3.superview!.layer.cornerRadius = h
    }
    
    let arr = ["系统消息","小区消息","会员卡消息"]
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let vc = MyMessageInfoVC()
        vc.title = arr[indexPath.row]
        vc.hidesBottomBarWhenPushed = true
        vc.type = indexPath.row+1
        
        self.navigationController?.pushViewController(vc, animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
