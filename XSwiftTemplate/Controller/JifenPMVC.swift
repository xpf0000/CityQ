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
        
        self.view.addSubview(main)
        self.view.addSubview(menu)
        
        
        menu.frame = CGRectMake(0, 0, swidth, 44.0)
        main.frame = CGRectMake(0, 0.0, swidth, sheight-64.0)
        
        main.menu=menu
        
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
        vc.view.frame = CGRectMake(0.0, 0.0, swidth, sheight-64.0)
        m.view = vc.view
        
        let m1 = XHorizontalMenuModel()
        m1.title = "财富达人"
        vc1.view.frame = CGRectMake(0.0, 0.0, swidth, sheight-64.0)
        m1.view = vc1.view
        
        menu.menuArr = [m,m1]
        
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let nv=self.navigationController as? XNavigationController
        {
            nv.removeRecognizer()
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let nv=self.navigationController as? XNavigationController
        {
            nv.setRecognizer()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        
        
        
    }
    

}
