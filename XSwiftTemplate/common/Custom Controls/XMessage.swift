//
//  XMessage.swift
//  chengshi
//
//  Created by X on 15/12/18.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class XMessage: UIView {

    
    var label=UILabel()
    var msg=""
    
    class func Share() ->XMessage! {
        
        struct Once {
            static var token:dispatch_once_t = 0
            static var dataCenterObj:XMessage! = nil
        }
        dispatch_once(&Once.token, {
            Once.dataCenterObj = XMessage(frame: CGRectZero)
        })
        return Once.dataCenterObj
    }
    
    
    func showMessage(str:String)
    {
        self.label.text = str
        
        UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            
            self.alpha = 1.0
            
            }) { (finished) -> Void in
                if(finished)
                {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                        
                        UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                            self.alpha=0.0
                            }) { (finished) -> Void in
                                
                                self.removeFromSuperview()
                        }
                        
                    });
                
                }
                
        }
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if(self.superview != nil)
        {
            self.snp_makeConstraints(closure: { (make) -> Void in
                make.centerX.equalTo(self.superview!)
                make.bottom.equalTo(-100.0)
                make.width.equalTo(swidth*0.6)
                make.height.equalTo(self.label.snp_height).offset(20.0)
                make.height.greaterThanOrEqualTo(50.0)
            })
        }
        
    }
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = "#333749".color
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5.0
        
        self.label.font = UIFont.boldSystemFontOfSize(13.0)
        self.label.textColor = UIColor.whiteColor()
        self.label.numberOfLines = 0
        self.label.textAlignment = NSTextAlignment.Center
        self.label.preferredMaxLayoutWidth = swidth*0.6-60.0
        self.addSubview(self.label)
        
        self.label.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(10.0)
            make.bottom.equalTo(-10.0)
            make.leading.equalTo(30.0)
            make.trailing.equalTo(-30.0)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
}
