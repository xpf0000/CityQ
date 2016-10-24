//
//  JifenGoodsCell.swift
//  chengshi
//
//  Created by X on 2016/10/24.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class JifenGoodsCell: UICollectionViewCell {

    @IBOutlet var img: UIImageView!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var price: UILabel!
    
    var model:GoodsModel?
    {
        didSet
        {
            img.url = model?.url
            name.text = model?.name
            if let str = model?.hfb
            {
                price.text = str+"怀府币"
            }
            
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
