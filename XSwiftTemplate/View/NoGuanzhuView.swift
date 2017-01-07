//
//  NoGuanzhuView.swift
//  chengshi
//
//  Created by X on 16/6/16.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class NoGuanzhuView: UIView {

    @IBOutlet var txt: UILabel!
    
    @IBOutlet var btn: UIButton!
    
   
    func initSelf()
    {
        let containerView:UIView=("NoGuanzhuView".Nib.instantiateWithOwner(self, options: nil))[0] as! UIView
        
        let newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        containerView.frame = newFrame
        self.addSubview(containerView)
        
        btn.click { [weak self,weak btn](b) in
            
            if self?.viewController?.checkIsLogin() == true
            {
                let vc = "CardIndexVC".VC
                vc.hidesBottomBarWhenPushed=true
                self?.viewController?.navigationController?.pushViewController(vc, animated: true)
                
            }

        }
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.initSelf()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initSelf()
        
    }
    
    func reSetTitle()
    {
        if Uid == ""
        {
            txt.text = "您还没有登录"
            btn.setTitle("马上登录", forState: .Normal)
        }
        else
        {
            txt.text = "您当前还没有任何会员卡"
            btn.setTitle("马上去领取", forState: .Normal)
        }
    }
    
}
