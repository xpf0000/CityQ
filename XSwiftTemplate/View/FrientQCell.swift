//
//  FrientQCell.swift
//  chengshi
//
//  Created by X on 15/11/24.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class FrientQCell: UITableViewCell {

    var typeEnable=true
    
    @IBOutlet var showAllButton: UIButton!
    
    
    @IBOutlet var headPic: UIImageView!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var time: UILabel!
    
    @IBOutlet var typeButton: UIButton!
    
    @IBOutlet var content: UILabel!
    
   // @IBOutlet var replyNum: UILabel!
    
    //@IBOutlet var likeNum: UILabel!

    @IBOutlet var bottomLine: UIView!
    
    @IBOutlet var replyView: FriendReplyView!
    
    @IBOutlet var replyH: NSLayoutConstraint!
    
    @IBOutlet var picsView: UIView!
    
    @IBOutlet var picsH: NSLayoutConstraint!
    
    @IBOutlet var picsW: NSLayoutConstraint!
    
    @IBOutlet var zanButton: UIButton!
    
    @IBOutlet var sexIcon: UIImageView!
    
    @IBOutlet var showButtonH: NSLayoutConstraint!
    
    
    var baseW=swidth-62
    
    var model:FriendModel = FriendModel()
        {
            didSet
            {
                show()
        }
    }
    
    lazy var replyCellHs:Array<CGFloat> = []
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        if(newSuperview == nil)
        {
            
        }
        
    }
    
    
    @IBAction func showAll(sender: UIButton) {
        
        sender.selected = !sender.selected
        
        NSNotificationCenter.defaultCenter().postNotificationName(NoticeWord.UpDateFriendCell.rawValue,
            object: nil,
            userInfo: ["id": self.model.id,"all" : sender.selected])
        
    }
    
    
    func delSelfComment(cmodel:FriendCommentModel) {
        
        let delU=APPURL+"Public/Found/?service=Quan.commentDel&id="+cmodel.id+"&username="+DataCache.Share.userModel.username
        
        XHttpPool.requestJson(delU, body: nil, method: .POST, block: {[weak self] (o) -> Void in
            
            XDeleteAlert.Share().removeFromSuperview()
            
            if(o?["data"]["code"] != nil)
            {
                if(o!["data"]["code"].intValue == 0 && self != nil)
                {
                    NSNotificationCenter.defaultCenter().postNotificationName(NoticeWord.UpDateFriendCell.rawValue,
                        object: nil,
                        userInfo: ["id": self!.model.id,"zan" : false])
                }
                else
                {
                    UIApplication.sharedApplication().keyWindow?.showAlert(o!["data"]["msg"].stringValue, block: nil)
                }
                
                return
                
            }
            
            UIApplication.sharedApplication().keyWindow?.showAlert("删除失败", block: nil)
            
        })
        
    }
    
    private func show() {

        if(model.id.numberValue.intValue == 0)
        {
            return
        }
        
        self.typeButton.hidden = !self.typeEnable
        
        //self.picsView.picCollection.removeAllSubViews()
        
        self.replyView.replyOtherBlock =
            {
                [weak self]
                (m)->Void in
               
                let cmodel:FriendCommentModel = m as! FriendCommentModel
                
                if(self == nil)
                {
                    return
                }
                
                if(!self!.viewController!.checkIsLogin())
                {
                    return
                }
                
                if(cmodel.uid == DataCache.Share.userModel.uid)
                {
                    self!.viewController!.navigationController?.view.window?.addSubview(XDeleteAlert.Share())
                    
                    XDeleteAlert.Share().block =
                        {
                            [weak self]
                            (o)->Void in
                            
                            if(self == nil)
                            {
                                return
                            }
                            
                            
                            self!.delSelfComment(cmodel)
                            
                    }
                    
                    return
                }
                
                let view:PostCommentView = "PostCommentView".View as! PostCommentView
                view.contentView.textView.placeHolder("回复"+cmodel.nickname+":")
                view.contentView.textView.inputAccessoryView = nil
                view.contentView.ptitle.text=""
                view.blurRadius = 0.0;
                view.iterations = 0;
                view.navController = self!.viewController!.navigationController as? XNavigationController
                self!.viewController!.navigationController?.view.addSubview(view)
                
                view.snp_makeConstraints { (make) -> Void in
                    make.leading.equalTo(0.0)
                    make.trailing.equalTo(0.0)
                    make.top.equalTo(0.0)
                    make.bottom.equalTo(0.0)
                }
                
                view.show {[weak self] (txt) -> Void in
                    
                    let url=APPURL+"Public/Found/?service=Quan.addComment"
                    let body="did="+self!.model.id+"&username="+DataCache.Share.userModel.username+"&content="+(txt as! String)+"&tuid="+cmodel.uid+"&dpic="+self!.model.picList[0].url+"&type=1"
                    
                    XHttpPool.requestJson(url, body: body, method: .POST, block: {[weak self] (o) -> Void in
                        
                        if(o?["data"]["code"].intValue == 0 && self != nil)
                        {
                            NSNotificationCenter.defaultCenter().postNotificationName(NoticeWord.UpDateFriendCell.rawValue,
                                object: nil,
                                userInfo: ["id": self!.model.id,"zan" : false])
                            
                            return
                        }
                        
                        UIApplication.sharedApplication().keyWindow?.showAlert("评论失败", block: nil)
                        
                    })
                    
                }
                
        }
        
        self.headPic.url = model.headimage
        
        let date=NSDate(timeIntervalSince1970: NSTimeInterval(model.create_time)!)
        
        let gregorian:NSCalendar=NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        
        let unitFlags:NSCalendarUnit = [.NSDayCalendarUnit, .NSYearCalendarUnit, .NSMonthCalendarUnit]
        
        let comps=gregorian.components(unitFlags, fromDate: date)
        let comps1=gregorian.components(unitFlags, fromDate: NSDate())
        
        
        if(comps.year != comps1.year)
        {
            self.time.text = date.str
        }
        else
        {
            if(comps.day == comps1.day && comps.month == comps1.month)
            {
                self.time.text = date.toStr("HH:mm")
            }
            else
            {
                self.time.text = date.toStr("MM-dd HH:mm")
            }
        }
        
        if(model.orzan > 0)
        {
            self.zanButton.setImage("likedIcon.png".image, forState: UIControlState.Normal)
        }
        else
        {
            self.zanButton.setImage("unlikedIcon.png".image, forState: UIControlState.Normal)
        }
        
        if(model.sex == "0")
        {
            self.sexIcon.image = "female_icon.png".image
        }
        else
        {
            self.sexIcon.image = "male_icon.png".image
        }
        
        replyView.zArrs = model.zanList
        replyView.cArrs = model.commentList
        replyH.constant = replyView.show(swidth-62-26-16)
        
        self.name.text = model.nickname
        self.typeButton.setTitle(model.title, forState: .Normal)
        
        
        let attributedString1:NSMutableAttributedString = NSMutableAttributedString(string: model.content)
        let paragraphStyle1:NSMutableParagraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle1.lineSpacing = 2.5

        attributedString1.addAttributes([NSParagraphStyleAttributeName:paragraphStyle1,NSKernAttributeName:0.0], range: NSMakeRange(0, (model.content as NSString).length))
        
        self.showAllButton.selected = model.all
        self.content.numberOfLines = 0
        self.content.attributedText = attributedString1
        self.content.layoutIfNeeded()
        
        if self.content.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height > ContentMaxHeight
        {
            self.showAllButton.enabled = true
            self.showButtonH.constant = 34.0

        }
        else
        {
            self.showAllButton.enabled = false
            self.showButtonH.constant = 10.0

        }
        
        self.content.numberOfLines = model.all ? 0 : 4
        self.content.attributedText = attributedString1
        self.content.layoutIfNeeded()
        
        //self.picsView.picList = model.picList
        //self.picsView.show()
        
        var  lineMax = 1
        var imgw:CGFloat = 1.0
        var imgh:CGFloat = 1.0
        if(model.picList.count >= 3)
        {
            lineMax = 3
            imgw = baseW/3.0
            imgh = imgw
            self.picsH.constant = baseW/3.0*CGFloat(ceil(Double(model.picList.count)/3.0))
            self.picsW.constant = baseW
        }
        else if(model.picList.count == 2)
        {
            imgw = baseW/2.0
            imgh = imgw
            lineMax = 2
            self.picsH.constant = baseW/2.0
            self.picsW.constant = baseW
        }
        else if(model.picList.count == 1)
        {
            let width:CGFloat=model.picList[0].width
            let height:CGFloat = model.picList[0].height
            
            var newW:CGFloat = width
            var newH:CGFloat = height
            
            if(width / height > 3.0)
            {
                newW=baseW
                newH = baseW/3.0
            }
            else if(width / height < 1 / 3)
            {
                newW=baseW/3.0
                newH = baseW
            }
            else
            {
                if(width>height)
                {
                    if(width > baseW)
                    {
                        newW=baseW
                        newH=newW*height/width
                    }
                }
                else if(width<height)
                {
                    if(height > baseW)
                    {
                        newH=baseW
                        newW=newH*width/height
                    }
                }
                else
                {
                    if(width > baseW)
                    {
                        newW=baseW
                        newH=newW*height/width
                    }
                }

            }
            
            self.picsH.constant = newH
            self.picsW.constant = newW
            
            imgw = newW
            imgh = newH
            
        }
        else
        {
            self.picsH.constant = 0.0
            self.picsW.constant = 0.0
        }
        
        self.picsView.removeAllSubViews()
        var x = 0
        for i in 0..<model.picList.count
        {
            let img = UIImageView()
            img.contentMode = .ScaleAspectFill
            img.layer.masksToBounds = true
            img.frame = CGRectMake(2+imgw*CGFloat(x), 2+imgh*CGFloat(Int(i/lineMax)), imgw-4, imgh-4)
            //img.backgroundColor = UIColor.lightGrayColor()
            self.picsView.addSubview(img)
            
            img.isGroup = true
            img.url = model.picList[i].url
            
            //img.sd_setImageWithURL(model.picList[i].url.url!)
            
            x += 1
            
            x = x % lineMax == 0 ? 0 : x
            
        }
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.content.preferredMaxLayoutWidth = swidth-62
        
        self.replyView.likedPeople.preferredMaxLayoutWidth = swidth-62-26-16
        
        self.headPic.contentMode = .ScaleAspectFill
        self.headPic.placeholder = "tx.jpg".image
        self.headPic.layer.cornerRadius = 17.0
        self.headPic.layer.masksToBounds = true
        
        self.typeButton.layer.cornerRadius = 11.0
        self.typeButton.layer.borderColor="#bcbcbc".color?.CGColor
        self.typeButton.layer.borderWidth = 0.5
        self.typeButton.layer.masksToBounds = true
        
        self.zanButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 18.5, bottom: 5, right: 18.5)
        
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    
    @IBAction func reply(sender: AnyObject) {
        
        if(!self.viewController!.checkIsLogin())
        {
            return
        }
        
        let view:PostCommentView = "PostCommentView".View as! PostCommentView
        view.contentView.textView.inputAccessoryView = nil
        view.contentView.ptitle.text=""
        view.blurRadius = 0.0;
        view.iterations = 0;
        view.navController = self.viewController?.navigationController as? XNavigationController
        self.viewController?.navigationController!.view.addSubview(view)
        
        view.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(0.0)
            make.trailing.equalTo(0.0)
            make.top.equalTo(0.0)
            make.bottom.equalTo(0.0)
        }
        
        view.show { (txt) -> Void in
            
            let url=APPURL+"Public/Found/?service=Quan.addComment"
            let body="did="+self.model.id+"&username="+DataCache.Share.userModel.username+"&content="+(txt as! String)+"&tuid="+self.model.uid+"&dpic="+self.model.picList[0].url+"&type=0"
            
            XHttpPool.requestJson(url, body: body, method: .POST, block: {[weak self] (o) -> Void in
                
                if(o?["data"]["code"].intValue == 0 && self != nil)
                {
                    NSNotificationCenter.defaultCenter().postNotificationName(NoticeWord.UpDateFriendCell.rawValue,
                        object: nil,
                        userInfo: ["id": self!.model.id,"zan" : false])
                    return
                }
                
                UIApplication.sharedApplication().keyWindow?.showAlert("评论失败", block: nil)
                
            })
            
        }
        
    }
    
    
    
    @IBAction func addZan(sender: AnyObject) {
        
        if(!self.viewController!.checkIsLogin())
        {
            return
        }
        
        if(self.model.orzan > 0)
        {
            UIApplication.sharedApplication().keyWindow?.showAlert("已赞过", block: nil)
            
            return
        }
        
        let url=APPURL+"Public/Found/?service=Quan.addZan"
        let body="did="+self.model.id+"&username="+DataCache.Share.userModel.username+"&tuid="+self.model.uid+"&dpic="+self.model.picList[0].url
        
        XHttpPool.requestJson(url, body: body, method: .POST, block: {[weak self] (o) -> Void in
            
            if(o == nil)
            {
                
                UIApplication.sharedApplication().keyWindow?.showAlert("点赞失败", block: nil)
                
                return
            }
            
            if(o?["data"]["code"].intValue == 0 && self != nil)
            {
                self!.zanButton.setImage("likedIcon.png".image, forState: UIControlState.Normal)
                self!.zanButton.imageView?.bounceAnimation(0.8, delegate: nil)
                
                NSNotificationCenter.defaultCenter().postNotificationName(NoticeWord.UpDateFriendCell.rawValue,
                    object: nil,
                    userInfo: ["id": self!.model.id,"zan" : true])
                
                return
            }
            else
            {
                UIApplication.sharedApplication().keyWindow?.showAlert("已赞过", block: nil)
            }
            
            
            
        })
        
    }
    
    
    
    @IBAction func toClass(sender: AnyObject) {
        
        let vc:FriendClassListVC = "FriendClassListVC".VC("Friend") as! FriendClassListVC
        
        let cmodel:CategoryModel = CategoryModel()
        cmodel.id = model.category_id
        cmodel.title = model.title
        vc.classModel = cmodel
        
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func share(sender: AnyObject) {
        
        let img = model.picList[0].url.image
        
        if(img == nil)
        {
            return
        }

        let url=WapUrl+"/city/city_info.html?id=\(model.id)"

        let data = img!.data(0.01)
        
        let nimg = UIImage(data: data!)
        
        let image = SSDKImage.init(image: nimg, format: SSDKImageFormatJpeg, settings: nil)
        
        
        let dic = NSMutableDictionary()
        
        dic.SSDKSetupShareParamsByText(model.content, images: image, url: url.url, title: model.content, type: SSDKContentType.Auto)
        
        ShareSDKCustomUI.Share.pushVC = self.viewController
        ShareSDKCustomUI.Share.shareContent = dic
        UIApplication.sharedApplication().keyWindow?.addSubview(ShareSDKCustomUI.Share)
        
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        //self.bottomLine.removeObserver(self, forKeyPath: "center")
    }
    
}
