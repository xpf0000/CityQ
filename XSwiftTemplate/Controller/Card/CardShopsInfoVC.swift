//
//  CardShopsInfoVC.swift
//  chengshi
//
//  Created by X on 16/6/10.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class CardShopsInfoVC: UITableViewController,UIWebViewDelegate {
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var phone: UILabel!
    
    @IBOutlet var address: UILabel!
    
    @IBOutlet var info: UILabel!

    var id = "0"
    {
        didSet
        {
            http()
        }
    }
    
    private var model:CardModel!
        {
        didSet
        {
            show()
        }
    }
    
    var harr:[CGFloat] = [swidth/750.0*313.0*screenFlag,42.0*screenFlag,42.0*screenFlag,8.0*screenFlag,42.0*screenFlag,42.0*screenFlag,8.0*screenFlag,37.0*screenFlag,1.0,44.0]
    
    func http()
    {
        let url = APPURL+"Public/Found/?service=Hyk.getShopInfo&id=\(id)"
        
        XHttpPool.requestJson(url, body: nil, method: .POST) { [weak self](json) in
            
            if let item = json?["data"]["info"][0]
            {
                self?.model = CardModel.parse(json: item, replace: nil)
            }
            
        }

    }
    
    func show()
    {
        img.url = model.logo
        
        phone.text = "电话: "+model.tel
        address.text = "地址: "+model.address
        
        let attributedString1=NSMutableAttributedString(string: model.info)
        let paragraphStyle1=NSMutableParagraphStyle()
        paragraphStyle1.lineSpacing=5.0
        paragraphStyle1.paragraphSpacing=10.0
        paragraphStyle1.firstLineHeadIndent=10.0
        attributedString1.addAttributes([NSParagraphStyleAttributeName:paragraphStyle1,NSFontAttributeName:UIFont.systemFontOfSize(18)], range: NSMakeRange(0, (model.info as NSString).length))
        
        info.attributedText = attributedString1
        info.layoutIfNeeded()
        
        let size = info.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        
        harr[8] = size.height > 0.0 ? size.height + 16.0 : 0.0
        
        table.reloadData()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
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
        
        table.reloadData()
        
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row < 7 || indexPath.row == 8)
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
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return harr[indexPath.row]
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 4
        {
            let vc = CardShopsCardVC()
            vc.id = id
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.row == 5
        {
            let vc = CardShopsActivitysVC()
            vc.id = id
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    
    
}
