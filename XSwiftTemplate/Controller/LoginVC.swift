//
//  LoginVC.swift
//  chengshi
//
//  Created by X on 15/11/28.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class LoginVC: UITableViewController,UITextFieldDelegate {

    @IBOutlet var table: UITableView!
    
    @IBOutlet var user: UITextField!
    
    @IBOutlet var pass: UITextField!
    
    @IBOutlet var loginIcon: UIActivityIndicatorView!
    
    @IBOutlet var loginButton: UIButton!
    
    var block:AnyBlock?
    
    
    @IBAction func wxLogin(sender: AnyObject) {
        
        ShareSDK.getUserInfoWithType(ShareTypeWeixiTimeline, authOptions: nil) { [weak self](result, userInfo, err) -> Void in
            
            if(result)
            {
                let uid=userInfo.uid()
                
                let url=APPURL+"Public/Found/?service=User.openLogin"
                let body="openid="+uid
                
                XHttpPool.requestJson(url, body: body, method: .POST, block: {[weak self] (o) -> Void in
                    
                    if(o?["data"]["code"].intValue == 1)
                    {
                        let nick=userInfo.nickname()
                        let sex=userInfo.gender() == 0 ? 1 : 0
                        let headimage=userInfo.profileImage()
                        let rbody="openid="+uid+"&nickname="+nick+"&sex=\(sex)&headimage="+headimage
                        
                        self?.doRegist(rbody)
                        return
                    }
                    
                    if(o?["data"]["info"].arrayValue.count > 0)
                    {
                        DataCache.Share().userModel = UserModel.parse(json: o!["data"]["info"][0], replace: nil)
                        
                        DataCache.Share().userModel.save()
                        
                        if(self?.block != nil)
                        {
                            self?.block!("loginSuccess")
                        }
                        
                        NoticeWord.LoginSuccess.rawValue.postNotice()
                        
                        self?.dismissViewControllerAnimated(true, completion: { () -> Void in
                            
                            
                        })
                        
                    }
                    else
                    {
                        ShowMessage("登录失败")
                    }
                    
                    })
            }
            else
            {
                ShowMessage("登录失败")
            }
        }
        
    }
    
    
    
    @IBAction func login(sender: AnyObject) {
        
        if(!user.checkNull() || !pass.checkNull())
        {
            return
        }
        
        self.view.endEditing(true)
        
        self.loginButton.enabled = false
        self.loginIcon.startAnimating()
        UIView.animateWithDuration(0.25) { () -> Void in
            
            self.loginButton.titleLabel?.alpha = 0.0
            self.loginIcon.alpha = 1.0
            
        }
        
        let url=APPURL+"Public/Found/?service=User.login"
        let p = pass.text!.trim()
        let u = user.text!.trim()
        let body="password="+p+"&mobile="+u
        
        XHttpPool.requestJson(url, body: body, method: .POST) { (o) -> Void in
            
            if(o?["data"].dictionaryValue.count > 0)
            {
                if(o!["data"]["code"].intValue == 0 && o?["data"]["info"].arrayValue.count > 0)
                {
                    
                    DataCache.Share().userModel = UserModel.parse(json: o!["data"]["info"][0], replace: nil)
                    DataCache.Share().userModel.password = p
                    
                    DataCache.Share().userModel.save()
                    
                    if(self.block != nil)
                    {
                        self.block!("loginSuccess")
                    }
                    
                    NoticeWord.LoginSuccess.rawValue.postNotice()
                    
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        
                        
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
                self.navigationController?.view.showAlert("登录失败", block: nil)
            }
 
        }
        
        
        
    }
    
    func reSetButton()
    {
        self.loginButton.titleLabel?.alpha = 1.0
        self.loginIcon.alpha = 0.0
        self.loginIcon.stopAnimating()
        self.loginButton.enabled = true
    }
    
    @IBAction func regist(sender: AnyObject) {
        
        let vc:BandPhoneVC = "BandPhoneVC".VC("User") as! BandPhoneVC
        vc.rootVC = self
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func forget(sender: AnyObject) {
     
        let vc = "FindBackPassVC".VC("User")
        
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func QQ(sender: AnyObject) {
        
        ShareSDK.getUserInfoWithType(ShareTypeQQSpace, authOptions: nil) { [weak self](result, userInfo, err) -> Void in
            
            if(result)
            {
                let uid=userInfo.uid()
                
                let url=APPURL+"Public/Found/?service=User.openLogin"
                let body="openid="+uid
                
                XHttpPool.requestJson(url, body: body, method: .POST, block: {[weak self] (o) -> Void in
                    
                    if(o?["data"]["code"].intValue == 1)
                    {
                        let nick=userInfo.nickname()
                        let sex=userInfo.gender() == 0 ? 1 : 0
                        let headimage=userInfo.profileImage()
                        let rbody="openid="+uid+"&nickname="+nick+"&sex=\(sex)&headimage="+headimage
                        
                        self?.doRegist(rbody)
                        return
                    }
                    
                    if(o?["data"]["info"].arrayValue.count > 0)
                    {
                        DataCache.Share().userModel = UserModel.parse(json: o!["data"]["info"][0], replace: nil)
                        
                        DataCache.Share().userModel.save()
                        
                        if(self?.block != nil)
                        {
                            self?.block!("loginSuccess")
                        }
                        
                        NoticeWord.LoginSuccess.rawValue.postNotice()
                        
                        self?.dismissViewControllerAnimated(true, completion: { () -> Void in
                            
                            
                        })
                        
                    }
                    else
                    {
                        ShowMessage("登录失败")
                    }
                    
                })
            }
            else
            {
                ShowMessage("登录失败")
            }
        }

    }
    
    @IBAction func sina(sender: AnyObject) {
        
        
        ShareSDK.getUserInfoWithType(ShareTypeSinaWeibo, authOptions: nil) { (result, userInfo, err) -> Void in
            
            if(result)
            {
                let uid=userInfo.uid()
                
                let url=APPURL+"Public/Found/?service=User.openLogin"
                let body="openid="+uid
                
                XHttpPool.requestJson(url, body: body, method: .POST, block: {[weak self] (o) -> Void in
                    
                    if(o?["data"]["code"].intValue == 1)
                    {
                        let nick=userInfo.nickname()
                        let sex=userInfo.gender() == 0 ? 1 : 0
                        let headimage=userInfo.profileImage()
                        let rbody="openid="+uid+"&nickname="+nick+"&sex=\(sex)&headimage="+headimage
                        
                        self?.doRegist(rbody)
                        return
                    }
                    
                    if(o?["data"]["info"].arrayValue.count > 0)
                    {
                        DataCache.Share().userModel = UserModel.parse(json: o!["data"]["info"][0], replace: nil)
                        
                        DataCache.Share().userModel.save()
                        
                        if(self?.block != nil)
                        {
                            self?.block!("loginSuccess")
                        }
                        
                        NoticeWord.LoginSuccess.rawValue.postNotice()
                        
                        self?.dismissViewControllerAnimated(true, completion: { () -> Void in
                            
                            
                        })
                        
                    }
                    else
                    {
                        ShowMessage("登录失败")
                    }
                    
                    })
            }
            else
            {
                ShowMessage("登录失败")
            }
        }

        
        
    }
    
    func doRegist(body:String)
    {
        let url=APPURL+"Public/Found/?service=User.openRegister"
        XHttpPool.requestJson(url, body: body, method: .POST) { (o) -> Void in
            
            if(o?["data"]["info"].arrayValue.count > 0)
            {
                DataCache.Share().userModel = UserModel.parse(json: o!["data"]["info"][0], replace: nil)
                
                DataCache.Share().userModel.save()
                
                if(self.block != nil)
                {
                    self.block!("loginSuccess")
                }
                
                NoticeWord.LoginSuccess.rawValue.postNotice()
                
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                    
                })

            }
            else
            {
                ShowMessage("登录失败")
            }
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBackButton()
        
        self.user.addEndButton()
        self.pass.addEndButton()
        
        self.user.delegate = self
        self.pass.delegate = self
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        table.tableFooterView=view1
        table.tableHeaderView=view1
        
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if(textField == self.user)
        {
            self.pass.becomeFirstResponder()
        }
        else
        {
            self.login(self.loginButton)
        }
        
        return true
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row == 0)
        {
            cell.separatorInset=UIEdgeInsetsMake(0, 20, 0, 20)
            if(IOS_Version>=8.0)
            {
                if #available(iOS 8.0, *) {
                    cell.layoutMargins=UIEdgeInsetsMake(0, 20, 0, 20)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        else if(indexPath.row == 1)
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.user.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}
