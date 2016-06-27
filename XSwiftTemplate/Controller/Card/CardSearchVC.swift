//
//  CardSearchVC.swift
//  chengshi
//
//  Created by X on 15/11/23.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class CardSearchVC: XViewController ,UISearchBarDelegate,UITableViewDelegate{
    
    let searchTable = XTableView(frame: CGRectMake(0, 0, swidth, sheight-64.0), style: .Grouped)
    
    var searchText = ""
        {
        didSet
        {
            searchbar.text = searchText
            let url=APPURL+"Public/Found/?service=Hyk.search&keyword=\(searchText)&page=[page]&perNumber=20"
            
            searchTable.httpHandle.reSet()
            searchTable.httpHandle.url = url
            searchTable.httpHandle.handle()
            
        }
    }
    
    let searchbar:UISearchBar=UISearchBar()
    
    var block:AnyBlock?
    
    var classModel:CategoryModel?
    var searchIng=false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        searchTable.backgroundColor = UIColor.whiteColor()
        searchTable.frame = CGRectMake(0, 0, swidth, sheight-64)
        
        searchTable.keyboardDismissMode = .OnDrag
        searchTable.hideHeadRefresh()
        
        self.view.addSubview(searchTable)
        
        searchbar.delegate = self
        
        searchbar.layer.masksToBounds = true
        searchbar.frame=CGRectMake(10, 0, swidth-20, 44)
        
        if(searchbar.respondsToSelector(Selector("barTintColor")))
        {
            if(IOS_Version>=7.1)
            {
                //searchbar.searchTextPositionAdjustment
                searchbar.subviews[0].subviews[0].removeFromSuperview()
                searchbar.backgroundColor = UIColor.clearColor()
                
            }
            else
            {
                //searchbar.searchTextPositionAdjustment
                searchbar.subviews[0].subviews[0].removeFromSuperview()
                searchbar.backgroundColor = UIColor.clearColor()
                searchbar.barTintColor = UIColor.clearColor()
                
            }
        }
        
        
        let header = UIView()
        header.backgroundColor = UIColor.whiteColor()
        header.frame = CGRectMake(0, 0, swidth, 13.0*screenFlag)
        searchTable.tableHeaderView = header
        
        let footer = UIView()
        footer.backgroundColor = UIColor.clearColor()
        footer.frame = CGRectMake(0, 0, swidth, 34.0)
        searchTable.tableFooterView = footer
        
        searchTable.separatorStyle = .None
        
        searchTable.registerNib("CardIndexCell".Nib, forCellReuseIdentifier: "CardIndexCell")
        searchTable.cellHeight = 120 * screenFlag
        
        searchTable.setHandle("", pageStr: "[page]", keys: ["data","info"], model: CardModel.self, CellIdentifier: "CardIndexCell")
        
        searchTable.Delegate(self)
        
        self.navigationController?.navigationBar.addSubview(searchbar)
        searchbar.becomeFirstResponder()
        self.searchIng = true
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        
        searchbar.setShowsCancelButton(true, animated: true)
        
        let arr=searchbar.subviews[0].subviews
        
        for view in arr
        {
            if(view is UIButton)
            {
                (view as! UIButton).enabled=true
                (view as! UIButton).setTitle("取消", forState: .Normal)
                (view as! UIButton).setTitleColor(UIColor.whiteColor(), forState: .Normal)
                break
            }
        }
        
        return true
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        searchbar.resignFirstResponder()
        self.view.endEditing(true)
        pop()
        
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchText = searchText
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchbar.resignFirstResponder()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let model = searchTable.httpHandle.listArr[indexPath.row] as! CardModel
        
        let vc = "CardInfoVC".VC("Card") as! CardInfoVC
        
        vc.id = model.id
        
        vc.SuccessBlock {[weak self]()->Void in
            
            if self == nil {return}
            
            model.orlq = 1
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            
        }
        
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchbar.endEditing(true)
        searchbar.removeFromSuperview()
        
    }
    
    
    
    deinit
    {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
}
