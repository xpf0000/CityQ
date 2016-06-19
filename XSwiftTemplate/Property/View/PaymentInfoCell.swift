//
//  PaymentInfoCell.swift
//  chengshi
//
//  Created by X on 16/2/26.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class PaymentInfoCell: UITableViewCell {

    
    @IBOutlet var time: UILabel!
    
    @IBOutlet var num: UILabel!
    
    @IBOutlet var yprice: UILabel!
    
    @IBOutlet var yuprice: UILabel!
    
    
    var model:PropertyPaymentModel!
        {
            didSet
            {
                show()
        }
    }
    
    var type = 0
    
    func show() {
        
        if let m = self.model
        {
            self.time.text = m.create_time
            
            if type == 3 || type == 2
            {
                self.num.text = m.unumber
                self.yprice.text = m.ymoney
                self.yuprice.text = m.yumoney
            }
            else
            {
                self.num.text = m.ymoney
                self.yprice.text = m.smoney
                self.yuprice.text = m.yumoney
            }
            
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if let m = self.model
        {
            if type == 3 || type == 2
            {
                
                if selected
                {
                    self.selected = false

                    let vc = PaymentInfoInfoVC()
                    vc.model = m
                    
                    vc.hidesBottomBarWhenPushed = true
                    self.viewController?.navigationController?.pushViewController(vc, animated: true)
                    
                }
  
            }
        }
        
    }
    
}
