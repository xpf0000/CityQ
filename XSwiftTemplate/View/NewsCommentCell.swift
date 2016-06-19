//
//  NewsCommentCell.swift
//  chengshi
//
//  Created by X on 15/12/5.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class NewsCommentCell: UITableViewCell {

    @IBOutlet var headPic: UIImageView!
    
    @IBOutlet var time: UILabel!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var content: UILabel!
    
    lazy var model:CommentModel=CommentModel()
    
    func show()
    {
        let date=NSDate(timeIntervalSince1970: NSTimeInterval(model.create_time)!)
    
        self.headPic.url = model.headimage
        self.name.text = model.nickname
        self.content.text = model.content
        self.time.text = date.timeSinceNow(0)+"前"
        
        //self.content.layoutIfNeeded()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.content.preferredMaxLayoutWidth = self.content.frame.width
        self.name.font = UIFont(name: "HYQiHei", size: 13.5)
        self.time.font = UIFont(name: "HYQiHei", size: 11.5)
        self.headPic.layer.cornerRadius = 18.0
        self.headPic.layer.masksToBounds = true
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       self.headPic.placeholder = "tx.jpg".image
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
