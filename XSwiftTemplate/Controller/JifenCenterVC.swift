//
//  JifenCenterVC.swift
//  chengshi
//
//  Created by X on 2016/10/20.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class JifenCenterVC: UITableViewController,UICollectionViewDelegate {

    @IBOutlet var tatle: UILabel!
    
    @IBOutlet var num: UILabel!
    
    @IBOutlet var state: UILabel!
    
    @IBOutlet var stateIcon: UIImageView!
    
    @IBOutlet var collect: XCollectionView!
    
    var harr:[CGFloat] = [48,140,12,44,44,44,12,44,100]
    
    func getTJGoods()
    {
        let url = "http://182.92.70.85/hfapi/Public/Found/?service=jifen.getproductList&page=1&perNumber=4"
        
        XHttpPool.requestJson(url, body: nil, method: .GET) {[weak self] (o) in
            
            if let arr = o?["data"]["info"].array
            {
                self?.collect.httpHandle.listArr.removeAll(keepCapacity: false)
                
                for item in arr
                {
                    let m = GoodsModel.parse(json: item, replace: nil)
                    
                    self?.collect.httpHandle.listArr.append(m)
                }
                
                self?.harr[8] = CGFloat(ceil(Double(arr.count)/2.0)) * self!.gh
                
                
                MainDo({ [weak self](nil) in
                    
                    self?.tableView.reloadData()
                    
                    self?.collect.reloadData()
                    
                })

            }
        }
        
        
    }
    
    @IBAction func toDetail(sender: UIButton) {
        
        let vc = JifenDetailVC()
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    let gh:CGFloat = (swidth*0.5-16)*0.75+65
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        collect.registerNib("JifenGoodsCell".Nib, forCellWithReuseIdentifier: "JifenGoodsCell")
        
        collect.ViewLayout.itemSize = CGSizeMake(swidth*0.5, gh)
        collect.ViewLayout.minimumLineSpacing = 0.0
        collect.ViewLayout.minimumInteritemSpacing = 0.0
 
        collect.CellIdentifier = "JifenGoodsCell"
        collect.Delegate(self)
        
        getTJGoods()
        
        tatle.text = DataCache.Share.userModel.hfb
 
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return harr[indexPath.row]
    }
    
  
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 3 || indexPath.row == 4
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
      
        self.tableView.separatorInset=UIEdgeInsetsMake(0, swidth, 0, 0)
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                self.tableView.layoutMargins=UIEdgeInsetsMake(0, swidth, 0, 0)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row == 4 && stateIcon.hidden
        {
            self.doQD()
        }
        
    }
    
    func doQD()
    {
        let url = APPURL + "Public/Found/?service=jifen.addQiandao&uid=\(Uid)&username=\(Uname)"
        
        XHttpPool.requestJson(url, body: nil, method: .POST) {[weak self] (o) in
            
            if o?["data"]["code"].int == 0
            {
                XAlertView.show("签到成功", block: nil)
                self?.stateIcon.hidden = false
                self?.state.text = "已完成"
                self?.state.textColor = APPBlueColor
            }
            else
            {
                var msg = o?["data"]["msg"].stringValue
                msg = msg == "" ? "签到失败" : msg
                XAlertView.show(msg!, block: nil)
            }
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let m = collect.httpHandle.listArr[indexPath.row] as! GoodsModel
        
        let alert = XCommonAlert(title: "提醒", message: "确定要兑换该商品?", buttons: "取消","确定")
        
        alert.click {[weak self] (index) -> Bool in
            
            if index == 1
            {
                self?.doDuihuan(m)
            }
            
            return true
        }
        
        alert.show()
        
        
    }
    
    func doDuihuan(m:GoodsModel)
    {
        XWaitingView.show()
        let url = "http://182.92.70.85/hfapi/Public/Found/?service=jifen.addDH&uid=\(Uid)&username=\(Uname)&id="+m.id
        
        XHttpPool.requestJson(url, body: nil, method: .POST) { (o) in
            
            XWaitingView.hide()
            
            if o?["data"]["code"].int == 0
            {
                XAlertView.show("兑换成功", block: nil)
            }
            else
            {
                var msg = o?["data"]["msg"].stringValue
                msg = msg == "" ? "兑换失败" : msg
                XAlertView.show(msg!, block: nil)
            }
            
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        DataCache.Share.userModel.OnValueChange {[weak self] (key, value) in
            
            if key == "orqd"
            {
                let orqd = value as! Int
                
                if orqd == 0
                {
                    self?.stateIcon.hidden = true
                    self?.state.text = "还未签到"
                    self?.state.textColor = "333333".color
                }
            
            }
            
        }
        
        DataCache.Share.userModel.getHFB()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
