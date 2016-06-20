//
//  FriendInfoVC.swift
//  chengshi
//
//  Created by X on 15/11/25.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class FriendInfoVC: XViewController,UIScrollViewDelegate,XDeleteDelegate,UITableViewDelegate,UITableViewDataSource {

    var typeEnable=true
    
    @IBOutlet var topLine: UIView!
    
    @IBOutlet var topLineH: NSLayoutConstraint!
    
    @IBOutlet var typeButton: UIButton!
    
    @IBOutlet var seeNum: UILabel!
    
    @IBOutlet var headPic: UIImageView!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var sexIcon: UIImageView!
    
    @IBOutlet var time: UILabel!
    
    @IBOutlet var content: UILabel!
    
    @IBOutlet var postion: UILabel!
    
    @IBOutlet var bottomLine: UIView!
    
    @IBOutlet var contentH: NSLayoutConstraint!
    
    @IBOutlet var picsView: FriendPicView!
    
    @IBOutlet var picsH: NSLayoutConstraint!
    
    //@IBOutlet var replyView: FriendReplyView!
    
    //@IBOutlet var replyH: NSLayoutConstraint!
    
    @IBOutlet var picsW: NSLayoutConstraint!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var replyNum: UILabel!
    
    @IBOutlet var bline: UIView!
    
    @IBOutlet var blineW: NSLayoutConstraint!
    
    @IBOutlet var zanIcon: UIImageView!

    @IBOutlet var zanLabel: UILabel!
    
    @IBOutlet var zanH: NSLayoutConstraint!
    
    @IBOutlet var zanPeople: UILabel!
    
    @IBOutlet var ctable: UITableView!
    
    @IBOutlet var commentH: NSLayoutConstraint!
    
    @IBOutlet var zanView: UIView!
    
    lazy var cheight:Dictionary<Int,CGFloat> = [:]
    lazy var carr:Array<FriendCommentModel> = []
    lazy var zarr:Array<FriendZanModel> = []
    
    var cellBlock:AnyBlock?
    
    var cmodel:FriendCommentModel?
    
    var commentHandle:XHttpHandle=XHttpHandle()
    var zanHandle:XHttpHandle=XHttpHandle()
    
    lazy var fmodel:FriendModel=FriendModel()
    var baseW=swidth-24
    
    var commentCell:FriendInfoCommentCell?
    
    var needRefresh=false
    
    func http()
    {
        let url=APPURL+"Public/Found/?service=Quan.getArticle&id=\(fmodel.id)&uid="+DataCache.Share().userModel.uid
        
        XHttpPool.requestJson(url, body: nil, method: .GET) { (o) -> Void in
            if(o?["data"].dictionaryValue.count > 0)
            {
                self.fmodel=FriendModel.parse(json: o!["data"]["info"][0], replace: nil)
            }
            
            self.show()
            
        }
    
        
    }
    
    func toType()
    {
        if(self.fmodel.category_id != "")
        {
            let vc:FriendClassListVC = "FriendClassListVC".VC("Friend") as! FriendClassListVC
            
            let c:CategoryModel = CategoryModel()
            c.id = fmodel.category_id
            c.title = fmodel.title
            vc.classModel = c
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        self.typeButton.enabled = self.typeEnable
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FriendInfoVC.http), name: NoticeWord.LoginSuccess.rawValue, object: nil)
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FriendInfoVC.upDate(_:)), name: NoticeWord.UpDateFriendCell.rawValue, object: nil)
        
        self.zanView.layer.masksToBounds = true
        self.ctable.layer.masksToBounds = true
        self.zanView.layer.cornerRadius = 5.0
        self.ctable.layer.cornerRadius = 5.0
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        self.ctable.tableFooterView=view1
        self.ctable.tableHeaderView=view1
        
        self.ctable.separatorInset=UIEdgeInsetsZero
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                self.ctable.layoutMargins=UIEdgeInsetsZero
            } else {
                // Fallback on earlier versions
            }
        }

        
        self.ctable.registerNib("FriendInfoCommentCell".Nib, forCellReuseIdentifier: "FriendInfoCommentCell")
        
        commentCell = ctable.dequeueReusableCellWithIdentifier("FriendInfoCommentCell") as? FriendInfoCommentCell
        
        self.bline.backgroundColor = self.ctable.separatorColor
        self.blineW.constant = 0.4
        
        self.typeButton.exclusiveTouch = true
        self.typeButton.addTarget(self, action: #selector(FriendInfoVC.toType), forControlEvents: .TouchUpInside)
        
        self.topLineH.constant = 0.34
        self.topLine.backgroundColor = self.ctable.separatorColor

        self.picsView.baseW = swidth-24
        
        self.bottomLine.addObserver(self, forKeyPath: "center", options: .New, context: nil)
        
        self.content.preferredMaxLayoutWidth = swidth-24
        self.zanPeople.preferredMaxLayoutWidth = swidth-70
        //self.replyView.likedPeople.preferredMaxLayoutWidth = swidth-24-30-16
        self.headPic.placeholder = "tx.jpg".image
        self.headPic.layer.cornerRadius = 17.0
        self.headPic.layer.masksToBounds = true
        
        self.typeButton.layer.cornerRadius = 11.0
        self.typeButton.layer.borderColor="#bcbcbc".color?.CGColor
        self.typeButton.layer.borderWidth = 0.5
        self.typeButton.layer.masksToBounds = true
        
        commentHandle.url=APPURL+"Public/Found/?service=Quan.getComment&id=\(fmodel.id)&page=[page]&perNumber=20"
        commentHandle.pageStr="[page]"
        commentHandle.replace=nil
        commentHandle.keys=["data","info"]
        commentHandle.modelClass=FriendCommentModel.self
        commentHandle.scrollView = self.scrollView
        
        commentHandle.BeforeBlock { [weak self]
            (o)->Void in
            
            if(self != nil)
            {
                self!.carr = self!.commentHandle.listArr as! Array<FriendCommentModel>
                self?.replyNum.text = "\(self!.carr.count)"
                self!.showComment()
            }
            
        }
        
        commentHandle.handle()
        
        zanHandle.url=APPURL+"Public/Found/?service=Quan.getZan&id=\(fmodel.id)&page=[page]&perNumber=20"
        zanHandle.pageStr="[page]"
        zanHandle.replace=nil
        zanHandle.keys=["data","info"]
        zanHandle.modelClass=FriendZanModel.self
        zanHandle.scrollView = self.scrollView
        zanHandle.BeforeBlock {
            [weak self]
            (o)->Void in
            if(self != nil)
            {
                self!.zarr = self!.zanHandle.listArr as! Array<FriendZanModel>
                
                if(self!.fmodel.orzan > 0)
                {
                    self?.zanLabel.text = "\(self!.zarr.count)"
                }
                
                self!.showZan()
            }
        }
        zanHandle.handle()
        
        self.scrollView.setFooterRefresh {[weak self] () -> Void in
            self?.commentHandle.handle()
            self?.zanHandle.handle()
        }
        self.scrollView.hideFootRefresh()
        
        self.http()
        
    }
    
    
    func upDate(notice:NSNotification)
    {
        let info=notice.userInfo
        let id:String? = info?["id"] as? String
        
        if(id == self.fmodel.id)
        {
            let zan:Bool = info!["zan"] as! Bool
            
            if(zan)
            {
                self.fmodel.orzan = 1
                self.zanHandle.reSet()
                self.zanHandle.handle()
            }
            else
            {
                self.commentHandle.reSet()
                self.commentHandle.handle()
            }
            
            
        }
        
    }
    
    
    func replyOther(m:FriendCommentModel)
    {
        if(!self.checkIsLogin())
        {
            return
        }

        if(m.uid == DataCache.Share().userModel.uid)
        {
            self.navigationController?.view.window?.addSubview(XDeleteAlert.Share())
            
            XDeleteAlert.Share().block =
                {
                    [weak self]
                    (o)->Void in
                    
                    let delU=APPURL+"Public/Found/?service=Quan.commentDel&id="+m.id+"&username="+DataCache.Share().userModel.username
                    
                    XHttpPool.requestJson(delU, body: nil, method: .POST, block: {[weak self] (o) -> Void in
                        
                        XDeleteAlert.Share().removeFromSuperview()
                        
                        if(o?["data"]["code"] != nil)
                        {
                            if(o!["data"]["code"].intValue == 0 && self != nil)
                            {
                                NSNotificationCenter.defaultCenter().postNotificationName(NoticeWord.UpDateFriendCell.rawValue,
                                    object: nil,
                                    userInfo: ["id": self!.fmodel.id,"zan" : false])
                                
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
            
            return
        }
        
        let view:PostCommentView = "PostCommentView".View as! PostCommentView
        view.contentView.textView.placeHolder("回复"+m.nickname+":")
        view.contentView.textView.inputAccessoryView = nil
        view.contentView.ptitle.text=""
        view.blurRadius = 0.0;
        view.iterations = 0;
        view.navController = self.navigationController as? XNavigationController
        self.navigationController?.view.addSubview(view)
        
        view.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(0.0)
            make.trailing.equalTo(0.0)
            make.top.equalTo(0.0)
            make.bottom.equalTo(0.0)
        }
        
        view.show { (txt) -> Void in
            
            let url=APPURL+"Public/Found/?service=Quan.addComment"
            let body="did="+self.fmodel.id+"&username="+DataCache.Share().userModel.username+"&content="+(txt as! String)+"&tuid="+m.uid+"&dpic="+self.fmodel.picList[0].url+"&type=1"
            
            XHttpPool.requestJson(url, body: body, method: .POST, block: {[weak self] (o) -> Void in
                
                if(o?["data"]["code"].intValue == 0 && self != nil)
                {
                    NSNotificationCenter.defaultCenter().postNotificationName(NoticeWord.UpDateFriendCell.rawValue,
                        object: nil,
                        userInfo: ["id": self!.fmodel.id,"zan" : false])
                    
                    return
                }
                
                UIApplication.sharedApplication().keyWindow?.showAlert("评论失败", block: nil)
                
            })
            
        }

    }
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        if(zanPeople.frame.size.height > 0)
        {
            zanH.constant = zanPeople.frame.size.height + 20
        }
        
    }
    
    func showZan()
    {
        if(self.zarr.count == 0)
        {
            self.zanH.constant = 0
        }
        else
        {
            var likep=""
            var i=0
            for s in self.zarr
            {
                if(i == self.zarr.count-1)
                {
                    likep += s.nickname
                }
                else
                {
                    likep += s.nickname+","
                }
                
                i += 1
            }
            
            likep += "等\(self.zarr.count)人".trim()
            
            let rang=(likep as NSString).rangeOfString("\(self.zarr.count)", options: NSStringCompareOptions.BackwardsSearch)
            
            let attributedString1 = NSMutableAttributedString(string: likep)
            let paragraphStyle1:NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle1.lineSpacing = 5.0
            
            attributedString1.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle1, range: NSMakeRange(0, likep.length()))
            attributedString1.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: rang)
            
            zanPeople.attributedText = attributedString1
            zanPeople.layoutIfNeeded()

        }
        
    }
    
    func showComment()
    {
        var i=0
        var count:CGFloat = 0
        for item in self.carr
        {
            commentCell?.model = item
            commentCell?.setComment()
            let size = commentCell?.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
            
            cheight[i] = size!.height+1
            count += size!.height+1
            i += 1
        }
        
        commentH.constant = count
        
        self.ctable.reloadData()
    }
    
    
    func show() {
        
        if(fmodel.id.numberValue.intValue == 0)
        {
            return
        }
        self.postion.text = fmodel.location
        self.headPic.url = fmodel.headimage
        
        let date=NSDate(timeIntervalSince1970: NSTimeInterval(fmodel.create_time)!)
        
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
        
        if(fmodel.orzan > 0)
        {
            self.zanIcon.image = "likedIcon.png".image
            self.zanLabel.text = "\(fmodel.zanList.count)"
        }
        else
        {
            self.zanIcon.image = "info_unlike.png".image
            self.zanLabel.text = "赞一下"
        }
        
        if(fmodel.sex == "0")
        {
            self.sexIcon.image = "female_icon.png".image
        }
        else
        {
            self.sexIcon.image = "male_icon.png".image
        }
        
        self.replyNum.text = fmodel.comment
        self.seeNum.text = fmodel.view
        self.name.text = fmodel.nickname
        self.typeButton.setTitle(fmodel.title, forState: .Normal)
        self.content.text = fmodel.content
        
        self.picsView.picList = fmodel.picList
        self.picsView.show()
        
        if(fmodel.picList.count >= 3)
        {
            self.picsH.constant = baseW/3.0*CGFloat(ceil(Double(fmodel.picList.count)/3.0))
            self.picsW.constant = baseW
        }
        else if(fmodel.picList.count == 2)
        {
            self.picsH.constant = baseW/2.0
            self.picsW.constant = baseW
        }
        else if(fmodel.picList.count == 1)
        {
            let width:CGFloat=fmodel.picList[0].width
            let height:CGFloat = fmodel.picList[0].height
            
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
        }
        else
        {
            self.picsH.constant = 0.0
            self.picsW.constant = 0.0
        }
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if(keyPath == "center")
        {
            contentH.constant = bottomLine.center.y+20
            self.scrollView.contentSize.width = swidth
            self.scrollView.contentSize.height = bottomLine.center.y+20
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    
    @IBAction func reply(sender: AnyObject) {
        
        if(!self.checkIsLogin())
        {
            return
        }
        
        let view:PostCommentView = "PostCommentView".View as! PostCommentView
        view.contentView.textView.inputAccessoryView = nil
        view.contentView.ptitle.text=""
        view.blurRadius = 0.0;
        view.iterations = 0;
        view.navController = self.navigationController as? XNavigationController
        self.navigationController?.view.addSubview(view)
        
        view.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(0.0)
            make.trailing.equalTo(0.0)
            make.top.equalTo(0.0)
            make.bottom.equalTo(0.0)
        }
        
        view.show { (txt) -> Void in
            
            let url=APPURL+"Public/Found/?service=Quan.addComment"
            let body="did="+self.fmodel.id+"&username="+DataCache.Share().userModel.username+"&content="+(txt as! String)+"&tuid="+self.fmodel.uid+"&dpic="+self.fmodel.picList[0].url+"&type=0"
            
            XHttpPool.requestJson(url, body: body, method: .POST, block: {[weak self] (o) -> Void in
                
                if(o?["data"]["code"].intValue == 0 && self != nil)
                {
                    NSNotificationCenter.defaultCenter().postNotificationName(NoticeWord.UpDateFriendCell.rawValue,
                        object: nil,
                        userInfo: ["id": self!.fmodel.id,"zan" : false])
                    
                    return
                }
                
                UIApplication.sharedApplication().keyWindow?.showAlert("评论失败", block: nil)
                
            })
            
        }
    }
    
    
    @IBAction func zan(sender: UIButton) {
        
        if(!self.checkIsLogin())
        {
            return
        }
        
        if(self.fmodel.orzan > 0)
        {
            return
        }
        
        sender.enabled = false
        
        self.zanIcon.image = "likedIcon.png".image
        self.zanIcon.bounceAnimation(0.5, delegate: nil)
        
        let url=APPURL+"Public/Found/?service=Quan.addZan"
        let body="did="+self.fmodel.id+"&username="+DataCache.Share().userModel.username+"&tuid="+self.fmodel.uid+"&dpic="+self.fmodel.picList[0].url
        
        XHttpPool.requestJson(url, body: body, method: .POST, block: { [weak self](o) -> Void in
            
            if(o == nil)
            {
                UIApplication.sharedApplication().keyWindow?.showAlert("点赞失败", block: nil)
                sender.enabled = true
                return
            }
            
            if(o?["data"]["code"].intValue == 0 && self != nil)
            {
                NSNotificationCenter.defaultCenter().postNotificationName(NoticeWord.UpDateFriendCell.rawValue,
                    object: nil,
                    userInfo: ["id": self!.fmodel.id,"zan" : true])
                
                return
            }
            else
            {
                UIApplication.sharedApplication().keyWindow?.showAlert("已赞过", block: nil)
            }
            
            
        })
        
        
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.separatorInset=UIEdgeInsetsZero
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                cell.layoutMargins=UIEdgeInsetsZero
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return carr.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return cheight[indexPath.row]!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:FriendInfoCommentCell = tableView.dequeueReusableCellWithIdentifier("FriendInfoCommentCell", forIndexPath: indexPath) as! FriendInfoCommentCell
        
        cell.model = self.carr[indexPath.row]
        cell.show()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.replyOther(self.carr[indexPath.row])
        
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.cmodel = nil
        self.bottomLine.removeObserver(self, forKeyPath: "center")
    }
    

   
}
