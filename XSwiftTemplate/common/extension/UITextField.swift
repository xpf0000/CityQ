//
//  UITextField.swift
//  lejia
//
//  Created by X on 15/10/26.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import Foundation
import UIKit

private var AutoHeightOffYKey : CChar?

extension UITextField{
    
    var autoHeightOffY:CGFloat
        {
        get
        {
            
            var f = objc_getAssociatedObject(self, &AutoHeightOffYKey) as? CGFloat
            
            f = f == nil ? 0.0 : f
            
            return f!
        }
        set(newValue) {
            self.willChangeValueForKey("AutoHeightOffYKey")
            objc_setAssociatedObject(self, &AutoHeightOffYKey, newValue,
                .OBJC_ASSOCIATION_COPY_NONATOMIC)
            self.didChangeValueForKey("AutoHeightOffYKey")
            
        }
    }
    
    func autoHeightOpen(offY:CGFloat)
    {
        self.autoHeightOffY = offY
        //使用NSNotificationCenter 鍵盤出現時
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        //使用NSNotificationCenter 鍵盤隐藏時
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)

    }
    
    func autoHeightClose()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    //实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
    func keyboardWillShow(aNotification:NSNotification)
    {
        self.viewController?.view.layer.transform = CATransform3DIdentity
        
        let frame=self.superview?.convertRect(self.frame, toView: UIApplication.sharedApplication().keyWindow)
        if frame == nil {return}
        
        let info:Dictionary = aNotification.userInfo!
        let kbSize:CGRect=info[UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        
        let h:CGFloat=kbSize.origin.y
    
        let moveH=frame!.size.height+frame!.origin.y+self.autoHeightOffY-h
        
        if(moveH > 0 )
        {
            let translation = CATransform3DMakeTranslation(0, -moveH, 0)
            self.viewController?.view.layer.transform = translation
        }
 
    }
    
    //当键盘隐藏的时候
    func keyboardWillBeHidden(aNotification:NSNotification)
    {
        self.viewController?.view.layer.transform = CATransform3DIdentity
    }
    
    
}
