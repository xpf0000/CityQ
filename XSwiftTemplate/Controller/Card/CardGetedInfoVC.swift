//
//  CardGetedInfoVC.swift
//  chengshi
//
//  Created by X on 16/6/10.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class CardGetedInfoVC: UITableViewController,UIActionSheetDelegate,UIWebViewDelegate    {
    
    @IBOutlet var dhBtn: UIButton!
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var web: UIWebView!
    
    @IBOutlet var imgBG: UIView!
    
    @IBOutlet var cardNum: UILabel!
    
    @IBOutlet var cardType: UILabel!
    
    @IBOutlet var yue: UILabel!
    
    @IBOutlet var yueCell: UITableViewCell!
    
    weak var supervc:CardGetedMainVC?
    
    @IBAction func doDuihuan(sender: UIButton) {
        
        
        let vc = HtmlVC()
        
        vc.baseUrl = TmpDirURL
        
        if let u = TmpDirURL?.URLByAppendingPathComponent("duihuan.html")
        {
            vc.url = "\(u)?uid=\(Uid)&uname=\(Uname)&cid=\(model.id)&sname=\(model.shopname)"
            
            print(vc.url)
        }
        
        vc.hidesBottomBarWhenPushed = true
        vc.title = "积分兑换"
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func doChongzhi(sender: UIButton) {
        
        let vc:CardTimesChongzhiVC = "CardTimesChongzhiVC".VC("Card") as! CardTimesChongzhiVC
        
        vc.model = model
        if model.type == "充值卡"
        {
            vc.type = 0
        }
        else
        {
            vc.type = 1
        }
        
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    var harr:[CGFloat] = [160,42.0,42.0,10,42,128]
    
    var model:CardModel!
    
    var url = ""
    
    func http()
    {
        url = url == "" ? APPURL+"Public/Found/?service=Hyk.getArticleYLQ&username=\(DataCache.Share.userModel.username)&id=\(model.hcmid)" : url
        
        XHttpPool.requestJson(url, body: nil, method: .POST) { [weak self](json) in
            
            if let item = json?["data"]["info"][0]
            {
                self?.model = CardModel.parse(json: item, replace: nil)
                
                self?.show()
            }
            
        }
    }
    
    func show()
    {
        var str = ""
        switch model.type {
        case "计次卡":
            ""
            str = "剩余次数: "+model.values+"\r\n当前积分: "+model.jifen
        case "打折卡":
            ""
            supervc?.btn.hidden = true
            supervc?.btnH.constant = 0.0
            str = "当前折扣: "+model.values+"\r\n当前积分: "+model.jifen
        case "充值卡":
            ""
            str = "剩余金额: ￥"+model.values+"\r\n当前积分: "+model.jifen
        case "积分卡":
            ""
            supervc?.btn.hidden = true
            supervc?.btnH.constant = 0.0
            str = "当前积分: "+model.values
            
        default:
            ""
        }
        
        img.url = model.logo
        name.text = model.shopname
        cardType.text = model.type
        
        cardNum.text = "NO."+model.cardnumber
        
        
        let rang=(str as NSString).rangeOfString("\(model.jifen)", options: NSStringCompareOptions.BackwardsSearch)
        
        let rang1=(str as NSString).rangeOfString("\(model.values)")
        
        let attributedString1 = NSMutableAttributedString(string: str)
        let paragraphStyle1:NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle1.lineSpacing = 3.0
        
        attributedString1.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle1, range: NSMakeRange(0, str.length()))
        
        attributedString1.addAttribute(NSForegroundColorAttributeName, value: APPBlueColor, range: rang)
        attributedString1.addAttribute(NSForegroundColorAttributeName, value: APPBlueColor, range: rang1)
        
        if model.type == "充值卡"
        {
            let rang2=(str as NSString).rangeOfString("￥")
            attributedString1.addAttribute(NSForegroundColorAttributeName, value: APPBlueColor, range: rang2)
        }
        
        yue.attributedText = attributedString1
        yue.layoutIfNeeded()
        
        //yue.text = str
        
        imgBG.backgroundColor = model.color.color
        
        model.info = BaseHtml.replace("[XHTMLX]", with: model.info).replace("#FFFFFF", with: "#F3F5F7")
        
        web.loadHTMLString(model.info, baseURL: nil)
        
        web.sizeToFit()
        
        
        var h = yueCell.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        h = max(h, 42.0)
        
        harr[2] = h


        table.reloadData()
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        webView.frame.size.height = 1
        let size = webView.sizeThatFits(CGSizeZero)
        
        harr[5] = size.height
        web.layoutIfNeeded()
        web.setNeedsLayout()
        web.scrollView.scrollEnabled = false
        table.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "会员卡详情"
        self.addBackButton()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(http), name: "PaySuccess", object: nil)
        
        yue.preferredMaxLayoutWidth = swidth - 63
        
        harr[0] = swidth * 0.485
        
        web.scrollView.showsHorizontalScrollIndicator = false
        web.scrollView.showsVerticalScrollIndicator = false
        
        web.delegate = self
        
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
        
        if(indexPath.row < 5)
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
            let vc:CardRecordVC = "CardRecordVC".VC("Card") as! CardRecordVC
            vc.id = model.id
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.row == 0
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        http()
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        //print("CardGetedInfoVC deinit !!!!!!!!!!")
    }
    
    
}
