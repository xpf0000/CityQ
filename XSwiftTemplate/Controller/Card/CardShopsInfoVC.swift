//
//  CardShopsInfoVC.swift
//  chengshi
//
//  Created by X on 16/6/10.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class CardShopsInfoVC: UITableViewController,UIWebViewDelegate,UIActionSheetDelegate {
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var phone: UILabel!
    
    @IBOutlet var address: UILabel!

    @IBOutlet var web: UIWebView!
    
    @IBAction func doCall(sender: AnyObject) {
        
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
    
    var harr:[CGFloat] = [swidth/16.0*7.0,42.0*screenFlag,42.0*screenFlag,8.0*screenFlag,0,42.0*screenFlag,8.0*screenFlag,37.0*screenFlag,1.0,44.0]
    
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
        
        phone.text = model.tel
        address.text = model.address
        
        model.info = BaseHtml.replace("[XHTMLX]", with: model.info)
        
        web.loadHTMLString(model.info, baseURL: nil)
        
        web.sizeToFit()
    
        
        table.reloadData()
    }

    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if(keyPath == "contentSize")
        {
            harr[8] = web.scrollView.contentSize.height
            web.layoutIfNeeded()
            web.setNeedsLayout()
            web.scrollView.scrollEnabled = false
            table.reloadData()
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
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
    
    deinit
    {
        web.scrollView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    
}
