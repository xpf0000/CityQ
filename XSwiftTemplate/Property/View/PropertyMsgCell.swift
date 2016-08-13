//
//  PropertyMsgCell.swift
//  chengshi
//
//  Created by X on 16/3/28.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class PropertyMsgCell: UITableViewCell,UIActionSheetDelegate  {
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var mcontent: UILabel!
    
    @IBOutlet var time: UILabel!
    
    var model:PropertyMsgModel!
    {
        didSet
        {
            name.text = model.xiaoqu
            mcontent.text = model.content
            time.text = model.create_time
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected
        {
            if let table = UIView.findTableView(self)
            {
                if let index = table.indexPathForCell(self)
                {
                    table.deselectRowAtIndexPath(index, animated: true)
                }
            }
            
            let vc = OAMessageInfoVC()
            vc.model.content = self.model.content
            vc.msgTitle.text = self.model.xiaoqu
            vc.ltitle.text = self.model.create_time
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }
    
}
