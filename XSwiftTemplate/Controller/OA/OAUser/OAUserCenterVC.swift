//
//  OAUserCenterVC.swift
//  chengshi
//
//  Created by X on 16/1/8.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class OAUserCenterVC: UITableViewController,UITextFieldDelegate {

    @IBOutlet var table: UITableView!
    
    @IBOutlet var name: UITextField!
    
    @IBOutlet var sex: UITextField!
    
    @IBOutlet var unit: UITextField!
    
    @IBOutlet var tel: UITextField!
    
    @IBOutlet var mobile: UITextField!
    
    @IBOutlet var qq: UITextField!
    
    @IBOutlet var email: UITextField!
    
    @IBOutlet var address: UITextField!
    
    @IBAction func doLogout(sender: AnyObject)
    {
        DataCache.Share.oaUserModel = OAUserModel()
        DataCache.Share.oaUserModel.save()
        
        UMessage.removeAllTags({ (obj, remain, error) -> Void in
            
        })
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func submit(sender: UIButton)
    {
        sender.enabled = false
        self.view.showWaiting()
        
        let url="http://101.201.169.38/apioa/Public/OA/?service=User.userEdit"
        var body="username="+DataCache.Share.oaUserModel.username
        body += "&uid="+DataCache.Share.oaUserModel.uid
        body += "&tel="+tel.text!.trim()
        body += "&mobile="+mobile.text!.trim()
        body += "&qq="+qq.text!.trim()
        body += "&email="+email.text!.trim()
        body += "&address="+address.text!.trim()
        
        XHttpPool.requestJson(url, body: body, method: .POST) {[weak self] (o) -> Void in
            
            sender.enabled = true
            RemoveWaiting()
            
            if(o?["data"].dictionaryValue.count > 0)
            {
                if(o!["data"]["code"].intValue == 0)
                {
                    self?.navigationController?.view.showAlert("信息修改成功", block: nil)
                    
                    self?.getUser()
                    
                    return
                }
                
                self?.navigationController?.view.showAlert(o!["data"]["msg"].stringValue, block: nil)
                
            }
            
            self?.navigationController?.view.showAlert("信息修改失败", block: nil)
            
        }
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true
    }
    
    func getUser()
    {
        let u=DataCache.Share.oaUserModel.username
        let p=DataCache.Share.oaUserModel.pass
        
        let url="http://101.201.169.38/apioa/Public/OA/?service=User.login&username="+u+"&password="+p
        
        XHttpPool.requestJson(url, body: nil, method: .GET) {[weak self] (o) -> Void in
            
            if(o?["data"]["info"].arrayValue.count>0 && o?["data"]["code"].intValue == 0)
            {
                DataCache.Share.oaUserModel = OAUserModel.parse(json: o!["data"]["info"][0], replace: nil)
                DataCache.Share.oaUserModel.pass = p
                DataCache.Share.oaUserModel.save()

                SetUMessageTag()
                
                self?.table.reloadData()
                
                return
            }

        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        getUser()
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        table.tableFooterView=view1
        table.tableHeaderView=view1
        
        tel.addEndButton()
        mobile.addEndButton()
        qq.addEndButton()
        email.delegate = self
        address.delegate = self
        
        name.text = DataCache.Share.oaUserModel.truename
        sex.text = DataCache.Share.oaUserModel.sex == "0" ? "女" : "男"
        unit.text = DataCache.Share.oaUserModel.bm
        tel.text = DataCache.Share.oaUserModel.tel
        mobile.text = DataCache.Share.oaUserModel.mobile
        qq.text = DataCache.Share.oaUserModel.qq
        email.text = DataCache.Share.oaUserModel.email
        address.text = DataCache.Share.oaUserModel.address
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row == 0 || indexPath.row == 8 || indexPath.row == 9 || indexPath.row == 10)
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
        else if(indexPath.row >= 11)
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
        
        if(indexPath.row == 10)
        {
            let vc=OAPasswordVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    deinit
    {
        RemoveWaiting()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}
