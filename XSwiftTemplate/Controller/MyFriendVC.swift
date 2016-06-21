//
//  MyFriendVC.swift
//  chengshi
//
//  Created by X on 15/11/30.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyFriendVC: XViewController,UITableViewDelegate,UITableViewDataSource {

    let menu = XHorizontalMenuView()
    let main = XHorizontalMainView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.view.backgroundColor = "F3F5F7".color
        
        self.view.addSubview(menu)
        self.view.addSubview(main)
        
        menu.frame = CGRectMake(0, 0, swidth, 42.0)
        main.frame = CGRectMake(0, 42.0, swidth, sheight-64.0-42.0)
        
        menu.main = main
        menu.menuSelectColor = APPBlueColor
        menu.line.backgroundColor = APPBlueColor
        menu.menuMaxScale = 1.25
        menu.menuPageNum = 2

        var arr:Array<XHorizontalMenuModel> = []
        
        let titles:Array<String> = ["我发表的","我回复的"]
        
        
        for i in 0...1
        {
            let model:XHorizontalMenuModel = XHorizontalMenuModel()
            
            let table:XTableView = XTableView(frame: CGRectMake(0, 0, swidth, sheight-64.0-42.0))
            
            var url = ""

            switch i
            {
            case 0:
                ""
                url = APPURL+"Public/Found/?service=Quan.getUserList&uid=\(DataCache.Share().userModel.uid)&page=[page]&perNumber=20"

            case 1:
                ""
                url = APPURL+"Public/Found/?service=Quan.getUserComment&uid=\(DataCache.Share().userModel.uid)&page=[page]&perNumber=20"

            default:
                ""
            }
            
            table.registerNib("MyPostFriendCell".Nib, forCellReuseIdentifier: "MyPostFriendCell")
            
            table.setHandle(url, pageStr: "[page]", keys: ["data","info"], model: FriendModel.self, CellIdentifier: "MyPostFriendCell")
            table.cellHeight = 95
            table.CellIdentifier = "MyPostFriendCell"
            table.tag = 20+i
            
            table.Delegate(self)
            table.DataSource(self)
            
            table.show()
            
            model.title = titles[i]
            
            model.view = table
            
            arr.append(model)
        }
        
        menu.menuArr = arr
        main.scrollEnabled = false
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(editingStyle == UITableViewCellEditingStyle.Delete)
        {
            
            let cell:MyPostFriendCell = tableView.cellForRowAtIndexPath(indexPath) as! MyPostFriendCell
            
            let id=cell.model.id
            let user=DataCache.Share().userModel.username
            var url=""
            if(tableView.tag == 20)
            {
                url=APPURL+"Public/Found/?service=Quan.quanDel&id="+id+"&username="+user
            }
            else
            {
                url=APPURL+"Public/Found/?service=Quan.commentDel&id="+cell.model.cid+"&username="+user
            }
            
            XHttpPool.requestJson(url, body: nil, method: .GET, block: { (json) in
                
                if let status = json?["data"]["code"].int
                {
                    if status == 0
                    {
                        if(tableView.tag == 20)
                        {
                            NSNotificationCenter.defaultCenter().postNotificationName(NoticeWord.FriendPostSuccess.rawValue, object: nil, userInfo: ["id":(tableView as! XTableView).httpHandle.listArr[indexPath.row].id!])
                        }
                        else
                        {
                            NSNotificationCenter.defaultCenter().postNotificationName(NoticeWord.UpDateFriendCell.rawValue,
                                object: nil,
                                userInfo: ["id": (tableView as! XTableView).httpHandle.listArr[indexPath.row].id!,"zan" : false])
                        }
                        
                        
                        (tableView as! XTableView).httpHandle.listArr.removeAtIndex(indexPath.row)
                        
                        (tableView as! XTableView).deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    }
                    else
                    {
                        ShowMessage(json!["data"]["msg"].stringValue)
                    }
                }
                else
                {
                    ShowMessage("删除失败!")
                }
            })
            
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        (self.navigationController as! XNavigationController).removeRecognizer()
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        (self.navigationController as! XNavigationController).setRecognizer()
        
    }
    
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
