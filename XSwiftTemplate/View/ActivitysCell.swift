//
//  ActivitysCell.swift
//  chengshi
//
//  Created by X on 16/6/16.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class ActivitysCell: UITableViewCell {
    
    @IBOutlet var ntitle: UILabel!
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var stateImg: UIImageView!
    
    @IBOutlet var time: UILabel!
    
    @IBOutlet var join: UILabel!
    
    
    var model:NewsModel!
        {
        didSet
        {
            img.url = model.url
            ntitle.text = model.title
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
