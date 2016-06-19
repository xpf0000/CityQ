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
            
            self?.viewController?.tabBarController?.selectedIndex = 1
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
    
}
