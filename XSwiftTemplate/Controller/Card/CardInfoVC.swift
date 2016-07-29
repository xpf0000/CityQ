//
//  CardInfoVC.swift
//  chengshi
//
//  Created by X on 16/6/10.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class CardInfoVC: UITableViewController ,UIActionSheetDelegate {

    @IBOutlet var imgBG: UIView!
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var leftLabel: UILabel!
    
    @IBOutlet var rightLabel: UILabel!
    
    @IBOutlet var phone: UILabel!
    
    @IBOutlet var address: UILabel!
    
    @IBOutlet var web: UIWebView!

    @IBOutlet var btn: UIButton!
    
    @IBOutlet var txtBG: UIView!
    
    var block:XNoBlock?
    
    
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
    
    
    func SuccessBlock(b:XNoBlock)
    {
        self.block = b
    }
    
    var harr:[CGFloat] = [133*screenFlag,42*screenFlag,42*screenFlag,42*screenFlag,12*screenFlag,42*screenFlag,128,100]
    
    private var model:CardModel!
    {
        didSet
        {
            show()
        }
    }
    
    var id = "0"
    {
        didSet
        {
            http()
        }
    }
    
    func http()
    {
        let url = APPURL+"Public/Found/?service=Hyk.getArticle&username=\(DataCache.Share().userModel.username)&id=\(id)"
        
        XHttpPool.requestJson(url, body: nil, method: .POST) { [weak self](json) in
            
            if let item = json?["data"]["info"][0]
            {
                self?.model = CardModel.parse(json: item, replace: nil)
            }
            
        }
        
    }
    
    func show()
    {
        imgBG.backgroundColor = model.color.color
        imgBG.setNeedsDisplay()
        
        name.text = model.shopname
        rightLabel.text = model.type
        img.url = model.logo
        
        phone.text = model.tel
        address.text = model.address
        
        let (r,g,b) = model.color.color!.getRGB()
        
        if r<100 && g<100 && b<100
        {
            txtBG.backgroundColor = UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 0.75)
        }
        else
        {
            txtBG.backgroundColor = UIColor(red: 65.0/255.0, green: 65.0/255.0, blue: 65.0/255.0, alpha: 0.75)
        }
        txtBG.setNeedsDisplay()
        
        model.info = BaseHtml.replace("[XHTMLX]", with: model.info)
        
        web.loadHTMLString(model.info, baseURL: nil)
        
        web.sizeToFit()
        
        btn.hidden = model.orlq == 1
        
        table.reloadData()
        
    }
    
    func doLingqu()
    {
        if !self.checkIsLogin()
        {
            return
        }
        
        let url = APPURL + "Public/Found/?service=Hyk.addCard&uid=\(DataCache.Share().userModel.uid)&username=\(DataCache.Share().userModel.username)&cardid=\(id)"
        
        XHttpPool.requestJson(url, body: nil, method: .POST) { [weak self](json) in
            
            if let code = json?["data"]["code"].int
            {
                if code == 0
                {
                    self?.lengquSuccess()
                    ShowMessage("领取成功")
                    
                    self?.pop()
                }
                else
                {
                    ShowMessage(json!["data"]["msg"].stringValue)
                }
            }
            else
            {
                ShowMessage("领取失败,请重试!")
            }
            
            
        }
        
    }
    
    func lengquSuccess()
    {
        //self.block?()
        leftLabel.text = "立即使用"
        leftLabel.hidden = false
        btn.hidden = true
        
        NoticeWord.CardChanged.rawValue.postNotice()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        img.layer.cornerRadius = img.frame.size.width * 0.5
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if(keyPath == "contentSize")
        {
            harr[6] = web.scrollView.contentSize.height
            web.layoutIfNeeded()
            web.setNeedsLayout()
            web.scrollView.scrollEnabled = false
            table.reloadData()
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "会员卡详情"
        self.addBackButton()
        
        web.scrollView.showsHorizontalScrollIndicator = false
        web.scrollView.showsVerticalScrollIndicator = false
        
        web.scrollView.addObserver(self, forKeyPath: "contentSize", options: .New, context: nil)
        
        let n = 8.0 * screenFlag
        
        imgBG.layer.masksToBounds = true
        imgBG.clipsToBounds = true
        imgBG.layer.cornerRadius = n
        
        img.layer.masksToBounds = true
        leftLabel.hidden = true
        btn.hidden = true
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        table.tableFooterView=view1
        table.tableHeaderView=view1
        
        table.separatorInset = UIEdgeInsetsZero
        if #available(iOS 8.0, *) {
            table.layoutMargins = UIEdgeInsetsZero
        } else {
            
        }
        
        btn.click {[weak self,weak btn] (b) in
            
            self?.doLingqu()
        }
        
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row < 6)
        {
            cell.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0)
            if(IOS_Version>=8.0)
            {
                if #available(iOS 8.0, *) {
                    cell.layoutMargins=UIEdgeInsetsMake(0, 0, 0, 0)
                } else {
                    
                }
            }
        }
        else
        {
            cell.separatorInset=UIEdgeInsetsMake(0, swidth, 0, 0)
            if(IOS_Version>=8.0)
            {
                if #available(iOS 8.0, *) {
                    cell.layoutMargins=UIEdgeInsetsMake(0, swidth, 0, 0)
                } else {
                    
                }
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        self.table.separatorInset=UIEdgeInsetsZero
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                self.table.layoutMargins=UIEdgeInsetsZero
            } else {
                
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return harr[indexPath.row]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 1
        {
            let vc = "CardShopsInfoVC".VC("Card") as! CardShopsInfoVC
            vc.id = model.shopid
            vc.title = model.shopname
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }

    deinit
    {
        web.scrollView.removeObserver(self, forKeyPath: "contentSize")
        //print("CardInfoVC deinit !!!!!!!!")
    }

}
