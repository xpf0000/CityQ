//
//  VerifyButton.swift
//  chengshi
//
//  Created by X on 15/11/29.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit


class XVerifyButton: UIButton {

    class postTimeModel: Reflect {
        
        var time:NSNumber = 0.0
        var postPhone:String = ""
        
        override func setValue(value: AnyObject?, forUndefinedKey key: String) {
            
        }
        
    }
    
    var bgColor=UIColor(red: 31.0/255.0, green: 172.0/255.0, blue: 252.0/255.0, alpha: 1.0)
    
    var waitTime:Int = 60
    private var surplusTime:Int = -1
    private var timer:NSTimer?
    private var outTimer:NSTimer?
    private let hideView:UIView=UIView()
    var phone:String = ""
    var postPhone:String = ""
    var outTime:NSTimeInterval = 300
    var block:AnyBlock?
    private lazy var timeModel:postTimeModel=postTimeModel()
    var type=1
    
    
    class func Share() ->XVerifyButton! {
        
        struct Once {
            static var token:dispatch_once_t = 0
            static var dataCenterObj:XVerifyButton! = nil
        }
        dispatch_once(&Once.token, {
            Once.dataCenterObj = XVerifyButton(type: .Custom)
        })
        return Once.dataCenterObj
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        
        super.willMoveToSuperview(newSuperview)
        
        if(newSuperview == nil)
        {
            self.phone = ""
            self.block = nil
        }
        
    }
    
    
    func initSelf()
    {
        let model = postTimeModel.read(name: "postTime")
        if(model != nil)
        {
            timeModel=postTimeModel.read(name: "postTime") as! postTimeModel
            self.postPhone = timeModel.postPhone
            
            if(timeModel.time != 0)
            {
                surplusTime = Int(NSDate().timeIntervalSince1970 - timeModel.time.doubleValue)
                
                let otime = Int(outTime)-surplusTime
                
                surplusTime = waitTime-surplusTime
                
                if(otime >= 0)
                {
                    self.outTimer=NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(otime), target: self, selector: #selector(timeOut), userInfo: nil, repeats: true)
                    self.outTimer!.fire()
                }
                else
                {
                    self.postPhone = ""
                }
                
                if(surplusTime >= 0)
                {
                    self.timer=NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(timeChange), userInfo: nil, repeats: true)
                    self.timer!.fire()
                }
                else
                {
                    postTimeModel.delete(name: "postTime")
                }
                
                
            }
        }
        
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        hideView.backgroundColor = UIColor.whiteColor()
        self.addSubview(hideView)
        self.hideView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(self)
        }
        hideView.alpha = 0.45
        self.contentEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 16)
        self.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        self.enabled = false
        self.setBackgroundImage(bgColor.image, forState: UIControlState.Normal)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.setTitle("点击获取验证码", forState: UIControlState.Normal)

        
        self.addTarget(self, action: #selector(btnClick), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func Phone(str:String)
    {
        self.phone = str
        
        if(self.timer != nil)
        {
            return
        }
        
        if(!self.phone.match(.Phone))
        {
            self.hideView.alpha = 0.45
            self.setTitle("点击获取验证码", forState: UIControlState.Normal)
            self.setTitle("点击获取验证码", forState: UIControlState.Disabled)
            self.enabled = false
        }
        else
        {
            self.hideView.alpha = 0.0
            self.setTitle("点击获取验证码", forState: UIControlState.Normal)
            self.setTitle("点击获取验证码", forState: UIControlState.Disabled)
            self.enabled = true
        }
    }
    
    func timeOut()
    {
        self.postPhone = ""
    }
    
 
    func postSuccess()
    {
        self.timeModel.time = NSDate().timeIntervalSince1970
        postTimeModel.save(obj: self.timeModel, name: "postTime")
        
        self.hideView.alpha = 0.0
        self.surplusTime = self.waitTime
        
        self.setTitle("\(self.surplusTime)秒后再次发送", forState: UIControlState.Disabled)
        self.enabled = false
        
        self.timer=NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(timeChange), userInfo: nil, repeats: true)
        self.timer!.fire()
        
        if(self.outTimer != nil)
        {
            self.outTimer?.invalidate()
            self.outTimer = nil
        }
        
        self.outTimer=NSTimer.scheduledTimerWithTimeInterval(self.outTime, target: self, selector: #selector(timeOut), userInfo: nil, repeats: true)
        self.outTimer!.fire()
    }
    

    
    func btnClick()
    {
        let temp=self.phone
        let url=APPURL+"Public/Found/?service=User.getUserM&mobile="+temp
        
        XHttpPool.requestJson(url, body: nil, method: .POST) { (o) -> Void in
            
            if(o?["data"]["code"].intValue == 0)
            {
                if(self.type == 1)
                {
                    UIApplication.sharedApplication().keyWindow?.showAlert("手机号已注册", block: nil)
                    
                    return
                }
                
                self.doPost(temp)
                
            }
            else if(o?["data"]["code"].intValue == 1)
            {
                
                if(self.type == 2)
                {
                    UIApplication.sharedApplication().keyWindow?.showAlert("无此用户", block: nil)
                    
                    return
                    
                }

                
                self.doPost(temp)
            }
            else
            {
                UIApplication.sharedApplication().keyWindow?.showAlert("发生错误,请重试", block: nil)
            }
            
            
        }
 
        
    }
    
    func doPost(str:String)
    {
        XWaitingView.show()
        
        self.postPhone = str
        
        if(self.block != nil)
        {
            self.block!(nil)
        }
        
        let url1=APPURL+"Public/Found/?service=User.smsSend"
        
        let body="mobile="+str+"&type=\(self.type)"
        
        XHttpPool.requestJson(url1, body: body, method: .POST, block: { (o) -> Void in
            
            XWaitingView.hide()
            
            if(o?["data"]["code"].intValue != 0)
            {
                UIApplication.sharedApplication().keyWindow?.showAlert("短信发送失败", block: nil)
            }
            else
            {
                self.postSuccess()
            }
            
            
        })

    }
    
    func timeChange()
    {
        surplusTime -= 1
        if(surplusTime >= 0)
        {
            self.setTitle("\(surplusTime)秒后再次发送", forState: UIControlState.Disabled)
        }
        else
        {
            self.timer!.invalidate()
            self.timer = nil
            self.Phone(self.phone)
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSelf()
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initSelf()
    }
    

}
