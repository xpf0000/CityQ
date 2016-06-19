//
//  PostCommentView.swift
//  chengshi
//
//  Created by X on 15/10/19.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class PostCommentView: FXBlurView,UIGestureRecognizerDelegate {

    @IBOutlet var bgView: UIView!
    var navController:XNavigationController?
    var block:AnyBlock?
    var anmationIng:Bool = false
    var contentView:postViewContent = "postViewContent".View as! postViewContent
    var superView:View?
    var changed:Bool = false
    var cacheText:String = ""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerForKeyboardNotifications()
        
        bgView.backgroundColor = UIColor(red: 0.13, green: 0.14, blue: 0.2, alpha: 0.6)
        
        self.tintColor = UIColor.darkGrayColor()
        self.dynamic = false;
        self.blurRadius = 12.5;
        self.iterations = 1;
        bgView.alpha=1.0;
        self.alpha = 0.0;
        
         let tap=UITapGestureRecognizer(target: self, action: #selector(PostCommentView.hideView))
        tap.delegate=self
        self.addGestureRecognizer(tap)
        
    }
    
    
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        self.superView = newSuperview
        if(self.superView != nil)
        {
            superView!.addSubview(self.contentView)
            self.contentView.textView.text=cacheText
            self.contentView.cancleButton.addTarget(self, action: #selector(PostCommentView.hideView), forControlEvents: .TouchUpInside)
            self.contentView.sendButton.addTarget(self, action: #selector(PostCommentView.submit), forControlEvents: .TouchUpInside)
            
            self.contentView.snp_makeConstraints(closure: { (make) -> Void in
            
                make.leading.equalTo(0)
                make.trailing.equalTo(0)
                make.height.equalTo(sheight*1.0/6.0+74)
                make.bottom.equalTo(sheight*1.0/6.0+74)
                
            })
            self.contentView.layoutIfNeeded()
        }
        
    }
    
    func submit()
    {
        if(!self.contentView.textView.checkNull())
        {
            return
        }
        
        self.hideView()
        
        if(self.block != nil)
        {
            self.block!(self.contentView.textView.text)
            self.block=nil
        }
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if(superView != nil)
        {
            superView!.bringSubviewToFront(self.contentView)
        }
        
    }
    
    func show(block:AnyBlock)
    {
        if(anmationIng)
        {
            return;
        }
        
        if(self.navController != nil)
        {
            navController!.removeRecognizer()
        }
        
        self.block = block
        anmationIng=true;
        self.contentView.textView.becomeFirstResponder()
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            
            self.alpha = 1.0
            
            
            }) { (finish) -> Void in
                
        }

    }

    func hideView()
    {
        self.contentView.endEditing(true)
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            
            self.contentView.snp_updateConstraints { (make) -> Void in
                make.bottom.equalTo(sheight*1.0/6.0+74)
            }
            self.contentView.layoutIfNeeded()
            
            self.alpha = 0.0
            
            }) { (finish) -> Void in
                
                self.removeFromSuperview()
                self.contentView.removeFromSuperview()
                
                if(self.navController != nil)
                {
                    self.navController!.setRecognizer()
                }
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        if(touch.view is UIButton)
        {
            return false
        }
        
        return true
    }
    
    func registerForKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PostCommentView.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PostCommentView.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWillShow(sender:NSNotification)
    {
        let info:Dictionary<String,AnyObject> = sender.userInfo as! Dictionary<String,AnyObject>
        //kbSize即為鍵盤尺寸 (有width, height)
        
        let keyBordHeight:CGFloat = info[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size.height
        
        if(!changed)
        {
            self.changed = true
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                
                self.contentView.snp_updateConstraints { (make) -> Void in
                    
                    make.bottom.equalTo(keyBordHeight * -1)
                }
                
                self.contentView.layoutIfNeeded()
                
                }) { (finish) -> Void in
                    
                    
            }

        }
        else
        {
            self.contentView.snp_updateConstraints { (make) -> Void in
                
                make.bottom.equalTo(keyBordHeight * -1)
            }
            
            self.contentView.layoutIfNeeded()
        }
       
    }
    
    func keyboardWillBeHidden(sender:NSNotification)
    {
        
    }
    
    
    deinit
    {
    }
    
}


class postViewContent:UIView
{
    
    @IBOutlet var textView: XTextView!
    
    @IBOutlet var cancleButton: UIButton!
    
    @IBOutlet var sendButton: UIButton!
  
    @IBOutlet var ptitle: UILabel!
    
}
