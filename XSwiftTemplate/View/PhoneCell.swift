//
//  PhoneCell.swift
//  chengshi
//
//  Created by X on 15/11/23.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class PhoneCell: UITableViewCell,UIActionSheetDelegate {

    @IBOutlet var name: UILabel!
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var phone: UILabel!
    
    @IBOutlet var buttonH: NSLayoutConstraint!
    
    @IBOutlet var buttonW: NSLayoutConstraint!
    
    @IBOutlet var lineH: NSLayoutConstraint!
    
    @IBOutlet var line: UIView!
    
    
    var model:PhoneModel=PhoneModel()
    {
        didSet
        {
            self.name.text=self.model.title
            self.img.url=self.model.url
            self.phone.text=self.model.tel
        }
    }
    
    
    @IBAction func phoneCall(sender: AnyObject) {
        
        if(self.model.tel == "")
        {
            return
        }
        
        let cameraSheet=UIActionSheet()
        cameraSheet.delegate=self
        cameraSheet.addButtonWithTitle("拨打: "+self.model.tel)
        cameraSheet.addButtonWithTitle("取消")
        
        cameraSheet.actionSheetStyle = UIActionSheetStyle.BlackTranslucent;
        cameraSheet.showInView(UIApplication.sharedApplication().keyWindow!)
        
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        if(buttonIndex == 0)
        {
            let str="tel:"+self.model.tel
            if(str.url != nil)
            {
                UIApplication.sharedApplication().openURL(str.url!)
            }
            
        }
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lineH.constant = 0.333333
        img.layer.masksToBounds = true
        img.layer.cornerRadius = img.frame.size.width/2.0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if(selected)
        {
            let vc:PhoneInfoVC = "PhoneInfoVC".VC as! PhoneInfoVC
            vc.hidesBottomBarWhenPushed=true
            vc.model=self.model
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
}
