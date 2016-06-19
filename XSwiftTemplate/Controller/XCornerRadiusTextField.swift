//
//  XCornerRadiusTextField.swift
//  chengshi
//
//  Created by X on 16/6/11.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class XCornerRadiusTextField: UITextField {

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        drawCornerRadius(rect)
        
    }
}
