//
//  UserCenterVC.swift
//  chengshi
//
//  Created by X on 15/11/28.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class UserCenterVC: UITableViewController {
    
    
    @IBOutlet weak var msgicon: UIImageView!
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var headW: NSLayoutConstraint!
    
    @IBOutlet var headH: NSLayoutConstraint!
    
    @IBOutlet var headPic: UIImageView!
    
    @IBOutlet var userName: UILabel!
    
    @IBOutlet var nickName: UILabel!
    
    @IBOutlet var leftnum: UILabel!
    
    @IBOutlet var rightnum: UILabel!
    
    @IBAction func leftClick(sender: UIButton) {
        
        if(!self.checkIsLogin())
        {
            return
        }
        
        let vc = "JifenCenterMainVC".VC("Jifen")
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func rightClick(sender: UIButton) {
        
        if(!self.checkIsLogin())
        {
            return
        }
        
        if DataCache.Share.userModel.orqd == 1
        {
            let vc = HtmlVC()
            
            vc.baseUrl = TmpDirURL
            
            if let u = TmpDirURL?.URLByAppendingPathComponent("index.html")
            {
                vc.url = "\(u)?uid=\(Uid)&uname=\(Uname)"
            }
            
            vc.hidesBottomBarWhenPushed = true
            vc.title = "每日签到"
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            return
        }
        
        sender.enabled = false
        
        let url = APPURL + "Public/Found/?service=jifen.addQiandao&uid=\(Uid)&username=\(Uname)"
        
        XHttpPool.requestJson(url, body: nil, method: .POST) { (o) in
            
            print("签到结果: \(o)")
            
            if o?["data"]["code"].int == 0
            {
                QDSuccessAlert()
                self.getUinfo()
            }
            else
            {
                var msg = o?["data"]["msg"].stringValue
                msg = msg == "" ? "签到失败" : msg
                XAlertView.show(msg!, block: nil)
            }
            
            sender.enabled = true
        }
        
    }
    
    
    func toEdit() {
        
        if(DataCache.Share.userModel.uid != "")
        {
            
            let vc:EditUserInfoVC = "EditUserInfoVC".VC("User") as! EditUserInfoVC
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            return
        }
        
        let vc:LoginVC = "LoginVC".VC("User") as! LoginVC
        let nv:XNavigationController = XNavigationController(rootViewController: vc)
        
        self.presentViewController(nv, animated: true) { () -> Void in
            
        }
        
    }
    
    func showInfo()
    {
        if(DataCache.Share.userModel.uid != "")
        {
            self.headPic.url = DataCache.Share.userModel.headimage
            self.userName.text = DataCache.Share.userModel.mobile
            self.nickName.text = DataCache.Share.userModel.nickname
            
            if(DataCache.Share.userModel.mobile == "")
            {
                self.userName.text = "尚未绑定手机号"
            }
 
        }
        else
        {
            self.headPic.url = ""
            self.headPic.image = "tx.jpg".image
            self.userName.text = "点击登录"
            self.nickName.text = "登录后查看更多"
        }
        
        
    }
    
    func msgCountChange()
    {
        if UMsgCount > 0
        {
            msgicon.image = "my_icon3_1.png".image
        }
        else
        {
            msgicon.image = "my_icon3.png".image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(msgCountChange), name: NoticeWord.MsgChange.rawValue, object: nil)
        
        
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
    
    let sarr:[Int] = [0,3,4,5,8]
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if sarr.contains(indexPath.row)
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
        else
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

    let tarr:[Int] = [0,1,3,4,5,6,8,9]
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if tarr.contains(indexPath.row)
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
            
        case 3:
            
            let vc = "MyMinePageVC".VC("User") as! MyMinePageVC
            
            vc.uid = Uid
            vc.uname = Uname
            
            vc.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            return
            
        case 4:
            
            let vc:MyFriendVC = MyFriendVC()
            
            vc.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            return
            
        case 5:
            
            let vc = "MyMessageVC".VC("User")
            
            vc.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            return
            
        case 8:
            
            let vc = "GoodsCenterVC".VC("Jifen")
            
            vc.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            return
            
        case 6:
            
            let vc:MyCollectVC = "MyCollectVC".VC("User") as! MyCollectVC
            
            vc.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 9:
            
            let vc = MyYouhuiquanVC()
            
            vc.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 11:
            
            let vc:ConfigVC = "ConfigVC".VC("User") as! ConfigVC
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        default :
            ""
        }
        
    }
    
    func getUinfo()
    {
        DataCache.Share.userModel.OnValueChange {[weak self] (key, value) in
            
            if key == "HFB"
            {
                let m = value as! UserModel
                self?.leftnum.text = m.hfb
                self?.rightnum.text = "\(m.wqd)/7"
            }
            
            if key == "User"
            {
                self?.showInfo()
            }
            
        }
        
        DataCache.Share.userModel.getHFB()
        DataCache.Share.userModel.getUser()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        getUinfo()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
