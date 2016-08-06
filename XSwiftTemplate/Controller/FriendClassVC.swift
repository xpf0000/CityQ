//
//  FriendClassVC.swift
//  chengshi
//
//  Created by X on 15/12/3.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class FriendClassVC: UITableViewController {

    
    @IBOutlet var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        self.table.tableFooterView=view1
        self.table.tableHeaderView=view1
        
        self.table.registerNib("FriendClassCell".Nib, forCellReuseIdentifier: "FriendClassCell")

    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.separatorInset=UIEdgeInsetsZero
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                cell.layoutMargins=UIEdgeInsetsZero
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
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 84
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DataCache.Share.quanCategory.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:FriendClassCell=tableView.dequeueReusableCellWithIdentifier("FriendClassCell") as! FriendClassCell
        
        cell.model = DataCache.Share.quanCategory[indexPath.row]
        
        cell.show()
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let vc:FriendClassListVC = "FriendClassListVC".VC("Friend") as! FriendClassListVC
        
        vc.classModel = DataCache.Share.quanCategory[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
