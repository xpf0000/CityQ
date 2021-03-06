//
//  GoodsCenterVC.swift
//  chengshi
//
//  Created by X on 2016/10/24.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class GoodsCenterVC: UITableViewController,UICollectionViewDelegate {
    
    
    @IBOutlet var banner: XBanner!
    
    @IBOutlet var collect: XCollectionView!
    
    @IBAction func leftClick(sender: UIButton) {
        
        let vc = "JifenCenterMainVC".VC("Jifen")
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func rightClick(sender: UIButton) {
        
        let vc = GoodsDuihuanDetailVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    let gh:CGFloat = (swidth*0.5-16)*0.75+65
    var harr:[CGFloat] = [swidth*9.0/16.0,48.0,12,44,100]
    
    func getBanner()
    {
        var barr:[XBannerModel] = []
        
        let url = "http://182.92.70.85/hfapi/Public/Found/?service=news.getGuanggao&typeid=111"
        
        XHttpPool.requestJson(url, body: nil, method: .GET) {[weak self] (o) in
            
            if let arr = o?["data"]["info"].array
            {
                for item in arr
                {
                    let m = XBannerModel()
                    m.image = item["picurl"].stringValue
                    m.title = item["title"].stringValue
                    m.obj = item["url"].stringValue
                    
                    barr.append(m)
                }
                
                self?.banner.bannerArr = barr
            }
            
        }
        
        
    }
    
    
    func getTJGoods()
    {
        collect.postDict = ["type":1]
        
        collect.ViewLayout.itemSize = CGSizeMake(swidth*0.5, gh)
        collect.ViewLayout.minimumLineSpacing = 0.0
        collect.ViewLayout.minimumInteritemSpacing = 0.0
        
        let url = "http://182.92.70.85/hfapi/Public/Found/?service=jifen.getproductList&page=[page]&perNumber=20"
        
        collect.setHandle(url, pageStr: "[page]", keys: ["data","info"], model: GoodsModel.self, CellIdentifier: "JifenGoodsCell")
        
        collect.httpHandle.BeforeBlock {[weak self] (arr) in
            
            self?.harr[4] = CGFloat(ceil(Double(arr.count)/2.0)) * self!.gh
            
            MainDo({ [weak self](nil) in
                
                self?.tableView.reloadData()
     
            })
            
            self?.tableView.endFooterRefresh()
            if arr.count < 20
            {
                self?.tableView.LoadedAll()
            }
        }
        
        
        collect.httpHandle.handle()
        
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "兑换商城"
        self.addBackButton()
        
        self.tableView.setFooterRefresh { 
            [weak self] in
            
            self?.collect.httpHandle.handle()
        }
        collect.Delegate(self)
        getBanner()
        getTJGoods()
        

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return harr[indexPath.row]
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if  indexPath.row == 3
        {
            cell.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0)
            cell.layoutMargins=UIEdgeInsetsMake(0, 0, 0, 0)
        }
        else
        {
            cell.separatorInset=UIEdgeInsetsMake(0, swidth, 0, 0)
            cell.layoutMargins=UIEdgeInsetsMake(0, swidth, 0, 0)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

}
