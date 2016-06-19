//
//  HmtlVC.swift
//  chengshi
//
//  Created by X on 15/12/12.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class HmtlVC: UIViewController {

    let htmlView:HtmlView = HtmlView(frame: CGRectZero)
    
    var url:String=""
    var html:String=""
    var baseUrl:String=""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(htmlView)
        
        htmlView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }
        
        htmlView.url = self.url
        htmlView.html = self.html
        htmlView.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
