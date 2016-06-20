//
//  NewsInfoVC.swift
//  chengshi
//
//  Created by X on 15/10/19.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit
import WebKit

class NewsInfoVC: XViewController {

    var  cacheComment:String=""

    @IBOutlet var num: UILabel!
    
    @IBOutlet var htmlView: HtmlView!
    
    @IBOutlet var button: UIButton!
    
    lazy var model:NewsModel = NewsModel()
    
    @IBOutlet var commentBtn: UIButton!
    
    @IBOutlet var shareBtn: UIButton!
    
    
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

            if self == nil {return}
            
            self?.cacheComment = txt as! String
            
            let url = APPURL+"Public/Found/?service=Comment.insert"
            let body="did=\(self!.model.id)&username="+DataCache.Share().userModel.username+"&content="+self!.cacheComment
            
            XHttpPool.requestJson(url, body: body, method: .POST, block: { [weak self](o) -> Void in
                
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
    
    func share() {
        
        let img = model.url.image
        
        if(img == nil)
        {
            return
        }

        let data = UIImagePNGRepresentation(img!)
        
        let image = ShareSDK.imageWithData(data, fileName: model.url.md5, mimeType: "png")
        
        let publishContent : ISSContent = ShareSDK.content(model.title, defaultContent:model.title,image:image, title:model.title,url:self.url,description:model.title,mediaType:SSPublishContentMediaTypeNews)
        
        
        ShareSDKCustomUI.Share.pushVC = self
        ShareSDKCustomUI.Share.shareContent = publishContent
        UIApplication.sharedApplication().keyWindow?.addSubview(ShareSDKCustomUI.Share)
 
    }
    
    var url:String = ""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func http()
    {
        self.cbutton?.hidden = true
        
        let url=APPURL+"Public/Found/?service=News.getArticle&id=\(model.id)"
        
        XHttpPool.requestJson(url, body: nil, method: .GET) { [weak self](o) -> Void in
            
            
            if(o?["data"]["info"][0].dictionaryValue.count > 0)
            {
                self?.model.comment = o!["data"]["info"][0]["comment"].stringValue
                
                self?.num.text = "\(self!.model.comment)"
                
            }
            
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        button.layer.cornerRadius = button.frame.size.height/2.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBackButton()
        self.title = "怀府新闻"
        
        commentBtn.click { [weak self](btn) in
            
            self?.toComment()
        }
        
        shareBtn.click { [weak self](btn) in
            
            self?.share()
        }
        
        if(DataCache.Share().newsCollect.dict[model.id] == true)
        {
            self.cbutton.selected = true
        }
        
        self.button.layer.borderColor = UIColor(red: 178.0/255.0, green: 178.0/255.0, blue: 178.0/255.0, alpha: 1.0).CGColor
        self.button.layer.borderWidth = 0.5
        self.button.layer.masksToBounds = true
        
        self.url="http://101.201.169.38/city/news_info.php?id=\(model.id)&type=1"

        htmlView.url = self.url
        htmlView.show()
        
        htmlView.block =
            {
                [weak self]
                (o)->Void in
                
                if(o is Dictionary<String,AnyObject>)
                {
                    let dic:Dictionary<String,AnyObject> = o as! Dictionary<String,AnyObject>
                    
                    if(dic["index"] != nil)
                    {
                        let vc:FriendDelPicVC = "FriendDelPicVC".VC("Friend") as! FriendDelPicVC
                        vc.canDel = false
                        vc.showBack = false
                        vc.nowIndex = (dic["index"] as! Int)+1
                        vc.imgArr = dic["list"] as! Array<String>
                        vc.hidesBottomBarWhenPushed = true
                        
                        let nv:XNavigationController = XNavigationController(rootViewController: vc)
                        
                        self?.jumpAnimType = .Alpha
                        self?.presentViewController(nv, animated: true, completion: { () -> Void in
                            
                        })
                    }
 
                }
                
                
        }
        
    
    }
    
    
    func toComment()
    {
        let vc:NewsCommentVC = "NewsCommentVC".VC as! NewsCommentVC
        
        vc.model = self.model
        
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    
    @IBOutlet var cbutton: UIButton!
    
    
    @IBAction func doCollect(sender: UIButton) {
        
        if(!checkIsLogin())
        {
            return
        }
        
        sender.selected = !sender.selected
        sender.bounceAnimation(0.8, delegate: nil)
        
        var url=""
        var body=""
        if(sender.selected)
        {
            url=APPURL+"Public/Found/?service=News.collectAdd"
            body="did="+model.id+"&username="+DataCache.Share().userModel.username
            DataCache.Share().newsCollect.dict[model.id] = true
            
        }
        else
        {
            url=APPURL+"Public/Found/?service=News.collectDel"
            body="id="+model.id+"&username="+DataCache.Share().userModel.username
            
            DataCache.Share().newsCollect.dict.removeValueForKey(model.id)
        }
        
        DataCache.Share().newsCollect.save()
        
        XHttpPool.requestJson(url, body: body, method: .POST) { (o) -> Void in

        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    deinit
    {
        //print(NSStringFromClass(self.dynamicType)+" "+__FUNCTION__+" !!!!!!!!!")
    }

}
