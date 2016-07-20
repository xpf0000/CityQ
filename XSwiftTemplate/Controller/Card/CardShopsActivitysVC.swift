//
//  CardShopsActivitysVC.swift
//  chengshi
//
//  Created by X on 16/6/7.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class CardShopsActivitysVC: UIViewController,UITableViewDelegate {
    
    let table = XTableView(frame: CGRectMake(0, 0, swidth, sheight-64))
    
    var id = ""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.title = "优惠活动"
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.title = "优惠活动"
    }
    
    func http()
    {
        let url = APPURL+"Public/Found/?service=Hyk.getShopHD&id=\(id)"
        
        table.httpHandle.reSet()
        
        table.httpHandle.url = url
        
        table.httpHandle.handle()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        self.view.addSubview(table)
        
        table.backgroundColor = UIColor.whiteColor()
        
        table.registerNib("ActivitysCell".Nib, forCellReuseIdentifier: "ActivitysCell")
        table.CellIdentifier = "ActivitysCell"
        table.cellHeight = 170.0 * screenFlag
        
        table.setHandle("", pageStr: "[page]", keys: ["data","info"], model: NewsModel.self, CellIdentifier: "ActivitysCell")
        table.httpHandle.pageSize = 10000
        table.httpHandle.replace = ["descrip":"description"]
        table.Delegate(self)
        
        self.http()
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        let model = table.httpHandle.listArr[indexPath.row] as! NewsModel
        
        let vc:CardActivitysInfoVC = "CardActivitysInfoVC".VC("Card") as! CardActivitysInfoVC
        vc.model.id = model.id
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
 
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
