//
//  FrientReplyCell.swift
//  chengshi
//
//  Created by X on 15/11/24.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class FrientReplyCell: UITableViewCell {

    @IBOutlet var label: UILabel!

    var replyOtherBlock:AnyBlock?
    lazy var model:FriendCommentModel = FriendCommentModel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.preferredMaxLayoutWidth = label.frame.width
    }
    
    func show()
    {
        var rang:NSRange
        var rang1:NSRange
        var str=(model.nickname+":"+model.content).trim()
        if(model.tnickname != "")
        {
            str=(model.nickname+"回复"+model.tnickname+":"+model.content).trim()
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
        
        label.attributedText = attributedString1
        
        label.layoutIfNeeded()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if(selected)
        {
            if(self.replyOtherBlock != nil)
            {
                self.replyOtherBlock!(self.model)
            }
        }
        
    }
    
}
