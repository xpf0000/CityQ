//
//  MyPostFriendCell.swift
//  chengshi
//
//  Created by X on 15/11/30.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyPostFriendCell: UITableViewCell {

    @IBOutlet var day: UILabel!
    
    @IBOutlet var month: UILabel!
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var ctitle: UILabel!
    
    @IBOutlet var replyNum: UILabel!
    
    @IBOutlet var zanNum: UILabel!
    
    var model:FriendModel!
    {
        didSet
        {
            self.show()
        }
    }
    
    func show() {
        
        self.ctitle.preferredMaxLayoutWidth = swidth - (80+75+20)
        
        if(self.model != nil)
        {
            self.img.layer.masksToBounds = true
            self.img.contentMode = .ScaleAspectFill

            let date=NSDate(timeIntervalSince1970: NSTimeInterval(model.create_time)!)
            
            let gregorian:NSCalendar=NSCalendar(calendarIdentifier: NSGregorianCalendar)!
            
            let unitFlags:NSCalendarUnit = [.NSDayCalendarUnit, .NSYearCalendarUnit, .NSMonthCalendarUnit]
            
            let comps=gregorian.components(unitFlags, fromDate: date)
            let comps1=gregorian.components(unitFlags, fromDate: NSDate())
            
            
            if(comps.year != comps1.year)
            {
                self.day.text = "\(comps.day)"
                self.month.text = "\(comps.month)月"
            }
            else
            {
                if(comps.day == comps1.day && comps.month == comps1.month)
                {
                    self.day.text = "今天"
                    self.month.text = ""
                }
                else
                {
                    self.day.text = "\(comps.day)"
                    self.month.text = "\(comps.month)月"
                }
            }
            
            
            if(self.model.picList.count > 0)
            {
                self.img.url =  self.model.picList[0].url
            }
            
            self.ctitle.text = self.model.content
            self.replyNum.text = "\(self.model.comment)"
            self.zanNum.text = "\(self.model.zan)"
            
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
