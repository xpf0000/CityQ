//
//  NewsActivitysCell.swift
//  chengshi
//
//  Created by X on 16/6/13.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class NewsActivitysCell: UITableViewCell {
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var ntitle: UILabel!

    
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
