//
//  NewsListCell.swift
//  chengshi
//
//  Created by X on 15/11/19.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class NewsListCell: UITableViewCell {

    @IBOutlet var pic: UIImageView!
    
    @IBOutlet var ntitle: UILabel!
    
    @IBOutlet var seeNum: UILabel!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var picTrailing: NSLayoutConstraint!
    
    var model:NewsModel!
    {
        didSet
        {
            show()
        }
    }
    
    func setHasSee()
    {
        if(DataCache.Share().newsViewedModel.has(model.id))
        {
            ntitle.textColor = UIColor(red: 142.0/255.0, green: 142.0/255.0, blue: 142.0/255.0, alpha: 1.0)
        }
        else
        {
            ntitle.textColor = UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        }
    }
    
    private func show() {
        if(self.model != nil)
        {
            if let  m = self.model
            {
                setHasSee()
                
                if m.url == ""
                {
                    picTrailing.constant = -(100+7)
                    pic.url = nil
                    pic.image = nil
                }
                else
                {
                    picTrailing.constant = 8.0
                    pic.url=m.url
                }

                let str=m.title.subStringToIndex(26)
                
                let attributedString1:NSMutableAttributedString = NSMutableAttributedString(string: str)
                let paragraphStyle1:NSMutableParagraphStyle = NSMutableParagraphStyle()
                
                paragraphStyle1.lineSpacing = 5.0
                
                attributedString1.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle1, range: NSMakeRange(0, (str as NSString).length))
                
                ntitle.attributedText = attributedString1
                ntitle.layoutIfNeeded()
                ntitle.setNeedsLayout()
                
                seeNum.text = m.view
                
                name.text = m.name
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ntitle.preferredMaxLayoutWidth = ntitle.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    deinit
    {
        print("NewsCell deinit !!!!!!!")
    }
    
}
