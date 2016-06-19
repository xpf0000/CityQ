//
//  MyPostFriendView.swift
//  chengshi
//
//  Created by X on 15/11/30.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyPostFriendView: UIView {

    @IBOutlet var table: XTableView!
    
    
    func initBanner()
    {
        let containerView:UIView=("MyPostFriendView".Nib.instantiateWithOwner(self, options: nil))[0] as! UIView
        
        let newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        containerView.frame = newFrame
        self.addSubview(containerView)
        
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.initBanner()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initBanner()
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
   deinit
    {
        self.table=nil
    }

}
