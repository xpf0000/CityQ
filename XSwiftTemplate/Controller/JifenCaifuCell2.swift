//
//  JifenCaifuCell2.swift
//  chengshi
//
//  Created by X on 2016/10/22.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class JifenCaifuCell2: UITableViewCell {

    @IBOutlet var order: UILabel!
    
    @IBOutlet var header: UIImageView!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var num: UILabel!
    
    
    @IBAction func click(sender: AnyObject) {
        
        if model == nil  {return}
        
        let vc = "MyMinePageVC".VC("User") as! MyMinePageVC
        
        vc.uid = model!.uid
        vc.uname = model!.username
        
        vc.hidesBottomBarWhenPushed = true
        
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    var dw = ""
    
    var model:HFBModel?
    {
        didSet
        {
            order.text = model?.pm
            name.text = model?.nickname
            header.url = model?.headimage
            
            let str = dw == "天" ? model!.qdday : model!.hfb
            
            num.text = "\(str)\(dw)"
        }
    }

    
    var lasted = false
    {
        didSet
        {
            if lasted
            {
                XCornerRadius?.CornerRadiusType = [.BottomLeft,.BottomRight]
            
                XCornerRadius?.BorderSidesType = [.Left,.Right,.Bottom]
                
                self.drawCornerRadius(self.frame)
            }
            else
            {
                XCornerRadius?.CornerRadiusType = []
                
                XCornerRadius?.BorderSidesType = [.Left,.Right]
                
                self.drawCornerRadius(self.frame)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let img = "home_head.png".image
        
        header.placeholder = img
        header.layer.masksToBounds = true
        
        let cm = XCornerRadiusModel()
        cm.StrokePath = true
        cm.StrokeColor = APPOrangeColor
        cm.BorderSidesType = [.Left,.Right]
        cm.BorderLineWidth=1.0
        cm.FillColor = UIColor.whiteColor()
        self.XCornerRadius = cm

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setHighlighted(false, animated: false)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.drawCornerRadius(self.bounds)
        header.layer.cornerRadius = header.frame.size.width / 2.0
        
    }


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected
        {
            deSelect()
            
            print("lasted: \(lasted)")
        }
    }
    
}
