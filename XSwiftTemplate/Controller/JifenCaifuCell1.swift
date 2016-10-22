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
    
    var dw = ""
    
    var model1:HFBModel?
    {
        didSet
        {
            name1.text = model1?.nickname
            header1.url = model1?.headimage
            
            let str = dw == "天" ? model1!.qdday : model1!.hfb
            
            number1.text = "\(str)\(dw)"
        }
    }
    
    var model2:HFBModel?
        {
        didSet
        {
            name2.text = model2?.nickname
            header2.url = model2?.headimage
            
            let str = dw == "天" ? model2!.qdday : model2!.hfb
            
            number2.text = "\(str)\(dw)"
        }
    }
    
    var model3:HFBModel?
        {
        didSet
        {
            name3.text = model3?.nickname
            header3.url = model3?.headimage
            
            let str = dw == "天" ? model3!.qdday : model3!.hfb
            
            number3.text = "\(str)\(dw)"
        }
    }
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let img = "home_head.png".image
        
        header1.placeholder = img
        header2.placeholder = img
        header3.placeholder = img
        
        header1.layer.masksToBounds = true
        header2.layer.masksToBounds = true
        header3.layer.masksToBounds = true
        
        let cm = XCornerRadiusModel()
        cm.StrokePath = true
        cm.StrokeColor = APPOrangeColor
        cm.BorderSidesType = [.Left,.Top]
        cm.BorderLineWidth=1.0
        cm.CornerRadius=6.0
        cm.CornerRadiusType = [.TopLeft]
        
        view2.XCornerRadius = cm
        
        let cm3 = XCornerRadiusModel()
        cm3.StrokePath = true
        cm3.StrokeColor = APPOrangeColor
        cm3.BorderSidesType = [.Right,.Top]
        cm3.BorderLineWidth=1.0
        cm3.CornerRadius=6.0
        cm3.CornerRadiusType = [.TopRight]
        
        view3.XCornerRadius = cm3
        
        
        
        let cm1 = XCornerRadiusModel()
        cm1.StrokePath = true
        cm1.StrokeColor = APPOrangeColor
        cm1.BorderSidesType = [.Right,.Top,.Left]
        cm1.BorderLineWidth=1.0
        cm1.CornerRadius=6.0
        cm1.CornerRadiusType = [.TopRight,.TopLeft]
        
        view1.XCornerRadius = cm1
        
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        view1.drawCornerRadius(view1.frame)
        view2.drawCornerRadius(view2.frame)
        view3.drawCornerRadius(view3.frame)
        
        header1.layer.cornerRadius = header1.frame.size.width / 2.0
        header2.layer.cornerRadius = header2.frame.size.width / 2.0
        header3.layer.cornerRadius = header3.frame.size.width / 2.0
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        
    }
    
}
