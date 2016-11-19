//
//  CardTimeChongzhiCell.swift
//  chengshi
//
//  Created by X on 2016/11/17.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class CardTimeChongzhiCell: UICollectionViewCell {

    @IBOutlet var btn: UIButton!
    
    @IBAction func click(sender: UIButton) {
        
        (self.viewController as? CardTimesChongzhiVC)?.choose(sender, model: model!)
    }
    
    var type = 0
    
    var model:CardChongzhiModel?
    {
        didSet
        {
            if let money = model?.money,let value = model?.value
            {
                let str = type == 0 ? "元" : "次"
                btn.setTitle(money+"元/"+value+str, forState: .Normal)
            }
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 8.0
        btn.layer.borderColor = APPBlueColor.CGColor
        btn.layer.borderWidth = 1.0
        
        btn.setTitleColor(APPBlueColor, forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        
        btn.setBackgroundImage(APPBlueColor.image, forState: .Selected)
        btn.setBackgroundImage(UIColor.whiteColor().image, forState: .Normal)
    }

}
