//
//  MyMinePageCell1.swift
//  chengshi
//
//  Created by 徐鹏飞 on 2016/12/13.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyMinePageCell1: UITableViewCell {

    @IBOutlet weak  var img: UIImageView!
    
    @IBOutlet  weak var name: UILabel!
    
    var model:UserModel?
    {
        didSet
        {
            img.url = model?.headimage
            name.text = model?.nickname
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        img.layer.cornerRadius = img.frame.size.width*0.5
        img.layer.borderColor = UIColor.whiteColor().CGColor
        img.layer.borderWidth = 2.0
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
