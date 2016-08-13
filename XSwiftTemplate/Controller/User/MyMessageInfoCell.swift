//
//  MyMessageInfoCell.swift
//  chengshi
//
//  Created by X on 16/6/13.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyMessageInfoCell: UITableViewCell {
    
    @IBOutlet var from: UILabel!
    
    @IBOutlet var see: UIView!
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet var time: UILabel!
    
    @IBOutlet var mtitle: UILabel!
    
    @IBOutlet var mcontent: UILabel!
    
    @IBOutlet var btn: UIButton!
    
    
    
    @IBAction func toSee(sender: AnyObject) {
        
        toInfoVC()
    }
    
    func toInfoVC()
    {
        DataCache.Share.userMsg.addViewed(model)
        see.hidden = true
        
        mtitle.textColor = "8E8E8E".color
        
        mcontent.textColor = "8E8E8E".color
        
        from.textColor = "8E8E8E".color
        
        btn.selected = true
        
        let vc = "MyMessageContentVC".VC("User") as! MyMessageContentVC
        vc.model = model
        vc.hidesBottomBarWhenPushed = true
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    var model:MessageModel!
    {
        didSet
        {
                let date=NSDate(timeIntervalSince1970: model.create_time.doubleValue!)
                time.text = date.toStr("yyyy-MM-dd HH:mm")!
            
                mtitle.text = model.title
                mcontent.text = model.content
            
                see.hidden = DataCache.Share.userMsg.checkViewed(model)
            
                if(see.hidden)
                {
                    mtitle.textColor = "8E8E8E".color
                    
                    mcontent.textColor = "8E8E8E".color
                    
                    from.textColor = "8E8E8E".color
                    
                    btn.selected = true
                    
                }
                else
                {
                    mtitle.textColor = "333333".color
                    
                    mcontent.textColor = "666666".color
                    
                    from.textColor = "999999".color
                    
                    btn.selected = false

                }

            
                from.text = model.xqname == "" ? model.shopname : model.xqname
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mcontent.preferredMaxLayoutWidth = mcontent.frame.size.width
    }

    override func awakeFromNib() {
        super.awakeFromNib()
      
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 6.0
        mainView.layer.borderColor = "d7d7d7".color!.CGColor
        mainView.layer.borderWidth = 1.0
        
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
            
            toInfoVC()
            
        }
        
    }
    
}
