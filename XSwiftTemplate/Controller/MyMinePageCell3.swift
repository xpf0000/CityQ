//
//  MyMinePageCell3.swift
//  chengshi
//
//  Created by 徐鹏飞 on 2016/12/13.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyMinePageCell3: UITableViewCell {

    var typeEnable=true
    
    @IBOutlet weak var headPic: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var picsView: UIView!
    
    @IBOutlet weak var picsH: NSLayoutConstraint!
    
    @IBOutlet weak var picsW: NSLayoutConstraint!
    
    @IBOutlet weak var sexIcon: UIImageView!
    
    
    var baseW=swidth-62
    
    var model:FriendModel = FriendModel()
        {
        didSet
        {
            show()
        }
    }
    
    lazy var replyCellHs:Array<CGFloat> = []
    
    
    private func show() {
        
        if(model.id.numberValue.intValue == 0)
        {
            return
        }
    
        self.headPic.url = model.headimage
        
        let date=NSDate(timeIntervalSince1970: NSTimeInterval(model.create_time)!)
        
        let gregorian:NSCalendar=NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        
        let unitFlags:NSCalendarUnit = [.NSDayCalendarUnit, .NSYearCalendarUnit, .NSMonthCalendarUnit]
        
        let comps=gregorian.components(unitFlags, fromDate: date)
        let comps1=gregorian.components(unitFlags, fromDate: NSDate())
        
        
        if(comps.year != comps1.year)
        {
            self.time.text = date.str
        }
        else
        {
            if(comps.day == comps1.day && comps.month == comps1.month)
            {
                self.time.text = date.toStr("HH:mm")
            }
            else
            {
                self.time.text = date.toStr("MM-dd HH:mm")
            }
        }
        
        if(model.sex == "0")
        {
            self.sexIcon.image = "female_icon.png".image
        }
        else
        {
            self.sexIcon.image = "male_icon.png".image
        }
        
        self.name.text = model.nickname

        let attributedString1:NSMutableAttributedString = NSMutableAttributedString(string: model.content)
        let paragraphStyle1:NSMutableParagraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle1.lineSpacing = 2.5
        
        attributedString1.addAttributes([NSParagraphStyleAttributeName:paragraphStyle1,NSKernAttributeName:0.0], range: NSMakeRange(0, (model.content as NSString).length))
        
        self.content.numberOfLines = 0
        self.content.attributedText = attributedString1
        self.content.layoutIfNeeded()

        
        var  lineMax = 1
        var imgw:CGFloat = 1.0
        var imgh:CGFloat = 1.0
        if(model.picList.count >= 3)
        {
            lineMax = 3
            imgw = baseW/3.0
            imgh = imgw
            self.picsH.constant = baseW/3.0*CGFloat(ceil(Double(model.picList.count)/3.0))
            self.picsW.constant = baseW
        }
        else if(model.picList.count == 2)
        {
            imgw = baseW/2.0
            imgh = imgw
            lineMax = 2
            self.picsH.constant = baseW/2.0
            self.picsW.constant = baseW
        }
        else if(model.picList.count == 1)
        {
            let width:CGFloat=model.picList[0].width
            let height:CGFloat = model.picList[0].height
            
            var newW:CGFloat = width
            var newH:CGFloat = height
            
            if(width / height > 3.0)
            {
                newW=baseW
                newH = baseW/3.0
            }
            else if(width / height < 1 / 3)
            {
                newW=baseW/3.0
                newH = baseW
            }
            else
            {
                if(width>height)
                {
                    if(width > baseW)
                    {
                        newW=baseW
                        newH=newW*height/width
                    }
                }
                else if(width<height)
                {
                    if(height > baseW)
                    {
                        newH=baseW
                        newW=newH*width/height
                    }
                }
                else
                {
                    if(width > baseW)
                    {
                        newW=baseW
                        newH=newW*height/width
                    }
                }
                
            }
            
            self.picsH.constant = newH
            self.picsW.constant = newW
            
            imgw = newW
            imgh = newH
            
        }
        else
        {
            self.picsH.constant = 0.0
            self.picsW.constant = 0.0
        }
        
        self.picsView.removeAllSubViews()
        var x = 0
        for i in 0..<model.picList.count
        {
            let img = UIImageView()
            img.contentMode = .ScaleAspectFill
            img.layer.masksToBounds = true
            img.frame = CGRectMake(2+imgw*CGFloat(x), 2+imgh*CGFloat(Int(i/lineMax)), imgw-4, imgh-4)
            //img.backgroundColor = UIColor.lightGrayColor()
            self.picsView.addSubview(img)
            
            img.isGroup = true
            img.url = model.picList[i].url
            
            //img.sd_setImageWithURL(model.picList[i].url.url!)
            
            x += 1
            
            x = x % lineMax == 0 ? 0 : x
            
        }
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.content.preferredMaxLayoutWidth = swidth-62
    
        self.headPic.contentMode = .ScaleAspectFill
        self.headPic.placeholder = "tx.jpg".image
        self.headPic.layer.cornerRadius = 17.0
        self.headPic.layer.masksToBounds = true
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected
        {
            self.deSelect()
            
            let vc:FriendInfoVC = "FriendInfoVC".VC("Friend") as! FriendInfoVC
            
            vc.typeEnable = false
            vc.hidesBottomBarWhenPushed = true
            vc.fmodel = model
            
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        //self.bottomLine.removeObserver(self, forKeyPath: "center")
    }
    
}
