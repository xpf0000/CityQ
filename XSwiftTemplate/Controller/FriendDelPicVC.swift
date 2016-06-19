//
//  PicNewsInfoVC.swift
//  chengshi
//
//  Created by X on 15/11/21.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class FriendDelPicVC: XViewController,UIScrollViewDelegate,UITextViewDelegate,zoomScrollDelegate {
    
    
    @IBOutlet var delButton: UIButton!
    
    var scrollView: UIScrollView = UIScrollView(frame: CGRectMake(0, 0, swidth, sheight))
    var nowIndex:Int=1
     var needRefresh:Int = 0
    var canDel=true
    var showBack=true
    var block:AnyBlock?
    lazy var imgArr:Array<AnyObject> = []
    
    @IBAction func del(sender: AnyObject) {
        
        self.navigationController?.view.window?.addSubview(XDeleteAlert.Share())
        
        XDeleteAlert.Share().block =
            {
                [weak self]
                (o)->Void in
                
                if(self == nil)
                {
                    return
                }
                
                let index=self!.nowIndex
                
                self?.imgArr.removeAtIndex(index-1)
                
                if(self?.imgArr.count == 0)
                {
                    self?.block?(self!.imgArr)
                    XDeleteAlert.Share().removeFromSuperview()
                    self?.jumpAnimType = .Alpha
                    self?.dismissViewControllerAnimated(true, completion: { () -> Void in
                        
                    })
                    
                    return
                }
                
                self!.nowIndex = index-1 == 0 ? 1 : index-1
                self?.handle()
                
                self?.title = "\(self!.nowIndex)/\(self!.imgArr.count)"
                XDeleteAlert.Share().removeFromSuperview()
                
            }
        
    }
    
    
    
    func handle()
    {
        scrollView.removeAllSubViews()
        
        print(self.imgArr)
        
        var i:Int=0
        for img in self.imgArr
        {
            var zoomScrollView:MRZoomScrollView!
            let imgView = UIImageView()
            if img is UIImage
            {
                imgView.image = img as? UIImage
            }
            else if img is String
            {
                imgView.url = img as? String
            }
            zoomScrollView = MRZoomScrollView(img: imgView)
            
            zoomScrollView.frame = CGRect(x: Int(swidth * CGFloat(i)), y: 0, width: Int(swidth), height: Int(sheight))
            zoomScrollView.topOffset = 0.0
            zoomScrollView.zoomDelegate = self
            scrollView.addSubview(zoomScrollView)
            
            i += 1
            
        }
        
        scrollView.contentSize.width = swidth * CGFloat(self.imgArr.count)
        
        scrollView.contentOffset.x = swidth * CGFloat(nowIndex-1)
        
        self.title = "\(nowIndex)/\(self.imgArr.count)"
        
    }
    
    func zoomTapClick() {
        self.pop()
    }
    
    
    override func pop() {
        
        self.block?(self.imgArr)
        super.pop()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationController?.view.window?.addSubview(XDeleteAlert.Share())
        XDeleteAlert.Share().removeFromSuperview()
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        
        self.view.addSubview(scrollView)
        self.view.sendSubviewToBack(scrollView)
        
        if(!canDel)
        {
            delButton.enabled = false
            delButton.hidden = true
        }
        
        if(self.showBack)
        {
            let button=UIButton(type: UIButtonType.Custom)
            button.frame=CGRectMake(10, 2, 25, 25);
            button.setBackgroundImage("back_arrow.png".image, forState: UIControlState.Normal)
            button.showsTouchWhenHighlighted = true
            button.exclusiveTouch = true
            button.addTarget(self, action: #selector(UIViewController.pop), forControlEvents: UIControlEvents.TouchUpInside)
            let leftItem=UIBarButtonItem(customView: button)
            self.navigationItem.leftBarButtonItem=leftItem;
            
            self.backButton=button

            self.title = "\(nowIndex)/\(self.imgArr.count)"
        }
        else
        {
            if(self.imgArr.count>0)
            {
                self.title = "\(nowIndex)/\(self.imgArr.count)"
            }
            
        }
        
        (self.navigationController as! XNavigationController).setAlpha(0.0)

        self.handle()
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        
        if(Int(scrollView.contentOffset.x*100)%Int(swidth*100)==0)
        {
            nowIndex=Int(Int(scrollView.contentOffset.x*100)/Int(swidth*100))+1;
            
            if(self.imgArr.count>0)
            {
                self.title = "\(nowIndex)/\(self.imgArr.count)"
            }

        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidDisappear(animated)
        

    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        (self.navigationController as! XNavigationController).setAlpha(0.0)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        (self.navigationController as! XNavigationController).setAlpha(1.0)
    }
    
    
    
    deinit
    {
        //print(NSStringFromClass(self.dynamicType)+" "+__FUNCTION__+" !!!!!!!!!")
        self.imgArr.removeAll(keepCapacity: false)
        self.scrollView.delegate = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
