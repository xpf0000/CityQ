//
//  CheckPhoneVC.swift
//  chengshi
//
//  Created by X on 15/11/29.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class CheckPhoneVC: UITableViewController,UITextFieldDelegate {
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var phone: UITextField!
    
    @IBOutlet var verCode: UITextField!
    
    @IBOutlet var cellContent: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        XVerifyButton.Share().type = 2
        
        self.phone.text = DataCache.Share().userModel.mobile
        
        XVerifyButton.Share().Phone(DataCache.Share().userModel.mobile)
        
        self.cellContent.addSubview(XVerifyButton.Share())
        
        XVerifyButton.Share().snp_makeConstraints { (make) -> Void in
            
            make.centerY.equalTo(self.cellContent)
            make.trailing.equalTo(self.cellContent).offset(-15)
            make.height.equalTo(32)
            
        }
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        table.tableFooterView=view1
        table.tableHeaderView=view1
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        return true
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row < 2)
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
        
        self.table.separatorInset=UIEdgeInsetsMake(0, swidth, 0, 0)
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                self.table.layoutMargins=UIEdgeInsetsMake(0, swidth, 0, 0)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    
    @IBAction func next(sender: AnyObject) {
        
        if(!self.verCode.checkNull())
        {
            return
        }
        
        let code=self.verCode.text!.trim()
        let phone=self.phone.text!.trim()
        
        let url=APPURL + "Public/Found/?service=User.smsVerify"
        let body="mobile="+phone+"&code="+code
        
        XHttpPool.requestJson(url, body: body, method: .POST) { (o) -> Void in
            
            
            if(o?["data"]["code"].int == 0)
            {
                let vc:ChangePassVC = "ChangePassVC".VC("User") as! ChangePassVC
                //vc.code = code
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                UIApplication.sharedApplication().keyWindow?.showAlert("验证失败", block: nil)
            }
            
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.verCode.text = ""
    }
    
    
    deinit
    {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
