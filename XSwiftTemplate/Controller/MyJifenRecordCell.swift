//
//  MyJifenRecordCell.swift
//  chengshi
//
//  Created by X on 16/6/21.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyJifenRecordCell: UITableViewCell {
    
    @IBOutlet var time: UILabel!
    
    @IBOutlet var line: UIView!
    
    @IBOutlet var info: UILabel!
    
    @IBOutlet var lineH: NSLayoutConstraint!
    
    var model:JifenRecordModel!
        {
        didSet
        {
            info.preferredMaxLayoutWidth = swidth - 56.0
            
            time.text = model.create_time
            
            let str1 = "增加积分: \(model.jf)\r\n剩余积分: \(model.jfsy)\r\n店铺名称: "+model.shopname
            
            let attributedString1=NSMutableAttributedString(string: str1)
            let paragraphStyle1=NSMutableParagraphStyle()
            paragraphStyle1.lineSpacing=5.0
            
            attributedString1.addAttributes([NSParagraphStyleAttributeName:paragraphStyle1,NSFontAttributeName:UIFont.systemFontOfSize(16.0)], range: NSMakeRange(0, (str1 as NSString).length))
            
            let rang = (str1 as NSString).rangeOfString("增加积分: \(model.jf)")
            let rang1 = (str1 as NSString).rangeOfString("剩余积分: \(model.jfsy)")
            
            attributedString1.addAttributes([NSForegroundColorAttributeName:"666666".color!], range: NSMakeRange(0, (str1 as NSString).length))
            
            attributedString1.addAttributes([NSForegroundColorAttributeName:"239400".color!], range: rang)
            
            attributedString1.addAttributes([NSForegroundColorAttributeName:"bd0000".color!], range: rang1)
            
            info.attributedText = attributedString1
            info.layoutIfNeeded()
            info.setNeedsLayout()
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lineH.constant = 0.3333
        info.preferredMaxLayoutWidth = swidth - 56.0
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
