//
//  JifenPMVC.swift
//  chengshi
//
//  Created by X on 2016/10/22.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class JifenPMVC: UIViewController {

    let menu = XHorizontalMenuView()
    let main = XHorizontalMainView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = APPBGColor
        self.title = "财富排行榜"
        self.addBackButton()
        
        self.view.addSubview(menu)
        self.view.addSubview(main)
        
        menu.frame = CGRectMake(0, 0, swidth, 44.0)
        main.frame = CGRectMake(0, 44.0, swidth, sheight-64.0-44.0)
        
        menu.menuPageNum = 2.0
        menu.line.hidden = true
        menu.menuMaxScale = 1.0
        menu.menuSelectColor = APPBlueColor
        
        let vc = "JifenQiandaoListVC".VC("Jifen")
        self.addChildViewController(vc)
        
        let vc1 = "JifenCaifuListVC".VC("Jifen")
        self.addChildViewController(vc1)
        
        let m = XHorizontalMenuModel()
        m.title = "签到达人"
        m.view = vc.view
        
        let m1 = XHorizontalMenuModel()
        m1.title = "财富达人"
        m1.view = vc1.view
        
        menu.menuArr = [m,m1]
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        
        
        
    }
    

}
