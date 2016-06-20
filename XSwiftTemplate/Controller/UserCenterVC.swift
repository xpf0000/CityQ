//
//  UserCenterVC.swift
//  chengshi
//
//  Created by X on 15/11/28.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class UserCenterVC: UITableViewController {

    @IBOutlet var pass: UILabel!
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var headW: NSLayoutConstraint!
    
    @IBOutlet var headH: NSLayoutConstraint!
    
    @IBOutlet var headPic: UIImageView!
    
    @IBOutlet var userName: UILabel!
    
    @IBOutlet var nickName: UILabel!
    
    
    func toEdit() {
        
        if(DataCache.Share().userModel.uid != "")
        {
            
            let vc:EditUserInfoVC = "EditUserInfoVC".VC("User") as! EditUserInfoVC
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            return
        }
        
        let vc:LoginVC = "LoginVC".VC("User") as! LoginVC
        let nv:XNavigationController = XNavigationController(rootViewController: vc)
        
        vc.block =
            {
                [weak self]
                (o)->Void in
                
                if(self == nil)
                {
                    return
                }
                
                self?.showInfo()
                
        }
        
        self.presentViewController(nv, animated: true) { () -> Void in
            
        }
        
    }
    
    func showInfo()
    {
        if(DataCache.Share().userModel.uid != "")
        {
            self.headPic.url = DataCache.Share().userModel.headimage
            self.userName.text = DataCache.Share().userModel.mobile
            self.nickName.text = DataCache.Share().userModel.nickname
            
            if(DataCache.Share().userModel.mobile == "")
            {
                self.userName.text = "尚未绑定手机号"
                self.pass.text = "绑定手机号"
            }
            else
            {
                self.pass.text = "修改密码"
            }
            
        }
        else
        {
            self.headPic.image = "tx.jpg".image
            self.userName.text = "点击登录"
            self.nickName.text = "登录后查看更多"
            self.pass.text = "修改密码"
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let button=UIButton(type: UIButtonType.Custom)
        button.frame=CGRectMake(0, 0, 40, 21);
        button.setTitle("设置", forState: .Normal)
        //button.titleLabel?.font = UIFont.systemFontOfSize(18.0)
        button.showsTouchWhenHighlighted = true
        button.exclusiveTouch = true
        let rightItem=UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem=rightItem;
        button.click { [weak self](btn) in
            
            let vc:ConfigVC = "ConfigVC".VC("User") as! ConfigVC
            
            self?.navigationController?.pushViewController(vc, animated: true)
 
        }
        
        
        self.navigationController?.view.window?.addSubview(XPhotoChoose.Share())
        XPhotoChoose.Share().removeFromSuperview()
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        table.tableFooterView=view1
        table.tableHeaderView=view1
        
        self.headPic.layer.borderWidth=1.0
        self.headPic.layer.borderColor="#bfbfbf".color?.CGColor
        self.headPic.layer.cornerRadius=7.0
        self.headPic.layer.masksToBounds=true
        self.headPic.placeholder = "tx.jpg".image
        
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
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
        
        switch indexPath.row
        {
        case 0:
            self.toEdit()
        case 5:
            
            if(!self.checkIsLogin())
            {
                return
            }
            
            let vc:MyCollectVC = "MyCollectVC".VC("User") as! MyCollectVC
            
            vc.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        case 2:
            
            if(!self.checkIsLogin())
            {
                return
            }
            
            let vc:MyFriendVC = MyFriendVC()
            
            vc.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            return
            
        case 3:
            
            if(!self.checkIsLogin())
            {
                return
            }
            
            let vc = "MyMessageVC".VC("User")
            
            vc.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            return
            
        case 4:
            
            if(!self.checkIsLogin())
            {
                return
            }
            
            let vc = "MyCardVC".VC("User")
            
            vc.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            return

        case 8:
            
            if(!self.checkIsLogin())
            {
                return
            }
            
            let vc = "ChangePassVC".VC("User")
            
            vc.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            return
            
        case 7 :
            ""

            
        default :
            ""
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
