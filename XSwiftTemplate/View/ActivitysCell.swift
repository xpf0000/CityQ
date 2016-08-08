//
//  ActivitysCell.swift
//  chengshi
//
//  Created by X on 16/6/16.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class ActivitysCell: UITableViewCell {
    
    @IBOutlet var ntitle: UILabel!
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var stateImg: UIImageView!
    
    @IBOutlet var time: UILabel!
    
    @IBOutlet var join: UILabel!
    
    
    var model:NewsModel!
        {
        didSet
        {
            
            let date=NSDate(timeIntervalSince1970: model.e_time.numberValue.doubleValue)
            let estr = date.toStr("yyyy-MM-dd")!
            
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
            time.text = "活动时间: \(model.s_time)~\(estr)"
            
            let nt = NSDate().formart().timeIntervalSince1970
            
            if nt < model.e_time.numberValue.doubleValue
            {
                stateImg.image = "jingxingzhong.png".image
            }
            else
            {
                stateImg.image = "yijieshu.png".image
            }

        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected
        {
            self.selected = false
        }

        
    }
    
}
