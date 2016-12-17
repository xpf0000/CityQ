//
//  CardShopsInfoVC.swift
//  chengshi
//
//  Created by X on 16/6/10.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class CardShopsInfoVC: UITableViewController,UIWebViewDelegate,UIActionSheetDelegate {
    
    
    @IBOutlet weak var levelIcon: UIImageView!
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var phone: UILabel!
    
    @IBOutlet var address: UILabel!

    @IBOutlet var web: UIWebView!
    
    @IBOutlet var addressCell: UITableViewCell!
    
    func doCall() {
        
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
    
    var harr:[CGFloat] = [swidth/16.0*7.0,44.0,44.0,10.0,44.0,44.0,10.0,44.0,10.0,50.0,0.0]
    
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
        
        switch model.viplevel {
        case "1":
            levelIcon.image = "rezheng_icon.png".image
        case "2":
            levelIcon.image = "vip_icon.png".image
        case "3":
            levelIcon.image = "svip_icon.png".image
        default:
            harr[7] = 0.0
            harr[8] = 0.0
        }
        
        img.url = model.logo
        
        phone.text = model.tel
        address.text = model.address
        
        var h = addressCell.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        
        h = max(44.0,h)
        
        harr[2] = h
        
        model.info = BaseHtml.replace("[XHTMLX]", with: model.info)
        
        web.loadHTMLString(model.info, baseURL: nil)
        
        web.sizeToFit()
    
        table.reloadData()
    }

    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if(keyPath == "contentSize")
        {
            harr[10] = web.scrollView.contentSize.height
            web.layoutIfNeeded()
            web.setNeedsLayout()
            web.scrollView.scrollEnabled = false
            table.reloadData()
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        address.preferredMaxLayoutWidth = swidth - 105
        
        web.scrollView.showsHorizontalScrollIndicator = false
        web.scrollView.showsVerticalScrollIndicator = false
        
        web.scrollView.addObserver(self, forKeyPath: "contentSize", options: .New, context: nil)
        
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
        
        if(indexPath.row == 4)
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
        else if(indexPath.row == 1 || indexPath.row == 9)
        {
            cell.separatorInset=UIEdgeInsetsMake(0, 15, 0, 15)
            if(IOS_Version>=8.0)
            {
                if #available(iOS 8.0, *) {
                    cell.layoutMargins=UIEdgeInsetsMake(0, 15, 0, 15)
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
        
        if indexPath.row == 1
        {
            doCall()
        }
        
        if indexPath.row == 4
        {
            let vc = CardShopsActivitysVC()
            vc.id = id
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.row == 5
        {
            let vc = CardYouhuiquanVC()
            vc.id = id
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.row == 7
        {
            let vc = "CardRenzhengVC".VC("Card") as! CardRenzhengVC
            vc.id = id
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
    }
    
    
}
