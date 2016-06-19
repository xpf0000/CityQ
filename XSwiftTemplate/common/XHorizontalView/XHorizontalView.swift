//
//  XHorizontalView.swift
//  chengshi
//
//  Created by X on 16/6/3.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class XHorizontalView: UIView {

    let menu = XHorizontalMenuView()
    let main = XHorizontalMainView()
    
    var selectColor:UIColor!
    {
        didSet
        {
            menu.menuSelectColor = selectColor
        }
    }
    
    var pageNum:CGFloat!
    {
        didSet
        {
            menu.menuPageNum = pageNum
        }
    }
    
    var menuArr:[XHorizontalMenuModel]!
    {
        didSet
        {
            menu.menuArr = menuArr
        }
    }
    
    
    
    func initSelf()
    {
        self.backgroundColor = UIColor.whiteColor()
        menu.main=main
        
        self.addSubview(menu)
        self.addSubview(main)
        
        menu.snp_makeConstraints { (make) in
            make.top.equalTo(0.0)
            make.leading.equalTo(0.0)
            make.trailing.equalTo(0.0)
            make.height.equalTo(45.0)
        }
        
        main.snp_makeConstraints { (make) in
            make.leading.equalTo(0.0)
            make.trailing.equalTo(0.0)
            make.top.equalTo(menu.snp_bottom).offset(0.0)
            make.bottom.equalTo(0.0)
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
