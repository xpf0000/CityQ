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
        let url = APPURL+"Public/Found/?service=Hyk.getShopCard&id=\(id)&username=\(Uname)"
        
        table.httpHandle.reSet()
        
        table.httpHandle.url = url
        
        table.httpHandle.handle()
        
    }
    
    func userChange()
    {
        http()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(userChange), name: NoticeWord.LogoutSuccess.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(userChange), name: NoticeWord.LoginSuccess.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(userChange), name: NoticeWord.CardChanged.rawValue, object: nil)
        
        self.view.addSubview(table)
        
        self.view.backgroundColor = APPBGColor
        table.backgroundColor = APPBGColor
        
        let header = UIView()
        header.backgroundColor = UIColor.clearColor()
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
        
        let model = table.httpHandle.listArr[indexPath.row] as! CardModel
        
        var vc:UIViewController!
        
        if model.orlq > 0
        {
            vc = "CardGetedMainVC".VC("Card")
            
            (vc as! CardGetedMainVC).model = model
            
        }
        else
        {
            vc = "CardInfoVC".VC("Card")
            
            (vc as! CardInfoVC).id = model.id
            
            (vc as! CardInfoVC).SuccessBlock {[weak self]()->Void in
                
                if self == nil {return}
                
                model.orlq = 1
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                
            }
            
        }
        
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
