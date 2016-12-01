//
//  GoodsDuihuanDetailVC.swift
//  chengshi
//
//  Created by X on 2016/10/20.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class GoodsDuihuanDetailVC: UIViewController,UITableViewDelegate {
    
    let table = XTableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.title = "兑换记录"
        self.view.backgroundColor = APPBGColor
        self.view.addSubview(table)
        table.frame = CGRectMake(0, 0, swidth, sheight-64)
        table.backgroundColor = APPBGColor
        table.cellHeight = 64
        table.postDict = ["type":1]
        
        table.Delegate(self)
        
        let url = APPURL+"Public/Found/?service=Jifen.getDHList&uid=\(Uid)&username=\(Uname)&page=[page]&pernumber=20"
        
        table.setHandle(url, pageStr: "[page]", keys: ["data","info"], model: HFBModel.self, CellIdentifier: "JifenDetailCell")
        
        table.show()
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let model = table.httpHandle.listArr[indexPath.row] as! HFBModel
        
        let vc = HtmlVC()
        
        vc.baseUrl = TmpDirURL
        
        if let u = TmpDirURL?.URLByAppendingPathComponent("duihuansuccess.html")
        {
            vc.url = "\(u)?id=\(model.id)"
        }
        
        vc.hidesBottomBarWhenPushed = true
        vc.title = "兑换详情"
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
}
