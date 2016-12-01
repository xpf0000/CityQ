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
    
    let msgbtn = UIButton(type: UIButtonType.Custom)

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)

        let view = UIView()
        view.frame = CGRectMake(0, 0, 64, 30)
        
        let button=UIButton(type: UIButtonType.Custom)
   
        button.frame=CGRectMake(10, 5, 20, 20);
        button.setBackgroundImage("search@3x.png".image, forState: UIControlState.Normal)
        button.showsTouchWhenHighlighted = true
        button.exclusiveTouch = true
        view.addSubview(button)
        
        msgbtn.frame=CGRectMake(40, 3, 24, 24);
        msgbtn.setBackgroundImage("home_message.png".image, forState: UIControlState.Normal)
        msgbtn.setBackgroundImage("home_message_1.png".image, forState: UIControlState.Selected)
        msgbtn.showsTouchWhenHighlighted = true
        msgbtn.exclusiveTouch = true
        view.addSubview(msgbtn)
        
        let rightItem=UIBarButtonItem(customView: view)
        self.navigationItem.rightBarButtonItem=rightItem;
        
        button.click { [weak self](btn) in
            
            self?.toSearch()
        }
        
        msgbtn.click { [weak self](btn) in
            
            if(self?.checkIsLogin() == false)
            {
                return;
            }
            
            let vc = "MyMessageVC".VC("User")
            
            vc.hidesBottomBarWhenPushed = true
            
            self?.navigationController?.pushViewController(vc, animated: true)
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
        msgbtn.selected = UMsgCount != nil
        
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
    
    
    func showAccountLogout()
    {
        //DataCache.Share.userMsg = UserMsgModel()
//        UIApplication.sharedApplication().keyWindow?.removeAllSubViews()
        
        for item in UIApplication.sharedApplication().keyWindow!.subviews
        {
            if "\(item)".has("<UILayoutContainerView:")
            {
                
            }
            else
            {
                item.removeFromSuperview()
            }
            print("view: \(item)")
        }
        
        
        DataCache.Share.userModel.unRegistNotice()
        DataCache.Share.userModel.reSet()
        msgCountChange()
        
        let alert = UIAlertView(title: "提醒", message: "您的账户已在其他设备登录", delegate: nil, cancelButtonTitle: "确定")
        
        alert.show()
    }

    func doQD(sender:UIButton)
    {
        if(!self.checkIsLogin())
        {
            return
        }
        
        if DataCache.Share.userModel.orqd == 1
        {
            let vc = HtmlVC()
            
            vc.baseUrl = TmpDirURL
            
            if let u = TmpDirURL?.URLByAppendingPathComponent("index.html")
            {
                vc.url = "\(u)?uid=\(Uid)&uname=\(Uname)"
            }
            
            vc.hidesBottomBarWhenPushed = true
            vc.title = "每日签到"
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            return
        }
        
        sender.enabled = false
        
        let url = APPURL + "Public/Found/?service=jifen.addQiandao&uid=\(Uid)&username=\(Uname)"
        
        XHttpPool.requestJson(url, body: nil, method: .POST) { (o) in
            
            if o?["data"]["code"].int == 0
            {
                XAlertView.show("签到成功,获得1怀府币", block: nil)
                DataCache.Share.userModel.orqd = 1
            }
            else
            {
                var msg = o?["data"]["msg"].stringValue
                msg = msg == "" ? "签到失败" : msg
                XAlertView.show(msg!, block: nil)
            }
            
            sender.enabled = true
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BackToRootViewController), name: "AccountLogout", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(msgCountChange), name: NoticeWord.MsgChange.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(msgCountChange), name: NoticeWord.LoginSuccess.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(msgCountChange), name: NoticeWord.LogoutSuccess.rawValue, object: nil)
        
        let button=UIButton(type: UIButtonType.Custom)
        button.frame=CGRectMake(0, 0, 50, 24);
        button.setTitle("签到", forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        button.showsTouchWhenHighlighted = true
        button.exclusiveTouch = true
        button.addTarget(self, action: #selector(doQD(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let leftItem=UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem=leftItem;
        
        self.backButton=button

        
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

        showBannerImage()

        menu.menuMaxScale = 1.0
        menu.menuPageNum = 4
        menu.menuTextColor = "666666".color!
        menu.menuSelectColor = APPBlueColor
        menu.line.backgroundColor = APPBlueColor
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
                item.imageInsets = UIEdgeInsetsMake(6.0, -13.0*screenFlag, -6.0, 13.0*screenFlag)
            }
            else if i == 1
            {
                item.imageInsets = UIEdgeInsetsMake(6.0, -8.0*screenFlag, -6.0, 8.0*screenFlag)
            }
            else if i==2
            {
                item.imageInsets = UIEdgeInsetsMake(6.0, 2.0*screenFlag, -6.0, -2.0*screenFlag)
            }
            else if i == 3
            {
                item.imageInsets = UIEdgeInsetsMake(6.0, 14.0*screenFlag, -6.0, -14.0*screenFlag)
            }
            else
            {
                item.imageInsets = UIEdgeInsetsMake(6.0, 13.0*screenFlag, -6.0, -13.0*screenFlag)
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
        
        msgbtn.selected = UMsgCount != nil
        
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
    
    
    func BackToRootViewController()
    {
        MainDo { (nil) in
            
            var vc = self.tabBarController?.selectedViewController
            
            if(vc is UINavigationController)
            {
                vc = (vc as! UINavigationController).visibleViewController
            }
            else
            {
                vc = vc?.navigationController?.visibleViewController
            }
            
            if(vc == nil)
            {
                return
            }
            
            print("vc: \(vc)")
            print("vc!.presentingViewController: \(vc!.presentingViewController)")
            
            let home = (self.tabBarController?.selectedViewController as? UINavigationController)?.viewControllers[0]
            
            if(vc == home)
            {
                self.tabBarController?.selectedIndex = 0
                self.showAccountLogout()
                return
            }
            
            if(vc!.presentingViewController != nil)
            {
                vc!.dismissViewControllerAnimated(false, completion: { () -> Void in
                    
                    self.BackToRootViewController()
                    
                })
            }
            else
            {
                vc?.navigationController?.popToRootViewControllerAnimated(false)
                self.BackToRootViewController()
            }
            
        }
        
    }

    
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    

   
}
