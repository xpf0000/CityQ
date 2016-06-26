//
//  MyMessageInfoCell.swift
//  chengshi
//
//  Created by X on 16/6/13.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyMessageInfoCell: UITableViewCell {
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet var time: UILabel!
    
    @IBOutlet var mtitle: UILabel!
    
    @IBOutlet var mcontent: UILabel!
    
    @IBAction func toSee(sender: AnyObject) {
        
        toInfoVC()
    }
    
    func toInfoVC()
    {
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
                time.text = date.toStr("yyyy年MM月dd号")!
            
                mtitle.text = model.title
                mcontent.text = model.content
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
            self.selected = false
        
            toInfoVC()
        }
        
    }
    
}
