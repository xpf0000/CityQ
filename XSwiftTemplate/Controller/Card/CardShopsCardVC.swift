//
//  CardShopsCardVC.swift
//  chengshi
//
//  Created by X on 16/6/7.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class CardShopsCardVC: UIViewController,UITableViewDelegate {
    
    let table = XTableView(frame: CGRectMake(0, 0, swidth, sheight-64), style: .Grouped)
    
    var id = ""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.title = "会员卡"
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.title = "会员卡"
    }
    
    
    func http()
    {
        let url = APPURL+"Public/Found/?service=Hyk.getShopCard&id=\(id)"
        
        table.httpHandle.reSet()
        
        table.httpHandle.url = url
        
        table.httpHandle.handle()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        self.view.addSubview(table)
        
        table.backgroundColor = UIColor.whiteColor()
        
        let header = UIView()
        header.backgroundColor = UIColor.whiteColor()
        header.frame = CGRectMake(0, 0, swidth, 13.0*screenFlag)
        table.tableHeaderView = header
        
        let footer = UIView()
        footer.backgroundColor = UIColor.clearColor()
        footer.frame = CGRectMake(0, 0, swidth, 34.0)
        table.tableFooterView = footer
        
        table.separatorStyle = .None
        
        table.registerNib("CardIndexCell".Nib, forCellReuseIdentifier: "CardIndexCell")
        table.CellIdentifier = "CardIndexCell"
        table.cellHeight = 120 * screenFlag
        
        table.setHandle("", pageStr: "[page]", keys: ["data","info"], model: CardModel.self, CellIdentifier: "CardIndexCell")
        table.httpHandle.pageSize = 10000
        table.Delegate(self)
        
        self.http()
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row % 2 == 0
        {
            let vc = "CardInfoVC".VC("Card")
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = "CardTimesInfoVC".VC("Card")
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
