//
//  PicNewsInfoVC.swift
//  chengshi
//
//  Created by X on 15/11/21.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class PicNewsInfoVC: XViewController,UIScrollViewDelegate,UITextViewDelegate {

    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var button: UIButton!
    
    @IBOutlet var linHeight: NSLayoutConstraint!
    
    @IBOutlet var content: UITextView!
    
    @IBOutlet var ptitle: UILabel!
    
    @IBOutlet var numCount: UILabel!
    
    @IBOutlet var nowIndex: UILabel!
    
    @IBOutlet var contentLabel: UILabel!
    
    var  cacheComment:String=""
    lazy var model:NewsModel = NewsModel()
    lazy var imgArr:Array<String>=[]
    lazy var titleArr:Array<String>=[]
    var json:JSON?
    
    @IBAction func reply(sender: AnyObject) {
        
        if(!self.checkIsLogin())
        {
            return
        }
        
        let view:PostCommentView = "PostCommentView".View as! PostCommentView
        view.contentView.textView.inputAccessoryView = nil
        view.cacheText = cacheComment
        view.navController = self.navigationController as? XNavigationController
        self.navigationController!.view.addSubview(view)
        
        view.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(0.0)
            make.trailing.equalTo(0.0)
            make.top.equalTo(0.0)
            make.bottom.equalTo(0.0)
        }
        
        view.show {[weak self] (txt) -> Void in
            if self==nil {return}
            self?.cacheComment = txt as! String
            
            let url = "http://101.201.169.38/api/Public/Found/?service=Comment.insert"
            let body="did=\(self!.model.id)&username="+DataCache.Share().userModel.username+"&content="+self!.cacheComment
            
            XHttpPool.requestJson(url, body: body, method: .POST, block: {[weak self] (o) -> Void in
                
                if(o?["data"].dictionaryValue.count > 0)
                {
                    if(o!["data"]["code"].intValue == 0)
                    {
                        UIApplication.sharedApplication().keyWindow?.showAlert("评论成功", block: nil)
                        self?.cacheComment=""
                        return
                    }
                    else
                    {
                        UIApplication.sharedApplication().keyWindow?.showAlert(o!["data"]["msg"].stringValue, block: nil)
                        
                        return
                    }
                }
                
                UIApplication.sharedApplication().keyWindow?.showAlert("评论失败", block: nil)
                
            })
        }
        
    }
    
    
    @IBAction func collect(sender: AnyObject) {
        
    }
    
    
    @IBAction func share(sender: AnyObject) {
        
        let url="http://101.201.169.38/city/pic_info.html?id=\(model.id)"
        
        let publishContent : ISSContent = ShareSDK.content(model.title, defaultContent:model.title,image:ShareSDK.imageWithUrl(model.url), title:model.title,url:url,description:model.descrip,mediaType:SSPublishContentMediaTypeNews)
        
        ShareSDK.showShareActionSheet(nil, shareList: XOC.ShareTypeList(), content: publishContent, statusBarTips: true, authOptions: nil, shareOptions: nil, result:
            {(type:ShareType,state:SSResponseState,statusInfo:ISSPlatformShareInfo!,error:ICMErrorInfo!,end:Bool) in
                
                if (state == SSResponseStateSuccess)
                {
                    let alert = UIAlertView(title: "提示", message:"分享成功", delegate:self, cancelButtonTitle: "ok")
                    alert.show()
                }
                else
                {
                    if (state == SSResponseStateFail)
                    {
                        let alert = UIAlertView(title: "提示", message:"您没有安装客户端，无法使用分享功能！", delegate:self, cancelButtonTitle: "ok")
                        alert.show()
                        
                    }
                    
                }
        })
    }
    
    
    
    
    func textViewDidChangeSelection(textView: UITextView) {
        
        
        
    }
    
    func http()
    {
        let url="http://101.201.169.38/api/Public/Found/?service=News.getPicArticle&id=\(model.id)"
        
        XHttpPool.requestJson(url, body: nil, method: .GET) {[weak self] (o) -> Void in
            
            if(self==nil)
            {
                return
            }
            
            if(o?["data"]["info"][0] != nil)
            {
                self?.json = o!["data"]["info"][0]
                
                self?.handle()
            }
            
            
  
        }
        
    }
    
    func handle()
    {
        self.contentLabel.text=json!["description"].stringValue
        self.content.text=json!["description"].stringValue
        
        self.ptitle.text=json!["title"].stringValue
        self.nowIndex.text = "1"
        
        for s in json!["content"].arrayValue
        {
            self.imgArr.append(s["src"].stringValue)
        }
        
        self.numCount.text = "\(imgArr.count)"
        
        var i:Int=0
        for url in imgArr
        {
            let img = UIImageView()
            img.url = url
            img.image = url.image
            let zoomScrollView=MRZoomScrollView(img: img)
            zoomScrollView.frame = CGRect(x: 0, y: 0, width: Int(swidth), height: Int(sheight))
            zoomScrollView.topOffset = -80
            zoomScrollView.tag=70+i
            scrollView.addSubview(zoomScrollView)
            
            zoomScrollView.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(self.scrollView)
                make.height.equalTo(self.scrollView)
                make.centerY.equalTo(self.scrollView)
                make.centerX.equalTo(self.scrollView).offset(swidth*CGFloat(i))
                
            })
            
            i += 1

            
        }
        
        scrollView.contentSize = CGSizeMake(swidth * CGFloat(imgArr.count), 0)
        if(IOS_Version<8.0)
        {
            scrollView.contentInset.right = swidth * CGFloat(imgArr.count)
        }

        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .All
        
        let button=UIButton(type: UIButtonType.Custom)
        button.frame=CGRectMake(10, 2, 25, 25);
        button.setBackgroundImage("back_arrow.png".image, forState: UIControlState.Normal)
        button.showsTouchWhenHighlighted = true
        button.exclusiveTouch = true
        button.addTarget(self, action: Selector("pop"), forControlEvents: UIControlEvents.TouchUpInside)
        let leftItem=UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem=leftItem;
        
        self.backButton=button
        
        (self.navigationController as! XNavigationController).setAlpha(0.0)
        
        self.content.textColor = UIColor.whiteColor()
        self.content.selectable=false
        self.content.contentInset = UIEdgeInsetsMake(-8, 0, 0, 0)
        
        
        self.button.layer.borderColor = UIColor(red: 178.0/255.0, green: 178.0/255.0, blue: 178.0/255.0, alpha: 1.0).CGColor
        self.button.layer.borderWidth = 0.5
        self.button.layer.masksToBounds = true
        self.button.layer.cornerRadius = 5.0
        self.linHeight.constant = 0.0
        contentLabel.preferredMaxLayoutWidth = swidth-20
        
        http()
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        
        if(Int(scrollView.contentOffset.x*100)%Int(swidth*100)==0)
        {
            let nowIndex:Int=Int(Int(scrollView.contentOffset.x*100)/Int(swidth*100));
            
            self.nowIndex.text = "\(nowIndex+1)"
        }
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let ind:Int=Int(scrollView.contentOffset.x/swidth)
        
        for i in 0 ..< self.imgArr.count
        {
            if(i != ind)
            {
                let tempview:MRZoomScrollView=self.scrollView.viewWithTag(70+i) as! MRZoomScrollView
                tempview.setZoomScale(1.0, animated: false)
            }
        }
        
    }
    
    @IBAction func toComment(sender: AnyObject) {
            let vc:NewsCommentVC = "NewsCommentVC".VC as! NewsCommentVC
        
        vc.model = self.model
        
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
        
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
        self.scrollView.delegate = nil
        self.imgArr.removeAll(keepCapacity: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
