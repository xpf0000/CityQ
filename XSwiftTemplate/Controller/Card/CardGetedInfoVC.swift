//
//  CardGetedInfoVC.swift
//  chengshi
//
//  Created by X on 16/6/10.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class CardGetedInfoVC: UITableViewController,UIActionSheetDelegate {
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var phone: UILabel!
    
    @IBOutlet var address: UILabel!
    
    @IBOutlet var web: UIWebView!
    
    @IBOutlet var imgBG: UIView!
    
    @IBOutlet var cardNum: UILabel!
    
    @IBOutlet var cardType: UILabel!
    
    @IBOutlet var yue: UILabel!
    
    @IBOutlet var yueCell: UITableViewCell!
    
    @IBOutlet var addressCell: UITableViewCell!
    
    
    
    
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
    
    
    
    var harr:[CGFloat] = [160,42.0,42.0,15,42.0,42,42,15,42,128,100]
    
    var model:CardModel!
    {
        didSet
        {
            if oldValue == nil
            {
                http()
            }
            else
            {
                show()
            }
        }
    }
    
    func http()
    {
        let url = APPURL+"Public/Found/?service=Hyk.getArticleYLQ&username=\(DataCache.Share.userModel.username)&id=\(model.hcmid)"
        
        XHttpPool.requestJson(url, body: nil, method: .POST) { [weak self](json) in
            
            if let item = json?["data"]["info"][0]
            {
                self?.model = CardModel.parse(json: item, replace: nil)
            }
            
        }
    }
    
    func show()
    {
        var str = ""
        switch model.type {
        case "计次卡":
            ""
            str = "剩余次数: "+model.values
        case "打折卡":
            ""
            str = "折扣: "+model.values
        case "充值卡":
            ""
            str = "剩余金额: "+model.values
        case "积分卡":
            ""
            str = "剩余积分: "+model.values+"\r\n当前积分: "+model.values
        default:
            ""
        }
        
        img.url = model.logo
        name.text = model.shopname
        cardType.text = model.type
        
       
        phone.text = model.tel
        address.text = model.address
        
        yue.text = str
        
        imgBG.backgroundColor = model.color.color
        
        model.info = BaseHtml.replace("[XHTMLX]", with: model.info)
        
        web.loadHTMLString(model.info, baseURL: nil)
        
        web.sizeToFit()
        
        
        var h = yueCell.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        h = max(h, 42.0)
        
        harr[2] = h

        var h1 = addressCell.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        h1 = max(h1, 42.0)
        
        harr[6] = h1
        
        
        table.reloadData()
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if(keyPath == "contentSize")
        {
            harr[9] = web.scrollView.contentSize.height
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
        
        address.preferredMaxLayoutWidth = swidth - 105
        yue.preferredMaxLayoutWidth = swidth - 63
        
        harr[0] = swidth * 0.485
        
        web.scrollView.showsHorizontalScrollIndicator = false
        web.scrollView.showsVerticalScrollIndicator = false
        
        web.scrollView.addObserver(self, forKeyPath: "contentSize", options: .New, context: nil)
        
        let n = 10.0 * screenFlag
        
        imgBG.layer.masksToBounds = true
        imgBG.clipsToBounds = true
        imgBG.layer.cornerRadius = n
        
        img.layer.masksToBounds = true
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        table.tableFooterView=view1
        table.tableHeaderView=view1
        
        table.separatorInset = UIEdgeInsetsZero
        if #available(iOS 8.0, *) {
            table.layoutMargins = UIEdgeInsetsZero
        } else {
            // Fallback on earlier versions
        }
        
        self.table.reloadData()
   
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row < 8)
        {
            cell.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0)
            if(IOS_Version>=8.0)
            {
                if #available(iOS 8.0, *) {
                    cell.layoutMargins=UIEdgeInsetsMake(0, 0, 0, 0)
                } else {
                    // Fallback on earlier versions
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
                    // Fallback on earlier versions
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
                // Fallback on earlier versions
            }
        }
        
        img.layer.cornerRadius = img.frame.size.width / 2.0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return harr[indexPath.row]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 1
        {
            let vc:MyWalletVC = MyWalletVC()
            vc.id = model.id
            vc.hidesBottomBarWhenPushed = true
            vc.ctitle = "消费详情"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.row == 4 || indexPath.row == 0
        {
            let vc = "CardShopsInfoVC".VC("Card") as! CardShopsInfoVC
            vc.id = model.shopid
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
        //print("CardGetedInfoVC deinit !!!!!!!!!!")
    }
    
    
}
