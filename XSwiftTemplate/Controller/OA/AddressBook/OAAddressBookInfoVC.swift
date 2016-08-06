//
//  OAAddressBookInfoVC.swift
//  chengshi
//
//  Created by X on 16/1/8.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class OAAddressBookInfoVC: UITableViewController,UIActionSheetDelegate {
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var nameIcon: UILabel!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var collect: UIButton!
    
    @IBOutlet var mobile: UILabel!
    
    @IBOutlet var qq: UILabel!
    
    @IBOutlet var email: UILabel!
    
    @IBOutlet var tel: UILabel!
    
    
    @IBOutlet var address: UILabel!
    
    var model:OAAddressBookModel = OAAddressBookModel()
    
    @IBAction func doCollect(sender: UIButton) {
     
        sender.selected = !sender.selected
        sender.bounceAnimation(0.8, delegate: nil)
        
        var i = 0
        var has = -1
        
        if(DataCache.Share.oaAddress.collect[DataCache.Share.oaUserModel.uid] == nil)
        {
            DataCache.Share.oaAddress.collect[DataCache.Share.oaUserModel.uid] = []
            DataCache.Share.oaAddress.collect[DataCache.Share.oaUserModel.uid]?.append(self.model)
        }
        else
        {
            for item in DataCache.Share.oaAddress.collect[DataCache.Share.oaUserModel.uid]!
            {
                if(item.id == self.model.id)
                {
                    has = i
                    break
                }
                i += 1
            }
            
            if(has>=0)
            {
                DataCache.Share.oaAddress.collect[DataCache.Share.oaUserModel.uid]!.removeAtIndex(has)
            }
            else
            {
                DataCache.Share.oaAddress.collect[DataCache.Share.oaUserModel.uid]!.append(self.model)
            }
        }
        
        
        
        DataCache.Share.oaAddress.save()
        
    }
    
    
    @IBAction func callMobil(sender: AnyObject) {
        
        if(self.model.mobile == "")
        {
            return
        }
        
        let cameraSheet=UIActionSheet()
        cameraSheet.delegate=self
        cameraSheet.addButtonWithTitle("拨打: "+self.model.mobile)
        cameraSheet.addButtonWithTitle("取消")
        cameraSheet.tag = 20
        cameraSheet.actionSheetStyle = UIActionSheetStyle.BlackTranslucent;
        cameraSheet.showInView(UIApplication.sharedApplication().keyWindow!)
        
        
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        var str = ""
        
        if(buttonIndex == 0)
        {
            if(actionSheet.tag == 20)
            {
                str="tel:"+self.model.mobile
            }
            else
            {
                str="tel:"+self.model.tel
            }
            
        }
        
        if(str.url != nil)
        {
            UIApplication.sharedApplication().openURL(str.url!)
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row == 6)
        {
            if(self.model.tel == "")
            {
                return
            }
            
            let cameraSheet=UIActionSheet()
            cameraSheet.delegate=self
            cameraSheet.addButtonWithTitle("拨打: "+self.model.tel)
            cameraSheet.addButtonWithTitle("取消")
            cameraSheet.tag = 21
            cameraSheet.actionSheetStyle = UIActionSheetStyle.BlackTranslucent;
            cameraSheet.showInView(UIApplication.sharedApplication().keyWindow!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        table.tableFooterView=view1
        table.tableHeaderView=view1
        
        nameIcon.layer.cornerRadius = 25.0
        nameIcon.layer.masksToBounds = true
        
        nameIcon.backgroundColor = (model.truename+model.fullLetter+model.id).md5.subStringToIndex(6).color
        
        nameIcon.text = model.truename.subStringToIndex(1)
        name.text = model.truename
        mobile.text = model.mobile
        qq.text = model.qq
        email.text = model.email
        tel.text = model.tel
        address.text = model.address
        
        if(DataCache.Share.oaAddress.collect[DataCache.Share.oaUserModel.uid] != nil)
        {
            var has = false
            for item in DataCache.Share.oaAddress.collect[DataCache.Share.oaUserModel.uid]!
            {
                if(item.id == self.model.id)
                {
                    has = true
                    break
                }
                
            }
            
            collect.selected = has
        }
        

        
        
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6)
        {
            cell.separatorInset=UIEdgeInsetsMake(0, 15, 0, 0)
            if(IOS_Version>=8.0)
            {
                if #available(iOS 8.0, *) {
                    cell.layoutMargins=UIEdgeInsetsMake(0, 15, 0, 0)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        else if(indexPath.row == 8)
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
        else
        {
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}
