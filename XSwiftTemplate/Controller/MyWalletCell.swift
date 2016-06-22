//
//  MyWalletCell.swift
//  chengshi
//
//  Created by X on 16/6/21.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyWalletCell: UITableViewCell {

    @IBOutlet var time: UILabel!
    
    @IBOutlet var line: UIView!
    
    @IBOutlet var info: UILabel!
    
    @IBOutlet var lineH: NSLayoutConstraint!
    
    var model:WalletModel!
    {
        didSet
        {
            time.text = model.create_time
            var str = ""
            var str1=""
            //1充值 2消费
            if model.type == "1"
            {
                str += "充值: +"+model.money+"元"
            }
            else
            {
                str += "消费: -"+model.money+"元"
            }
            
            str1 += str
            
            if model.value.numberValue.doubleValue > 0.0
            {
                str1 += "\r\n获得积分: "+model.value
            }
          
            str1 += "\r\n店铺名称: "+model.shopname
            
            
            
            let attributedString1=NSMutableAttributedString(string: str1)
            let paragraphStyle1=NSMutableParagraphStyle()
            paragraphStyle1.lineSpacing=5.0
//            paragraphStyle1.paragraphSpacing=10.0
//            paragraphStyle1.firstLineHeadIndent=10.0
            attributedString1.addAttributes([NSParagraphStyleAttributeName:paragraphStyle1,NSFontAttributeName:UIFont.systemFontOfSize(16.0)], range: NSMakeRange(0, (str1 as NSString).length))
            
            let rang = (str1 as NSString).rangeOfString(str)
            var color:UIColor!
            if model.type == "1"
            {
                color = "239400".color
            }
            else
            {
                color = "bd0000".color
            }
            
            attributedString1.addAttributes([NSForegroundColorAttributeName:"666666".color!], range: NSMakeRange(0, (str1 as NSString).length))
            attributedString1.addAttributes([NSForegroundColorAttributeName:color], range: rang)
            
            info.attributedText = attributedString1
            info.layoutIfNeeded()
            
            
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
