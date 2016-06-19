//
//  LaunchScreen.swift
//  chengshi
//
//  Created by X on 16/3/25.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class LaunchScreen: UIView {

    @IBOutlet var atitle: UILabel!
    
    func initSelf()
    {
        let containerView:UIView=("XDeleteAlert".Nib.instantiateWithOwner(self, options: nil))[0] as! UIView
        
        let newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        containerView.frame = newFrame
        self.addSubview(containerView)

        atitle.text = "00000000000"
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initSelf()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initSelf()
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    
}
