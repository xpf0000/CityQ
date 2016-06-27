//
//  FriendPicView.swift
//  chengshi
//
//  Created by X on 15/11/25.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class FriendPicView: UIView,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIImageViewGroupDelegate {

    @IBOutlet var picCollection: UICollectionView!
    
    lazy var picList:Array<FriendPicModel> = []
    
    var baseW=swidth-62
    
    func show()
    {
 
        
//        if(picList.count >= 3)
//        {
//            return CGSizeMake(baseW/3.0, baseW/3.0);
//        }
//        else if(picList.count == 2)
//        {
//            return CGSizeMake(baseW/2.0, baseW/2.0);
//        }
//        else if(picList.count==1)
//        {
//            let width:CGFloat=picList[0].width
//            let height:CGFloat = picList[0].height
//            
//            var newW:CGFloat = width
//            var newH:CGFloat = height
//            
//            if(width / height > 3.0)
//            {
//                newW=baseW
//                newH = baseW/3.0
//            }
//            else if(width / height < 1 / 3)
//            {
//                newW=baseW/3.0
//                newH = baseW
//            }
//            else
//            {
//                if(width>height)
//                {
//                    if(width > baseW)
//                    {
//                        newW=baseW
//                        newH=newW*height/width
//                    }
//                }
//                else if(width<height)
//                {
//                    if(height > baseW)
//                    {
//                        newH=baseW
//                        newW=newH*width/height
//                    }
//                }
//                else
//                {
//                    if(width > baseW)
//                    {
//                        newW=baseW
//                        newH=newW*height/width
//                    }
//                }
//                
//            }
//            
//            return CGSizeMake(newW, newH);
//        }
        
        picCollection.registerNib("FrientPicCell".Nib, forCellWithReuseIdentifier: "FrientPicCell")
        
        self.picCollection.reloadData()
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(picList.count == 0)
        {
            return 0
        }
        
        return picList.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0.0
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        if(picList.count >= 3)
        {
            return CGSizeMake(baseW/3.0, baseW/3.0);
        }
        else if(picList.count == 2)
        {
            return CGSizeMake(baseW/2.0, baseW/2.0);
        }
        else if(picList.count==1)
        {
            let width:CGFloat=picList[0].width
            let height:CGFloat = picList[0].height
            
            var newW:CGFloat = width
            var newH:CGFloat = height
            
            if(width / height > 3.0)
            {
                newW=baseW
                newH = baseW/3.0
            }
            else if(width / height < 1 / 3)
            {
                newW=baseW/3.0
                newH = baseW
            }
            else
            {
                if(width>height)
                {
                    if(width > baseW)
                    {
                        newW=baseW
                        newH=newW*height/width
                    }
                }
                else if(width<height)
                {
                    if(height > baseW)
                    {
                        newH=baseW
                        newW=newH*width/height
                    }
                }
                else
                {
                    if(width > baseW)
                    {
                        newW=baseW
                        newH=newW*height/width
                    }
                }
                
            }
            
            return CGSizeMake(newW, newH);
        }
        
        return CGSizeMake(0.0, 0.0);
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell:FrientPicCell = collectionView.dequeueReusableCellWithReuseIdentifier("FrientPicCell", forIndexPath: indexPath) as! FrientPicCell
        
        if(picList.count == 0)
        {
            cell.model=nil
        }
        else
        {
            cell.model = picList[indexPath.row]
        }
        
        cell.img.isGroup = true
        cell.img.groupDelegate = self
        cell.show()
        
        imgArr[indexPath.row] = cell.img
        
        return cell
        
    }
    
    var imgArr:[Int:UIImageView] = [:]
    
    func UIImageViewGroupTap(obj: UIImageView) {
        
        var arr:[UIImageView] = []
        for i in 0..<picList.count
        {
            arr.append(imgArr[i]!)
        }
        
        XImageBrowse.Share.imageArr = arr
        XImageBrowse.Share.show(obj)
        
    }
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    func initSelf()
    {
        let containerView:UIView=("FriendPicView".Nib.instantiateWithOwner(self, options: nil))[0] as! UIView
        
        let newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        containerView.frame = newFrame
        
        self.addSubview(containerView)
        
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.initSelf()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initSelf()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.picCollection.registerNib("FrientPicCell".Nib, forCellWithReuseIdentifier: "FrientPicCell")
        
    }

}
