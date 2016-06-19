//
//  FriendHomeVC.swift
//  chengshi
//
//  Created by X on 15/11/26.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class FriendHomeVC: XViewController ,UIScrollViewDelegate,XPhotoDelegate{

    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var contentW: NSLayoutConstraint!
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    var imageIng:Bool = false
    
    lazy var imgArr:Array<UIImage> = []
    var childVC0:FrientVC!
    var childVC1:FriendNewsVC!
    
    var xiaoquid = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.scrollsToTop = false
        childVC0 = self.childViewControllers[0] as! FrientVC
        childVC1 = self.childViewControllers[1] as! FriendNewsVC
        childVC0.table.scrollsToTop = true
        childVC0.banner.scrollView.scrollsToTop = false
        childVC1.collectionView.scrollsToTop = false
        
        self.navigationController?.view.window?.addSubview(XPhotoChoose.Share())
        XPhotoChoose.Share().removeFromSuperview()
        
        contentW.constant=swidth*2.0
        
        segmentedControl.tintColor=腾讯颜色.图标蓝.rawValue.color
        
        segmentedControl.addTarget(self, action: "changePage:", forControlEvents: .ValueChanged)
       
        if xiaoquid == "0"
        {
            let button=UIButton(type: UIButtonType.Custom)
            button.frame=CGRectMake(10, 2, 25, 25);
            button.setBackgroundImage("class_icon_blue.png".image, forState: UIControlState.Normal)
            button.showsTouchWhenHighlighted = true
            button.exclusiveTouch = true
            button.addTarget(self, action: "toClass", forControlEvents: UIControlEvents.TouchUpInside)
            let leftItem=UIBarButtonItem(customView: button)
            self.navigationItem.leftBarButtonItem=leftItem;
        }
        else
        {
            self.addBackButton()
            
            childVC0.xiaoquid = xiaoquid
            childVC1.xiaoquid = xiaoquid
            
            
        }
        
        let button1=UIButton(type: UIButtonType.Custom)
        button1.frame=CGRectMake(10, 2, 25, 25);
        button1.setBackgroundImage("camera_icon_blue.png".image, forState: UIControlState.Normal)
        button1.showsTouchWhenHighlighted = true
        button1.exclusiveTouch = true
        button1.addTarget(self, action: "toPhoto", forControlEvents: UIControlEvents.TouchUpInside)
        let rightItem=UIBarButtonItem(customView: button1)
        self.navigationItem.rightBarButtonItem=rightItem;
        
    }
    
    
    func changePage(sender:UISegmentedControl)
    {
        self.scrollView.setContentOffset(CGPointMake(swidth*CGFloat(sender.selectedSegmentIndex), 0), animated: true)
        childVC0.table.scrollsToTop = sender.selectedSegmentIndex == 0 ? true : false
        childVC1.collectionView.scrollsToTop = !childVC0.table.scrollsToTop
    
    }
    
    func toClass()
    {
        let vc:FriendClassVC = "FriendClassVC".VC("Friend") as! FriendClassVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func XPhotoResult(o: AnyObject?) {
        
        if(o == nil)
        {
            let vc:PostFriendVC = "PostFriendVC".VC("Friend") as! PostFriendVC
            vc.imageArr = self.imgArr
            
            vc.xiaoquid = xiaoquid
            
            let nv:XNavigationController = XNavigationController(rootViewController: vc)
            
            self.jumpAnimType = .Default
            self.presentViewController(nv, animated: true, completion: { () -> Void in
            
                
                self.imgArr.removeAll(keepCapacity: false)
                
                                })
        }
        
        if(o is UIImage)
        {
            imgArr.append(o as! UIImage)
        }
        
        if(o is Array<AnyObject>)
        {
            for item in (o! as! Array<AnyObject>)
            {
                if(item is ALAsset)
                {
                    
                    let cgImg =  (item as! ALAsset).defaultRepresentation().fullScreenImage().takeUnretainedValue()
                    let image = UIImage(CGImage:cgImg)
                    
                    imgArr.append(image)
                }
                
            }

        }
    }
    
    
    func toPhoto()
    {
        if(!self.checkIsLogin())
        {
            return
        }

        self.navigationController?.view.window?.addSubview(XPhotoChoose.Share())
        self.jumpAnimType = .Default
        XPhotoChoose.Share().vc = self
        XPhotoChoose.Share().delegate = self
        XPhotoChoose.Share().maxNum = UInt(9 - self.imgArr.count)
        
    }

    
    

    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if(scrollView == self.scrollView)
        {
            if(Int(scrollView.contentOffset.x*100)%Int(swidth*100)==0)
            {
                let nowIndex:Int=Int(Int(scrollView.contentOffset.x*100)/Int(swidth*100));
                
                self.segmentedControl.selectedSegmentIndex = nowIndex
                childVC0.table.scrollsToTop = nowIndex == 0 ? true : false
                childVC1.collectionView.scrollsToTop = !childVC0.table.scrollsToTop
                
            }
        }
 
    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
   
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
 
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
