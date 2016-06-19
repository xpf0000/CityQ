//
//  XPhotoChoose.swift
//  chengshi
//
//  Created by X on 15/11/26.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

@objc protocol XDeleteDelegate:NSObjectProtocol{
    //回调方法
    optional func XDeleteDoDel()

}

class XDeleteAlert: UIView,UIGestureRecognizerDelegate {
    
    @IBOutlet var button1: UIButton!
    
    @IBOutlet var button2: UIButton!
    
    @IBOutlet var chooseView: UIView!
    
    @IBOutlet var bottom: NSLayoutConstraint!
    
    weak var delegate:XDeleteDelegate?
    
    var block:AnyBlock?
    
    var vc:UIViewController?
    
    var showed=false
    
    @IBAction func doDel(sender: AnyObject) {
        
        self.delegate?.XDeleteDoDel!()
        
        if(self.block != nil)
        {
            self.block!(nil)
        }
        
    }
    
    @IBAction func cancel(sender: AnyObject) {
        
        self.hide()
        
    }
    
    class func Share() ->XDeleteAlert! {
        
        struct Once {
            static var token:dispatch_once_t = 0
            static var dataCenterObj:XDeleteAlert! = nil
        }
        dispatch_once(&Once.token, {
            Once.dataCenterObj = XDeleteAlert(frame: CGRectMake(0, 0, swidth, sheight))
        })
        return Once.dataCenterObj
    }
    
    
    func initSelf()
    {
        let containerView:UIView=("XDeleteAlert".Nib.instantiateWithOwner(self, options: nil))[0] as! UIView
        
        let newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        containerView.frame = newFrame
        self.addSubview(containerView)
        
        self.userInteractionEnabled = true
        
        for view in self.chooseView.subviews
        {
            if(view is UIButton)
            {
                view.layer.cornerRadius = 4.0
                view.layer.borderColor = "#D2D2D2".color?.CGColor
                view.layer.borderWidth = 0.5
                view.layer.masksToBounds = true
            }
        }
        
        let recognizer = UITapGestureRecognizer(target: self, action: "hide")
        recognizer.delegate = self
        recognizer.delaysTouchesBegan = true
        self.addGestureRecognizer(recognizer)
        
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        if(touch.view == self.chooseView)
        {
            return false
        }
        
        return true
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initSelf()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initSelf()
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        
        super.willMoveToSuperview(newSuperview)
        
        if(newSuperview != nil)
        {
            if(self.showed)
            {
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    
                    self.bottom.constant = 0.0
                    
                    self.chooseView.layoutIfNeeded()
                    
                })
            }
            
        }
        else
        {
            self.bottom.constant = -180.0
            self.chooseView.layoutIfNeeded()
        }
    }
    
    override func didMoveToSuperview() {
        
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        
        self.block = nil
        self.delegate = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.chooseView.layoutIfNeeded()
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            
            self.bottom.constant = 0.0
            self.chooseView.layoutIfNeeded()
            
            }) { (finish) -> Void in
                
                self.showed = true
        }

        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func hide()
    {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            
            self.bottom.constant = -180.0
            
            self.chooseView.layoutIfNeeded()
            
            }) { (finish) -> Void in
                
                self.removeFromSuperview()
                
        }
    }
    
    
}
