//
//  CardYouhuiquanVC.swift
//  chengshi
//
//  Created by X on 2016/10/24.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class CardYouhuiquanVC: UIViewController,UICollectionViewDelegate {

    let collect = XCollectionView()
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = APPBGColor
        self.addBackButton()
        self.title = "优惠券"
        
        collect.frame = CGRectMake(0, 0, swidth, sheight-64)
        self.view.addSubview(collect)
        
        collect.backgroundColor = APPBGColor
        collect.ViewLayout.sectionInset = UIEdgeInsetsMake(10.0, 0, 0, 0)
        collect.ViewLayout.itemSize = CGSizeMake(swidth, 100.0)
        collect.ViewLayout.minimumLineSpacing = 10.0
        collect.ViewLayout.minimumInteritemSpacing = 10.0
        
        collect.Delegate(self)
        
        let url = "http://182.92.70.85/hfapi/Public/Found/?service=jifen.getYHQList&shopid=\(id)&uid=\(Uid)&page=[page]&perNumber=20"
        
        collect.setHandle(url, pageStr: "[page]", keys: ["data","info"], model: YouhuiquanModel.self, CellIdentifier: "YouhuiquanCell")
        
        collect.show()

       
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let m = collect.httpHandle.listArr[indexPath.row] as! YouhuiquanModel
        
        if m.orlq == 0
        {
            doLingqu(m)
        }
  
    }

    func doLingqu(m:YouhuiquanModel)
    {
        XWaitingView.show()
        
        let url = "http://182.92.70.85/hfapi/Public/Found/?service=Jifen.addYHQ&uid=\(Uid)&username=\(Uname)&yhqid="+m.id
        
        XHttpPool.requestJson(url, body: nil, method: .POST) { (o) in
            
            XWaitingView.hide()
            
            if o?["data"]["code"].int == 0
            {
                m.orlq = 1
                XAlertView.show("领取成功", block: nil)
                MainDo({ [weak self](nil) in
                    
                    self?.collect.reloadData()
                })
            }
            else
            {
                var msg = o?["data"]["msg"].stringValue
                msg = msg == "" ? "领取失败" : msg
                XAlertView.show(msg!, block: nil)
            }
            
          
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

    
}
