//
//  PropertyPhotoInfoCell.swift
//  chengshi
//
//  Created by X on 16/2/24.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class PropertyPhotoInfoCell: UITableViewCell {

    @IBOutlet var timeView: UIView!
    
    @IBOutlet var time: UILabel!
    
    @IBOutlet var pic: UIImageView!
    
    @IBOutlet var label: UILabel!
    
    @IBOutlet var replyView: SkyRadiusView!
    
    
    @IBOutlet var leftPic: UIImageView!
    
    @IBOutlet var leftReplyView: UIView!
    
    @IBOutlet var leftLabel: UILabel!

    @IBOutlet var rightPao: UIImageView!
    
    @IBOutlet var leftPao: UIImageView!
    
    
    var model:PropertyPhoteModel!
    
    var minH:CGFloat = 0.0
    
    func show()
    {
        time.text = model.create_time.replace(NSDate().toStr("yyyy")!+"-", with: "")
        label.text = ""
        leftLabel.text = ""
        if(model.uid == DataCache.Share.userModel.uid)
        {
            leftPic.hidden = true
            leftReplyView.hidden = true
            leftPao.hidden = true
            pic.hidden = false
            replyView.hidden = false
            rightPao.hidden = false
            
            label.text = model.content
            
            let h = label.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
            
            if h > minH
            {
                label.textAlignment = .Left
            }
            else
            {
                label.textAlignment = .Center
            }
        }
        else
        {
            leftPic.hidden = false
            leftReplyView.hidden = false
            leftPao.hidden = false
            pic.hidden = true
            replyView.hidden = true
            rightPao.hidden = true
            
            leftLabel.text = model.content
            
            let h = leftLabel.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
            
            if h > minH
            {
                leftLabel.textAlignment = .Left
            }
            else
            {
                leftLabel.textAlignment = .Center
            }

        }
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        timeView.layer.cornerRadius = 13.0
        timeView.layer.masksToBounds = true
        
        label.preferredMaxLayoutWidth = swidth*0.5-20
        pic.placeholder = "tx.jpg".image
        pic.layer.cornerRadius = 3.0
        pic.layer.masksToBounds = true
        pic.url = DataCache.Share.userModel.headimage
        replyView.layer.cornerRadius = 10.0
        replyView.layer.masksToBounds = true
        
        leftLabel.preferredMaxLayoutWidth = swidth*0.5-20
        leftPic.layer.cornerRadius = 3.0
        leftPic.layer.masksToBounds = true
        leftReplyView.layer.cornerRadius = 10.0
        leftReplyView.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
