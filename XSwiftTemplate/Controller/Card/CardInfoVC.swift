//
//  CardInfoVC.swift
//  chengshi
//
//  Created by X on 16/6/10.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class CardInfoVC: UITableViewController {

    @IBOutlet var imgBG: SkyRadiusView!
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var leftLabel: UILabel!
    
    @IBOutlet var rightLabel: UILabel!
    
    @IBOutlet var phone: UILabel!
    
    @IBOutlet var address: UILabel!
    
    @IBOutlet var userContent: UILabel!
    
    @IBOutlet var btn: UIButton!
    
    @IBOutlet var txtBG: SkyRadiusView!
    
    var block:XNoBlock?
    
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
        
        phone.text = "电话: "+model.tel
        address.text = "地址: "+model.address
        
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
        
        harr[6] = size.height + 16.0
        
        btn.hidden = model.orlq == 1
        
        table.reloadData()
        
    }
    
    func doLingqu()
    {
        if !self.checkIsLogin()
        {
            return
        }
        
        let url = "http://123.57.162.97/hfapi/Public/Found/?service=Hyk.addcard&uid=\(DataCache.Share().userModel.uid)&username=\(DataCache.Share().userModel.username)&cardid=\(id)"
        
        XHttpPool.requestJson(url, body: nil, method: .POST) { [weak self](json) in
            
            if let code = json?["data"]["code"].int
            {
                if code == 0
                {
                    self?.lengquSuccess()
                    ShowMessage("领取成功")
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
        self.block?()
        leftLabel.text = "立即使用"
        leftLabel.hidden = false
        btn.hidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        img.layer.cornerRadius = img.frame.size.width * 0.5
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "会员卡详情"
        self.addBackButton()
        
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
        
        userContent.preferredMaxLayoutWidth = swidth-30
    
        
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
        print("CardInfoVC deinit !!!!!!!!")
    }

}
