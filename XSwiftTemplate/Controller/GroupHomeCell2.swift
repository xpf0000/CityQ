//
//  GroupHomeCell2.swift
//  chengshi
//
//  Created by X on 2016/11/12.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class GroupHomeCell2: UITableViewCell {
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var txt: UILabel!
    
    var model:GroupModel?
    {
        didSet
        {
            img.url = model?.url
            txt.text = model?.jdinfo
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected
        {
            self.deSelect()
            
            let vc = "CardShopsInfoVC".VC("Card") as! CardShopsInfoVC
            vc.id = model!.id
            vc.title = model?.name
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
