//
//  OAMessageInfoVC.swift
//  OA
//
//  Created by X on 15/5/8.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit

class OAMessageInfoVC: UIViewController {
    
    var msgTitle=UILabel()
    var ltitle=UILabel()
    var content=UILabel()
    lazy var model:OAMessageModel = OAMessageModel()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.title="消息详情"
        self.navigationItem.hidesBackButton=true
        self.addBackButton()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func showView()
    {
        msgTitle.frame=CGRectMake(10, 15, swidth-20, 24)
        msgTitle.font=UIFont.systemFontOfSize(20.0)
        msgTitle.numberOfLines=0
        msgTitle.sizeToFit()
        msgTitle.frame=CGRectMake(10, 15, swidth-20, msgTitle.frame.size.height)
        
        ltitle.frame=CGRectMake(10, msgTitle.frame.size.height+15+10, swidth-20, 24)
        //ltitle.text="发布人：某先生 发布时间：2015-05-08"
        ltitle.font=UIFont.systemFontOfSize(15.0)
        ltitle.textColor=UIColor.lightGrayColor()
        
        msgTitle.textAlignment=NSTextAlignment.Center
        ltitle.textAlignment=NSTextAlignment.Center
        
        let line=UILabel()
        line.backgroundColor="#bebebe".color
        line.frame=CGRectMake(0, ltitle.frame.origin.y+ltitle.frame.size.height+12, swidth, 0.5)
        
        let attributedString1=NSMutableAttributedString(string: model.content)
        let paragraphStyle1=NSMutableParagraphStyle()
        paragraphStyle1.lineSpacing=8.0
        paragraphStyle1.paragraphSpacing=10.0
        paragraphStyle1.firstLineHeadIndent=20.0
        attributedString1.addAttributes([NSParagraphStyleAttributeName:paragraphStyle1,NSFontAttributeName:UIFont.systemFontOfSize(18.0)], range: NSMakeRange(0, (model.content as NSString).length))
        content.frame=CGRectMake(10, ltitle.frame.origin.y+ltitle.frame.size.height+12+15, swidth-20, sheight-64-10-(ltitle.frame.origin.y+ltitle.frame.size.height+12+15))
        content.backgroundColor=UIColor.whiteColor()
        content.font=UIFont.systemFontOfSize(18.0)
        content.attributedText=attributedString1
        content.numberOfLines=0
        content.sizeToFit()
        content.frame=CGRectMake(0, 0, swidth-20, content.frame.size.height)
        
        let scroll=UIScrollView(frame: CGRectMake(10, ltitle.frame.origin.y+ltitle.frame.size.height+12+15, swidth-20, sheight-64-10-(ltitle.frame.origin.y+ltitle.frame.size.height+12+15)))
        
        scroll.contentSize=CGSizeMake(0, content.frame.size.height)
        scroll.addSubview(content)
        
        self.view.addSubview(msgTitle)
        self.view.addSubview(ltitle)
        self.view.addSubview(line)
        self.view.addSubview(scroll)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor=UIColor.whiteColor()
        
        showView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}