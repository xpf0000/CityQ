//
//  FriendNewsCell.swift
//  chengshi
//
//  Created by X on 15/11/26.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class FriendNewsCell: UICollectionViewCell {

    @IBOutlet var img: UIImageView!
    
    @IBOutlet var content: UILabel!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var time: UILabel!
    
    lazy var model:FriendModel=FriendModel()
    
    
    func show()
    {
        self.img.layer.masksToBounds = true
        self.img.contentMode = .ScaleAspectFill
        self.img.url=model.url
        self.content.text = model.content
        self.name.text = model.nickname
        
        let date=NSDate(timeIntervalSince1970: NSTimeInterval(model.create_time)!)
        self.time.text = date.timeSinceNow(0)+"前"
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
