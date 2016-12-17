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
    
    @IBOutlet var state: UILabel!
    
    @IBOutlet var stateIcon: UIImageView!
    
    @IBOutlet var collect: XCollectionView!
    
    @IBOutlet  var zlicon: UIImageView!
    
    @IBOutlet  var zltxt: UILabel!
    
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
        else if  indexPath.row == 7
        {
            cell.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0)
            cell.layoutMargins=UIEdgeInsetsMake(0, 0, 0, 0)
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
        
        if indexPath.row == 3
        {
            let vc = HtmlVC()
            
            vc.baseUrl = TmpDirURL
            
            if let u = TmpDirURL?.URLByAppendingPathComponent("hfbguize.html")
            {
                vc.url = "\(u)?id=6892"
            }
            
            vc.hidesBottomBarWhenPushed = true
            vc.title = "怀府币规则"
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.row == 4
        {
            let vc:EditUserInfoVC = "EditUserInfoVC".VC("User") as! EditUserInfoVC
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.row == 5
        {
            self.doQD()
        }
        
    }
    
    func doQD()
    {
        
        if DataCache.Share.userModel.orqd == 1
        {
            let vc = HtmlVC()
            
            vc.baseUrl = TmpDirURL
            
            if let u = TmpDirURL?.URLByAppendingPathComponent("index.html")
            {
                vc.url = "\(u)?uid=\(Uid)&uname=\(Uname)"
            }
            
            vc.hidesBottomBarWhenPushed = true
            vc.title = "每日签到"
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            return
        }
        
        
        let url = APPURL + "Public/Found/?service=jifen.addQiandao&uid=\(Uid)&username=\(Uname)"
        
        XHttpPool.requestJson(url, body: nil, method: .POST) {[weak self] (o) in
            
            if o?["data"]["code"].int == 0
            {
                QDSuccessAlert()
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
        
        let vc = HtmlVC()
        
        vc.baseUrl = TmpDirURL
        
        if let u = TmpDirURL?.URLByAppendingPathComponent("duihuaninfo.html")
        {
            vc.url = "\(u)?uid=\(Uid)&uname=\(Uname)&id=\(m.id)"
        }
        
        vc.hidesBottomBarWhenPushed = true
        vc.title = "兑换详情"
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        DataCache.Share.userModel.OnValueChange {[weak self] (key, value) in
            
            if key == "HFB"
            {
                let m = value as! UserModel
                self?.tatle.text = m.hfb
                if m.orqd == 0
                {
                    self?.stateIcon.hidden = true
                    self?.state.text = "还未签到"
                    self?.state.textColor = "333333".color
                }
               
                if(m.orwsinfo == "1")
                {
                    self?.zlicon.image = "duihao.png".image
                    self?.zltxt.text = "已完成"
                    self?.zltxt.textColor = APPBlueColor
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
