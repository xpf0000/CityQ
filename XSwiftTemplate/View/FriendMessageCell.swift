//
//  FriendMessageCell.swift
//  chengshi
//
//  Created by X on 15/12/9.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class FriendMessageCell: UITableViewCell {

    @IBOutlet var head: UIImageView!
    
    @IBOutlet var nick: UILabel!
    
    @IBOutlet var content: UILabel!
    
    @IBOutlet var time: UILabel!
    
    @IBOutlet var pic: UIImageView!
    
    @IBOutlet var heatIcon: UIImageView!
    
    
    lazy var model:FriendMsgModel = FriendMsgModel()
    
    func show()
    {
        self.head.layer.cornerRadius = 5.0
        self.head.layer.masksToBounds = true
        self.head.url = model.headimage
        self.head.contentMode = .ScaleAspectFill
        
        self.nick.text = model.nickname
        self.time.text = model.create_time
    
        self.pic.layer.masksToBounds = true
        self.pic.url = model.dpic
        self.pic.contentMode = .ScaleAspectFill
        
        if(model.content != "0")
        {
            self.heatIcon.hidden = true
            self.content.text = model.content
            self.content.layoutIfNeeded()
        }
        else
        {
            self.heatIcon.hidden = false
            self.content.text = " "
            self.content.layoutIfNeeded()
        }
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.content.preferredMaxLayoutWidth = self.content.frame.width
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
