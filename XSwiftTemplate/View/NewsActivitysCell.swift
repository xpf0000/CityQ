//
//  NewsActivitysCell.swift
//  chengshi
//
//  Created by X on 16/6/13.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class NewsActivitysCell: UITableViewCell {
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var ntitle: UILabel!

    @IBOutlet var top: NSLayoutConstraint!
    
    @IBOutlet var bottom: NSLayoutConstraint!
    
    
    var model:NewsModel!
    {
        didSet
        {
            var b = false
            if model.url != ""
            {
                img.url = model.url
                b = true
            }
            else
            {
                if model.picList.count > 0
                {
                    img.url = model.picList[0].url
                    b = true
                }
            }
            
            if !b
            {
                img.image = nil
                img.url = nil
            }
            
            ntitle.text = model.title
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        top.constant = 10 * screenFlag
        bottom.constant = 8 * screenFlag
        
//        self.layoutIfNeeded()
//        self.setNeedsLayout()
       
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected
        {
            self.selected = false
        }

       
    }
    
}
