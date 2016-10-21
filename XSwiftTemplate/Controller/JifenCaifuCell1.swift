//
//  JifenCaifuCell1.swift
//  chengshi
//
//  Created by X on 2016/10/21.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class JifenCaifuCell1: UITableViewCell {

    @IBOutlet var view1: UIView!
    
    @IBOutlet var view2: UIView!
    
    @IBOutlet var view3: UIView!
    
    @IBOutlet var num1: UILabel!
    
    @IBOutlet var num2: UILabel!
    
    @IBOutlet var num3: UILabel!
    
    @IBOutlet var header1: UIImageView!
    
    @IBOutlet var header2: UIImageView!
    
    @IBOutlet var header3: UIImageView!
    
    @IBOutlet var name1: UILabel!
    
    @IBOutlet var name2: UILabel!
    
    @IBOutlet var name3: UILabel!
    
    @IBOutlet var number1: UILabel!
    
    @IBOutlet var number2: UILabel!
    
    @IBOutlet var number3: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let img = "home_head.png".image
        
        header1.image = img
        header2.image = img
        header3.image = img
        
        header1.layer.masksToBounds = true
        header2.layer.masksToBounds = true
        header3.layer.masksToBounds = true
        
        let cm = XCornerRadiusModel()
        cm.StrokePath = true
        cm.StrokeColor = APPOrangeColor
        cm.BorderSidesType = [.Left,.Top]
        cm.BorderLineWidth=1.0
        cm.CornerRadius=30.0
        cm.CornerRadiusType = [.TopLeft]
        
        view2.XCornerRadius = cm
        
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        view2.drawCornerRadius(view2.frame)
        
        header1.layer.cornerRadius = header1.frame.size.width / 2.0
        header2.layer.cornerRadius = header1.frame.size.width / 2.0
        header3.layer.cornerRadius = header1.frame.size.width / 2.0
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        
    }
    
}
