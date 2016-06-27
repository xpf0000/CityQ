//
//  FrientPicCell.swift
//  chengshi
//
//  Created by X on 15/11/24.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class FrientPicCell: UICollectionViewCell {

    @IBOutlet var img: UIImageView!
    
    var model:FriendPicModel?
    
    func show()
    {
        if(model != nil)
        {
          self.img.url = model!.url
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    
    deinit
    {
    }

}
