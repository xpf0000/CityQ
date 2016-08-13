//
//  DiscountCell.swift
//  chengshi
//
//  Created by X on 15/11/23.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class DiscountCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var lineH: NSLayoutConstraint!
    
    @IBOutlet var line: UIView!
    
    @IBOutlet var stime: UILabel!
    
    @IBOutlet var etime: UILabel!
    
    @IBOutlet var seeNum: UILabel!
    
    var model:DiscountModel!
    {
        didSet
        {
            self.name.text=self.model.title
            self.img.url=self.model.url
            self.stime.text=self.model.s_time
            self.etime.text=self.model.e_time
            self.seeNum.text = self.model.view
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lineH.constant = 0.333333
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if(selected)
        {
            if let table = UIView.findTableView(self)
            {
                if let index = table.indexPathForCell(self)
                {
                    table.deselectRowAtIndexPath(index, animated: true)
                }
            }
            
            let vc:DiscountInfoVC = "DiscountInfoVC".VC("Discount") as! DiscountInfoVC
            vc.hidesBottomBarWhenPushed=true
            vc.model = self.model
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
            
            if(!DataCache.Share.jigouViewRecord.has(vc.model.id))
            {
                DataCache.Share.jigouViewRecord.add(vc.model.id)

                let url = APPURL+"Public/Found/?service=News.addView&id="+vc.model.id
                
                XHttpPool.requestJson(url, body: nil, method: .GET, block: { (o) -> Void in
                    
                })
                
            }
            
            
        }
    }
    
}
