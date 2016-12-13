//
//  MyMinePageHeader.swift
//  chengshi
//
//  Created by 徐鹏飞 on 2016/12/13.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyMinePageHeader: UIView {

    @IBOutlet weak var leftbtn: UIButton!
    
    @IBOutlet weak var rightbtn: UIButton!
    
    @IBOutlet weak var leftline: UIView!
    
    @IBOutlet weak var rightline: UIView!
    
    weak var superVC:MyMinePageVC?
    
    var type = 0
    
    let ncolor = "F6F6F6".color
    let scolor = APPBlueColor
    
    @IBAction func click(_ sender: UIButton) {
        
        if sender.selected {return}
        
        if type == 0
        {
            type = 1
            leftbtn.selected = false
            leftline.backgroundColor = ncolor
            
             rightbtn.selected = true
            rightline.backgroundColor = scolor
        }
        else
        {
            type = 0
            leftbtn.selected = true
            leftline.backgroundColor = scolor
            
            rightbtn.selected = false
            rightline.backgroundColor = ncolor
            
        }
        
        superVC?.type =  type
        
        
    }
    
    func initSelf()
    {
        let containerView:UIView=("MyMinePageHeader".Nib.instantiateWithOwner(self, options: nil))[0] as! UIView
        
        let newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        containerView.frame = newFrame
        self.addSubview(containerView)
        
        self.userInteractionEnabled = true
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initSelf()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initSelf()
    }

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
