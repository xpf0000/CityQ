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
        self.title = "商圈"
        
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            return 1
        }
        else
        {
            return httpHandle.listArr.count+1
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0
        {
            
            return 56.0
        }
        else
        {
            if indexPath.row == 0
            {
                return 52.0
            }
            else
            {
                return 100.0
            }
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("GroupHomeCell1", forIndexPath: indexPath)
            
            
            
            return cell
        }
        else
        {
            if indexPath.row == 0
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
                
                
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("GroupHomeCell2", forIndexPath: indexPath) as! GroupHomeCell2
                
                let m =  httpHandle.listArr[indexPath.row - 1] as! GroupModel
                
                cell.model = m
                
                return cell
            }
            
        }

    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1
        {
            return 50.0
        }
        
        return 0.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1
        {
            let v = GroupSearchView()
            v.frame = CGRectMake(0, 0, swidth, 50.0)
            v.block = block
            return v
        }
        
        return nil
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
