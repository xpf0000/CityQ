//
//  PropertyPhptoCell.swift
//  chengshi
//
//  Created by X on 16/2/23.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class PropertyPhptoCell: UITableViewCell {
    
    @IBOutlet var pic: UIImageView!
    
    @IBOutlet var typeView: UIView!
    
    // 所属分类0,问题 fe4400；1，建议 00a9fe；2.表扬 26cb3a
    @IBOutlet var type: UILabel!
    
    @IBOutlet var time: UILabel!
    
    @IBOutlet var ptitle: UILabel!

    let typeStr=["0":"报修","1":"建议","2":"表扬"]
    let typeColor = ["0":"fe4400".color,"1":"00a9fe".color,"2":"26cb3a".color]
    
    var model:PropertyPhoteModel!
    {
        didSet
        {
            show()
        }
    }
    
    private func show() {
        
        if let m = self.model
        {
            if m.picList.count > 0
            {
                pic.url = m.picList[0].url
            }
            else
            {
                pic.image = "bucket_no_picture@2x.png".image
            }
            
            typeView.backgroundColor = typeColor[m.type]!
            type.text = typeStr[m.type]
            time.text = m.create_time
            ptitle.text=m.content
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ptitle.preferredMaxLayoutWidth = swidth-114
        
        pic.layer.cornerRadius = 6.0
        pic.layer.masksToBounds = true
        
        typeView.layer.cornerRadius = 5.0
        typeView.layer.masksToBounds = true
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
            
            let vc = "PropertyPhotoInfoVC".VC("Wuye") as! PropertyPhotoInfoVC
            
            vc.model = self.model
            
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
