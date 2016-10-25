//
//  PropertyIndexVC.swift
//  OA
//
//  Created by X on 15/4/28.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit

class PropertyIndexVC: XViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    var gridView:UICollectionView?
    var picArr=["wuye_index_3.png","wuye_index_0.png","wuye_index_1.png","wuye_index_2.png","wuye_index_5.png"]
    var txtArr=["房屋信息","小区公告","物业缴费","物业报修","电话黄页"]
    
    var banner:XBanner = XBanner(frame: CGRectMake(0, 0, swidth, swidth / 16.0 * 6.0), collectionViewLayout: UICollectionViewLayout())
    
    let num=UIButton(type: .Custom)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.title="物业"
        self.navigationItem.hidesBackButton=true
        self.addBackButton()
        self.getBanner()
        self.getMsgCount()
    }
    
    func getMsgCount()
    {
        
        let url = APPURL+"Public/Found/?service=Wuye.getUserNewsCount&uid=\(DataCache.Share.userModel.uid)&username=\(DataCache.Share.userModel.username)"
        
        XHttpPool.requestJson(url, body: nil, method: .GET) { [weak self](o) -> Void in
           
            if let count = o?["data"]["info"][0]["count"].string
            {
                if count == "0"
                {
                    self?.num.hidden = true
                }
                else
                {
                    self?.num.hidden = false
                    self?.num.setTitle(count, forState: .Normal)
                }
            }
            
        }
        
    }
    
    
    func getBanner()
    {

        let url=APPURL+"Public/Found/?service=News.getGuanggao&typeid=93"
        
        XHttpPool.requestJson(url, body: nil, method: .GET) { (o) -> Void in
            
            if(o == nil)
            {
                
                
                return
            }
            
            var bannerArr:Array<XBannerModel>=[]
            
            for item in o!["data"]["info"].arrayValue
            {
                let model:XBannerModel=XBannerModel()
                model.obj = item["url"].stringValue
                model.image =  item["picurl"].stringValue
                bannerArr.append(model)
                
            }
            
            self.banner.bannerArr = bannerArr
            //self.table.beginUpdates()
            //self.table.endUpdates()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.whiteColor()
        
        self.banner.scrollInterval = 5.0
//        self.banner.hiddenTitle = true
//        self.banner.page.removeConstraints(self.banner.page.constraints)
//        self.banner.page.snp_makeConstraints { (make) -> Void in
//            make.bottom.equalTo(-8.0)
//            make.centerX.equalTo(self.banner)
//        }
//        banner.page.pageIndicatorTintColor = UIColor.lightGrayColor()
//        banner.page.currentPageIndicatorTintColor = APPBlueColor
        
        banner.click
            {
                [weak self]
                (o)->Void in
                
                if(self != nil)
                {
                    let vc:HtmlVC = HtmlVC()
                    vc.hidesBottomBarWhenPushed = true
                    vc.url = o.obj as! String
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
        }

        self.view.addSubview(banner)
        
        let clayout:UICollectionViewFlowLayout=UICollectionViewFlowLayout()
        clayout.scrollDirection=UICollectionViewScrollDirection.Vertical
        gridView=UICollectionView(frame: CGRectMake(0, swidth / 16.0 * 6.0, swidth, sheight-(swidth / 16.0 * 6.0)-64), collectionViewLayout: clayout)
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

        num.hidden = true
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
        
        let label:UILabel=UILabel()
        label.text=txtArr[indexPath.row]
        label.textAlignment=NSTextAlignment.Center
        label.textColor="232323".color
        cell.contentView.addSubview(label)
        
        label.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(cell.contentView)
            make.top.equalTo(img.snp_bottom).offset(10.0)
        }
        
        
        if(indexPath.row == 4)
        {
            cell.contentView.addSubview(num)
            num.snp_makeConstraints(closure: { (make) -> Void in
                make.height.equalTo(24)
                make.width.greaterThanOrEqualTo(24)
                make.top.equalTo(img.snp_top).offset(-10)
                make.trailing.equalTo(img.snp_trailing).offset(10)
            })
        }
        
        
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if(!self.checkIsLogin())
        {
            return
        }
        
        var vc:UIViewController?
        
        switch Int(indexPath.row)
        {
        case 0:
            ""
            vc = "UserHouseVC".VC("Wuye")
            
            
        case 1:
            ""
            if !self.checkDefaultHouse(){return}
            if !DataCache.Share.userModel.house.checkStatus(true){return}
            
            vc = PropertyNoticVC()
            
            
        case 2:
            ""
            
            if !self.checkDefaultHouse(){return}
            if !DataCache.Share.userModel.house.checkStatus(true){return}
            
            vc = "PropertyPaymentVC".VC("Wuye")
            
            
        case 3:
            ""
            
            if !self.checkDefaultHouse(){return}
            if !DataCache.Share.userModel.house.checkStatus(true){return}
            
            vc = PropertyPhotoVC()
            
//        case 4:
//            ""
//            if !self.checkDefaultHouse(){return}
//            if !DataCache.Share.userModel.house.checkStatus(true){return}
//            
//            vc = PropertyMsgVC()
//            
//            self.num.setTitle("0", forState: .Normal)
//            self.num.hidden = true
            
        case 4:
            ""
            if !self.checkDefaultHouse(){return}
            if !DataCache.Share.userModel.house.checkStatus(true){return}
            
            vc = PropertyPhoneVC()
            
        case 5:
            ""
            if !self.checkDefaultHouse(){return}
            if !DataCache.Share.userModel.house.checkStatus(true){return}
            
            vc = "FriendHomeVC".VC
            (vc as? FriendHomeVC)?.xiaoquid = DataCache.Share.userModel.house.houseid
            
        default :
            ""
        }
        if(vc != nil)
        {
            vc!.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
    }
    
    
    func checkDefaultHouse()->Bool
    {
        if(DataCache.Share.userModel.house.houseid.numberValue.intValue == 0)
        {
            let vc = "UserHouseVC".VC("Wuye")
            self.navigationController?.pushViewController(vc, animated: true)
            
            ShowMessage("请先添加房屋信息")
            
            return false
        }
        
        return true
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = DataCache.Share.userModel.house.xiaoqu
        self.title = (self.title == nil || self.title == "") ? "尚未绑定房屋" : self.title
        
        (self.navigationController as? XNavigationController)?.setRecognizer()
        
//        (self.navigationController as! XNavigationController).block={
//            [weak self](o)->Void in
//            if self==nil{return}
//            
//            if let recoginzer:UIScreenEdgePanGestureRecognizer = o as? UIScreenEdgePanGestureRecognizer
//            {
//                if recoginzer.edges == UIRectEdge.Left {return}
//                
//                let progress = fabs(recoginzer.translationInView(self!.view).x) / self!.view.bounds.width
//                
//                switch recoginzer.state
//                {
//                case .Began:
//                    
//                    if(JumpInteraction.Share.running){return}
//                    JumpInteraction.Share.running = true
//                    JumpInteraction.Share.interacting = true
//                    self!.chooseHouse()
//                    
//                case .Changed:
//
//                    if(JumpInteraction.Share.interacting)
//                    {
//                        JumpInteraction.Share.updateInteractiveTransition(progress)
//                    }
//                    
//                case .Ended,.Cancelled :
//
//                    if(JumpInteraction.Share.interacting)
//                    {
//                        JumpInteraction.Share.interacting=false
//                        
//                        if(progress<=JumpInteraction.Share.completeProgress)
//                        {
//                            JumpInteraction.Share.cancelInteractiveTransition()
//                        }
//                        else
//                        {
//                            JumpInteraction.Share.finishInteractiveTransition()
//                            JumpInteraction.Share.complete = true
//                        }
//                        
//                    }
//                    
//                    
//                    
//                default:
//                    
//                    JumpInteraction.Share.cancelInteractiveTransition()
//                }
//            }
//        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        (self.navigationController as! XNavigationController).block=nil
    }
    
    deinit
    {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
