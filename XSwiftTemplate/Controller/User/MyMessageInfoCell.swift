//
//  MyMessageInfoCell.swift
//  chengshi
//
//  Created by X on 16/6/13.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyMessageInfoCell: UITableViewCell {
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet var time: UILabel!
    
    @IBOutlet var mtitle: UILabel!
    
    @IBOutlet var mcontent: UILabel!
    
    @IBAction func toSee(sender: AnyObject) {
        
        
    }
    
    var model:MessageModel!
    {
        didSet
        {
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mcontent.preferredMaxLayoutWidth = mcontent.frame.size.width
    }

    override func awakeFromNib() {
        super.awakeFromNib()
      
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 6.0
        mainView.layer.borderColor = "d7d7d7".color!.CGColor
        mainView.layer.borderWidth = 1.0
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        
    }
    
}
