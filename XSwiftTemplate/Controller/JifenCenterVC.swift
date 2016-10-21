//
//  JifenCenterVC.swift
//  chengshi
//
//  Created by X on 2016/10/20.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class JifenCenterVC: UITableViewController {

    @IBOutlet var tatle: UILabel!
    
    @IBOutlet var num: UILabel!
    
    @IBOutlet var state: UILabel!
    
    @IBOutlet var stateIcon: UIImageView!
    
    @IBOutlet var collect: XCollectionView!
    
    var harr:[CGFloat] = [48,140,12,44,44,44,12,44,100]
    
    
    @IBAction func toDetail(sender: UIButton) {
        
        let vc = JifenDetailVC()
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return harr[indexPath.row]
    }
    
  
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 3 || indexPath.row == 4
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
      
        self.tableView.separatorInset=UIEdgeInsetsMake(0, swidth, 0, 0)
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                self.tableView.layoutMargins=UIEdgeInsetsMake(0, swidth, 0, 0)
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
