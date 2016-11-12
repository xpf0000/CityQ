//
//  GroupSearchView.swift
//  chengshi
//
//  Created by X on 2016/11/12.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class GroupSearchView: UIView,UITextFieldDelegate {

    @IBOutlet var mainView: UIView!
    
    @IBOutlet var txtfield: UITextField!
    
    @IBOutlet var btn: UIButton!
    
    var block:XHTMLBlock?
    
    @IBAction func click(sender: AnyObject) {
        
        if !txtfield.checkNull() {return}
        
        block?(txtfield.text!)
    }
    
    
    func initSelf()
    {
        let containerView:UIView=("GroupSearchView".Nib.instantiateWithOwner(self, options: nil))[0] as! UIView
        
        let newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        containerView.frame = newFrame
        self.addSubview(containerView)
        
        mainView.layer.masksToBounds = true
        mainView.layer.borderColor = "dedede".color?.CGColor
        mainView.layer.borderWidth = 1.0
        mainView.layer.cornerRadius = 6.0
        
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 6.0
        
        txtfield.delegate = self
        
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initSelf()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initSelf()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.endEdit()
        
        return true
    }
    
}
