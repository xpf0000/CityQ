//
//  PhoneSearchVC.swift
//  chengshi
//
//  Created by X on 15/11/23.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class PhoneSearchVC: XViewController ,UISearchBarDelegate{
    
    @IBOutlet var searchTable: XTableView!
    
    var isSearchVC:Bool=false
    
    var searchText = ""
    {
        didSet
        {
            searchbar.text = searchText
            let url=APPURL+"Public/Found/?service=Tel.search"
            let body = "key="+searchText
            XHttpPool.requestJson(url, body: body, method: .POST) { (o) -> Void in
                
                self.searchTable.httpHandle.listArr = []
                
                if(o?["data"]["info"] != nil)
                {
                    for item in o!["data"]["info"].arrayValue
                    {
                        let model:PhoneModel = PhoneModel.parse(json: item, replace: nil)
                        self.searchTable.httpHandle.listArr.append(model)
                    }
                }
                
                self.searchTable.reloadData()
            }
        }
    }
    
    let searchbar:UISearchBar=UISearchBar()
    
    var block:AnyBlock?
    
    var classModel:CategoryModel?
    var searchIng=false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBackButton()

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
        
        self.searchTable.registerNib("PhoneCell".Nib, forCellReuseIdentifier: "PhoneCell")
        self.searchTable.cellHeight = 75+16
        self.searchTable.CellIdentifier = "PhoneCell"
        self.searchTable.httpHandle.modelClass = PhoneModel.self
        
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
        
        if(isSearchVC)
        {
            self.dismissViewControllerAnimated(true) { () -> Void in
                
                self.block?("show")
            }
        }
        else
        {
            self.searchIng = false
            searchBar.removeFromSuperview()
        }
        
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchText = searchText
  
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchbar.resignFirstResponder()
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
