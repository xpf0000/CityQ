//
//  PropertyPaymentVC.swift
//  chengshi
//
//  Created by X on 16/2/26.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class PropertyPaymentVC: UITableViewController {

    @IBOutlet var table: UITableView!
    
    @IBOutlet var pic: UIImageView!
    
    @IBOutlet var xiaoqu: UILabel!
    
    @IBOutlet var dizhi: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        table.tableFooterView=view1
        table.tableHeaderView=view1
        
        pic.layer.cornerRadius = swidth*0.18*0.5
        pic.layer.borderColor = UIColor.whiteColor().CGColor
        pic.layer.borderWidth = 3.0
        pic.layer.masksToBounds = true
        pic.placeholder = "defaultTx.png".image
        pic.url = DataCache.Share().userModel.headimage

        xiaoqu.text = "小区:  "+DataCache.Share().userModel.house.xiaoqu
        dizhi.text = "地址:  "+DataCache.Share().userModel.house.louhao+DataCache.Share().userModel.house.danyuan+DataCache.Share().userModel.house.louceng+DataCache.Share().userModel.house.fanghao
        
        
    }

    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row == 0 || indexPath.row == 4)
        {
            cell.separatorInset=UIEdgeInsetsMake(0, swidth, 0, 0)
            if #available(iOS 8.0, *) {
                cell.layoutMargins=UIEdgeInsetsMake(0, swidth, 0, 0)
            } else {
                // Fallback on earlier versions
            }
        }
        else
        {
            cell.separatorInset=UIEdgeInsetsMake(0, 15, 0, 0)
            if #available(iOS 8.0, *) {
                cell.layoutMargins=UIEdgeInsetsMake(0, 15, 0, 0)
            } else {
                // Fallback on earlier versions
            }
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        table.separatorInset=UIEdgeInsetsZero
        if #available(iOS 8.0, *) {
            table.layoutMargins=UIEdgeInsetsZero
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0
        {
            return swidth*0.18+84.0
        }
        
        return 70.0
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = PaymentInfoVC()
        
        switch indexPath.row
        {
        case 0:
            ""
        case 1:
            ""
            vc.type = 3
            vc.title = "水费"
        case 2:
            ""
            vc.type = 2
            vc.title = "电费"
        case 3:
            ""
            vc.type = 4
            vc.title = "停车费"
        case 4:
            ""
            vc.type = 1
            vc.title = "物业费"
        default:
            ""
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    deinit
    {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
   }
