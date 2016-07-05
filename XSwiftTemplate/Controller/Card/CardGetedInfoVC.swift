//
//  CardGetedInfoVC.swift
//  chengshi
//
//  Created by X on 16/6/10.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class CardGetedInfoVC: UITableViewController {
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var leftLabel: UILabel!
    
    @IBOutlet var rightLabel: UILabel!
    
    @IBOutlet var phone: UILabel!
    
    @IBOutlet var address: UILabel!
    
    @IBOutlet var userContent: UILabel!
    
    @IBOutlet var num: UILabel!
    
    @IBOutlet var typeTxt: UILabel!
    
    @IBOutlet var imgBG: UIView!
    
    @IBOutlet var txtBG: UIView!
    
    
    var harr:[CGFloat] = [133*screenFlag,42*screenFlag,15,42*screenFlag,42*screenFlag,42*screenFlag,15,42*screenFlag,128,0]
    
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
        let url = APPURL+"Public/Found/?service=Hyk.getArticleYLQ&username=\(DataCache.Share().userModel.username)&id=\(model.hcmid)"
        
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
            str = "剩余次数: "
        case "打折卡":
            ""
            str = "折扣: "
        case "充值卡":
            ""
            str = "剩余余额: "
        case "积分卡":
            ""
            str = "剩余积分: "
        default:
            ""
        }
        
        typeTxt.text = str
        img.url = model.logo
        name.text = model.shopname
        rightLabel.text = model.type
        
        phone.text = model.tel
        address.text = model.address
        
        num.text = model.values
        
        imgBG.backgroundColor = model.color.color
        imgBG.setNeedsDisplay()
        
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
        
        
        let attributedString1=NSMutableAttributedString(string: model.info)
        let paragraphStyle1=NSMutableParagraphStyle()
        paragraphStyle1.lineSpacing=5.0
        paragraphStyle1.paragraphSpacing=10.0
        paragraphStyle1.firstLineHeadIndent=10.0
        attributedString1.addAttributes([NSParagraphStyleAttributeName:paragraphStyle1,NSFontAttributeName:UIFont.systemFontOfSize(18)], range: NSMakeRange(0, (model.info as NSString).length))
        
        userContent.attributedText = attributedString1
        userContent.layoutIfNeeded()
        
        let size = userContent.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        
        harr[8] = size.height + 16.0
        
        table.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "会员卡详情"
        self.addBackButton()
        
        let n = 8.0 * screenFlag
        
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
        
        userContent.preferredMaxLayoutWidth = swidth-30
        
        let h = userContent.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height+16
        
        harr[8] = h+20
        
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
        
        if indexPath.row == 3
        {
            let vc = "CardShopsInfoVC".VC("Card") as! CardShopsInfoVC
            vc.id = model.id
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    deinit
    {
        print("CardGetedInfoVC deinit !!!!!!!!!!")
    }
    
    
}
