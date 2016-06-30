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
        view1.frame = CGRectMake(0, 0, swidth, 0.01)
        table.tableHeaderView=view1
        
        let view2=UIView()
        view2.backgroundColor=UIColor.clearColor()
        view2.frame = CGRectMake(0, 0, swidth, 50.0)
        table.tableFooterView=view2
        
        
        self.headPic.layer.borderWidth=1.0
        self.headPic.layer.borderColor="#bfbfbf".color?.CGColor
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
        
        self.headPic.layer.cornerRadius=headPic.frame.size.width/2.0
        
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
        
        if indexPath.row > 1 && indexPath.row < 9 && indexPath.row != 7
        {
            if(!self.checkIsLogin())
            {
                return
            }
        }
        
        switch indexPath.row
        {
        case 0:
            self.toEdit()
        case 2:
            
            let vc:MyFriendVC = MyFriendVC()
            
            vc.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            return
            
        case 3:
            
            let vc = "MyMessageVC".VC("User")
            
            vc.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            return
            
        case 4:
            
            let vc = "MyCardVC".VC("User") as!  MyCardVC
            
            vc.hidesBottomBarWhenPushed = true
            
            vc.tabbar = self.tabBarController
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            return
            
        case 5:
            
            let vc:MyCollectVC = "MyCollectVC".VC("User") as! MyCollectVC
            
            vc.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 6:
            
            let vc:MyWalletVC = MyWalletVC()
            
            vc.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(vc, animated: true)

        case 8:
            
            if(DataCache.Share().userModel.mobile == "")
            {
                let vc = "AuthBandPhoneVC".VC("User")
                
                vc.hidesBottomBarWhenPushed = true
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let vc = "ChangePassVC".VC("User")
                
                vc.hidesBottomBarWhenPushed = true
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
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
