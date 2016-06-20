//
//  PostFriendVC.swift
//  chengshi
//
//  Created by X on 15/11/26.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class ChooseButton:UIButton
{
   
    lazy var model:CategoryModel = CategoryModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
    }
    
    func show()
    {
        self.layer.borderColor = "#E2E2E2".color?.CGColor
        self.layer.borderWidth = 0.4
        self.layer.cornerRadius = 3.0
        self.layer.masksToBounds =  true
        self.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        self.setTitleColor(blackTXT, forState: .Normal)
        self.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)
        self.titleLabel?.font = UIFont.systemFontOfSize(12.0)
        self.setBackgroundImage(grayBGC.image, forState: .Normal)
        self.setBackgroundImage(APPBlueColor.image, forState: .Selected)
        self.setTitle(model.title, forState: .Selected)
        self.setTitle(model.title, forState: .Normal)
        self.sizeToFit()
        
    }
    
}

class PostFriendVC: XViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,XPhotoDelegate {

    @IBOutlet var contentH: NSLayoutConstraint!
    
    @IBOutlet var collectionH: NSLayoutConstraint!
    
    @IBOutlet var collectionW: NSLayoutConstraint!
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var textView: XTextView!
    
    @IBOutlet var flagView: UIView!
    
    @IBOutlet var flagH: NSLayoutConstraint!
    
    @IBOutlet var location: UILabel!
    
    lazy var imageArr:Array<UIImage> = []
    
    var choosedB:ChooseButton?
    
    lazy var PoiInfo:Array<BMKPoiInfo> = []
    
    var xiaoquid = "0"
    
    @IBAction func chooseLocation(sender: AnyObject) {
        
        let vc:FriendLocationChooseVC = "FriendLocationChooseVC".VC("Friend") as! FriendLocationChooseVC
        vc.PoiInfo = self.PoiInfo
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
        vc.block={
                [weak self]
                (o)->Void in
                if(self == nil)
                {
                    return
                }
                
                if(o == nil)
                {
                    self?.location.text = "不显示位置"
                }
                else
                {
                    self?.location.text = (o! as! BMKPoiInfo).name
                }
                
        }
        
        
    }
    
    func getPositon()
    {
        position.Share().block={
            [weak self]
            (o)->Void in
            if(o != nil)
            {
                self?.PoiInfo.removeAll(keepCapacity: false)
                for item in o!.poiList
                {
                    self?.PoiInfo.append(item as! BMKPoiInfo)
                }
                
                if(self?.location.text == "")
                {
                    self?.location.text = self?.PoiInfo[0].name
                }
                
                
            }
            
        }
        
        position.Share().getLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.title = ""
        
        let button=UIButton(type: UIButtonType.Custom)
        button.frame=CGRectMake(10, 2, 40, 25);
        button.setTitle("发送", forState: UIControlState.Normal)
        button.setTitleColor(腾讯颜色.图标蓝.rawValue.color!, forState: .Normal)
        button.showsTouchWhenHighlighted = true
        button.exclusiveTouch = true
        button.addTarget(self, action: "send", forControlEvents: UIControlEvents.TouchUpInside)
        let rightItem=UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem=rightItem;
        
       collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        textView.layer.borderColor = "#E2E2E2".color?.CGColor
        textView.layer.borderWidth = 0.65
        textView.layer.masksToBounds = true
        textView.placeHolder("内容")
        
        if(DataCache.Share().quanCategory.count > 0 && xiaoquid == "0")
        {
           
            var y:CGFloat=0
            var w:CGFloat=0
            for item in DataCache.Share().quanCategory
            {
                let button:ChooseButton = ChooseButton(type: .Custom)
                button.model = item
                button.show()
                button.frame = CGRectMake(w, y, button.frame.width+30, 30)
                
                w=w+button.frame.width+10
                
                if(w>swidth-30)
                {
                    w=0
                    y=y+30+12
                    button.frame = CGRectMake(w, y, button.frame.width+30, 30)
                    w = button.frame.width+10
                }
                
                button.addTarget(self, action: "choose:", forControlEvents: .TouchUpInside)
                
                self.flagView.addSubview(button)
                
            }
  
            y=y+30
        
            flagH.constant=y

        }
        else
        {
            flagH.constant = 20.0
        }
        
    }
    
    func choose(button:ChooseButton)
    {
        if(button != self.choosedB)
        {
            self.choosedB?.selected = false
            button.selected = true
            self.choosedB = button
        }
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageArr.count+1 > 9 ? 9 : imageArr.count+1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 15.0
    }

    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        
        return CGSizeMake((swidth-75)/4.0, (swidth-75)/4.0);
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        
        cell.contentView.removeAllSubViews()
        
        let image:UIImageView=UIImageView()
        image.frame=CGRectMake(0, 0, (swidth-75)/4.0, (swidth-75)/4.0)
        
        if(indexPath.row<imageArr.count)
        {
            image.image = imageArr[indexPath.row]
        }
        else
        {
            image.image = "AddPhotoNormal.png".image
        }
        
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        image.contentMode = .ScaleAspectFill
        
        cell.contentView.addSubview(image)
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row==imageArr.count)
        {
            
            self.navigationController?.view.window?.addSubview(XPhotoChoose.Share())
            self.jumpAnimType = .Default
            XPhotoChoose.Share().vc = self
            XPhotoChoose.Share().delegate = self
            XPhotoChoose.Share().maxNum = UInt(9 - self.imageArr.count)
            
        }
        else
        {
            let vc:FriendDelPicVC = "FriendDelPicVC".VC("Friend") as! FriendDelPicVC
            vc.imgArr = self.imageArr
            vc.nowIndex = indexPath.row+1
            vc.hidesBottomBarWhenPushed = true
            
            let nv:XNavigationController = XNavigationController(rootViewController: vc)
            
            vc.block = {
                [weak self](o)->Void in
                
                self?.imageArr.removeAll(keepCapacity: false)
                for item in o as! Array<AnyObject>
                {
                    self?.imageArr.append(item as! UIImage)
                }
            }
            
            self.jumpAnimType = .Default
            self.presentViewController(nv, animated: true, completion: { () -> Void in
                
            })
        }
        
        
    }
    
    func XPhotoResult(o: AnyObject?) {
        
        if(o is UIImage)
        {
            imageArr.append(o as! UIImage)
        }
        
        if(o is Array<AnyObject>)
        {
            for item in (o! as! Array<AnyObject>)
            {
                if(item is ALAsset)
                {
                    
                    let cgImg =  (item as! ALAsset).defaultRepresentation().fullScreenImage().takeUnretainedValue()
                    let image = UIImage(CGImage:cgImg)
                    
                    imageArr.append(image)
                }
                
            }
            
        }
        
    }
    
    
    func send()
    {
        if(self.imageArr.count == 0)
        {
            self.view.showAlert("请至少选择一张图片", block: nil)
            return
        }
        
        if(!textView.checkNull())
        {
            return
        }
        
        if(self.choosedB == nil && xiaoquid == "0")
        {
            self.flagView.shake()
            return
        }
        
        self.view.endEditing(true)
        
        self.navigationController?.view.addSubview(XProgressView.Share())
        
        var locationStr=self.location.text
        if(locationStr == "不显示位置")
        {
            locationStr=""
        }
        
        var imgDataArr:Array<NSData> = []
        
        for item in self.imageArr
        {
            let data=item.data(0.01)
            if(data != nil)
            {
                imgDataArr.append(data!)
            }
            
        }
        
        let url=APPURL+"Public/Found/?service=Quan.addQuan"
        
        let cid = self.choosedB == nil ? "68" : self.choosedB!.model.id
        
        XHttpPool.upLoadWithMutableName(url, parameters: ["category_id":cid,"username":DataCache.Share().userModel.username,"content":self.textView.text.trim(),"location":locationStr!,"xiaoquid":xiaoquid], file: imgDataArr, name: "file", progress: {[weak self] (p) -> Void in
            
            if self == nil {return}
            XProgressView.Share().setAngle(p)
            
            }) { [weak self](o) -> Void in
                
                XProgressView.Share().removeFromSuperview()
                if(o?["data"].dictionaryValue.count > 0)
                {
                    if(o!["data"]["code"].intValue == 0)
                    {
                        NoticeWord.FriendPostSuccess.rawValue.postNotice()
                        self?.dismissViewControllerAnimated(true, completion: { () -> Void in
                            
                            self?.imageArr.removeAll(keepCapacity: false)
                        })
                        
                        return
                    }
                }
                
                self?.navigationController?.view.showAlert("发送失败", block: nil)
        }
        
        
        
    }
    
    
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionH.constant = ((swidth-75)/4.0+15)*CGFloat(ceil(Double(self.imageArr.count+1)/4.0))
        
        self.collectionView.reloadData()
        
        self.contentH.constant = self.collectionH.constant+8+100+10+flagH.constant+10+60+20
        
        self.getPositon()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        position.Share().stop()
    }
    
    
    deinit
    {
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
 
}
