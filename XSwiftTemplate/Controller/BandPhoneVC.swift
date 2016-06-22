//
//  BandPhoneVC.swift
//  chengshi
//
//  Created by X on 15/11/29.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class BandPhoneVC: UITableViewController,UITextFieldDelegate {

    @IBOutlet var table: UITableView!
    
    @IBOutlet var phone: UITextField!
    
    @IBOutlet var verCode: UITextField!
    
    @IBOutlet var cellContent: UIView!
    
    weak var rootVC:LoginVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.phone.addEndButton()
        
        self.cellContent.addSubview(XVerifyButton.Share())
        
        XVerifyButton.Share().type = 1
        
        XVerifyButton.Share().snp_makeConstraints { (make) -> Void in

            make.centerY.equalTo(self.cellContent)
            make.trailing.equalTo(self.cellContent).offset(-15)
            make.height.equalTo(32)
            
        }
        
        XVerifyButton.Share().block={
            [weak self]
            (o)->Void in
            if(self != nil)
            {
                self?.phone.enabled = false
            }
        }
        
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        table.tableFooterView=view1
        table.tableHeaderView=view1
        
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == self.phone)
        {
            var txt=textField.text!
            txt=(txt as NSString).stringByReplacingCharactersInRange(range, withString: string)
            XVerifyButton.Share().Phone(txt)
        }
        
        
        
        return true
        
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
        
        let url=APPURL+"Public/Found/?service=User.smsVerify"
        let body="mobile="+phone+"&code="+code
        
        XHttpPool.requestJson(url, body: body, method: .POST) { (o) -> Void in
            
            
            if(o?["data"]["code"].intValue == 0)
            {
                let vc:RegistVC = "RegistVC".VC("User") as! RegistVC
                vc.code = code
                vc.registPhone = phone
                vc.rootVC = self.rootVC
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
        
        self.phone.text = ""
        self.phone.enabled = true
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
