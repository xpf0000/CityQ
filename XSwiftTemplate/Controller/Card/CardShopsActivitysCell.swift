//
//  CardShopsActivitysCell.swift
//  chengshi
//
//  Created by X on 16/6/11.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class CardShopsActivitysCell: UITableViewCell {

    @IBOutlet var ctitle: UILabel!
    
    @IBOutlet var time: UILabel!
    
    var model:CardActivityModel!
    {
        didSet
        {
            ctitle.text = "1.充值100元送话费20元"
            time.text = "2016-06-11"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
