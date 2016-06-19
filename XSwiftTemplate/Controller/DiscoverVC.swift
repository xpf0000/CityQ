//
//  DiscoverVC.swift
//  chengshi
//
//  Created by X on 15/11/23.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class DiscoverVC: XViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView!
    
    lazy var imgArr:Array<String>=["phone_icon.png","Discount_icon.png","more_icon.png"]
    lazy var titleArr:Array<String>=["电话黄页","打折信息"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSizeMake(swidth/3.0, swidth/3.0);
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        
        cell.contentView.removeAllSubViews()
        
        //cell.contentView.backgroundColor = UIColor.redColor()
        
        if(indexPath.row<2)
        {
            let img=UIImageView()
            img.image=imgArr[indexPath.row].image
            cell.contentView.addSubview(img)
            
            let label=UILabel()
            label.text=titleArr[indexPath.row]
            label.textColor=blackTXT
            label.font = UIFont.systemFontOfSize(13.0)
            cell.contentView.addSubview(label)
            
            let line=UILabel()
            line.backgroundColor = borderBGC
            line.frame=CGRectMake(swidth/3.0-0.34, 0, 0.34, swidth/3.0)
            cell.contentView.addSubview(line)
            
            img.snp_makeConstraints { (make) -> Void in
                make.centerX.equalTo(cell.contentView)
                make.centerY.equalTo(cell.contentView).offset(-10.0)
                make.width.equalTo(swidth/3.0*0.25)
                make.height.equalTo(swidth/3.0*0.25)
            }
            
            label.snp_makeConstraints { (make) -> Void in
                make.centerX.equalTo(cell.contentView)
                make.top.equalTo(img.snp_bottom).offset(5.0)
                
            }
        }
        else
        {
            let img=UIImageView()
            img.image=imgArr[indexPath.row].image
            cell.contentView.addSubview(img)
            
            img.snp_makeConstraints { (make) -> Void in
                make.center.equalTo(cell.contentView)
                make.width.equalTo(swidth/3.0*0.65)
                make.height.equalTo(swidth/3.0*0.65)
            }
            
        }
        
        let line=UILabel()
        line.backgroundColor = borderBGC
        line.frame=CGRectMake(0, swidth/3.0-0.34, swidth/3.0, 0.34)
        cell.contentView.addSubview(line)
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row
        {
        case 0:
            
            let vc:PhoneVC = "PhoneVC".VC as! PhoneVC
            vc.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        case 1:
            
            let vc:DiscountVC = "DiscountVC".VC("Discount") as! DiscountVC
            vc.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            ""
        }
        
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
