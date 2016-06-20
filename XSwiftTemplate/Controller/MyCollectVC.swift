//
//  MyCollectVC.swift
//  chengshi
//
//  Created by X on 15/11/30.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyCollectVC: UITableViewController {

    @IBOutlet var table: XTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBackButton()
        
        table.registerNib("MyCollectCell".Nib, forCellReuseIdentifier: "MyCollectCell")
        
        let url = APPURL+"Public/Found/?service=News.getCollectList&uid=\(DataCache.Share().userModel.uid)&page=[page]&perNumber=20"
        
        table.setHandle(url, pageStr: "[page]", keys: ["data","info"], model: MyCollectModel.self, CellIdentifier: "MyCollectCell")
        
        self.table.cellHeight = 102.5
        self.table.CellIdentifier = "MyCollectCell"
        self.table.show()
        
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(editingStyle == UITableViewCellEditingStyle.Delete)
        {
            
            let id=(self.table.httpHandle.listArr[indexPath.row] as! MyCollectModel).id
            let user=DataCache.Share().userModel.username
            
            let url=APPURL+"Public/Found/?service=News.collectDel&id="+id+"&username="+user
            
            XHttpPool.requestJson(url, body: nil, method: .GET, block: { (json) in
                
                if let status = json?["data"]["code"].int
                {
                    if status == 0
                    {
                        DataCache.Share().newsCollect.dict.removeValueForKey(id)
                        DataCache.Share().newsCollect.save()
                        
                        self.table.httpHandle.listArr.removeAtIndex(indexPath.row)
                        
                        self.table.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}
