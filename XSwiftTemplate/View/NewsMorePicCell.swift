//
//  NewsMorePicCell.swift
//  chengshi
//
//  Created by X on 16/7/15.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class NewsMorePicCell: UITableViewCell {

    @IBOutlet var ntitle: UILabel!
    
    @IBOutlet var img1: UIImageView!
    
    @IBOutlet var img2: UIImageView!
    
    @IBOutlet var img3: UIImageView!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var num: UILabel!
    
    @IBOutlet var time: UILabel!
    
    var model:NewsModel!
        {
        didSet
        {
            show()
        }
    }
    
    func setHasSee()
    {
        if(DataCache.Share.newsViewedModel.has(model.id))
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
                
                img1.url = model.picList[0].url
                img2.url = model.picList[1].url
                img3.url = model.picList[2].url
                
                let str=m.title.subStringToIndex(26)
                
                let attributedString1:NSMutableAttributedString = NSMutableAttributedString(string: str)
                let paragraphStyle1:NSMutableParagraphStyle = NSMutableParagraphStyle()
                
                paragraphStyle1.lineSpacing = 0.0
                
                attributedString1.addAttributes([NSParagraphStyleAttributeName:paragraphStyle1,NSFontAttributeName:UIFont.systemFontOfSize(16.0)], range: NSMakeRange(0, (str as NSString).length))
                
                
                ntitle.attributedText = attributedString1
                ntitle.layoutIfNeeded()
                ntitle.setNeedsLayout()
                
                
                
                num.text = m.view+"阅读"
                
                name.text = m.name
                
                time.text = UIString.timeSinceNow(m.create_time, flag: 0)
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
    
}
