//
//  PaymentInfoInfoVC.swift
//  chengshi
//
//  Created by X on 16/2/26.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class PaymentInfoInfoVC: UIViewController {
    
    let label = UITextView()
    
    var model = PropertyPaymentModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.title = "详情"
        self.view.backgroundColor = "F2F2F2".color
        
        label.font = UIFont.systemFontOfSize(22.0)
        label.showsVerticalScrollIndicator = false
        label.showsHorizontalScrollIndicator = false
        label.editable = false
        label.userInteractionEnabled = false
        label.backgroundColor = UIColor.clearColor()
        //label.textAlignment = .Center
        //label.numberOfLines = 0
        //label.preferredMaxLayoutWidth = swidth - 40.0
        
        self.view.addSubview(label)
        
        label.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(20.0)
            make.leading.equalTo(15.0)
            make.trailing.equalTo(15.0)
            make.bottom.equalTo(0.0)
        }
        
        label.text = "日期: \(model.create_time.subStringToIndex(4))年\(model.create_time.subStringFromIndex(4))月\r\n\r\n 上月抄表数: \(model.snumber)\r\n\r\n 本月抄表数: \(model.bnumber)\r\n\r\n 使用量: \(model.unumber) \r\n\r\n 应缴金额: \(model.ymoney)元\r\n\r\n 实缴金额: \(model.smoney)元\r\n\r\n 余额: \(model.yumoney)元\r\n\r\n 单价: \(model.price)元"
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    deinit
    {
        
    }
    
}
