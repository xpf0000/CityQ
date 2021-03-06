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
    
    @IBOutlet var wxBtn: UIButton!
    
    //var block:AnyBlock?
    
    func toInputNickVC(userInfo:SSDKUser,type:String)
    {
        
        var dic = ["1":"新浪微博","2":"微信","3":"QQ"]
        
        let vc = HtmlVC()
        
        vc.baseUrl = TmpDirURL
        vc.userinfo = userInfo
        
        if let u = TmpDirURL?.URLByAppendingPathComponent("unitLogin.html")
        {
            vc.url = "\(u)?header=\(userInfo.icon)&type=\(dic[type]!)&nick=\(userInfo.nickname)&openid=\(userInfo.uid)"
        }
        
        vc.hidesBottomBarWhenPushed = true
        vc.title = "联合登录"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func wxLogin(sender: AnyObject) {
        
        self.view.showWaiting()
        
        ShareSDK.getUserInfo(.TypeWechat) {[weak self] (state, userInfo, err) -> Void in
            
            if(state == SSDKResponseState.Success)
            {
                self?.otherLogin(userInfo,type: "2")
            }
            else
            {
                RemoveWaiting()
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
                    
                    print("user: \(o)")

                    DataCache.Share.userModel = UserModel.parse(json: o!["data"]["info"][0], replace: nil)
                    
                    DataCache.Share.userModel.save()
                    
                    DataCache.Share.userModel.registNotice()
                    DataCache.Share.userModel.getHFB()
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
        
        self.view.showWaiting()
        
        ShareSDK.getUserInfo(.TypeQQ) {[weak self] (state, userInfo, err) -> Void in
            
            if(state == SSDKResponseState.Success)
            {
                self?.otherLogin(userInfo,type: "3")
            }
            else
            {
                RemoveWaiting()
                ShowMessage("登录失败")
            }
        }

    }
    
    @IBAction func sina(sender: AnyObject) {
        
        self.view.showWaiting()
        
        ShareSDK.getUserInfo(.TypeSinaWeibo) {[weak self] (state, userInfo, err) -> Void in
            
            if(state == SSDKResponseState.Success)
            {
                self?.otherLogin(userInfo,type: "1")
            }
            else
            {
                RemoveWaiting()
                ShowMessage("登录失败")
            }
        }

    }
    
    func otherLogin(userInfo:SSDKUser,type:String)
    {
        
        let uid=userInfo.uid
        
        let url=APPURL+"Public/Found/?service=User.openLogin"
        let body="openid="+uid+"&type="+type
        
        print("body: \(body)")
        
        XHttpPool.requestJson(url, body: body, method: .POST, block: {[weak self] (o) -> Void in
            RemoveWaiting()
            if(o?["data"]["code"].intValue == 1)
            {

                self?.toInputNickVC(userInfo,type: type)
                
                return
            }
            
            if(o?["data"]["info"].arrayValue.count > 0)
            {
                if let mobile = o?["data"]["info"][0]["mobile"].string
                {
                    if mobile != ""
                    {

                        DataCache.Share.userModel = UserModel.parse(json: o!["data"]["info"][0], replace: nil)
                        
                        DataCache.Share.userModel.save()
                        
                        DataCache.Share.userModel.getHFB()
                        
                        DataCache.Share.userModel.registNotice()
                        NoticeWord.LoginSuccess.rawValue.postNotice()
                        
                        self?.dismissViewControllerAnimated(true, completion: { () -> Void in
                            
                            
                        })
                        
                        return
                        
                    }
                }
                
//                let u = UserModel.parse(json: o!["data"]["info"][0], replace: nil)
//                self?.toInputNickVC(nil,user: u)
                
            }
            else
            {
                ShowMessage("登录失败")
            }
            
            })
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        ShareSDK.cancelAuthorize(.TypeSinaWeibo)
        ShareSDK.cancelAuthorize(.TypeQQ)
        ShareSDK.cancelAuthorize(.TypeWechat)
        
        self.user.addEndButton()
        self.pass.addEndButton()
        
        self.user.delegate = self
        self.pass.delegate = self
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        table.tableFooterView=view1
        table.tableHeaderView=view1
        
        wxBtn.hidden = !WXApi.isWXAppInstalled()
        
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

    deinit
    {
        //print("LoginVC deinit !!!!!!!!!!")
    }

}
