//
//  PhoneClassCell.swift
//  chengshi
//
//  Created by X on 15/11/23.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class DiscountClassCell: UICollectionViewCell {

    @IBOutlet var img: UIImageView!
    
    @IBOutlet var ctitle: UILabel!
    
    @IBOutlet var imgH: NSLayoutConstraint!
    
    @IBOutlet var imgW: NSLayoutConstraint!
    
    lazy var model:CategoryModel=CategoryModel()
    
    
    func show()
    {
        self.img.url=model.url
        self.ctitle.text=model.title
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgH.constant = swidth/4.0*0.4
        imgW.constant = swidth/4.0*0.4
    }

}
