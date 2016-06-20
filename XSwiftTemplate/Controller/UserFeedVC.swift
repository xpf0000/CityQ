//
//  UserFeedVC.swift
//  chengshi
//
//  Created by X on 15/12/17.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class UserFeedVC: UIViewController {

    @IBOutlet var textView: XTextView!
    
    
    override func pop() {
        self.view.endEditing(true)
        super.pop()
    }
    
    func send(sender:UIButton)
    {
        if(!self.checkIsLogin() || !self.textView.checkNull())
        {
            return
        }
        
        if(!self.textView.checkLength(10, max: 1000))
        {
            UIApplication.sharedApplication().keyWindow?.showAlert("内容长度为10-1000个字符", block: nil)
            
            return
        }
        
        sender.enabled = false
        
        let url=APPURL+"Public/Found/?service=User.feedAdd&user="+DataCache.Share().userModel.username+"&content="+self.textView.text.trim()
        
        XHttpPool.requestJson(url, body: nil, method: .POST) { (o) -> Void in
            
            if(o?["data"]["code"].intValue == 0)
            {
                UIApplication.sharedApplication().keyWindow?.showAlert("发送成功", block: { (o) -> Void in
                    
                    self.pop()
                })
                
                return
            }
            
            sender.enabled = true
            UIApplication.sharedApplication().keyWindow?.showAlert("发送失败,请重试", block: nil)
            
        }
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBackButton()
        self.title = "意见反馈"
        
        textView.placeHolder("内容")
        textView.inputAccessoryView = nil
        
        let button=UIButton(type: UIButtonType.Custom)
        button.frame=CGRectMake(10, 2, 40, 25);
        button.setTitle("发送", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.showsTouchWhenHighlighted = true
        button.exclusiveTouch = true
        button.addTarget(self, action: #selector(send(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let rightItem=UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem=rightItem;
        
        textView.becomeFirstResponder()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
