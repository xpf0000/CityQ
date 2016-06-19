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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.title = "优惠活动"
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.title = "优惠活动"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        self.view.addSubview(table)
        
        table.backgroundColor = UIColor.whiteColor()
        
        table.registerNib("CardShopsActivitysCell".Nib, forCellReuseIdentifier: "CardShopsActivitysCell")
        table.CellIdentifier = "CardShopsActivitysCell"
        table.cellHeight = 50
        
        for _ in 0...3
        {
            table.httpHandle.listArr.append(CardActivityModel())
        }
        
        table.reloadData()
        
        table.Delegate(self)
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
