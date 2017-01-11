//
//  AuthBandPhoneVC.swift
//  chengshi
//
//  Created by X on 15/12/1.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class AuthBandPhoneVC: UITableViewController,UITextFieldDelegate {
    
    @IBOutlet var nickname: UITextField!
    
    @IBOutlet var cellContent: UIView!
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var pass: UITextField!
    
    @IBOutlet var pass1: UITextField!
    
    @IBOutlet var button: UIButton!
    
    @IBOutlet var waitActiv: UIActivityIndicatorView!
    
    @IBOutlet var hideView: UIView!
    
    @IBOutlet var code: UITextField!
    
    @IBOutlet var phone: UITextField!
    
    var userinfo:SSDKUser!
    var type:String  = ""
    
    
    @IBAction func submit(sender: UIButton) {
        
        self.view.endEditing(true)
        
        if(!nickname.checkLength(3, max: 12))
        {
            
            ShowMessage("昵称为3-12位")
            
            return
        }
        
        if self.pass.text!.trim() != self.pass1.text!.trim()
        {
            ShowMessage("密码和确认密码不一致!")
            return
        }
        
        sender.enabled = false
        sender.titleLabel?.alpha = 0.0
        waitActiv.hidden = false
        waitActiv.startAnimating()
        
        self.doRegist()
        
    }
    
    func doRegist()
    {
    
        XWaitingView.show()
        
        let nick = self.nickname.text!.trim()
        let sex=userinfo.gender.rawValue == 0 ? 1 : 0
        let p = phone.text!.trim()
        let pass = self.pass.text!.trim()
        let code = self.code.text!.trim()
        
        let url=APPURL+"Public/Found/?service=User.openRegister"
        
        let body = "openid=\(userinfo.uid)&type=\(type)&nickname=\(nick)&sex=\(sex)&headimage=\(userinfo.icon)&mobile=\(p)&password=\(pass)&code=\(code)"
        
        XHttpPool.requestJson(url, body: body, method: .POST) { [weak self](o) -> Void in
            
            XWaitingView.hide()
            
            if let code = o?["data"]["code"].int
            {
                if code == 0
                {

                    DataCache.Share.userModel = UserModel.parse(json: o!["data"]["info"][0], replace: nil)
                    
                    DataCache.Share.userModel.save()
                    
                    DataCache.Share.userModel.registNotice()
                    DataCache.Share.userModel.getHFB()
                    NoticeWord.LoginSuccess.rawValue.postNotice()
                    
                    self?.dismissViewControllerAnimated(true, completion: { () -> Void in
                        
                        
                    })
                    
                    return
                    
                }
                else
                {
                    self?.reSetButton()
                    ShowMessage(o!["data"]["msg"].stringValue)
                }
                
            }
            else
            {
                self?.reSetButton()
                ShowMessage("注册失败")
            }
            
        }
    }

    
    func reSetButton()
    {
        self.waitActiv.hidden = true
        button.titleLabel?.alpha = 1.0
        
        let b = self.pass.checkLength(3, max: 12)
        
        if(!self.phone.text!.match(.Phone) || code.text!.trim() == "" || !self.pass.checkLength(6, max: 15) || !self.pass1.checkLength(6, max: 15) || !b)
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
        
        let block:XTextChangeBlock = {[weak self] (tf,str) in
            
            if tf == self?.phone
            {
                XVerifyButton.Share().Phone(str)
            }
            
            self?.reSetButton()
            
        }
        
        nickname.onTextChange(block)
        pass.onTextChange(block)
        pass1.onTextChange(block)
        code.onTextChange(block)
        phone.onTextChange(block)
        
        
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var txt=textField.text!
        txt=(txt as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if(txt.length()>15)
        {
            return false
        }
        
        return true
        
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
    
    var harr:[CGFloat] = [55.0,55.0,55.0,55.0,55.0,90.0]
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return harr[indexPath.row]
        
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
    
    deinit {
        
        print("AuthBandPhoneVC deinit !!!!!!!!!!")
        
    }
    
    
}
