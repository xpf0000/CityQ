//
//  FriendMessageVC.swift
//  chengshi
//
//  Created by X on 15/12/9.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class FriendMessageVC: UITableViewController {

    @IBOutlet var table: UITableView!
    
    lazy var heightArr:Dictionary<Int,CGFloat>=[:]
    var showMore=false
    
    var httpHandle:XHttpHandle = XHttpHandle()
    
    
    func getMore()
    {
        showMore = true
        httpHandle.reSet()
        httpHandle.url=APPURL+"Public/Found/?service=Quan.getNewsMore&username="+DataCache.Share.userModel.username+"&page=[page]&perNumber=20"
        
        self.table.setFooterRefresh { () -> Void in
            
            self.httpHandle.handle()
        }
        
        httpHandle.handle()
        
        //self.table.beginFooterRefresh()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        table.tableFooterView=view1
        table.tableHeaderView=view1
        
        self.table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.table.registerNib("FriendMessageCell".Nib, forCellReuseIdentifier: "FriendMessageCell")
        
        httpHandle.url=APPURL+"Public/Found/?service=Quan.getNews&username="+DataCache.Share.userModel.username
        httpHandle.pageStr="[page]"
        httpHandle.scrollView=self.table
        httpHandle.replace=nil
        httpHandle.keys=["data","info"]
        httpHandle.modelClass=FriendMsgModel.self
        httpHandle.handle()

    }
    
    func getCellHeight(i:Int)->CGFloat
    {
        let model:FriendMsgModel = httpHandle.listArr[i] as! FriendMsgModel
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(14.0)
        label.frame = CGRectMake(0, 0, swidth-(10+50+10+30+60+10), 1)
        label.numberOfLines = 0
        label.text = model.content
        label.sizeToFit()
        
        return label.frame.height + 65
        
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
//        if(self.httpHandle.listArr.count == 0)
//        {
//            return 0
//        }
        
        if(!showMore && indexPath.row == httpHandle.listArr.count)
        {
            return 60.0
        }
        
        if(heightArr[indexPath.row] == nil)
        {
            
            for i in self.heightArr.count..<self.httpHandle.listArr.count
            {
                
                heightArr[i] = self.getCellHeight(i)
                
            }
            
            return heightArr[indexPath.row]!
        }
        else
        {
            return heightArr[indexPath.row]!
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(!showMore)
        {
            return httpHandle.listArr.count+1
        }
        else
        {
            return httpHandle.listArr.count
        }
        
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if(!showMore && indexPath.row == httpHandle.listArr.count)
        {
            let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            
            cell.contentView.removeAllSubViews()
            
            let button=UIButton(type: .Custom)
            button.setTitle("点击查看历史消息", forState: .Normal)
            button.setTitleColor(blackTXT, forState: .Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(15.0)
            
            cell.contentView.addSubview(button)
            
            button.snp_makeConstraints(closure: { (make) -> Void in
                make.top.equalTo(10.0)
                make.bottom.equalTo(-10.0)
                make.leading.equalTo(30.0)
                make.trailing.equalTo(-30.0)
            })
            
            button.layer.cornerRadius = 6.0
            button.layer.borderColor = borderBGC.CGColor
            button.layer.borderWidth = 0.6
            button.layer.masksToBounds = true
            
            button.addTarget(self, action: #selector(FriendMessageVC.getMore), forControlEvents: .TouchUpInside)
            
            return cell
        }
        
        
        
        let cell:FriendMessageCell = tableView.dequeueReusableCellWithIdentifier("FriendMessageCell", forIndexPath: indexPath) as! FriendMessageCell
        
        cell.model = httpHandle.listArr[indexPath.row]  as! FriendMsgModel
        cell.show()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if(indexPath.row < httpHandle.listArr.count)
        {
            let vc:FriendInfoVC = "FriendInfoVC".VC("Friend") as! FriendInfoVC
            
            vc.hidesBottomBarWhenPushed = true
            vc.fmodel = FriendModel()
            vc.fmodel.id = (httpHandle.listArr[indexPath.row] as! FriendMsgModel).did
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}
