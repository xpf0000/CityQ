//
//  MyCollectCell.swift
//  chengshi
//
//  Created by X on 15/11/30.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyCollectCell: UITableViewCell {

    @IBOutlet var img: UIImageView!
    
    @IBOutlet var ctitle: UILabel!
    
    var model:MyCollectModel = MyCollectModel()
        {
            didSet
            {
               self.ctitle.preferredMaxLayoutWidth = swidth - 140
                img.url = model.url
                ctitle.text = model.title
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
            
            let vc:NewsInfoVC = "NewsInfoVC".VC as! NewsInfoVC
            vc.model = NewsModel()
            vc.model.id = model.id
            vc.model.url = model.url
            vc.model.title = model.title
            vc.http()
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
}
