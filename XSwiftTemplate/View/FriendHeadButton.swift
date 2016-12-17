//
//  FriendHeadButton.swift
//  chengshi
//
//  Created by 徐鹏飞 on 2016/12/17.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class FriendHeadButton: UIButton {

    var uid = ""
    var uname = ""
    
    func initSelf()
    {
        self.addTarget(self, action: #selector(toMinePage), forControlEvents: .TouchUpInside)
    }
    
    func toMinePage()
    {
        let vc = "MyMinePageVC".VC("User") as! MyMinePageVC
        
        vc.uid = uid
        vc.uname = uname
        
        vc.hidesBottomBarWhenPushed = true
        
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSelf()
    }
    
    
    
    
    
}
