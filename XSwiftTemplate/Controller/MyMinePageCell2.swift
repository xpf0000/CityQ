//
//  MyMinePageCell2.swift
//  chengshi
//
//  Created by 徐鹏飞 on 2016/12/13.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyMinePageCell2: UITableViewCell {

    @IBOutlet weak var sex: UILabel!
    
    @IBOutlet weak var birthday: UILabel!
    
    var model:UserModel?
        {
        didSet
        {
            
            if(model?.sex == "0")
            {
                self.sex.text = "女"
            }
            else
            {
                self.sex.text = "男"
            }

            birthday.text = model?.birthday
            
        }
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
