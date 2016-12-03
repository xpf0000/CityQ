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

typealias XTextChangeBlock = (UITextField,String)->Void

class XTextChangeBlockModel: NSObject {
    
    var block:XTextChangeBlock?
}

private var XTextChangeBlockKey:CChar = 0
private var XTextDelegateKey:CChar = 0
private var AutoHeightViewKey : CChar?

extension UITextField{
    
    
    private var xdelegate:XTextDelegate?
        {
        get
        {
            let f = objc_getAssociatedObject(self, &XTextDelegateKey) as? XTextDelegate
            
            return f
        }
        set(newValue) {
            self.willChangeValueForKey("XTextDelegateKey")
            objc_setAssociatedObject(self, &XTextDelegateKey, newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.didChangeValueForKey("XTextDelegateKey")
            
        }
    }
    
    
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
    
    var autoHeightView:UIView?
        {
        get
        {
            return objc_getAssociatedObject(self, &AutoHeightViewKey) as? UIView
        }
        set(newValue) {
            self.willChangeValueForKey("AutoHeightViewKey")
            objc_setAssociatedObject(self, &AutoHeightViewKey, newValue,
                                     .OBJC_ASSOCIATION_ASSIGN)
            self.didChangeValueForKey("AutoHeightViewKey")
            
        }
    }
    
    func autoHeightOpen(offY:CGFloat,moveView:UIView?)
    {
        self.autoHeightView = moveView
        self.autoHeightOffY = offY
        //使用NSNotificationCenter 鍵盤出現時
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UITextField.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        //使用NSNotificationCenter 鍵盤隐藏時
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UITextField.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    
    //实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
    func keyboardWillShow(aNotification:NSNotification)
    {
        if !self.isFirstResponder(){return}
        
        self.autoHeightView?.layer.transform = CATransform3DIdentity
        
        let frame=self.superview?.convertRect(self.frame, toView: UIApplication.sharedApplication().keyWindow)
        if frame == nil {return}
        
        let info:Dictionary = aNotification.userInfo!
        let kbSize:CGRect=info[UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        
        let h:CGFloat=kbSize.origin.y
        
        let moveH=frame!.size.height+frame!.origin.y+self.autoHeightOffY-h
        
        if(moveH > 0 )
        {
            self.autoHeightView?.transform = CGAffineTransformMakeTranslation(0, -moveH)
            let ba = CABasicAnimation(keyPath: "transform")
            ba.duration=0.15;
            ba.toValue = NSValue(CATransform3D: CATransform3DMakeTranslation(0, -moveH, 0))
            
            ba.fillMode=kCAFillModeForwards
            ba.removedOnCompletion=false
            
            self.autoHeightView?.layer.addAnimation(ba, forKey: nil)
            
        }
        
    }
    
    //当键盘隐藏的时候
    func keyboardWillBeHidden(aNotification:NSNotification)
    {
        self.autoHeightView?.transform = CGAffineTransformIdentity
        self.autoHeightView?.layer.removeAllAnimations()
    }
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        if newSuperview == nil
        {
            NSNotificationCenter.defaultCenter().removeObserver(self)
            removeTextChangeBlock()
        }
    }
    
    
    
    private var textChangeBlock:XTextChangeBlockModel?
        {
        get
        {
            let r = objc_getAssociatedObject(self, &XTextChangeBlockKey) as? XTextChangeBlockModel
            
            return r
        }
        set {
            
            self.willChangeValueForKey("XTextChangeBlockKey")
            objc_setAssociatedObject(self, &XTextChangeBlockKey, newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.didChangeValueForKey("XTextChangeBlockKey")
            
        }
        
    }
    
    func removeTextChangeBlock()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.textChangeBlock?.block = nil
        self.textChangeBlock = nil
    }
    
    func onTextChange(b:XTextChangeBlock)
    {
        self.textChangeBlock?.block = nil
        self.textChangeBlock = nil
        
        let m = XTextChangeBlockModel()
        m.block = b
        self.textChangeBlock=m
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(textChange(_:)), name: UITextFieldTextDidChangeNotification, object: self)
        
    }
    
    
    
    func textChange(notic:NSNotification)
    {
        if let obj = notic.object as? UITextField
        {
            if obj != self
            {
                return
            }
        }
        else
        {
            return
        }
        
        if let t = notic.object as? UITextField
        {
            if t.markedTextRange == nil
            {
                let txt = self.text == nil ? "" : self.text!

                self.textChangeBlock?.block?(self,txt)
            }
        }
        
    }
    
    func autoReturn(textField:UITextField...)
    {
        var arr = textField
        arr.insert(self, atIndex: 0)
        self.xdelegate = XTextDelegate(v: arr)
    }
    
    func autoReturnClose()
    {
        self.xdelegate?.txtArr.removeAll(keepCapacity: false)
        self.xdelegate = nil
    }
    
}



class XTextDelegate: NSObject,UITextFieldDelegate,UITextViewDelegate {
    
    lazy var txtArr:[UITextField] = []
    
    init(v:[UITextField])
    {
        super.init()
        
        txtArr = v
        
        for item in txtArr
        {
            item.delegate = self
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if let i = txtArr.indexOf(textField)
        {
            if i == txtArr.count-1
            {
                textField.endEdit()
            }
            else
            {
                txtArr[i+1].becomeFirstResponder()
            }
        }
        
        return true
        
    }
    
    deinit
    {
        print("XTextDelegate deinit !!!!!!!!")
    }
    
}
