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

    }
    
    func http()
    {
        let c1 = UMsgCount1
        let c2 = UMsgCount2
        let c3 = UMsgCount3
        
        if c1 > 0
        {
            self.txt1.text = "\(c1)"
            self.txt1.superview?.hidden = false
        }
        else
        {
            self.txt1.superview?.hidden = true
        }
        
        if c2 > 0
        {
            self.txt1.text = "\(c2)"
            self.txt1.superview?.hidden = false
        }
        else
        {
            self.txt1.superview?.hidden = true
        }
        
        if c3 > 0
        {
            self.txt1.text = "\(c3)"
            self.txt1.superview?.hidden = false
        }
        else
        {
            self.txt1.superview?.hidden = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的消息"
        self.addBackButton()
        
        self.txt1.superview?.hidden = true
        self.txt2.superview?.hidden = true
        self.txt3.superview?.hidden = true
        
        http()

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
        
        switch indexPath.row {
        case 0:
            ""
            self.txt1.superview?.hidden = true
            //self.txt2.superview?.hidden = true
            //self.txt3.superview?.hidden = true
            
        case 1:
            ""
            //self.txt1.superview?.hidden = true
            self.txt2.superview?.hidden = true
            //self.txt3.superview?.hidden = true
            
        case 2:
            ""
            //self.txt1.superview?.hidden = true
            //self.txt2.superview?.hidden = true
            self.txt3.superview?.hidden = true
            
        default:
            ""
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
