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
