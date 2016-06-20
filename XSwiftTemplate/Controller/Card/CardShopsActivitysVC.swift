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
        
        table.registerNib("CardShopsActivitysCell".Nib, forCellReuseIdentifier: "CardShopsActivitysCell")
        table.CellIdentifier = "CardShopsActivitysCell"
        table.cellHeight = 50
        
        table.setHandle("", pageStr: "[page]", keys: ["data","info"], model: CardActivityModel.self, CellIdentifier: "CardShopsActivitysCell")
        table.httpHandle.pageSize = 10000
        table.httpHandle.replace = ["descrip":"description"]
        table.Delegate(self)
        
        self.http()
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
 
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
