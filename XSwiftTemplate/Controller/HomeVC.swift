//
//  HomeVC.swift
//  lejia
//
//  Created by X on 15/9/10.
//  Copyright (c) 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

var AdvImage:UIImageView? = UIImageView()

class HomeVC: UIViewController {
    
    let menu = XHorizontalMenuView()
    let main = XHorizontalMainView()
    
    let noNet:NoNewWork = NoNewWork(frame: CGRectZero)
    lazy var topArr:Array<XHorizontalMenuModel> = []
    lazy var views:Array<UIView> = []

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)

        addSearchButton { [weak self](btn) in
            
            self?.toSearch()
        }
        
        getCategory()
    }
    
    var time = 3
    let coverImage = UIImageView()
    
    let timeLabel = UIButton(type: .Custom)
    var timer:NSTimer?
    
    func timerGo()
    {
        if time > 0
        {
            time = time-1
            //timeLabel.text = "\(time)"
        }
        else
        {
            
            timer?.invalidate()
            timer = nil
            
            MainDo({ (o) -> Void in
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    
                    self.coverImage.alpha = 0.0
                    
                    }, completion: { (finish) -> Void in
                        
                        self.coverImage.removeFromSuperview()
                        AdvImage?.image = nil
                        AdvImage = nil
                })
                
                UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
                
            })
        }
    }
    
    func timeThread()
    {
        autoreleasepool
            {
                NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(HomeVC.timerGo), userInfo: nil, repeats: true)
                NSRunLoop.currentRunLoop().run()
        }
    }
    
    func toSearch()
    {
        let vc = NewsSearchVC()
        let nv = XNavigationController(rootViewController: vc)
        
        self.presentViewController(nv, animated: true) { 
            
        }
        
    }
    
    func msgCountChange()
    {
        if let item = self.tabBarController?.tabBar.items?[4]
        {
            if screenScale == 3.0
            {
                if UMsgCount != nil
                {
                    item.image="tarbar4_1@3x.png".image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                    item.selectedImage="tarbar4_selected_1@3x.png".image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                }
                else
                {
                    item.image="tarbar4@3x.png".image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                    item.selectedImage="tarbar4_selected@3x.png".image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                }
            }
            else
            {
                if UMsgCount != nil
                {
                    item.image="tarbar4_1@2x.png".image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                    item.selectedImage="tarbar4_selected_1@2x.png".image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                }
                else
                {
                    item.image="tarbar4@2x.png".image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                    item.selectedImage="tarbar4_selected@2x.png".image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                }
            }

        }
        
        
    }
    
    func showBannerImage()
    {
        coverImage.frame = CGRectMake(0,0,swidth,sheight)
        coverImage.contentMode = .ScaleAspectFill
        coverImage.image = "cover\(Int(sheight * UIScreen.mainScreen().scale)).png".image
        //coverImage.image = UIColor.whiteColor().image
        
        AdvImage?.frame = CGRectMake(0,0,swidth,sheight - 423.0*swidth/1242.0)
        //AdvImage?.frame = CGRectMake(0,0,swidth,sheight)
        coverImage.addSubview(AdvImage!)
        
        timeLabel.frame=CGRectMake(swidth-48-16, 22, 44, 24)
        timeLabel.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        timeLabel.setTitle("跳过", forState: .Normal)
        timeLabel.titleLabel?.font = UIFont.boldSystemFontOfSize(16.0)
        //timeLabel.text = "\(time)"
        //timeLabel.textColor = UIColor.whiteColor()
        timeLabel.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.8)
        //timeLabel.font = UIFont.boldSystemFontOfSize(18.0)
        //timeLabel.textAlignment = .Center
        timeLabel.layer.cornerRadius = 5.0
        timeLabel.layer.masksToBounds = true
        coverImage.addSubview(timeLabel)
        
        coverImage.userInteractionEnabled = true;
        
        timeLabel.click {[weak self,weak timeLabel] (btn) in
            
            self?.timer?.invalidate()
            self?.timer = nil
            
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                self?.coverImage.alpha = 0.0
                
                }, completion: { (finish) -> Void in
                    
                    self?.coverImage.removeFromSuperview()
                    AdvImage?.image = nil
                    AdvImage = nil
            })
            
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
        }
        
        
        UIApplication.sharedApplication().keyWindow?.addSubview(coverImage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(msgCountChange), name: NoticeWord.MsgChange.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(msgCountChange), name: NoticeWord.LoginSuccess.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(msgCountChange), name: NoticeWord.LogoutSuccess.rawValue, object: nil)
        
        menu.frame = CGRectMake(swidth/6.0, 0, swidth/3.0*2.0, 42.0*screenFlag)
        
        main.frame = CGRectMake(0, 42.0*screenFlag, swidth, sheight-64.0-42.0*screenFlag)
        
        main.menu = menu
        menu.line.backgroundColor=APPBlueColor
        menu.lineHeight = 4.0*screenFlag
        menu.menuFontSize = 17.0
        
        self.view.backgroundColor = PageBGColor
        
        self.view.addSubview(menu)
        self.view.addSubview(main)

        if(DataCache.Share.welcom.show)
        {
            let boot = XBootView(frame: CGRectMake(0, 0, swidth, sheight))
            
            if(UIApplication.sharedApplication().keyWindow != nil)
            {
                boot.show(UIApplication.sharedApplication().keyWindow)
            }
            else
            {
                boot.block =
                    {
                        [weak self] (o)->Void in
                        
                        self?.tabBarController?.tabBar.hidden = false
                }
                
                self.tabBarController?.tabBar.hidden = true
                boot.show(self.navigationController?.view)
                
            }
            
        }

        //showBannerImage()

        menu.menuMaxScale = 1.0
        menu.menuPageNum = 4
        menu.menuTextColor = "666666".color!
        menu.menuSelectColor = "333333".color!
        menu.menuBGColor = PageBGColor
        
        let arr:Array<UITabBarItem> = (self.tabBarController?.tabBar.items)!
        
        var i=0
        for (index,item) in arr.enumerate()
        {
            if screenScale == 3.0
            {
                item.image="tarbar\(i)@3x.png".image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                item.selectedImage="tarbar\(i)_selected@3x.png".image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                
                if UMsgCount != nil && index == 4
                {
                    item.image="tarbar\(i)_1@3x.png".image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                    item.selectedImage="tarbar\(i)_selected_1@3x.png".image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                }
            }
            else
            {
                item.image="tarbar\(i)@2x.png".image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                item.selectedImage="tarbar\(i)_selected@2x.png".image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                
                if UMsgCount != nil && index == 4
                {
                    item.image="tarbar\(i)_1@2x.png".image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                    item.selectedImage="tarbar\(i)_selected_1@2x.png".image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                }
            }
            
            
            if i == 0
            {
                item.imageInsets = UIEdgeInsetsMake(4.0, -13.0*screenFlag, -4.0, 13.0*screenFlag)
            }
            else if i == 1
            {
                item.imageInsets = UIEdgeInsetsMake(4.0, -8.0*screenFlag, -4.0, 8.0*screenFlag)
            }
            else if i==2
            {
                item.imageInsets = UIEdgeInsetsMake(4.0, 2.0*screenFlag, -4.0, -2.0*screenFlag)
            }
            else if i == 3
            {
                item.imageInsets = UIEdgeInsetsMake(4.0, 14.0*screenFlag, -4.0, -14.0*screenFlag)
            }
            else
            {
                item.imageInsets = UIEdgeInsetsMake(4.0, 13.0*screenFlag, -4.0, -13.0*screenFlag)
            }
            
            item.setTitleTextAttributes([NSForegroundColorAttributeName:APPBlueColor,NSFontAttributeName:UIFont.systemFontOfSize(16.0)], forState: UIControlState.Selected)
            
            i += 1;
        }
        
        //一屏显示的标题的个数
        
        if(topArr.count > 0)
        {
            menu.menuArr = topArr
        }
        
        NSThread(target: self, selector: #selector(timeThread), object: nil).start()
        
        
        
        if !CheckNet()
        {
            self.view.addSubview(self.noNet)
            
            self.noNet.block =
                {
                    [weak self]
                    (o)->Void in
                    
                    if CheckNet()
                    {
                        for item in self!.topArr
                        {
                            (item.view as! NewsIndexView).httpHandle.reSet()
                            (item.view as! NewsIndexView).httpHandle.handle()
                        }
                        
                       self?.noNet.removeFromSuperview()
                    }
                    else
                    {
                        self?.noNet.connectFail()
                    }
                    
            }
            
            

        }
        
    }
    
    func getCategory()
    {
        let strArr = ["推荐","本地","关注","活动"]
        
        let urlArr =
        [APPURL+"Public/Found/?service=News.getListTJ&page=[page]&perNumber=20",
        APPURL+"Public/Found/?service=News.getList&category_id=97&page=[page]&perNumber=20",
        APPURL+"Public/Found/?service=News.getListGZ&username=\(DataCache.Share.userModel.username)&page=[page]&perNumber=20",
        APPURL+"Public/Found/?service=News.getList&category_id=98&page=[page]&perNumber=20"]
        
        let idArr = ["83","104","103","106"]
        
        var i = 0
        for item in strArr
        {
            let model:XHorizontalMenuModel = XHorizontalMenuModel()
            model.title = item
            
            let table = NewsIndexView()
            table.url = urlArr[i]
            table.bannerID = idArr[i]

            model.view = table
            
            self.topArr.append(model)
            
            i += 1
        }
        
        self.menu.menuArr = self.topArr
        
//        let url=APPURL+"Public/Found/?service=News.getCategory";
//        
//        XHttpPool.requestJson(url, body: nil, method: .GET) { (o) -> Void in
//            
//            if(o == nil)
//            {
//                
//                self.view.addSubview(self.noNet)
//                
//                self.noNet.block =
//                    {
//                        [weak self]
//                        (o)->Void in
//                        
//                        if(self != nil)
//                        {
//                            self!.getCategory()
//                        }
//                        
//                }
//                
//                self.noNet.connectFail()
//                return;
//            }
//            
//            self.noNet.removeFromSuperview()
// 
//            for item in o!["data"]["info"].arrayValue
//            {
//
//                let model:XHorizontalMenuModel = XHorizontalMenuModel()
//                model.title = item["title"].stringValue
//                model.id = item["id"].intValue
//                
//                
//                if(model.id != 42)
//                {
//                    let view:NewsIndexView = "NewsIndexView".View as! NewsIndexView
//                    view.nid = model.id
//                    view.show()
//                    model.view = view
//                    
//                    //model.view=UIView()
//                }
//                else
//                {
//                    let view:PicNewsIndexView = "PicNewsIndexView".View as! PicNewsIndexView
//                    view.nid = model.id
//                    view.show()
//                    model.view = view
//                }
//                
//                
//                self.topArr.append(model)
//            }
//            
//            self.menu.menuArr = self.topArr
//            
//        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        ALBBMANPageHitHelper.getInstance().pageAppear(self)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        ALBBMANPageHitHelper.getInstance().pageDisAppear(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    

   
}
