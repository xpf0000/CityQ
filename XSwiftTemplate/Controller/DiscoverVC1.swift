//
//  DiscoverVC1.swift
//  chengshi
//
//  Created by X on 15/12/6.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class DiscoverVC1: UITableViewController {

    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if(indexPath.row == 0)
        {
            //let vc:FrientVC = "FrientVC".VC as! FrientVC
            let vc:PhoneVC = "PhoneVC".VC as! PhoneVC
            vc.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if(indexPath.row == 1)
        {
            let vc:DiscountVC = "DiscountVC".VC("Discount") as! DiscountVC
            vc.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if(indexPath.row == 2)
        {
            if !checkIsLogin()
            {
                return
            }
            
            if DataCache.Share.userModel.truename == ""
            {
                 UIApplication.sharedApplication().keyWindow?.showAlert("请先设置你的真实姓名", block: { (o) -> Void in
                    
                    let vc:EditUserInfoVC = "EditUserInfoVC".VC("User") as! EditUserInfoVC
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                 })
                
                return
            }
            
            if DataCache.Share.userModel.mobile == ""
            {
                UIApplication.sharedApplication().keyWindow?.showAlert("请先绑定手机号", block: { (o) -> Void in
                    
                    let vc = "AuthBandPhoneVC".VC("User")
                    
                    vc.hidesBottomBarWhenPushed = true
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                })
                
                return
            }

            DataCache.Share.userModel.house.checkStatus(false)
            let vc = PropertyIndexVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
            
            
        }
        else if(indexPath.row == 4)
        {
            if(DataCache.Share.oaUserModel.uid == "")
            {
                let vc:OALoginVC = OALoginVC()
                let nv:XNavigationController = XNavigationController(rootViewController: vc)
                
                vc.block = {
                    [weak self]
                    (o)->Void in
                    
                    if(DataCache.Share.oaUserModel.uid != "")
                    {
                        let vc:WorksVC = WorksVC()
                        vc.hidesBottomBarWhenPushed=true
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
                self.presentViewController(nv, animated: true, completion: { () -> Void in
                    
                    
                })
            }
            else
            {
                let vc:WorksVC = WorksVC()
                vc.hidesBottomBarWhenPushed=true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}
