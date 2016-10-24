//
//  CardRenzhengVC.swift
//  chengshi
//
//  Created by X on 2016/10/24.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class CardRenzhengVC: UITableViewController {
    
    class RenzhengModel: Reflect {
        
        var id = ""
        var vip_time = ""
        var content = ""
        
        override func setValue(value: AnyObject?, forKey key: String) {
            
            if(value == nil)
            {
                return
            }
            
            if(key == "vip_time" && value != nil)
            {
                if value?.doubleValue > 0
                {
                    let date=NSDate(timeIntervalSince1970: value!.doubleValue)
                    self.vip_time = date.toStr("yyyy年MM月dd日")!
                    
                    return
                }
                
            }
            
            super.setValue(value, forKey: key)
        }
    }

    @IBOutlet var cell1: UITableViewCell!
    
    @IBOutlet var cell2: UITableViewCell!
    
    @IBOutlet var cell3: UITableViewCell!
    
    @IBOutlet var txt1: UILabel!
    
    @IBOutlet var txt2: UILabel!
    
    @IBOutlet var web: UIWebView!
    
    //@IBOutlet var txt3: UILabel!
    
    var id = ""
    var model:RenzhengModel?
    
    var harr:[CGFloat] = [50.0,50.0,50.0]
    
    func http()
    {
        let url = "http://182.92.70.85/hfapi/Public/Found/?service=hyk.getShopVIPInfo&id="+id
        
        XHttpPool.requestJson(url, body: nil, method: .GET) {[weak self] (o) in
            
            self?.model = RenzhengModel.parse(json: o?["data"]["info"][0], replace: nil)
            
            self?.show()
        }
        
        
    }
    
    func show()
    {
        txt2.text = "于\(model!.vip_time)完成怀府网认证，每年怀府网及第三方审核机构都将对其资料进行审核。"
        
        let info = BaseHtml.replace("[XHTMLX]", with: model!.content).replace("#FFFFFF", with: "#F0F0F0")
        
        web.loadHTMLString(info, baseURL: nil)
        web.sizeToFit()
        
        harr[0] = cell1.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        harr[1] = cell2.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        
        tableView.reloadData()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if(keyPath == "contentSize")
        {
            let h = web.scrollView.contentSize.height+36
            
            harr[2] = h
            
            web.layoutIfNeeded()
            web.setNeedsLayout()
            web.scrollView.scrollEnabled = false
            
            tableView.reloadData()
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        txt1.preferredMaxLayoutWidth = swidth - 55.0
        txt2.preferredMaxLayoutWidth = swidth - 55.0
        //txt3.preferredMaxLayoutWidth = swidth - 55.0
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        tableView.tableFooterView=view1
        tableView.tableHeaderView=view1
        
        web.scrollView.showsHorizontalScrollIndicator = false
        web.scrollView.showsVerticalScrollIndicator = false
        
        web.scrollView.addObserver(self, forKeyPath: "contentSize", options: .New, context: nil)
        
        http()
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
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
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        self.tableView.separatorInset=UIEdgeInsetsMake(0, 15, 0, 15)
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                self.tableView.layoutMargins=UIEdgeInsetsMake(0, 15, 0, 15)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return harr[indexPath.row]
    }

    deinit
    {
        web.scrollView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
