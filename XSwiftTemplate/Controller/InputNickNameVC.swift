//
//  InputNickNameVC.swift
//  chengshi
//
//  Created by X on 15/12/1.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class InputNickNameVC: UITableViewController {
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var nickName: UITextField!
    
    @IBOutlet var button: UIButton!
    
    @IBOutlet var waitActiv: UIActivityIndicatorView!
    
    @IBOutlet var hideView: UIView!
    
    var body = ""
    
    @IBAction func submit(sender: UIButton) {
        
        self.view.endEditing(true)

        if(!nickName.checkNull())
        {
            return
        }
        
        if(!nickName.checkLength(2, max: 15))
        {
            UIApplication.sharedApplication().keyWindow?.showAlert("昵称为2-15位", block: nil)
            
            return
        }

        
        let nick = self.nickName.text!.trim()
        
        self.body += "&nickname="+nick
        
        sender.enabled = false
        sender.titleLabel?.alpha = 0.0
        waitActiv.hidden = false
        waitActiv.startAnimating()
        
        doRegist()
        
    }
    
    func doRegist()
    {
        
        let url=APPURL+"Public/Found/?service=User.openRegister"
        XHttpPool.requestJson(url, body: body, method: .POST) { (o) -> Void in
            
            if let code = o?["data"]["code"].int
            {
                if code == 0
                {

                    DataCache.Share.userModel = UserModel.parse(json: o!["data"]["info"][0], replace: nil)
                    
                    DataCache.Share.userModel.save()
                    
                    NoticeWord.LoginSuccess.rawValue.postNotice()
                    
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        
                    })
                    
                    return

                }
                else
                {
                    ShowMessage(o!["data"]["msg"].stringValue)
                }
                
            }
            else
            {
                ShowMessage("注册失败")
            }
            
            self.reSetButton()
            
        }
    }

    
    func reSetButton()
    {
        self.waitActiv.hidden = true
        self.waitActiv.stopAnimating()
        button.titleLabel?.alpha = 1.0
        
        if(!self.nickName.checkLength(2, max: 15) )
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
    
    func textChange(notic:NSNotification)
    {
        if let t = notic.object as? UITextField
        {
            if let _ = t.markedTextRange
            {
//                if let _ = t.positionFromPosition(rang.start, offset: 0)
//                {
//                    print("nickName000: \(nickName.text)")
//                    reSetButton()
//                }
//                else
//                {
//                    print("nickName111: \(nickName.text)")
//                    reSetButton()
//                }
            }
            else
            {
                //print("nickName222: \(nickName.text)")
                reSetButton()
            }
            
        }
  
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(textChange(_:)), name: UITextFieldTextDidChangeNotification, object: nil)
        
        waitActiv.hidden = true
        self.button.enabled = false
        
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        table.tableFooterView=view1
        table.tableHeaderView=view1
        
        
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        return true
        
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        
        textField.text = ""
        reSetButton()
        
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        return true
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row < 1
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
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        //print("InputNickNameVC deinit !!!!!!!!!!")
    }
    
    
}
