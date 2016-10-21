//
//  XBuyNumView.swift
//  lejia
//
//  Created by X on 15/9/30.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class XBuyNumView: UIView,UITextFieldDelegate {
    
    @IBOutlet var lineWidth: NSLayoutConstraint!
    
    var xframe:CGRect = CGRectZero
    var num:Int=1
    var max:Int=0
    var min:Int=1

    override func layoutSubviews() {
        
        if(xframe != CGRectZero)
        {
            self.frame = xframe
        }
        
        super.layoutSubviews()
        
        
    }
    
    
    @IBAction func clipClick(sender: AnyObject) {
        
        num = Int(text.text!)!
        if(num == min)
        {
            return
        }
        
        num -= 1
        text.text = "\(num)"
        
    }
    
    @IBAction func addClick(sender: AnyObject) {
        
        num = Int(text.text!)!
        if(num == max)
        {
            return
        }
        num += 1
        text.text = "\(num)"
    }
    
    @IBOutlet var text: UITextField!

    
    func initSelf()
    {
        let containerView:UIView=("XBuyNumView".Nib.instantiateWithOwner(self, options: nil))[0] as! UIView
        
        let newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        containerView.frame = newFrame
        self.addSubview(containerView)

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initSelf()
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lineWidth.constant = 0.4
        self.layer.borderWidth = 0.4
        self.layer.borderColor = "#646464".color?.CGColor
        self.layer.cornerRadius = 2.0
        
        self.text.addEndButton()
        
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if(text.text == "\(min)" && !(range.length == 1 && range.location == 0))
        {
            text.text = string
            
            return false
        }
        else if(range.length == 1 && range.location == 0)
        {
            text.text = "\(min)"
            
            return false
        }
        else
        {
            return true
        }
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.endEditing(true)
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        num = Int(text.text!)!
        
        if(num>max)
        {
            XAlertView.show("超出最大范围", block: nil)
            num=max
            self.text.text = "\(num)"
        }
        
    }
    
    
    
    
    
    deinit
    {
        
    }

}
