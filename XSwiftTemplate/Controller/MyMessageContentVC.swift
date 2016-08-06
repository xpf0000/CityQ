//
//  MyMessageContentVC.swift
//  chengshi
//
//  Created by 徐鹏飞 on 16/6/25.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyMessageContentVC: UIViewController {

    @IBOutlet weak var ntitle: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var content: UILabel!
    
    
    var model:MessageModel!
    {
        didSet
        {
            self.title = model.title
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        ntitle.preferredMaxLayoutWidth = swidth - 30
        content.preferredMaxLayoutWidth = swidth - 30
        
        let date=NSDate(timeIntervalSince1970: model.create_time.doubleValue!)
        let time = date.toStr("yyyy-MM-dd HH:mm")!
        
        ntitle.text = model.title
        self.time.text = time
        
        content.text = model.content
        
//        let str = model.content
//        
//        let attributedString=NSMutableAttributedString(string: str)
//        let paragraphStyle=NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing=5.0
//        paragraphStyle.paragraphSpacing=10.0
//        paragraphStyle.firstLineHeadIndent=10.0
//        attributedString.addAttributes([NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:UIFont.systemFontOfSize(16.0),NSForegroundColorAttributeName:APPMiddleColor], range: NSMakeRange(0, (str as NSString).length))
//        
//        let rang = (str as NSString).rangeOfString(model.title)
//        
//        attributedString.addAttributes([NSForegroundColorAttributeName:APPBlackColor], range: rang)
//        
//        content.attributedText = attributedString
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
