//
//  FriendNewsVC.swift
//  chengshi
//
//  Created by X on 15/11/26.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class FriendNewsVC: XViewController,UICollectionViewDataSource,UICollectionViewDelegate,DDCollectionViewDelegateFlowLayout{

    @IBOutlet var collectionView: UICollectionView!
    var httpHandle:XHttpHandle=XHttpHandle()
    lazy var heightArr:Dictionary<Int,CGFloat>=[:]
    var xiaoquid = "0"
    {
        didSet
        {
            httpHandle.url=APPURL+"Public/Found/?service=Quan.getListHot&page=[page]&perNumber=20&xiaoquid="+xiaoquid
            httpHandle.reSet()
            httpHandle.handle()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.registerNib("FriendNewsCell".Nib, forCellWithReuseIdentifier: "FriendNewsCell")
        
        let layout:DDCollectionViewFlowLayout=DDCollectionViewFlowLayout()
        layout.delegate = self;
        self.collectionView.collectionViewLayout = layout
        
        httpHandle.url=APPURL+"Public/Found/?service=Quan.getListHot&page=[page]&perNumber=20&xiaoquid="+xiaoquid
        httpHandle.pageStr="[page]"
        httpHandle.scrollView=self.collectionView
        httpHandle.replace=["descrip":"description"]
        httpHandle.keys=["data","info"]
        httpHandle.modelClass=FriendModel.self
        
        self.collectionView.setHeaderRefresh { [weak self] () -> Void in
            
            if(self == nil)
            {
                return
            }
            self?.heightArr.removeAll(keepCapacity: false)
            self!.httpHandle.reSet()
            self!.httpHandle.handle()
        }
        
        self.collectionView.beginHeaderRefresh()
        
        self.collectionView.setFooterRefresh {[weak self] () -> Void in
            
            self!.httpHandle.handle()
        }
        
        self.collectionView.hideFootRefresh()
        
    }

    func collectionView(collectionView: UICollectionView!, layout: DDCollectionViewFlowLayout!, numberOfColumnsInSection section: Int) -> Int {
        
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return httpHandle.listArr.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        
        var h:CGFloat = 0.0
        
        if(self.httpHandle.listArr.count == 0)
        {
            return CGSizeMake(0.0, h);
        }
        
        if(heightArr[indexPath.row] == nil)
        {
            
            for i in self.heightArr.count..<self.httpHandle.listArr.count
            {
                var ch:CGFloat=0.0
                
                let model:FriendModel = self.httpHandle.listArr[i] as! FriendModel
                if(model.width > 0 && model.height > 0)
                {
                    let newW:CGFloat = (swidth-30)/2.0
                    ch += newW*model.height / model.width
                }
                
                    ch += 10+20+4+16+10
                
                self.heightArr[i] = ch
            }
            
            h=self.heightArr[indexPath.row]!
            
        }
        else
        {
            h=self.heightArr[indexPath.row]!
        }
        
        
        return CGSizeMake((swidth-15)/2.0, h);
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell:FriendNewsCell = collectionView.dequeueReusableCellWithReuseIdentifier("FriendNewsCell", forIndexPath: indexPath) as! FriendNewsCell
        
        cell.layer.cornerRadius = 5.0
        cell.layer.masksToBounds = true
        
        cell.model = httpHandle.listArr[indexPath.row] as! FriendModel
        cell.show()
        
        cell.layer.borderColor = "#d7d7d7".color!.CGColor
        cell.layer.borderWidth = 0.2
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let vc:FriendInfoVC = "FriendInfoVC".VC("Friend") as! FriendInfoVC
        vc.hidesBottomBarWhenPushed = true
        vc.fmodel = httpHandle.listArr[indexPath.row] as! FriendModel
        
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
