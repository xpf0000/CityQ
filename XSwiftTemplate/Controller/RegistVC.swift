//
//  RegistVC.swift
//  chengshi
//
//  Created by X on 15/11/30.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class RegistVC: UITableViewController,UITextFieldDelegate {

    @IBOutlet var table: UITableView!
    
    @IBOutlet var nickName: UITextField!
    
    @IBOutlet var pass: UITextField!
    
    @IBOutlet var pass1: UITextField!
    
    
    @IBOutlet var waitActiv: UIActivityIndicatorView!
    
    @IBOutlet var button: UIButton!
    
    
    @IBOutlet var hideView: UIView!
    
    var code:String = ""
    weak var rootVC:LoginVC?
    var registPhone=""
    
    @IBAction func regist(sender: UIButton) {
        
        if(!nickName.checkNull())
        {
            return
        }
        
        if(!nickName.checkLength(2, max: 15))
        {
            UIApplication.sharedApplication().keyWindow?.showAlert("昵称为2-15位", block: nil)
            
            return
        }
        
        if (self.pass.text!) != (self.pass1.text!)
        {
            UIApplication.sharedApplication().keyWindow?.showAlert("密码和确认密码不一致", block: nil)
            
            return
        }
    
        
        self.view.endEditing(true)
        sender.enabled = false
        sender.titleLabel?.alpha = 0.0
        waitActiv.hidden = false
        waitActiv.startAnimating()
        
        let nick=self.nickName.text!.trim()
        let pass = self.pass.text!.trim()
        
        let url=APPURL+"Public/Found/?service=User.register"
        let body="mobile="+registPhone+"&nickname="+nick+"&password="+pass+"&code="+code
        
        XHttpPool.requestJson(url, body: body, method: .POST) { (o) -> Void in
            
            if(o?["data"].dictionaryValue.count > 0)
            {
                if(o!["data"]["code"].intValue == 0)
                {
                    
                    if(self.rootVC != nil)
                    {
                        self.rootVC!.user.text = self.registPhone
                        self.rootVC!.pass.text = pass
                        self.rootVC!.login(self.rootVC!.loginButton)
                    }
                    
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    
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
                self.navigationController?.view.showAlert("注册失败", block: nil)
            }
            
            
        }
        
        
    }
    
    func reSetButton()
    {
        self.waitActiv.hidden = true
        button.titleLabel?.alpha = 1.0
        
        if(self.nickName.checkLength(2, max: 15) && self.pass.checkLength(6, max: 15))
        {
            if(self.waitActiv.hidden)
            {
                self.hideView.alpha = 0.0
                self.button.enabled = true
                
            }
        }
        else
        {
            if(self.waitActiv.hidden)
            {
                self.hideView.alpha = 0.45
                self.button.enabled = false
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
        
        
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var txt=textField.text!
        txt=(txt as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if(txt.length()>15)
        {
            return false
        }
        
        
        
        if(textField == self.nickName)
        {
            if(txt.checkLength(2, max: 15) && self.pass.checkLength(6, max: 15))
            {
                if(self.waitActiv.hidden)
                {
                    self.hideView.alpha = 0.0
                    self.button.enabled = true

                }
            }
            else
            {
                if(self.waitActiv.hidden)
                {
                self.hideView.alpha = 0.45
                self.button.enabled = false
                }
            }
        }
        else
        {
            if(txt.checkLength(6, max: 15) && self.nickName.checkLength(2, max: 15))
            {
                if(self.waitActiv.hidden)
                {
                    self.hideView.alpha = 0.0
                    self.button.enabled = true
                    
                }
            }
            else
            {
                if(self.waitActiv.hidden)
                {
                self.hideView.alpha = 0.45
                self.button.enabled = false
                }
            }
        }
        
        
        
        return true
        
    }


    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        return true
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 4)
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
