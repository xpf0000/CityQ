//
//  ReportVC.swift
//  chengshi
//
//  Created by X on 16/2/16.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class ReportVC: UIViewController {

    let txt:XTextView = XTextView(frame: CGRectMake(10, 20, swidth-20, sheight*0.4))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "举报"
        self.view.backgroundColor = "F0F0F0".color
        self.addBackButton()
        
        let button=UIButton(type: UIButtonType.Custom)
        button.frame=CGRectMake(30, 0, 60, 25);
        button.setTitleColor(腾讯颜色.图标蓝.rawValue.color, forState: .Normal)
        button.setTitle("确定", forState: .Normal)
        button.showsTouchWhenHighlighted = true
        button.exclusiveTouch = true
        button.addTarget(self, action: "submit:", forControlEvents: UIControlEvents.TouchUpInside)
        let rightItem=UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem=rightItem;
        
        txt.font = UIFont.systemFontOfSize(16.0)
        txt.layer.borderColor = UIColor.lightGrayColor().CGColor
        txt.layer.borderWidth = 0.5
        txt.layer.masksToBounds = true
        
        txt.placeHolder("请填写您的举报理由")
        
        self.view.addSubview(txt)
        
        txt.becomeFirstResponder()
        
    }
    
    func submit(sender:UIButton)
    {
        if(!self.txt.checkNull())
        {
            return
        }
        
        if(!self.txt.checkLength(10, max: 1000))
        {
            UIApplication.sharedApplication().keyWindow?.showAlert("内容长度为5-1000个字符", block: nil)
            
            return
        }
        
        sender.enabled = false
        self.view.endEditing(true)
        
        let url=APPURL+"Public/Found/?service=User.feedAdd&user="+DataCache.Share.userModel.username+"&content="+self.txt.text.trim()
        
        XHttpPool.requestJson(url, body: nil, method: .POST) { (o) -> Void in
            
            if(o?["data"]["code"].intValue == 0)
            {
                UIApplication.sharedApplication().keyWindow?.showAlert("发送成功,我们会尽快核实举报信息", block: { (o) -> Void in
                    
                    self.pop()
                })
                
                return
            }
            
            sender.enabled = true
            UIApplication.sharedApplication().keyWindow?.showAlert("发送失败,请重试", block: nil)
            
        }

    }

    deinit
    {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    
}
