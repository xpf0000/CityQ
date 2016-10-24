//
//  YouhuiquanCell.swift
//  chengshi
//
//  Created by X on 2016/10/24.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class YouhuiquanCell: UICollectionViewCell {

    @IBOutlet var price: UILabel!
    
    @IBOutlet var time: UILabel!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var info: UILabel!
    
    @IBOutlet var state: UIButton!
    
    var model:YouhuiquanModel?
    {
        didSet
        {
            if let str = model?.money
            {
               price.text = "￥\(str)"
            }
            
            if let str = model?.s_money
            {
                if str != "0"
                {
                   info.text = "满\(str)使用"
                }
                else
                {
                    info.text = "无门槛使用"
                }
                
            }
            
            if let stime = model?.s_time
            {
                if let etime = model?.e_time
                {
                    let n = NSDate().toStr("yyyy-MM-dd")
                    if stime == n && etime == n
                    {
                        time.text = "仅限当天"
                    }
                    else
                    {
                        time.text = "\(stime)至\(etime)"
                    }
  
                }
                    
            }
            
            state.selected = model?.orlq == 1
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        state.titleLabel?.numberOfLines = 0
    }

}
