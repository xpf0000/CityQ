//
//  PhoneCollectionCell.swift
//  chengshi
//
//  Created by X on 15/11/23.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class PhoneCollectionCell: UITableViewCell ,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{

    
    @IBOutlet var collectionView: UICollectionView!
    
    lazy var arr:Array<CategoryModel> = []
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arr.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSizeMake(swidth/4.0, swidth/4.0);
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell:PhoneClassCell = collectionView.dequeueReusableCellWithReuseIdentifier("PhoneClassCell", forIndexPath: indexPath) as! PhoneClassCell
        cell.model = self.arr[indexPath.row]
        cell.show()
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        let vc:PhoneSearchVC = "PhoneSearchVC".VC as! PhoneSearchVC
        vc.hidesBottomBarWhenPushed=true
        vc.classModel =  self.arr[indexPath.row]

        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        self.collectionView.registerNib("PhoneClassCell".Nib, forCellWithReuseIdentifier: "PhoneClassCell")
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
