//
//  PhoneInfoVC.swift
//  chengshi
//
//  Created by X on 15/11/23.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class PhoneInfoVC: XViewController,UIActionSheetDelegate {

    @IBOutlet var img: UIImageView!
    
    @IBOutlet var lineH: NSLayoutConstraint!
    
    @IBOutlet var tel: UILabel!
    
    @IBOutlet var url: UILabel!
    
    @IBOutlet var address: UILabel!
    
    @IBOutlet var juli: UILabel!
    
    @IBOutlet var button: UIButton!
    
    @IBOutlet var contentH: NSLayoutConstraint!
    
    @IBOutlet var imgH: NSLayoutConstraint!
    
    @IBOutlet var viewBLine: UIView!
    
    @IBOutlet var viewH: NSLayoutConstraint!
    
    @IBAction func callPhone(sender: AnyObject) {
        
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
    
    
    lazy var model:PhoneModel = PhoneModel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func http()
    {
        let url="http://101.201.169.38/api/Public/Found/?service=Tel.getArticle&id=\(model.id)"
        XHttpPool.requestJson(url, body: nil, method: .GET) { (o) -> Void in
            
            if(o?["data"].dictionaryValue.count > 0)
            {
                self.model=PhoneModel.parse(json: o!["data"]["info"][0], replace: nil)
                
                self.show()
            }
            
            
            
        }
    }
    
    func show()
    {
        self.img.url = self.model.url
        self.tel.text = self.model.tel
        self.url.text = self.model.durl
        self.address.text=self.model.address
        
    }
    
    
    func toUrl()
    {
        let html:HtmlVC = HtmlVC()
        html.url = model.durl
        
        self.navigationController?.pushViewController(html, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PhoneInfoVC.toUrl))
        
        self.url.addGestureRecognizer(tap)
        
        self.url.preferredMaxLayoutWidth = self.url.frame.width
        self.address.preferredMaxLayoutWidth = self.address.frame.width
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBackButton()
        
        self.title="详情"
        
        var c:String = ""
        
        self.viewBLine.addObserver(self, forKeyPath: "center", options: .New, context: &c)
        
        lineH.constant = 0.34
        imgH.constant = swidth/16.0*7.8
        
        self.button.addObserver(self, forKeyPath: "center", options: .New, context: nil)
        
        self.http()
    }

    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if(keyPath == "center")
        {
            if(context == nil)
            {
                self.contentH.constant = self.button.center.y+25+20
            }
            else
            {
                self.viewH.constant = self.viewBLine.center.y
            }
            
            
        }
    }
    
    deinit
    {
        self.viewBLine.removeObserver(self, forKeyPath: "center")
        self.button.removeObserver(self, forKeyPath: "center")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
