//
//  passwordVC.swift
//  OA
//
//  Created by X on 15/4/28.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit

class OAPasswordVC: UIViewController,UITableViewDataSource,UITableViewDelegate,commonDelegate,UITextFieldDelegate{
    
    var oldPass:UITextField=UITextField()
    var newPass:UITextField=UITextField()
    var newPass1:UITextField=UITextField()
    var txtArr:Array<String>=["原密码","新密码","确认新密码"]
    var newp=""
    let table=UITableView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.title="修改密码"
        self.navigationItem.hidesBackButton=true
        
        let user=UIButton()
        user.frame=CGRectMake(10, 2, 25, 25);
        user.setBackgroundImage("back.png".image, forState: UIControlState.Normal)
        user.showsTouchWhenHighlighted = true
        user.addTarget(self, action: Selector("back"), forControlEvents: UIControlEvents.TouchUpInside)
        let leftitem=UIBarButtonItem(customView: user)
        self.navigationItem.leftBarButtonItem=leftitem;
        
        let submit=UIButton()
        submit.frame=CGRectMake(10, 2, 50, 25);
        submit.setTitle("确定", forState: UIControlState.Normal)
        submit.setTitleColor(腾讯颜色.图标蓝.rawValue.color, forState: UIControlState.Normal)
        submit.showsTouchWhenHighlighted = true
        submit.addTarget(self, action: #selector(OAPasswordVC.submit(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let rightItem=UIBarButtonItem(customView: submit)
        self.navigationItem.rightBarButtonItem=rightItem;
        
    }
    
    func submit(sender:UIButton)
    {
        sender.enabled = false
        var oldp=oldPass.text!.trim() as NSString
        var p=newPass.text!.trim() as NSString
        var p1=newPass1.text!.trim() as NSString
        
        oldp=oldp.stringByReplacingOccurrencesOfString(" ", withString: "")
        p=p.stringByReplacingOccurrencesOfString(" ", withString: "")
        p1=p1.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        if(oldp.length==0 || p.length==0 || p1.length==0)
        {
            let alertView = UIAlertView()
            alertView.delegate = self
            alertView.message = "原密码和新密码不能为空"
            alertView.addButtonWithTitle("确定")
            alertView.show()
            return
        }
        
        if(!p.isEqualToString(p1 as String))
        {
            let alertView = UIAlertView()
            alertView.delegate = self
            alertView.message = "新密码和确认密码不一致"
            alertView.addButtonWithTitle("确定")
            alertView.show()
            return

        }
        
        if(oldp.length<6 || oldp.length>16 || p.length<6 || p1.length<6 || p.length>16 || p1.length>16)
        {
            let alertView = UIAlertView()
            alertView.delegate = self
            alertView.message = "密码应为6到16位"
            alertView.addButtonWithTitle("确定")
            alertView.show()
            return
            
        }
        
        newp=p as String
        
        let url=WapUrl+"/apioa/Public/OA/?service=User.updatePass"
        let body="username="+DataCache.Share.oaUserModel.username+"&password="+(oldp as String)+"&newpassword="+newp
        
        XHttpPool.requestJson(url, body: body, method: .POST) {[weak self] (o) -> Void in
            
            if(o?["data"].dictionaryValue.count > 0)
            {
                if(o!["data"]["code"].intValue == 0)
                {
                    DataCache.Share.oaUserModel.pass = oldp as String
                    DataCache.Share.oaUserModel.save()
                    
                    self?.view.showAlert("修改密码成功", block: { (o) -> Void in
                        
                        self?.navigationController?.popViewControllerAnimated(true)
                    })
                }
                else
                {
                    sender.enabled = true
                    self?.view.showAlert(o!["data"]["msg"].stringValue, block: nil)
                }
            }
            else
            {
                sender.enabled = true
                self?.view.showAlert("修改密码失败", block: nil)
            }
            
        }
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        self.view.backgroundColor="#f2f2f2".color
        
        let frame=CGRectMake(130, 5, swidth-130-20, 60)
        oldPass.frame=frame
        newPass.frame=frame
        newPass1.frame=frame
        
        oldPass.delegate=self
        newPass.delegate=self
        newPass1.delegate=self
        
        oldPass.font=UIFont.systemFontOfSize(14.5)
        newPass.font=UIFont.systemFontOfSize(14.5)
        newPass1.font=UIFont.systemFontOfSize(14.5)
        
        oldPass.secureTextEntry=true
        newPass.secureTextEntry=true
        newPass1.secureTextEntry=true
        
        oldPass.placeholder="请输入原登录密码"
        newPass.placeholder="6-16位,建议由字母和数字组成"
        newPass1.placeholder="请再次输入新密码"
        
        oldPass.clearButtonMode=UITextFieldViewMode.WhileEditing
        newPass.clearButtonMode=UITextFieldViewMode.WhileEditing
        newPass1.clearButtonMode=UITextFieldViewMode.WhileEditing

        table.frame=CGRectMake(0, 15, swidth, 70*3)
        table.dataSource=self
        table.delegate=self
        table.backgroundColor=UIColor.clearColor()
        table.showsHorizontalScrollIndicator=false
        table.showsVerticalScrollIndicator=false
        table.allowsSelection=false
        table.bounces=false
        let view=UIView()
        view.backgroundColor=UIColor.whiteColor()
        
        table.tableFooterView=view
        table.tableHeaderView=view
        
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(table)
        
        
        self.view.addSubview(oldPass)
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 70.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellIdentifier="cell"
        
        let cell:UITableViewCell=tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) 
        
       let label=UILabel(frame: CGRectMake(0, 0, 120, 70))
        label.text=txtArr[indexPath.row]
        label.font=UIFont.systemFontOfSize(18)
        label.textAlignment=NSTextAlignment.Right
        
        cell.contentView.addSubview(label)
        
        switch indexPath.row
        {
            case 0:
                cell.contentView.addSubview(oldPass)
            case 1:
                cell.contentView.addSubview(newPass)
            case 2:
                cell.contentView.addSubview(newPass1)
            default:
            ""
        }
        
        return cell
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if(textField==newPass1)
        {
            self.table.setContentOffset(CGPointMake(0, 70), animated: true)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if(textField==newPass1)
        {
            self.table.setContentOffset(CGPointMake(0, 0), animated: true)
        }
    }
    

    deinit
    {

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

