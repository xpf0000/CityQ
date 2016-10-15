//
//  OAAddMessageVC.swift
//  OA
//
//  Created by X on 15/5/5.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit
import EventKit

class OAAddMessageVC: UIViewController,commonDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIAlertViewDelegate{
    
    let titleText=UITextField()
    let contentText=UITextView()
    let placeholdL=UILabel()
    let button=UIButton()
    var activity:XWaitingView?
    var delegate:commonDelegate?
    var unitArr:Array<Int>=[]
    var unitLabel = UILabel()
    var unitMsg = ""
    lazy var addtag:Array<OAPowerModel> = []
    var block:AnyBlock?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.title="新建消息"
        self.navigationItem.hidesBackButton=true
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func submit()
    {
        self.view.endEditing(true)
        
        if(!titleText.checkNull() || !contentText.checkNull())
        {
            return
        }
        
        if(self.unitMsg == "")
        {
            self.view.showAlert("请选择接收部门", block: nil)
            return
        }
        
        let title=titleText.text!.trim()
        let content=contentText.text.trim()
        
        button.enabled=false
        
        
        self.view.showWaiting()
        
        let url=WapUrl+"/apioa/Public/OA/?service=News.sendGroupcast"
        var body="username="+DataCache.Share.oaUserModel.username
        body += "&uid="+DataCache.Share.oaUserModel.uid
        body += "&apptype=1"
        body += "&tag="+self.unitMsg
        body += "&title="+title
        body += "&content="+content
        
        XHttpPool.requestJson(url, body: body, method: .POST) {[weak self] (o) -> Void in
            
            RemoveWaiting()
            
            if(o?["data"].dictionaryValue.count > 0)
            {
                if(o!["data"]["code"].intValue == 0)
                {
                    self?.block?(nil)
                    self?.navigationController?.view.showAlert("消息发送成功", block: { (o) -> Void in
                        
                        self?.navigationController?.popViewControllerAnimated(true)
                        
                    })
                   
                    return
                }
                
                self?.button.enabled = true
                self?.navigationController?.view.showAlert(o!["data"]["msg"].stringValue, block: nil)
                
            }
            
            self?.navigationController?.view.showAlert("消息发送失败", block: nil)
            
        }

    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        self.view.backgroundColor="#f0f0f0".color
        
        let table=UITableView()
        
        table.frame=CGRectMake(0, 10, swidth, sheight-64-10)
        table.dataSource=self
        table.delegate=self
        table.backgroundColor=UIColor.clearColor()
        table.showsHorizontalScrollIndicator=false
        table.showsVerticalScrollIndicator=false
        table.separatorStyle=UITableViewCellSeparatorStyle.None
        table.allowsSelection=true
        let view=UIView()
        view.backgroundColor=UIColor.clearColor()
        
        table.tableFooterView=view
        table.tableHeaderView=view
        
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(table)
        
        titleText.frame=CGRectMake(10,0, swidth-20, 50)
        titleText.backgroundColor=UIColor.whiteColor()
        titleText.font=UIFont.systemFontOfSize(15.5)
        titleText.placeholder="请输入信息主题"
        
        let lview=UIView()
        lview.frame=CGRectMake(0, 0, 10, 50)
        titleText.leftView=lview
        titleText.leftViewMode = UITextFieldViewMode.Always
        titleText.clearButtonMode=UITextFieldViewMode.WhileEditing
        
        contentText.frame=CGRectMake(0,0, swidth-20, 140)
        contentText.backgroundColor=UIColor.clearColor()
        contentText.font=UIFont.systemFontOfSize(15.5)
        contentText.delegate=self
        
        contentText.addEndButton()
        titleText.addEndButton()
        
        placeholdL.frame=CGRectMake(10,2, swidth-40, 24)
        placeholdL.backgroundColor=UIColor.whiteColor()
        placeholdL.text="请输入信息内容"
        placeholdL.numberOfLines=0
        placeholdL.textColor="#c7c7cd".color
        placeholdL.font=UIFont.systemFontOfSize(15.5)
        
        unitLabel.frame = CGRectMake(100, 0, swidth-160, 50)
        unitLabel.font=UIFont.systemFontOfSize(18)
        unitLabel.textAlignment = .Right
        unitLabel.text = ""
        
    }
    
    func dismissKeyBoard()
    {
        self.view.endEditing(true)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(indexPath.row==1)
        {
            return 150
        }
        
        if(indexPath.row==3)
        {

            return 80
            
        }
        
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellIdentifier="cell"
        
        let cell:UITableViewCell=tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath)
        
        for view in cell.contentView.subviews
        {
            view.removeFromSuperview()
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyle.None
        cell.backgroundColor=UIColor.clearColor()
        
        cell.clipsToBounds = true
        cell.layer.masksToBounds = true
        
        cell.selectionStyle = .None
        
        if(indexPath.row==0)
        {
            cell.contentView.addSubview(titleText)
        }
        else if(indexPath.row==1)
        {
            let bgView=UIView()
            bgView.frame=CGRectMake(10,0, swidth-20, 140)
            bgView.backgroundColor=UIColor.whiteColor()
            cell.contentView.addSubview(bgView)
            
            bgView.addSubview(placeholdL)
            bgView.addSubview(contentText)
            
        }
        else if(indexPath.row==2)
        {
            let bgView=UIView()
            bgView.frame=CGRectMake(10,0, swidth-20, 50)
            bgView.backgroundColor=UIColor.whiteColor()
            cell.contentView.addSubview(bgView)
            
            bgView.addSubview(unitLabel)
            
            let label=UILabel()
            label.frame=CGRectMake(10,0, 80, 50)
            label.font=UIFont.systemFontOfSize(18)
            
            bgView.addSubview(label)
            
            let img=UIImageView()
            img.frame=CGRectMake(swidth-50, 15, 20, 20)
            img.image="go_arrow_icon.png".image
            bgView.addSubview(img)
            
            label.text="接收部门"
            
        }
        else if(indexPath.row==3)
        {
            button.frame=CGRectMake(10, 7.5, swidth-20, 60)
            
            button.backgroundColor="#6696e8".color
            
            button.setTitle("发送", forState: UIControlState.Normal)
            button.setTitle("发送中...", forState: UIControlState.Selected)
            
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
            
            button.titleLabel?.font=UIFont.systemFontOfSize(20)
            button.layer.cornerRadius=6.0
            
            button.addTarget(self, action: #selector(OAAddMessageVC.submit), forControlEvents: UIControlEvents.TouchUpInside)
            
            cell.contentView.addSubview(button)
        }
  
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if(indexPath.row == 2)
        {
            let choose=OAChooseUnitVC()
            choose.addtag = self.addtag
            choose.block =
                {
                    [weak self]
                    (o)->Void in
                    if(self == nil)
                    {
                        return
                    }
                    
                    let index = o as! Int
                    self!.unitMsg = ""
                    
                    var j=0
                    for item in self!.addtag
                    {
                        if(j==index)
                        {
                            self!.unitLabel.text = item.name
                            self!.unitMsg = item.value
                            break
                        }
                        j += 1
                    }
                    
                    
                    
            }
            self.navigationController?.pushViewController(choose, animated: true)
        }
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        placeholdL.hidden=true
    }
    
    func textViewDidChange(textView: UITextView) {
        
        placeholdL.hidden = (textView.text.length() > 0)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        placeholdL.hidden = (textView.text.length() > 0)
    }
    
    deinit
    {
        delegate=nil
        RemoveWaiting()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}
