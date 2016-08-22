//
//  OADocInfoVC.swift
//  OA
//
//  Created by X on 15/5/8.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit

class OADocInfoVC: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    var table=UITableView()
    var msgTitle=UILabel()
    var ltitle=UILabel()
    var content=UILabel()
    var info:OADocModel!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.title="公文详情"
        self.navigationItem.hidesBackButton=true
        self.addBackButton()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func back()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func getContent()
    {
        let url=WapUrl+"/apioa/Public/OA/?service=Document.getArticle&id=\(info.id)&uid=\(DataCache.Share.oaUserModel.uid)&username=\(DataCache.Share.oaUserModel.username)"
        
        
        XHttpPool.requestJson(url, body: nil, method: .GET) {[weak self] (o) -> Void in
            
            if(o?["data"]["info"].arrayValue.count > 0)
            {
                self?.info = OADocModel.parse(json: o!["data"]["info"][0], replace: nil)
                
                self?.showView()
                return
            }
            
            ShowMessage("加载失败")
            
        }
        
        
    }
    
    
    func showView()
    {
        msgTitle.text=info!.title
        msgTitle.frame=CGRectMake(10, 15, swidth-20, 24)
        msgTitle.font=UIFont.systemFontOfSize(20.0)
        msgTitle.numberOfLines=0
        msgTitle.sizeToFit()
        msgTitle.frame=CGRectMake(10, 15, swidth-20, msgTitle.frame.size.height)
        
        let time=NSDate(timeIntervalSince1970: NSTimeInterval(info.create_time)!).str
        
        ltitle.frame=CGRectMake(10, msgTitle.frame.size.height+15+10, swidth-20, 24)
        ltitle.text="发布时间："+time!
        ltitle.font=UIFont.systemFontOfSize(15.0)
        ltitle.textColor=UIColor.lightGrayColor()
        
        msgTitle.textAlignment=NSTextAlignment.Center
        ltitle.textAlignment=NSTextAlignment.Center
        
        let line=UILabel()
        line.backgroundColor="#bebebe".color
        line.frame=CGRectMake(0, ltitle.frame.origin.y+ltitle.frame.size.height+12, swidth, 0.5)
        
        let attributedString1=NSMutableAttributedString(string: info!.content)
        let paragraphStyle1=NSMutableParagraphStyle()
        paragraphStyle1.lineSpacing=8.0
        paragraphStyle1.paragraphSpacing=10.0
        paragraphStyle1.firstLineHeadIndent=20.0
        attributedString1.addAttributes([NSParagraphStyleAttributeName:paragraphStyle1,NSFontAttributeName:UIFont.systemFontOfSize(18)], range: NSMakeRange(0, (info!.content as NSString).length))
        content.frame=CGRectMake(10, ltitle.frame.origin.y+ltitle.frame.size.height+12+15, swidth-20, sheight-64-10-(ltitle.frame.origin.y+ltitle.frame.size.height+12+15))
        content.backgroundColor=UIColor.whiteColor()
        content.font=UIFont.systemFontOfSize(18)
        content.attributedText=attributedString1
        content.numberOfLines=0
        content.sizeToFit()
        content.frame=CGRectMake(10, 10, swidth-20, content.frame.size.height)
        
        
        self.view.addSubview(msgTitle)
        self.view.addSubview(ltitle)
        self.view.addSubview(line)
        
        
        table.frame=CGRectMake(0, line.frame.origin.y+line.frame.size.height, swidth, sheight-64-(line.frame.origin.y+line.frame.size.height))
        table.dataSource=self
        table.delegate=self
        table.showsHorizontalScrollIndicator=false
        table.showsVerticalScrollIndicator=false
        table.separatorStyle=UITableViewCellSeparatorStyle.None
        let view=UIView()
        view.backgroundColor=UIColor.clearColor()
        
        table.tableFooterView=view
        table.tableHeaderView=view
        
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(table)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor=UIColor.whiteColor()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2+info.fileList.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row==0)
        {
            return content.frame.size.height+20
        }
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellIdentifier="cell"
        
        let cell:UITableViewCell=tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath)
        
        for view in cell.contentView.subviews
        {
            (view ).removeFromSuperview()
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyle.None
        
        if(indexPath.row==0)
        {
            cell.contentView.addSubview(content)
        }
        else
        {
            let label=UILabel()
            label.frame=CGRectMake(20, 0, swidth-40, 50)
            if(indexPath.row==1)
            {
                label.text="附件: "
                
                label.font=UIFont.boldSystemFontOfSize(22.5)
            }
            else
            {
                label.text=info.fileList[indexPath.row-2].name
                label.font=UIFont.boldSystemFontOfSize(17.5)
                label.textColor="#2c66ee".color
            }
            
            cell.contentView.addSubview(label)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if(indexPath.row>1)
        {
            let att=OAAttachmentVC()
            att.model=info.fileList[indexPath.row-2]

            self.navigationController?.pushViewController(att, animated: true)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}