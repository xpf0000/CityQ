//
//  CardUserYouhuiquanVC.swift
//  chengshi
//
//  Created by X on 2016/11/18.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class CardUserYouhuiquanVC: UIViewController ,UICollectionViewDelegate {
    
    let collect = XCollectionView()
    var sid = ""
    
    var moneyModel:CardChongzhiModel?
    
    var block:AnyBlock?
    
    func onChoose(b:AnyBlock)
    {
        self.block = b
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = APPBGColor
        self.addBackButton()
        self.title = "我的优惠券"
        
        collect.frame = CGRectMake(0, 0, swidth, sheight-64)
        self.view.addSubview(collect)
        
        collect.backgroundColor = APPBGColor
        collect.ViewLayout.sectionInset = UIEdgeInsetsMake(10.0, 0, 0, 0)
        collect.ViewLayout.itemSize = CGSizeMake(swidth, 100.0)
        collect.ViewLayout.minimumLineSpacing = 10.0
        collect.ViewLayout.minimumInteritemSpacing = 10.0
        collect.postDict = ["type":1]
        collect.Delegate(self)
        
        let url = "http://182.92.70.85/hfapi/Public/Found/?service=Jifen.getUYHQList&uid=\(Uid)&shopid=\(sid)&page=[page]&perNumber=20"
        
        collect.setHandle(url, pageStr: "[page]", keys: ["data","info"], model: YouhuiquanModel.self, CellIdentifier: "YouhuiquanCell")
        
        print("0: \(NSDate())")
        print("1: \(NSDate().formart())")
        print("2: \(NSDate.server())")
        
        
        print("00: \(NSDate().timeIntervalSince1970)")
        print("11: \(NSDate().formart().timeIntervalSince1970)")
        print("22: \(NSDate.server().timeIntervalSince1970)")
        
        print("333: \(NSDate().dateByAddingTimeInterval(XHttpPool.Share.serverTimeInterval).timeIntervalSince1970)")
        
        collect.httpHandle.BeforeBlock {[weak self] (res) in
            
            let t = NSDate.serverUnix()
        
            let arr = self?.collect.httpHandle.listArr.filter({ (item) -> Bool in
                
                if let m = item as? YouhuiquanModel,let m1 = self?.moneyModel
                {
                    
                    let a = t >= m.s_time_unix && t <= m.e_time_unix
                    
                    let b = m.s_money.numberValue.doubleValue <= m1.money.numberValue.doubleValue
                    
                    
                    return a && b
                }
                
                return false
                
            })
            
            self?.collect.httpHandle.listArr = arr!
            
            if self?.collect.httpHandle.listArr.count == 0
            {
                ShowMessage("暂无可用优惠券")
            }
        }
        
        collect.show()
        
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let m = collect.httpHandle.listArr[indexPath.row]
        block?(m)
        
        self.pop()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
