//
//  GroupSearchCell.swift
//  chengshi
//
//  Created by X on 2016/11/12.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class GroupSearchCell: UITableViewCell {
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var icon: UIImageView!
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var txt: UILabel!

    var model:GroupModel?
    {
        didSet
        {
            name.text = model?.name
            img.url = model?.url
            txt.text = model?.jdinfo
            
            if let str = model?.viplevel
            {
                icon.hidden = false
                if str == "1"
                {
                    
                    icon.image = "renzheng_icon.png".image
                }
                else if str == "2"
                {
                    icon.image = "vip_icon.png".image
                }
                else if str == "3"
                {
                    icon.image = "svip_icon.png".image
                }
                else
                {
                    icon.hidden = true
                }
                
                
            }
            
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        img.layer.masksToBounds = true
        img.layer.cornerRadius = img.frame.size.height*0.5
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
