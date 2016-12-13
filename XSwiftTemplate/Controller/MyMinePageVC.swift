//
//  MyMinePageVC.swift
//  chengshi
//
//  Created by X on 2016/10/24.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyMinePageVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet  var table: UITableView!
    
    @IBOutlet  var btn: UIButton!
    
    @IBOutlet  var btnH: NSLayoutConstraint!
    
    var type = 0
    {
        didSet
        {
            table.reloadData()
        }
    }
    
    let baseW=swidth-62
    
    let httpHandle:XHttpHandle=XHttpHandle()
    
    let header = MyMinePageHeader()
    
    lazy var heightArr:Dictionary<Int,CGFloat>=[:]
    
    @IBAction func btnClick(sender: AnyObject) {
        
        let vc:EditUserInfoVC = "EditUserInfoVC".VC("User") as! EditUserInfoVC
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    var uid = ""
    var uname = ""
    
    var umodel = UserModel()
    
    func getUser()
    {
        if uid == Uid {
            umodel = DataCache.Share.userModel
            table.reloadData()
            return
        }
        else{
            btnH.constant = 0.0
        }
        
        let url = "http://182.92.70.85/hfapi/Public/Found/?service=User.getUser&username=\(uname)"
        
        XHttpPool.requestJson(url, body: nil, method: .GET) { [weak self](o) in
            
            self?.umodel = UserModel.parse(json: o?["data"]["info"][0], replace: nil)
            
            self?.table.reloadData()
            
        }
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.title = "我的主页"
        
        let v = UIView()
        table.tableHeaderView = v
        table.tableFooterView = v
        
        header.frame = CGRectMake(0, 0, swidth, 46)
        header.superVC = self
        
        table.registerNib("MyMinePageCell1".Nib, forCellReuseIdentifier: "MyMinePageCell1")
        
        table.registerNib("MyMinePageCell2".Nib, forCellReuseIdentifier: "MyMinePageCell2")
        
        table.registerNib("MyMinePageCell3".Nib, forCellReuseIdentifier: "MyMinePageCell3")
        
     
        httpHandle.url=APPURL+"Public/Found/?service=quan.getMyList&page=[page]&perNumber=20&uid="+uid
        
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
        
        self.table.setFooterRefresh {[weak self] () -> Void in
            
            self!.httpHandle.handle()
        }
        
        self.table.hideFootRefresh()
        
        httpHandle.handle()
        getUser()
        
        
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if type == 1
        {
            cell.separatorInset=UIEdgeInsetsMake(0, swidth, 0, 0)
            cell.layoutMargins=UIEdgeInsetsMake(0, swidth, 0, 0)
        }
        else
        {
            cell.separatorInset=UIEdgeInsetsMake(0, 15, 0, 0)
            cell.layoutMargins=UIEdgeInsetsMake(0, 15, 0, 0)
        
        }
        
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section == 0)
        {
            return 1
        }
        else
        {
            if type == 0
            {
                return httpHandle.listArr.count
            }
            
            return 1
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(indexPath.section == 0)
        {
            return swidth * 400 / 750
        }
        else
        {
            if type == 0
            {
                if(heightArr[indexPath.row] != nil)
                {
                    return heightArr[indexPath.row]!
                }
                else
                {
                    return 0
                }

            }
            
            return 120
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("MyMinePageCell1", forIndexPath: indexPath) as! MyMinePageCell1
            
            cell.model = umodel
            
            return cell
            
        }
        else
        {
            if(type == 0)
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("MyMinePageCell3", forIndexPath: indexPath) as! MyMinePageCell3
                
                cell.model = self.httpHandle.listArr[indexPath.row] as! FriendModel
                
                return cell

            }
            else
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("MyMinePageCell2", forIndexPath: indexPath) as! MyMinePageCell2
                cell.model = umodel
                return cell

            }
            
        }
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 0
        }
        
        return 46
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0
        {
            return nil
        }
        
        return header
        
    }
    
    
    
    
    
    func getCellHeight(i:Int)->CGFloat
    {
        let model:FriendModel=self.httpHandle.listArr[i] as! FriendModel
        
        var baseH:CGFloat = 60
        
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
            baseH += ContentMaxHeight+10.0
        }
        else
        {
            baseH += CGFloat(ceil(label.frame.size.height)) + 10.0
        }
        
        baseH += self.getPicH(model)
        
        baseH += 12
        
        return baseH
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
        
        
        print("H000 : \(h)")
        
        return h
    }

    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
