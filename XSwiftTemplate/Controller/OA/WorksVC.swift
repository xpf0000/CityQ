//
//  WorksVC.swift
//  OA
//
//  Created by X on 15/4/28.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit

class WorksVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    var gridView:UICollectionView?
    var picArr=["oa_index_icon05.png","oa_index_icon06.png","oa_index_icon03.png","oa_index_icon0400.png","index_icon11.png"]
    var txtArr=["消息","通讯录","公文","个人中心","文档"]
    
    var headImg:UIImageView?
    let num=UIButton(type: .Custom)
    let num1=UIButton(type: .Custom)
    
    
    func http()
    {
        let url="http://101.201.169.38/apioa/Public/OA/?service=user.getncount&jgid="+DataCache.Share.oaUserModel.jgid+"&dwid="+DataCache.Share.oaUserModel.dwid+"&bmid="+DataCache.Share.oaUserModel.bmid+"&username="+DataCache.Share.oaUserModel.username+"&uid="+DataCache.Share.oaUserModel.uid

        XHttpPool.requestJson(url, body: nil, method: .GET) { [weak self](o) -> Void in

            if(o?["data"]["info"].arrayValue.count>=2)
            {
                let ncount = o!["data"]["info"][0]["value"].stringValue.numberValue.integerValue
                let dcount = o!["data"]["info"][1]["dcount"].stringValue.numberValue.integerValue
                
                if(ncount > 0)
                {
                    self?.num.setTitle("\(ncount)", forState: .Normal)
                    self?.num.hidden = false
                }
                
                if(dcount > 0)
                {
                    self?.num1.setTitle("\(dcount)", forState: .Normal)
                    self?.num1.hidden = false
                }
                
                
            }
            
        }
        
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.title="办公OA"
        self.navigationItem.hidesBackButton=true
        self.addBackButton()
        
    }
    
   override func viewDidLoad() {
    super.viewDidLoad()
            self.view.backgroundColor=UIColor.whiteColor()
    
            let clayout:UICollectionViewFlowLayout=UICollectionViewFlowLayout()
            clayout.scrollDirection=UICollectionViewScrollDirection.Vertical
            gridView=UICollectionView(frame: CGRectMake(0, 0, swidth, sheight), collectionViewLayout: clayout)
            gridView?.backgroundColor=UIColor.whiteColor()
            gridView?.delegate=self
            gridView?.dataSource=self
    
            gridView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "GradientCell")
    
            self.view.addSubview(gridView!)
    
        num.backgroundColor = UIColor.redColor()
        num.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        num.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        num.contentEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 6)
        num.layer.cornerRadius = 12.0
        num.layer.masksToBounds = true
        num.setTitle("1", forState: .Normal)
    
        num1.backgroundColor = UIColor.redColor()
        num1.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        num1.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        num1.contentEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 6)
        num1.layer.cornerRadius = 12.0
        num1.layer.masksToBounds = true
        num1.setTitle("128", forState: .Normal)
        num.hidden = true
        num1.hidden = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(10, 15, 0, 15)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSizeMake((swidth-15*5)/4, (swidth-15*5)/4+30)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let CellIdentifier = "GradientCell"
        let cell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) 
        
        cell.backgroundColor=UIColor.clearColor()
        
        let img:UIImageView=UIImageView()
        img.image=picArr[indexPath.row].image
        cell.contentView.addSubview(img)
        
        img.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(cell.contentView)
            make.centerY.equalTo(cell.contentView).offset(-15.0)
            make.height.equalTo(cell.frame.size.width*0.7)
            make.width.equalTo(cell.frame.size.width*0.7)
        }
        
        if(indexPath.row == 0)
        {
            cell.contentView.addSubview(num)
            num.snp_makeConstraints(closure: { (make) -> Void in
                make.height.equalTo(24)
                make.width.greaterThanOrEqualTo(24)
                make.top.equalTo(img.snp_top).offset(-10)
                make.trailing.equalTo(img.snp_trailing).offset(10)
            })
        }
        
        if(indexPath.row == 2)
        {
            cell.contentView.addSubview(num1)
            num1.snp_makeConstraints(closure: { (make) -> Void in
                make.height.equalTo(24)
                make.width.greaterThanOrEqualTo(24)
                make.top.equalTo(img.snp_top).offset(-10)
                make.trailing.equalTo(img.snp_trailing).offset(10)
            })
        }
        
        
        let label:UILabel=UILabel()
        label.text=txtArr[indexPath.row]
        label.textAlignment=NSTextAlignment.Center
        cell.contentView.addSubview(label)
        
        label.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(cell.contentView)
            make.top.equalTo(img.snp_bottom).offset(10.0)
        }
        
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var vc:UIViewController?
        
        switch Int(indexPath.row)
        {
        case 0:
            vc=OAMessageVC()
            self.num.setTitle("0", forState: .Normal)
            self.num.hidden = true
            
        case 1:
            ""
            vc=OAAddressBookVC()
        case 2:
           ""
            vc=OADocVC()
           self.num1.setTitle("0", forState: .Normal)
           self.num1.hidden = true
            
        case 3:
            ""
            vc="OAUserCenterVC".VC("OA")
        case 4:
            ""
            vc=OAFileVC()
            
        default :
            ""
        }
        if(vc != nil)
        {
            vc!.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if(keyPath == "headerPic")
        {
            //headImg?.requestURL=DataCache.Share.userInfo.headerPic
            //headImg?.refreshImage()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.http()
    }
    
    deinit
    {
        //DataCache.Share.userInfo.removeObserver(self, forKeyPath: "headerPic")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
