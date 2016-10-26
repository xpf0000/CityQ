//
//  MyYouhuiquanVC.swift
//  chengshi
//
//  Created by X on 2016/10/24.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyYouhuiquanVC: UIViewController,UICollectionViewDelegate {
    
    let collect = XCollectionView()
    
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
        
        let url = "http://182.92.70.85/hfapi/Public/Found/?service=Jifen.getUYHQList&uid=\(Uid)&page=[page]&perNumber=20"
        
        collect.setHandle(url, pageStr: "[page]", keys: ["data","info"], model: YouhuiquanModel.self, CellIdentifier: "YouhuiquanCell")
        
        collect.show()
        
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
}
