//
//  ShareSDKCustomUI.swift
//  chengshi
//
//  Created by X on 15/11/26.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit


class ShareSDKCustomUI: UIView,UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    static let Share = ShareSDKCustomUI(frame: CGRectMake(0, 0, swidth, sheight))
    
    @IBOutlet var chooseView: UIView!
    
    @IBOutlet var bottom: NSLayoutConstraint!
    
    @IBOutlet var collection1: UICollectionView!
    
    @IBOutlet var collection2: UICollectionView!
    
    @IBOutlet var lineH: NSLayoutConstraint!
    
    @IBOutlet var bgView: UIView!
    
    let txt1=["微信好友","微信朋友圈","新浪微博","QQ好友","QQ空间"]
    let txt2=["举报","复制链接"]
    
    let icon1=["shareIcon7.png","shareIcon6.png","shareIcon5.png","shareIcon4.png","shareIcon3.png"]
    let icon2=["shareIcon2.png","shareIcon1.png"]
    
    var showed=false
    
    var block:AnyBlock?
    
    var vc:UIViewController?
    
    var fontW:CGFloat = 0.0
    
    var shareContent:ISSContent!
    
    weak var pushVC:UIViewController!
    
    @IBOutlet var toolBar: UIToolbar!
    
    @IBAction func cancel(sender: AnyObject) {
        
        self.hide()
        
    }
    
    func initSelf()
    {
        let containerView:UIView=("ShareSDKCustomUI".Nib.instantiateWithOwner(self, options: nil))[0] as! UIView
        
        let newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        containerView.frame = newFrame
        self.addSubview(containerView)
        
        self.userInteractionEnabled = true
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ShareSDKCustomUI.hide as (ShareSDKCustomUI) -> () -> ()))
        recognizer.delegate = self
        recognizer.delaysTouchesBegan = true
        self.bgView.addGestureRecognizer(recognizer)
        
        self.collection1.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        self.collection2.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        toolBar.layer.borderWidth = 0
        toolBar.clipsToBounds = true
        toolBar.layer.masksToBounds = true
        toolBar.layer.shadowColor = UIColor.clearColor().CGColor
        
        let label = UILabel()
        label.text = "微信朋友圈"
        label.font=UIFont.systemFontOfSize(12.5)
        label.frame = CGRectMake(0, 0, 200, 20)
        label.sizeToFit()
        
        self.fontW = label.frame.size.width
        
        self.lineH.constant = 0.5
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        if(touch.view == self.chooseView || touch.view == self.collection1 || touch.view == self.collection2)
        {
            return false
        }
        
        return true
        
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initSelf()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initSelf()
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        
        super.willMoveToSuperview(newSuperview)

        if(newSuperview != nil)
        {
            if(self.showed)
            {
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    
                    self.bottom.constant = 0.0
                    
                    self.chooseView.layoutIfNeeded()
                    
                })
            }
            
        }
        else
        {
            self.bottom.constant = -290.0
            self.chooseView.layoutIfNeeded()
        }
        
    }
    
    override func didMoveToSuperview() {
        
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        self.shareContent = nil
        self.block = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.chooseView.layoutIfNeeded()
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            
            self.bottom.constant = 0.0
            self.chooseView.layoutIfNeeded()
            
            }) { (finish) -> Void in
                
                self.showed = true
        }

        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func hide(block:AnyBlock)
    {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            
            self.bottom.constant = -290.0
            
            self.chooseView.layoutIfNeeded()
            
            }) { (finish) -> Void in
                
                self.removeFromSuperview()
                block(nil)
        }

    }
    
    func hide()
    {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            
            self.bottom.constant = -290.0
            
            self.chooseView.layoutIfNeeded()
            
            }) { (finish) -> Void in
                
                self.removeFromSuperview()
                
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView == self.collection1)
        {
            return 5
        }
        else
        {
            return 2
        }
        
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(self.fontW+16, 120)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        
        cell.contentView.removeAllSubViews()
        
        let img = UIImageView()
        
        img.frame = CGRectMake(0, 0, self.fontW, self.fontW)
        img.center = CGPointMake((self.fontW+16)/2, 120/2-11)
        cell.contentView.addSubview(img)
        
        let label = UILabel()
        label.frame = CGRectMake(0, 0, self.fontW+16, 24)
        
        if(collectionView == self.collection1)
        {
            label.text = txt1[indexPath.row]
            img.image = icon1[indexPath.row].image
        }
        else
        {
            label.text = txt2[indexPath.row]
            img.image = icon2[indexPath.row].image
        }
        label.textAlignment = .Center
        label.textColor = 腾讯颜色.标题灰.rawValue.color
        label.font = UIFont.systemFontOfSize(12.5)
        label.center = CGPointMake((self.fontW+16)/2, 120/2+self.fontW/2+1)
        
        cell.contentView.addSubview(label)
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if(collectionView ==  self.collection1)
        {
            var shareType:ShareType!
            switch indexPath.row
            {
            case 0:
                ""
                shareType=ShareTypeWeixiSession
            case 1:
                ""
                shareType=ShareTypeWeixiTimeline
            case 2:
                ""
                shareType=ShareTypeSinaWeibo
            case 3:
                ""
                shareType=ShareTypeQQ
            case 4:
                ""
                shareType=ShareTypeQQSpace
            default:
                ""
            }
            
            
            ShareSDK.showShareViewWithType(shareType, container: nil, content: shareContent, statusBarTips: true, authOptions: nil, shareOptions: nil, result: { (type, state, info, error, end) -> Void in
                
                if (state == SSResponseStateSuccess)
                {
                    
                    let alert = UIAlertView(title: "提示", message:"分享成功", delegate:self, cancelButtonTitle: "ok")
                    alert.show()
                }
                else
                {
                    
                    
                    if (state == SSResponseStateFail)
                    {
                        
                        let alert = UIAlertView(title: "提示", message:error.errorDescription(), delegate:self, cancelButtonTitle: "ok")
                        alert.show()
                        
                    }
                    
                }
            })
            
            self.hide()
            
        }
        else
        {
            switch indexPath.row
            {
            case 0:
                ""
                let vc=ReportVC()
                vc.hidesBottomBarWhenPushed=true
                
                self.pushVC?.navigationController?.pushViewController(vc, animated: true)
                self.removeFromSuperview()
                
            case 1:
                ""
                let past = UIPasteboard.generalPasteboard()
                past.string = shareContent.url()
                
                self.hide({ (o) -> Void in
                    
                    ShowMessage("链接复制成功")
                    
                })
                
                
                
            default:
                ""
            }

        }
        
        
        
    }
    
    
    
}
