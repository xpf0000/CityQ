//
//  FriendClassCell.swift
//  chengshi
//
//  Created by X on 15/12/3.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class FriendClassCell: UITableViewCell {

    @IBOutlet var img: UIImageView!
    
    @IBOutlet var ctitle: UILabel!
    
    
    lazy var model:CategoryModel=CategoryModel()
    
    func show()
    {
        self.img.url = model.url
        self.ctitle.text = model.title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
