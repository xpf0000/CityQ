//
//  PaymentInfoVC.swift
//  chengshi
//
//  Created by X on 16/2/26.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class PaymentInfoVC: UIViewController {

    var type = 0
    
    var iframe: XHorizontalView = XHorizontalView(frame: CGRectMake(0, 0, swidth, sheight-64))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        self.view.addSubview(iframe)
        iframe.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(0.0)
            make.bottom.equalTo(0.0)
            make.leading.equalTo(0.0)
            make.trailing.equalTo(0.0)
        }
        
        self.iframe.selectColor = 腾讯颜色.图标蓝.rawValue.color!
        self.iframe.pageNum = 2
        
        var arr:Array<XHorizontalMenuModel> = []
        
        let titles:Array<String> = ["未缴费","已缴费"]
        
        for i in 0...1
        {
            let model:XHorizontalMenuModel = XHorizontalMenuModel()
            
            let view:PaymentInfoView = PaymentInfoView(frame: CGRectZero)
            view.type = self.type
            view.status = i
            view.show()

            model.title = titles[i]
            
            model.view = view
            
            arr.append(model)
        }
        
        self.iframe.menuArr = arr
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    deinit
    {
        
    }
   
}
