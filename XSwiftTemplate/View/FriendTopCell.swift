//
//  FriendTopCell.swift
//  chengshi
//
//  Created by X on 15/12/9.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class FriendTopModel:Reflect
{
    dynamic var count = ""
    var top = ""
    
    func reSet()
    {
        top = ""
        count = ""
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        if(value == nil)
        {
            return
        }
        self.setValue(value, forKey: key)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}

class FriendTopCell: UITableViewCell {

    @IBOutlet var bgView: UIView!
    
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var content: UILabel!
    
    
    lazy var model:FriendTopModel = FriendTopModel()
    
    func show()
    {
        self.img.layer.masksToBounds = true
        self.img.layer.cornerRadius = 5.0
        self.img.placeholder = "tx.jpg".image
        self.img.url = model.top
        self.img.contentMode = .ScaleAspectFill
        
        self.content.text = model.count+"条新消息"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.masksToBounds = true
        self.bgView.layer.cornerRadius = 5.0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func toNext(sender: AnyObject) {
        
        let vc:FriendMessageVC = "FriendMessageVC".VC("Friend") as! FriendMessageVC
        
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
        
        model.reSet()
    }
    
    
    
}
