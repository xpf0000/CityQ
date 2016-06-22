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
            ctitle.text = model.title
            time.text = model.s_time
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
