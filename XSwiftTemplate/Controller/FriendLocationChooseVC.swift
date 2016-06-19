//
//  FriendLocationChooseVC.swift
//  chengshi
//
//  Created by X on 15/11/27.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class FriendLocationChooseVC: UITableViewController {

    @IBOutlet var table: UITableView!
    
    lazy var PoiInfo:Array<BMKPoiInfo> = []
    
    var block:AnyBlock?
    
    func back()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择地址"
        
        self.addBackButton()
        
        self.table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return PoiInfo.count+1
    }

    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 60.0
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.contentView.removeAllSubViews()
        
        let title=UILabel()
        title.font=UIFont(name: "HYQiHei", size: 16.0)
        title.textColor = blackTXT
        
        if(indexPath.row == 0)
        {
            title.text = "不显示位置"
            title.frame = CGRectMake(20, 0, swidth-40, 60)
            cell.contentView.addSubview(title)
        }
        else
        {
            let ltitle=UILabel()
            ltitle.font=UIFont(name: "HYQiHei", size: 12.5)
            ltitle.textColor = UIColor.lightGrayColor()
            
            title.text = PoiInfo[indexPath.row-1].name
            title.frame = CGRectMake(20, 8, swidth-40, 20)
            cell.contentView.addSubview(title)
            
            ltitle.text = PoiInfo[indexPath.row-1].address
            ltitle.frame = CGRectMake(20, 30, swidth-40, 18)
            cell.contentView.addSubview(ltitle)
            
        }
        
        
        return cell
        
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if(self.block != nil)
        {
            if(indexPath.row == 0)
            {
                self.block!(nil)
            }
            else
            {
               self.block!(PoiInfo[indexPath.row-1])
            }
            
        }
        
        self.back()
        
    }

    

}
