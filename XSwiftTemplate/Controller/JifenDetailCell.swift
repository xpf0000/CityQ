//
//  JifenDetailCell.swift
//  chengshi
//
//  Created by X on 2016/10/20.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class JifenDetailCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    
    @IBOutlet var time: UILabel!
    
    @IBOutlet var num: UILabel!
    
    @IBOutlet var price: UILabel!
    
    var model:HFBModel?
    {
        didSet
        {
            name.text = model?.name
            time.text = model?.create_time
            if let n = model?.hfbsy
            {
                num.text = "余额: \(n)个"
            }
            
            if let n = model?.hfb
            {
                price.text = "+\(n)"
            }
            
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
