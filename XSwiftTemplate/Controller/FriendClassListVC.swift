//
//  FrientVC.swift
//  chengshi
//
//  Created by X on 15/11/24.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class FriendClassListVC: XViewController ,UITableViewDelegate,UITableViewDataSource,commonDelegate,XPhotoDelegate{
    
    @IBOutlet var table: UITableView!
    
    lazy var classModel:CategoryModel = CategoryModel()
    lazy var imgArr:Array<UIImage> = []
    var httpHandle:XHttpHandle=XHttpHandle()
    lazy var heightArr:Dictionary<Int,CGFloat>=[:]
    var baseW=swidth-62
    
    func refresh()
    {
        self.table.beginHeaderRefresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        let button1=UIButton(type: UIButtonType.Custom)
        button1.frame=CGRectMake(10, 2, 25, 25);
        button1.setBackgroundImage("camera_icon_blue.png".image, forState: UIControlState.Normal)
        button1.showsTouchWhenHighlighted = true
        button1.exclusiveTouch = true
        button1.addTarget(self, action: #selector(FriendClassListVC.toPhoto), forControlEvents: UIControlEvents.TouchUpInside)
        let rightItem=UIBarButtonItem(customView: button1)
        self.navigationItem.rightBarButtonItem=rightItem;

        
        self.title = classModel.title
 
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FriendClassListVC.upDateCell(_:)), name: NoticeWord.UpDateFriendCell.rawValue, object: nil)
        
        self.table.registerNib("FrientQCell".Nib, forCellReuseIdentifier: "FrientQCell")
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        self.table.tableFooterView=view1
        self.table.tableHeaderView=view1
        
        self.table.separatorInset=UIEdgeInsetsZero
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                self.table.layoutMargins=UIEdgeInsetsZero
            } else {
                // Fallback on earlier versions
            }
        }
        
        httpHandle.url="http://101.201.169.38/api/Public/Found/?service=Quan.getList&page=[page]&perNumber=20&category_id="+classModel.id+"&uid="+DataCache.Share().userModel.uid
        
        httpHandle.autoReload = false
        httpHandle.pageStr="[page]"
        httpHandle.scrollView=self.table
        httpHandle.replace=["descrip":"description"]
        httpHandle.keys=["data","info"]
        httpHandle.modelClass=FriendModel.self
        
        httpHandle.BeforeBlock {
            
            [weak self]
            (o)->Void in
            
            self?.heightArr.removeAll(keepCapacity: false)
            
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
            
            self!.heightArr.removeAll(keepCapacity: false)
            
            self!.httpHandle.reSet()
            
            self!.httpHandle.handle()
        }
        
        self.table.beginHeaderRefresh()
        
        self.table.setFooterRefresh {[weak self] () -> Void in
            
            self!.httpHandle.handle()
        }
        
        self.table.hideFootRefresh()
        
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

    func XPhotoResult(o: AnyObject?) {
        
        if(o == nil)
        {
            let vc:PostFriendVC = "PostFriendVC".VC("Friend") as! PostFriendVC
            vc.imageArr = self.imgArr
            let nv:XNavigationController = XNavigationController(rootViewController: vc)
            
            self.jumpAnimType = .Default
            self.presentViewController(nv, animated: true, completion: { () -> Void in
                
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.httpHandle.listArr.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:FrientQCell = tableView.dequeueReusableCellWithIdentifier("FrientQCell", forIndexPath: indexPath) as! FrientQCell
        
        cell.model = self.httpHandle.listArr[indexPath.row] as! FriendModel
        cell.typeEnable = false
        return cell
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
                let cell:FrientQCell? = self.table.cellForRowAtIndexPath(NSIndexPath.init(forRow: i, inSection: 0)) as? FrientQCell
                
                if(cell != nil)
                {
                    if(info?["all"] != nil)
                    {
                        let all = info!["all"] as! Bool
                        
                        (self.httpHandle.listArr[i] as! FriendModel).all = all
                        self.heightArr[i] = self.getCellHeight(i)
                        self.table.reloadRowsAtIndexPaths([NSIndexPath(forRow: i, inSection: 0)], withRowAnimation: .Automatic)
                
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
        
        let vc:FriendInfoVC = "FriendInfoVC".VC("Friend") as! FriendInfoVC
    
        vc.typeEnable = false
        vc.hidesBottomBarWhenPushed = true
        vc.fmodel = self.httpHandle.listArr[indexPath.row] as! FriendModel
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    
    
    
}
