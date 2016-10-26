//
//  MyMinePageVC.swift
//  chengshi
//
//  Created by X on 2016/10/24.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyMinePageVC: UIViewController {

    @IBOutlet var header: UIImageView!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var tel: UILabel!
    
    @IBOutlet var menu: XHorizontalMenuView!
    
    @IBOutlet var main: XHorizontalMainView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.title = "我的主页"
        
        header.layer.masksToBounds = true
        header.layer.borderColor = UIColor.whiteColor().CGColor
        header.layer.borderWidth = 2.0
        
        header.url = DataCache.Share.userModel.headimage
        tel.text = DataCache.Share.userModel.mobile
        name.text = DataCache.Share.userModel.nickname
        
        if(DataCache.Share.userModel.mobile == "")
        {
            tel.text = "尚未绑定手机号"
        }
        
        menu.main = main
        menu.menuBGColor = "f6f6f6".color!
        menu.lineWidthScale = 0.4
        menu.menuPageNum = 2.0
        menu.menuSelectColor = APPBlueColor
        
        let m = XHorizontalMenuModel()
        m.title = "动态"
        
        let m1 = XHorizontalMenuModel()
        m1.title = "资料"
        
        let vc = "MyMinePageRightVC".VC("User")
        self.addChildViewController(vc)
        m1.view = vc.view
        
        
        let vc1 = "FriendMineListVC".VC("Friend")
        self.addChildViewController(vc1)
        m.view = vc1.view
        
        
        
        
        menu.menuArr = [m,m1]
        

        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        header.layer.cornerRadius = header.frame.size.width * 0.5
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
