//
//  FrientVC.swift
//  chengshi
//
//  Created by X on 15/11/24.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class FrientVC: XViewController ,UITableViewDelegate,UITableViewDataSource,commonDelegate{

    @IBOutlet var table: UITableView!
    var httpHandle:XHttpHandle=XHttpHandle()
    lazy var heightArr:Dictionary<Int,CGFloat>=[:]
    var baseW=swidth-62
    lazy var bannerArr:Array<XBannerModel> = []
    lazy var topModel:FriendTopModel = FriendTopModel()
    var banner:XBanner = XBanner(frame: CGRectMake(0, 0, swidth, swidth / 16.0 * 6.0))
    var xiaoquid = "0"
        {
            didSet
            {
                httpHandle.url="http://101.201.169.38/api/Public/Found/?service=Quan.getListAll&page=[page]&perNumber=20&uid="+DataCache.Share().userModel.uid+"&xiaoquid="+xiaoquid
                httpHandle.reSet()
                httpHandle.handle()
            }
        }
    //var tempCell:FrientQCell!

    func getBanner()
    {
        self.bannerArr.removeAll(keepCapacity: false)
        
        let url="http://101.201.169.38/api/Public/Found/?service=News.getGuanggao&typeid=84"
        
        XHttpPool.requestJson(url, body: nil, method: .GET) { (o) -> Void in
            
            if(o == nil)
            {
                
                
                return
            }
            
            for item in o!["data"]["info"].arrayValue
            {
                let model:XBannerModel=XBannerModel()
                model.obj = item["url"].stringValue
                model.url =  item["picurl"].stringValue
                self.bannerArr.append(model)
                
            }
            
            self.banner.arr = self.bannerArr
            self.table.beginUpdates()
            self.table.endUpdates()
            
        }
    }

    
    func refresh(notification: NSNotification)
    {
        if(notification.userInfo == nil)
        {
            self.table.beginHeaderRefresh()
        }
        else
        {
            var hArr:Dictionary<Int,CGFloat>=[:]
            let id = notification.userInfo!["id"] as? String
            if(id != nil)
            {
                var i=0
                var n = -1
                
                for item in self.httpHandle.listArr
                {
                    if((item as! FriendModel).id == id!)
                    {
                        n=i
                    }
                    
                    if(n<0)
                    {
                        hArr[i] = self.heightArr[i]
                    }
                    else if(n == i)
                    {
                        
                    }
                    else
                    {
                        hArr[i-1] = self.heightArr[i]
                        
                    }
                    
                    i += 1
                }
                
                if(n>=0)
                {
                    self.httpHandle.listArr.removeAtIndex(n)
                    self.heightArr=hArr

                    self.table.reloadData()
         
                }
            }
        }
        
    }
    
    func getTop()
    {
        self.topModel.reSet()
        
        let url="http://101.201.169.38/api/Public/Found/?service=Quan.getNewsTop&username="+DataCache.Share().userModel.username
        
        XHttpPool.requestJson(url, body: nil, method: .GET) { (o) -> Void in
            
            if(o?["data"]["info"] != nil)
            {
                let count = o!["data"]["info"]["count"].stringValue
                if(count != self.topModel.count)
                {
                    self.topModel.top = o!["data"]["info"]["top"].stringValue
                    self.topModel.count = count
                }
                
            }
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if(keyPath == "count")
        {
            self.table.beginUpdates()
            self.table.endUpdates()
        }
    }
    
    var times=0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.banner.hiddenTitle = true
        self.banner.page.removeConstraints(self.banner.page.constraints)
        self.banner.page.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(-8.0)
            make.centerX.equalTo(self.banner)
        }
        banner.page.pageIndicatorTintColor = UIColor.lightGrayColor()
        banner.page.currentPageIndicatorTintColor = APPBlueColor
        
        
        banner.block =
            {
                [weak self]
                (o)->Void in
                
                if(self != nil)
                {
                    
                    let vc:HtmlVC = HtmlVC()
                    vc.hidesBottomBarWhenPushed = true
                    vc.url = o as! String
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                }
        }

        
        topModel.addObserver(self, forKeyPath: "count", options: .New, context: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(FrientVC.refresh(_:)) , name: NoticeWord.FriendPostSuccess.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(FrientVC.getTop) , name: NoticeWord.LoginSuccess.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(FrientVC.getTop) , name: NoticeWord.LogoutSuccess.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FrientVC.upDateCell(_:)), name: NoticeWord.UpDateFriendCell.rawValue, object: nil)
        
        
        self.table.registerNib("FrientQCell".Nib, forCellReuseIdentifier: "FrientQCell")
        self.table.registerNib("FriendTopCell".Nib, forCellReuseIdentifier: "FriendTopCell")
        self.table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //tempCell = self.table.dequeueReusableCellWithIdentifier("FrientQCell") as! FrientQCell
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        self.table.tableFooterView=view1
        self.table.tableHeaderView=view1
        
        self.table.separatorInset=UIEdgeInsetsMake(0, swidth, 0, 0)
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                self.table.layoutMargins=UIEdgeInsetsMake(0, swidth, 0, 0)
            } else {
                // Fallback on earlier versions
            }
        }
        
        httpHandle.url="http://101.201.169.38/api/Public/Found/?service=Quan.getListAll&page=[page]&perNumber=10&uid="+DataCache.Share().userModel.uid+"&xiaoquid="+xiaoquid
        httpHandle.autoReload = false
        httpHandle.pageSize = 10
        httpHandle.pageStr="[page]"
        httpHandle.scrollView=self.table
        httpHandle.replace=["descrip":"description"]
        httpHandle.keys=["data","info"]
        httpHandle.modelClass=FriendModel.self

        httpHandle.BeforeBlock {[weak self] (o) in
            
            self!.heightArr.removeAll(keepCapacity: false)
            
            if(self != nil)
            {
                for i in self!.heightArr.count..<self!.httpHandle.listArr.count
                {
                    
                    self!.heightArr[i] = self!.getCellHeight(i)
                    
                }
                
                self?.table.reloadData()
                
            }
        }
            
            
        self.table.setHeaderRefresh { [weak self] () -> Void in
            
            if(self == nil)
            {
                return
            }
            
            self!.getTop()
            self!.getBanner()
            
            self!.httpHandle.reSet()
            self!.httpHandle.handle()
        }
        
        self.table.beginHeaderRefresh()
        
        self.table.setFooterRefresh {[weak self] () -> Void in
            
            self!.httpHandle.handle()
        }
        
        self.table.hideFootRefresh()
        
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
    
    func getCellHeight(i:Int)->CGFloat
    {
        let model:FriendModel=self.httpHandle.listArr[i] as! FriendModel
        
        var baseH:CGFloat = 70.0+40.0
        var likep=""
        
        let attributedString1:NSMutableAttributedString = NSMutableAttributedString(string: model.content)
        let paragraphStyle1:NSMutableParagraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle1.lineSpacing = 2.5
        
        attributedString1.addAttributes([NSParagraphStyleAttributeName:paragraphStyle1,NSKernAttributeName:0.0], range: NSMakeRange(0, (model.content as NSString).length))
        
        let label = UILabel()
        label.frame = CGRectMake(0, 0, swidth-62, 1)
        label.font = UIFont.systemFontOfSize(16.0)
        label.attributedText = attributedString1
        label.numberOfLines = model.all ? 0 : 4
        label.numberOfLines = 0
        label.sizeToFit()
        
        if(label.frame.height > ContentMaxHeight)
        {
            baseH += 24
        }
        
        label.numberOfLines = model.all ? 0 : 4
        label.sizeToFit()
        baseH += label.frame.height+10
        
        baseH += self.getPicH(model)
        
        var zh=0
        if(model.zanList.count != 0)
        {
            var j=0
            for s in model.zanList
            {
                if(j == model.zanList.count-1)
                {
                    likep += s.nickname
                }
                else
                {
                    likep += s.nickname+","
                }
                
                j += 1
            }
            
            likep += "等\(model.zanList.count)人".trim()
            
            let attributedString1:NSMutableAttributedString = NSMutableAttributedString(string: likep)
            let paragraphStyle1:NSMutableParagraphStyle = NSMutableParagraphStyle()
            
            paragraphStyle1.lineSpacing = 5.0
            
            attributedString1.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle1, range: NSMakeRange(0, likep.length()))
            
            let label = UILabel()
            label.frame = CGRectMake(0, 0, swidth-62-26-16, 1)
            label.font = UIFont(name: "HYQiHei", size: 13.0)
            label.attributedText=attributedString1
            label.numberOfLines = 0
            label.sizeToFit()
            baseH += label.frame.height+21+12
            zh = 1
        }
        else
        {
           //baseH += 12
        }
    
        var mcount:CGFloat=0.0
        for item in model.commentList
        {
            let str=((item.nickname+":"+item.content).trim()).trim()
            
            let attributedString1:NSMutableAttributedString = NSMutableAttributedString(string: str)
            let paragraphStyle1:NSMutableParagraphStyle = NSMutableParagraphStyle()
            
            paragraphStyle1.lineSpacing = 5.0

            attributedString1.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle1, range: NSMakeRange(0, (str as NSString).length))
            
            let label = UILabel()
            label.frame = CGRectMake(0, 0, swidth-62-16, 1)
            label.font = UIFont(name: "HYQiHei", size: 13.0)
            label.attributedText = attributedString1
            label.numberOfLines = 0
            label.sizeToFit()
            mcount += label.frame.height+16
        }
        
        if(mcount > 0)
        {
            baseH += mcount
            baseH += 10
            if(zh == 0)
            {
                baseH += 10
            }
        }
        
        return baseH
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(indexPath.section == 0)
        {
            if(self.topModel.count.numberValue.intValue > 0)
            {
                return 75
            }
            else
            {
                return 0
            }
        }
        else if(indexPath.section == 1)
        {
            if(self.bannerArr.count>0)
            {
                return swidth / 16.0 * 6.0
                
            }
            else
            {
                return 0
            }
            
        }
        else
        {
            if(self.httpHandle.listArr.count == 0)
            {
                return 0
            }
            
            if(heightArr[indexPath.row] != nil)
            {
                return heightArr[indexPath.row]!
            }
            else
            {
                return 0
            }
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
    
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if(section < 2)
        {
            return 1
        }
        else
        {
            return self.httpHandle.listArr.count
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0)
        {
            let cell:FriendTopCell = tableView.dequeueReusableCellWithIdentifier("FriendTopCell", forIndexPath: indexPath) as! FriendTopCell
            
            cell.model = self.topModel
            cell.show()
            
            return cell
        }
        else if(indexPath.section == 1)
        {
            let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            
            cell.clipsToBounds = true
            
            cell.contentView.removeAllSubViews()
            cell.contentView.addSubview(self.banner)
            
            return cell
        }
        else
        {
            let cell:FrientQCell = tableView.dequeueReusableCellWithIdentifier("FrientQCell", forIndexPath: indexPath) as! FrientQCell
            
            cell.model = self.httpHandle.listArr[indexPath.row] as! FriendModel
            return cell
        }
        
    }
    
    func upDateCell(notice:NSNotification)
    {
        let info=notice.userInfo
        let id:String? = info?["id"] as? String
        
        var i=0
        for item in self.httpHandle.listArr
        {
            if(id == item.id)
            {
                let cell:FrientQCell? = self.table.cellForRowAtIndexPath(NSIndexPath.init(forRow: i, inSection: 2)) as? FrientQCell
                
                if(cell != nil)
                {
                    if(info?["all"] != nil)
                    {
                        let all = info!["all"] as! Bool
                        
                        (self.httpHandle.listArr[i] as! FriendModel).all = all
                        self.heightArr[i] = self.getCellHeight(i)
                        self.table.reloadRowsAtIndexPaths([NSIndexPath(forRow: i, inSection: 2)], withRowAnimation: .Automatic)
                        
                    }
                    else
                    {
                        self.doSameThingWithObj(cell!)
                    }
                }
                else
                {
                    let dict:Dictionary<String,AnyObject> = ["id":id!,"index":i]
                    self.doSameThingWithObj(dict)
                }
  
            }
            
            i += 1
        }
        
        

    }
    
    
    func doSameThingWithObj(o: AnyObject?) {
        
        if(o is Dictionary<String,AnyObject>)
        {
            let id = o!["id"] as! String
            let i = o!["index"] as! Int
            
            let url="http://101.201.169.38/api/Public/Found/?service=Quan.getArticle&id=\(id)&uid="+DataCache.Share().userModel.uid
            
            XHttpPool.requestJson(url, body: nil, method: .GET) {[weak self] (o) -> Void in
                if(self == nil)
                {
                    return
                }
                
                if(o?["data"].dictionaryValue.count > 0)
                {
                    let model:FriendModel=FriendModel.parse(json: o!["data"]["info"][0], replace: nil)
                    self?.httpHandle.listArr[i] = model
                    
                    self?.heightArr[i] = self?.getCellHeight(i)
                    
                    self?.table.beginUpdates()
                    self?.table.endUpdates()
                    
                }
                
            }

            
        }
        
        if(o is FrientQCell)
        {
            let cell = o as! FrientQCell
            
            let url="http://101.201.169.38/api/Public/Found/?service=Quan.getArticle&id=\(cell.model.id)&uid="+DataCache.Share().userModel.uid
            
            XHttpPool.requestJson(url, body: nil, method: .GET) {[weak self] (o) -> Void in
                if(self == nil)
                {
                    return
                }
                    
                if(o?["data"].dictionaryValue.count > 0)
                {
                    let indexPath = self?.table.indexPathForCell(cell)
                    
                    if(indexPath != nil)
                    {
                        let model:FriendModel=FriendModel.parse(json: o!["data"]["info"][0], replace: nil)
                        self?.httpHandle.listArr[indexPath!.row] = model
                        
                        self?.heightArr[indexPath!.row] = self?.getCellHeight(indexPath!.row)
                        
                        self?.table.beginUpdates()
                        
                        cell.model = model
                        
                        self?.table.endUpdates()
                    }
  
                }
                
            }
        }
    }

    
    func getPicH(fmodel:FriendModel)->CGFloat
    {
        var h:CGFloat=0.0
        
        if(fmodel.picList.count >= 3)
        {
            h = baseW/3.0*CGFloat(ceil(Double(fmodel.picList.count)/3.0))
        }
        else if(fmodel.picList.count == 2)
        {
            h = baseW/2.0
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
            
            h = newH
            
        }
        else
        {
            h = 0.0
        }
        
        return h
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if(indexPath.section == 2)
        {
            let vc:FriendInfoVC = "FriendInfoVC".VC("Friend") as! FriendInfoVC
            
            vc.hidesBottomBarWhenPushed = true
            vc.fmodel = self.httpHandle.listArr[indexPath.row] as! FriendModel
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.table.reloadData()
        //self.table.beginUpdates()
        //self.table.endUpdates()
    }
    
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        topModel.removeObserver(self, forKeyPath: "count")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    

   

}
