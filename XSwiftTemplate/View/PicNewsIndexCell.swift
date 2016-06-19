//
//  PicNewsIndexCell.swift
//  chengshi
//
//  Created by X on 15/11/20.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class PicNewsIndexCell: UITableViewCell {

    @IBOutlet var ctitle: UILabel!
    
    @IBOutlet var pic: UIImageView!
    
    var model:NewsModel = NewsModel()
        {
            didSet
            {
                pic.url=model.url
                ctitle.text = model.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pic.layer.masksToBounds = true
        pic.contentMode = .ScaleAspectFill
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if(selected)
        {
            
        }
    }
    
}
