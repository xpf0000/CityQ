//
//  GroupHomeVC.swift
//  chengshi
//
//  Created by X on 2016/11/12.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class GroupModel: Reflect {
    
    var id = ""
    var name = ""
    var jdinfo = ""
    var url = ""
    var viplevel = ""
}


class GroupHomeVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let table = UITableView()
    
    let httpHandle = XHttpHandle()
    
    var block:XHTMLBlock?
    
    func toSearch(str:String)
    {
        let vc = "GroupSearchVC".VC("Jifen") as! GroupSearchVC
        vc.key = str
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func http()
    {
        let url = APPURL+"Public/Found/?service=hyk.getShopTJList&page=[page]&perNumber=20"
        
        httpHandle.setHandle(table, url: url, pageStr: "[page]", keys: ["data","info"], model: GroupModel.self)
        httpHandle.handle()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = APPBGColor
        
        block =
        {
            (str)->Void in
                
            self.toSearch(str)
        }

        
        table.frame = CGRectMake(0, 0, swidth, sheight-64)
        table.backgroundColor = UIColor.whiteColor()

        let v = UIView()
        table.tableHeaderView = v
        let v1 = UIView()
        v1.frame = CGRectMake(0, 0, swidth, 50.0)
        table.tableFooterView = v1
        
        table.registerNib("GroupHomeCell1".Nib, forCellReuseIdentifier: "GroupHomeCell1")
        table.registerNib("GroupHomeCell2".Nib, forCellReuseIdentifier: "GroupHomeCell2")
        table.registerNib("GroupSearchBarCell".Nib, forCellReuseIdentifier: "GroupSearchBarCell")
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        table.delegate = self
        table.dataSource = self
        
        table.setHeaderRefresh { 
            [weak self] in
            self?.httpHandle.reSet()
            self?.httpHandle.handle()
        }
        
        table.setFooterRefresh { 
            [weak self] in
            
            self?.httpHandle.handle()
        }
        
        self.view.addSubview(table)
        
        table.reloadData()
        
        http()
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row < 1
        {
            cell.separatorInset=UIEdgeInsetsMake(0, swidth, 0, 0)
            if(IOS_Version>=8.0)
            {
                if #available(iOS 8.0, *) {
                    cell.layoutMargins=UIEdgeInsetsMake(0, swidth, 0, 0)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        else
        {
            cell.separatorInset=UIEdgeInsetsMake(0, 15, 0, 0)
            if(IOS_Version>=8.0)
            {
                if #available(iOS 8.0, *) {
                    cell.layoutMargins=UIEdgeInsetsMake(0, 15, 0, 0)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        self.table.separatorInset=UIEdgeInsetsZero
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                self.table.layoutMargins=UIEdgeInsetsZero
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return httpHandle.listArr.count+2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0
        {
            return 62.0
        }
        else if indexPath.row == 1
        {
            return 44.0
        }
        
        return 110
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0
        {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("GroupSearchBarCell", forIndexPath: indexPath) as! GroupSearchBarCell
            
            cell.block = block
            
            return cell
        
        }
        else if indexPath.row == 1
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            
            cell.contentView.removeAllSubViews()
            
            let txt = UILabel()
            txt.font = UIFont.systemFontOfSize(15.0)
            txt.textColor = "666666".color
            txt.text = "为您推荐"
            
            cell.contentView.addSubview(txt)
            
            txt.snp_makeConstraints(closure: { (make) in
                make.bottom.equalTo(cell.contentView).offset(-8.0)
                make.leading.equalTo(cell.contentView).offset(10.0)
            })
            
            cell.selectionStyle = .None
            return cell

        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("GroupHomeCell2", forIndexPath: indexPath) as! GroupHomeCell2
            
            let m =  httpHandle.listArr[indexPath.row - 2] as! GroupModel
            
            cell.model = m
            
            return cell
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
