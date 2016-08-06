//
//  AuthBandPhoneVC.swift
//  chengshi
//
//  Created by X on 15/12/1.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class AuthBandPhoneVC: UITableViewController,UITextFieldDelegate {
    
    @IBOutlet var cellContent: UIView!
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var pass: UITextField!
    
    @IBOutlet var pass1: UITextField!
    
    @IBOutlet var button: UIButton!
    
    @IBOutlet var waitActiv: UIActivityIndicatorView!
    
    @IBOutlet var hideView: UIView!
    
    @IBOutlet var code: UITextField!
    
    @IBOutlet var phone: UITextField!
    
    @IBAction func submit(sender: UIButton) {
        
        self.view.endEditing(true)
        
        if self.pass.text!.trim() != self.pass1.text!.trim()
        {
            ShowMessage("密码和确认密码不一致!")
            return
        }
        
        sender.enabled = false
        sender.titleLabel?.alpha = 0.0
        waitActiv.hidden = false
        waitActiv.startAnimating()
        
        let pass = self.pass.text!.trim()
        let code = self.code.text!.trim()
        let p = self.phone.text!.trim()
        
        let url=APPURL+"Public/Found/?service=User.openMobileAdd"
        let body="username="+DataCache.Share.userModel.username+"&mobile="+p+"&password="+pass+"&code="+code
        let msg="绑定成功"
        
        XHttpPool.requestJson(url, body: body, method: .POST) { (o) -> Void in
            
            if(o?["data"].dictionaryValue.count > 0)
            {
                if(o!["data"]["code"].intValue == 0)
                {
                    DataCache.Share.userModel.mobile = p
                    DataCache.Share.userModel.password = pass
                    DataCache.Share.userModel.save()
                    
                    self.navigationController?.view.showAlert(msg, block: { (o) -> Void in
                        
                        self.navigationController?.popToRootViewControllerAnimated(true)
                        
                    })
                    
                    return
                }
                else
                {
                    self.navigationController?.view.showAlert(o!["data"]["msg"].stringValue, block: nil)
                    self.reSetButton()
                    return
                }
            }
            else
            {
                self.reSetButton()
                self.navigationController?.view.showAlert("绑定失败", block: nil)
            }
            
        }
        
    }
    
    func reSetButton()
    {
        self.waitActiv.hidden = true
        button.titleLabel?.alpha = 1.0
        
        if(!self.phone.text!.match(.Phone) || code.text!.trim() == "" || !self.pass.checkLength(6, max: 15) || !self.pass1.checkLength(6, max: 15))
        {
            if(self.waitActiv.hidden)
            {
                self.hideView.alpha = 0.45
                self.button.enabled = false
            }
        }
        else
        {
            if(self.waitActiv.hidden)
            {
                self.hideView.alpha = 0.0
                self.button.enabled = true
            }
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        waitActiv.hidden = true
        self.button.enabled = false
        
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        table.tableFooterView=view1
        table.tableHeaderView=view1
        
        self.cellContent.addSubview(XVerifyButton.Share())
        
        XVerifyButton.Share().type = 1
        
        XVerifyButton.Share().snp_makeConstraints { (make) -> Void in
            
            make.centerY.equalTo(self.cellContent)
            make.trailing.equalTo(self.cellContent).offset(-15)
            make.height.equalTo(32)
            
        }
        
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var txt=textField.text!
        txt=(txt as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        
        if(textField == self.phone)
        {
            XVerifyButton.Share().Phone(txt)
        }
        
        if(txt.length()>15)
        {
            return false
        }
        
        textField.text = txt
        
        reSetButton()
        
        return false
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        
        textField.text = ""
        reSetButton()
        return false
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row < 4
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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
