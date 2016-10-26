//
//  CardTimesChongzhiVC.swift
//  chengshi
//
//  Created by X on 2016/10/26.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class CardTimesChongzhiVC: UITableViewController {
    
    @IBOutlet var btn1: UIButton!
    
    @IBOutlet var btn2: UIButton!
    
    @IBOutlet var btn4: UIButton!
    
    @IBOutlet var btn5: UIButton!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var num: UILabel!
    
    @IBAction func choose(sender: UIButton) {
        
        selectBtn?.selected = false
        sender.selected = true
        selectBtn = sender
        
    }
    
    var model:CardModel?
    
    var selectBtn:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        let arr = [btn1,btn2,btn4,btn5]
        
        for item in arr
        {
            item.layer.masksToBounds = true
            item.layer.cornerRadius = 8.0
            item.layer.borderColor = APPBlueColor.CGColor
            item.layer.borderWidth = 1.0
            
            item.setTitleColor(APPBlueColor, forState: .Normal)
            item.setTitleColor(UIColor.whiteColor(), forState: .Selected)
            
            item.setBackgroundImage(APPBlueColor.image, forState: .Selected)
            item.setBackgroundImage(UIColor.whiteColor().image, forState: .Normal)
        }
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        tableView.tableFooterView=view1
        tableView.tableHeaderView=view1
        
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row == 0 || indexPath.row == 7)
        {
            cell.separatorInset=UIEdgeInsetsMake(0, 15, 0, 15)
            if(IOS_Version>=8.0)
            {
                if #available(iOS 8.0, *) {
                    cell.layoutMargins=UIEdgeInsetsMake(0, 15, 0, 15)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        else
        {
            cell.separatorInset=UIEdgeInsetsMake(0, swidth, 0, 0)
            if(IOS_Version>=8.0)
            {
                if #available(iOS 8.0, *) {
                    cell.layoutMargins=UIEdgeInsetsMake(0, swidth, 0, 0)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        self.tableView.separatorInset=UIEdgeInsetsZero
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                self.tableView.layoutMargins=UIEdgeInsetsZero
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
