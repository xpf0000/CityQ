//
//  CardIndexCell.swift
//  chengshi
//
//  Created by X on 16/6/10.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class CardIndexCell: UITableViewCell {
    
    @IBOutlet var bView: SkyRadiusView!
    
    @IBOutlet var mainRight: NSLayoutConstraint!
    
    @IBOutlet var mainLeft: NSLayoutConstraint!
    
    @IBOutlet var mainBottom: NSLayoutConstraint!
    
    @IBOutlet var imgLeft: NSLayoutConstraint!
    
    @IBOutlet var imgTop: NSLayoutConstraint!
    
    @IBOutlet var imgBottom: NSLayoutConstraint!
    
    @IBOutlet var nameRight: NSLayoutConstraint!
    
    @IBOutlet var nameTop: NSLayoutConstraint!
    
    @IBOutlet var bViewH: NSLayoutConstraint!
    
    @IBOutlet var leftTop: NSLayoutConstraint!
    
    @IBOutlet var leftleft: NSLayoutConstraint!
    
    @IBOutlet var rightRight: NSLayoutConstraint!
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var bgView: SkyRadiusView!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var leftLabel: UILabel!
    
    @IBOutlet var rightLabel: UILabel!
    
    
    
    var model:CardModel!
    {
        didSet
        {
            img.url = model.logo
            bgView.backgroundColor = model.color.color
            bgView.setNeedsDisplay()
            
            let (r,g,b) = model.color.color!.getRGB()
            
            if r<100 && g<100 && b<100
            {
                bView.backgroundColor = UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 0.75)
            }
            else
            {
                bView.backgroundColor = UIColor(red: 65.0/255.0, green: 65.0/255.0, blue: 65.0/255.0, alpha: 0.75)
            }
            bView.setNeedsDisplay()
            
            name.text = model.shopname
            
            rightLabel.text = model.type
            
            leftLabel.text = model.orlq == 0 ? "立即领取" : "已领取"
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        img.placeholder = WhiteDefaultIMG
        
        mainRight.constant = 19.0/2.0 * screenFlag
        mainLeft.constant = 21.0/2.0 * screenFlag
        mainBottom.constant = 15.0 * screenFlag
        
        imgLeft.constant = 21.0/2.0 * screenFlag
        imgTop.constant = 17.0/2.0 * screenFlag
        imgBottom.constant = 14.0/2.0 * screenFlag
        
        bViewH.constant = 77.0/2.0 * screenFlag
        
        nameRight.constant = 15.0 * screenFlag
        
        nameTop.constant = 17.0 * screenFlag
        
        leftTop.constant = 12.0 * screenFlag
        
        leftleft.constant = 14.0 * screenFlag
        
        rightRight.constant = 16.0 * screenFlag
        
        let font = UIFont.boldSystemFontOfSize(16.5 * screenFlag)
        
        name.font = font
        
        leftLabel.font = font
        rightLabel.font = font
        
        let n = 8.0 * screenFlag
        
        bView.cornerRadius = n
        bgView.cornerRadius = n
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        img.layer.masksToBounds = true
        img.layer.cornerRadius = img.frame.size.width / 2.0
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
