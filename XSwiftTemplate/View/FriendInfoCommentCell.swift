//
//  FriendInfoCommentCell.swift
//  chengshi
//
//  Created by X on 15/12/17.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class FriendInfoCommentCell: UITableViewCell {

    @IBOutlet var headPic: UIImageView!
    
    @IBOutlet var nick: UILabel!
    
    @IBOutlet var sexIcon: UIImageView!
    
    @IBOutlet var content: UILabel!
    
    @IBOutlet var time: UILabel!
    
    lazy var model:FriendCommentModel = FriendCommentModel()
    
    func setComment()
    {
        var str=(model.content).trim()
        if(model.tnickname != "")
        {
            str=("回复"+model.tnickname+":"+model.content).trim()
        }

        let attributedString1:NSMutableAttributedString = NSMutableAttributedString(string: str)
        let paragraphStyle1:NSMutableParagraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle1.lineSpacing = 5.0
        
        attributedString1.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle1, range: NSMakeRange(0, (str as NSString).length))
        
        self.content.attributedText = attributedString1
        
        self.content.layoutIfNeeded()
    }
    
    func show()
    {
        self.headPic.url = self.model.headimage
        self.nick.text = self.model.nickname
        
        let date=NSDate(timeIntervalSince1970: NSTimeInterval(model.create_time)!)
        self.time.text = date.timeSinceNow(0)+"前"
        
        if(model.sex == "")
        {
            self.sexIcon.hidden = true
        }
        else if(model.sex == "0")
        {
            self.sexIcon.hidden = false
            self.sexIcon.image = "female_icon.png".image
        }
        else
        {
            self.sexIcon.hidden = false
            self.sexIcon.image = "male_icon.png".image
        }
        
        
        var rang:NSRange
        var rang1:NSRange
        var str=(model.content).trim()
        if(model.tnickname != "")
        {
            str=("回复"+model.tnickname+":"+model.content).trim()
        }
        
        rang=(str as NSString).rangeOfString(model.nickname)
        
        let attributedString1:NSMutableAttributedString = NSMutableAttributedString(string: str)
        let paragraphStyle1:NSMutableParagraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle1.lineSpacing = 5.0
        
        attributedString1.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle1, range: NSMakeRange(0, (str as NSString).length))
        attributedString1.addAttribute(NSForegroundColorAttributeName, value: "#2674C5".color!, range: rang)
        
        if(model.tnickname != "")
        {
            rang1 = (str as NSString).rangeOfString(model.tnickname)
            attributedString1.addAttribute(NSForegroundColorAttributeName, value: "#2674C5".color!, range: rang1)
        }
        
        self.content.attributedText = attributedString1
        
        self.content.layoutIfNeeded()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.headPic.placeholder = "tx.jpg".image
        self.headPic.layer.masksToBounds = true
        self.headPic.layer.cornerRadius = 16.0
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
