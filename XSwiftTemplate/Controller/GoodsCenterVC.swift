//
//  GoodsCenterVC.swift
//  chengshi
//
//  Created by X on 2016/10/24.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class GoodsCenterVC: UITableViewController {

    @IBOutlet var img: UIImageView!
    
    @IBOutlet var collect: XCollectionView!
    
    @IBAction func leftClick(sender: UIButton) {
        
        
    }
    
    @IBAction func rightClick(sender: UIButton) {
        
        
    }
    
    
    var harr:[CGFloat] = [swidth*9.0/16.0,48.0,12,44,100]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return harr[indexPath.row]
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
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
       
    }
    

}
