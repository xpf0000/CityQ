//
//  PostFriendVC.swift
//  chengshi
//
//  Created by X on 15/11/26.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class PostPhotoVC: XViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,XPhotoDelegate {
    
    @IBOutlet var contentH: NSLayoutConstraint!
    
    @IBOutlet var collectionH: NSLayoutConstraint!
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var textView: XTextView!
    
    @IBOutlet var bline: UIView!
    
    @IBOutlet var tel: UITextField!
    
    @IBOutlet var segment: UISegmentedControl!
    
    @IBOutlet var location: UILabel!
    
    @IBOutlet var locationH: NSLayoutConstraint!
    
    lazy var imageArr:Array<UIImage> = []
    
    var choosedB:ChooseButton?
    
    lazy var PoiInfo:Array<BMKPoiInfo> = []
    
    var block:AnyBlock?
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if(keyPath == "center")
        {
            self.contentH.constant = bline.center.y
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.title = "物业报修"
        
        bline.addObserver(self, forKeyPath: "center", options: .New, context: nil)
        
        let button=UIButton(type: UIButtonType.Custom)
        button.frame=CGRectMake(10, 2, 40, 25);
        button.setTitle("发送", forState: UIControlState.Normal)
        button.setTitleColor(腾讯颜色.图标蓝.rawValue.color!, forState: .Normal)
        button.showsTouchWhenHighlighted = true
        button.exclusiveTouch = true
        button.addTarget(self, action: #selector(PostPhotoVC.send), forControlEvents: UIControlEvents.TouchUpInside)
        let rightItem=UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem=rightItem;
        
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        textView.layer.borderColor = "#E2E2E2".color?.CGColor
        textView.layer.borderWidth = 0.65
        textView.layer.masksToBounds = true
        textView.placeHolder("在此输入想说的话...")
        
        tel.addEndButton()
        
        segment.addTarget(self, action: #selector(PostPhotoVC.changePage(_:)), forControlEvents: .ValueChanged)
        segment.selectedSegmentIndex = 2
        self.changePage(segment)
    }
    
    func changePage(sender:UISegmentedControl)
    {

        if sender.selectedSegmentIndex == 2
        {
            //locationH.constant = 38
            locationH.constant = 0
        }
        else
        {
           locationH.constant = 0
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
            
            vc.block = {
                [weak self](o)->Void in
                
                self?.imageArr.removeAll(keepCapacity: false)
                
                for item in o as! Array<AnyObject>
                {
                    self?.imageArr.append(item as! UIImage)
                }
            }
            
            let nv:XNavigationController = XNavigationController(rootViewController: vc)
            
            self.jumpAnimType = .Default
            self.presentViewController(nv, animated: true, completion: { () -> Void in
                
                self.imageArr.removeAll(keepCapacity: false)
                
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
        
        if(!textView.checkNull())
        {
            return
        }
        
        self.view.endEditing(true)
    
        UIApplication.sharedApplication().keyWindow?.addSubview(XProgressView.Share())
    
        var imgDataArr:Array<NSData>?
        
        for item in self.imageArr
        {
            if imgDataArr == nil {imgDataArr = []}
            let data=item.data(0.01)
            if(data != nil)
            {
                imgDataArr!.append(data!)
            }
            
        }

        let url=APPURL+"Public/Found/?service=Wuye.addfeed"

        let dict:[String:AnyObject] = ["uid":DataCache.Share.userModel.uid,"username":DataCache.Share.userModel.username,"houseid":DataCache.Share.userModel.house.houseid,"content":self.textView.text.trim(),"type":Int(fabs(Double(segment.selectedSegmentIndex)-2.0))]

        XHttpPool.upLoadWithMutableName(url, parameters: dict, file: imgDataArr, name: "file", progress: { [weak self](p) -> Void in
            
            if self == nil {return}
            
            XProgressView.Share().setAngle(p)
            
            }) { [weak self](o) -> Void in
                
                if self == nil {return}

                XProgressView.Share().removeFromSuperview()
                
                if(o?["data"].dictionaryValue.count > 0)
                {
                    if(o!["data"]["code"].intValue == 0)
                    {
                        self?.imageArr.removeAll(keepCapacity: false)
                        self?.block?(nil)
                        self?.view.showAlert("发送成功", block: { (o) -> Void in
                            
                            self?.dismissViewControllerAnimated(true, completion: { () -> Void in
                                
                            })
                            
                        })
                        
                        return
                    }
                }
                
                self?.navigationController?.view.showAlert("发送失败", block: nil)
                
        }
        
    }
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        
        
    }
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.collectionView.reloadData()
        self.collectionH.constant = ((swidth-75)/4.0+15)*CGFloat(ceil(Double(self.imageArr.count+1)/4.0))
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    
    deinit
    {
        //print(NSStringFromClass(self.dynamicType)+" "+__FUNCTION__+" !!!!!!!!!")
        self.imageArr.removeAll(keepCapacity: false)
        bline.removeObserver(self, forKeyPath: "center")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
}
