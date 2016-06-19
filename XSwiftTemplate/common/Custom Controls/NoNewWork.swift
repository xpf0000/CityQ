//
//  NoNewWork.swift
//  chengshi
//
//  Created by X on 15/12/18.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class NoNewWork: UIView {

    @IBOutlet var label: UILabel!
    
    @IBOutlet var button: UIButton!
    
    @IBOutlet var icon: UIImageView!
    
    @IBOutlet var waiting: NVActivityIndicatorView!
    
    @IBOutlet var iconW: NSLayoutConstraint!
    
    @IBOutlet var iconH: NSLayoutConstraint!
    
    @IBOutlet var waitW: NSLayoutConstraint!
    
    @IBOutlet var waitH: NSLayoutConstraint!
    
    var block:AnyBlock?
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        
        super.willMoveToSuperview(newSuperview)
        
        if(newSuperview != nil)
        {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("networkStatusChanged:"), name: ReachabilityStatusChangedNotification, object: nil)
            Reach().monitorReachabilityChanges()
        }
        else
        {
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
        
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if(self.superview != nil)
        {
            self.snp_makeConstraints(closure: { (make) -> Void in
                make.top.equalTo(0.0)
                make.bottom.equalTo(0.0)
                make.leading.equalTo(0.0)
                make.trailing.equalTo(0.0)
            })
            
            self.superview!.bringSubviewToFront(self)

        }
    }
    
    func initSelf()
    {
        let containerView:UIView=("NoNewWork".Nib.instantiateWithOwner(self, options: nil))[0] as! UIView
        
        let newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        containerView.frame = newFrame
        self.addSubview(containerView)
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.initSelf()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initSelf()
        
    }
    
    func networkStatusChanged(notification: NSNotification) {
        let userInfo = notification.userInfo
        
        if((userInfo!["Status"] as! String).has("Online"))
        {
            if(self.button.enabled)
            {
                self.reTry(self.button)
            }
        }
 
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.button.layer.masksToBounds = true
        self.button.layer.cornerRadius = 5.0
        self.waiting.alpha = 0.0
        self.waiting.color = UIColor.lightGrayColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.iconH.constant = self.frame.size.width * 0.4
        self.iconW.constant = self.frame.size.width * 0.4
    }
    
    
    
    @IBAction func reTry(sender: UIButton) {
        
        sender.enabled = false
        self.waiting.type = .LineScale
        self.waiting.startAnimation()
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            
            self.icon.alpha = 0.0
            self.label.alpha = 0.0
            self.button.alpha = 0.0
            self.waiting.alpha = 1.0
            
            }) { (finish) -> Void in
                
                if(self.block != nil)
                {
                    self.block!(nil)
                }
                
        }
        
        
    }
    
    func connectFail()
    {
        if(self.superview == nil)
        {
            return
        }
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            
            self.icon.alpha = 1.0
            self.label.alpha = 1.0
            self.button.alpha = 1.0
            self.waiting.alpha = 0.0
            
            }) { (finish) -> Void in
                
                self.button.enabled = true
                self.waiting.stopAnimation()
        }
    }
    

    
}
