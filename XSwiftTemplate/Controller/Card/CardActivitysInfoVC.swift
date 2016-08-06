//
//  CardActivitysInfoVC.swift
//  chengshi
//
//  Created by X on 15/11/23.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class CardActivitysInfoVC: XViewController,UIActionSheetDelegate,UIWebViewDelegate {
    
    @IBOutlet var infoH: NSLayoutConstraint!
    
    @IBOutlet var middleViewH: NSLayoutConstraint!
    
    @IBOutlet var positionIcon: UIImageView!
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var lineH: NSLayoutConstraint!
    
    @IBOutlet var tel: UILabel!
    
    @IBOutlet var address: UILabel!
    
    @IBOutlet var imgH: NSLayoutConstraint!
    
    @IBOutlet var seeNum: UILabel!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var stime: UILabel!
    
    @IBOutlet var etime: UILabel!
    
    @IBOutlet var infoWeb: UIWebView!
    
    lazy var web:UIWebView = UIWebView()
    
    lazy var model:DiscountModel = DiscountModel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func http()
    {
        //let url=APPURL+"Public/Found/?service=Discount.getArticle&id=\(model.id)"
        
        let url=APPURL+"Public/Found/?service=Discount.getArticle&id=\(model.id)"
        
        XHttpPool.requestJson(url, body: nil, method: .GET) { (o) -> Void in
            
            if(o?["data"].dictionaryValue.count > 0)
            {
                self.model=DiscountModel.parse(json: o!["data"]["info"][0], replace: nil)
                
                self.show()
            }
            
        }
    }
    
    func show()
    {
        self.img.url = self.model.url
        self.address.text=self.model.address
        self.address.layoutIfNeeded()
        
        self.stime.text=self.model.s_time
        self.etime.text=self.model.e_time
        self.tel.text = self.model.tel
        self.name.text=self.model.title
        self.name.layoutIfNeeded()
        
        self.seeNum.text=self.model.view
        

        self.model.content = BaseHtml.replace("[XHTMLX]", with: model.content)
        
        self.infoWeb.scrollView.backgroundColor = UIColor.whiteColor()
        self.infoWeb.backgroundColor = UIColor.whiteColor()
        self.infoWeb.delegate = self
        
        infoWeb.loadHTMLString(model.content, baseURL: nil)
        
//        self.infoWeb.loadRequest("http://101.201.169.38/city/dis_info_info.php?id=\(self.model.id)".urlRequest!)
        
        self.infoWeb.sizeToFit()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
        RemoveWaiting()
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        RemoveWaiting()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        self.name.preferredMaxLayoutWidth = self.name.frame.width
        self.address.preferredMaxLayoutWidth = self.address.frame.width
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        self.title="详情"
        
        self.infoWeb.scrollView.showsHorizontalScrollIndicator=false
        self.infoWeb.scrollView.showsVerticalScrollIndicator=false
        self.infoWeb.scrollView.scrollEnabled=true
        
        self.infoWeb.scrollView.addObserver(self, forKeyPath: "contentSize", options: .New, context: nil)
        
        infoH.constant = 0.34
        lineH.constant = 0.34
        imgH.constant = swidth/16.0*9.0
        positionIcon.addObserver(self, forKeyPath: "center", options: .New, context: nil)

        self.view.showWaiting()
        self.http()
    }
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if(keyPath == "center")
        {
            middleViewH.constant = positionIcon.center.y+8
        }
        
        if(keyPath == "contentSize")
        {
            infoH.constant = infoWeb.scrollView.contentSize.height
            
            infoWeb.layoutIfNeeded()
            infoWeb.setNeedsLayout()
        }
        
    }
    
    
    @IBAction func collect(sender: AnyObject) {
        
        let url=APPURL+"Public/Found/?service=Discount.collectAdd&did="+model.id+"&username="+DataCache.Share.userModel.username
        
        XHttpPool.requestJson(url, body: nil, method: .POST) { (o) -> Void in
            
            if(o?["data"]["code"].intValue == 0)
            {
                ShowMessage("收藏成功")
                return
            }
            
            if(o?["data"]["code"].intValue == 1)
            {
                ShowMessage("已收藏")
                return
            }
            
            ShowMessage("收藏失败")
        }
    }
    
    @IBAction func share(sender: AnyObject) {
        
        
    }
    
    
    
    
    
    
    
    
    
    deinit
    {
        positionIcon.removeObserver(self, forKeyPath: "center")
        self.infoWeb.scrollView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
}
