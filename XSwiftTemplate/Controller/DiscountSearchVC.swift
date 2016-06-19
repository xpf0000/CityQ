//
//  DiscountSearchVC.swift
//  chengshi
//
//  Created by X on 15/11/23.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class DiscountSearchVC: XViewController ,UISearchBarDelegate{
    
    @IBOutlet var nvTitle: UINavigationItem!
    
    
    @IBOutlet var table: XTableView!
    
    @IBOutlet var searchTable: XTableView!
    
    
    var isSearchVC:Bool=false
    
    let searchbar:UISearchBar=UISearchBar()
    let searchView:UIView=UIView(frame: CGRectMake(0, 0, swidth, 44))
    
    var block:AnyBlock?
    
    var classModel:CategoryModel?
    var searchIng=false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBackButton()
        
        self.nvTitle.title = classModel?.title
        
        searchView.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        
        searchbar.delegate = self
        
        if(IOS_Version>=8.0)
        {
            searchbar.frame=CGRectMake(10, 0, swidth-20, 44)
        }
        else
        {
            searchbar.frame=CGRectMake(0, 0, swidth, 44)
        }
        
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
        
        searchView.addSubview(searchbar)
        
        self.searchTable.registerNib("DiscountCell".Nib, forCellReuseIdentifier: "DiscountCell")
        self.searchTable.cellHeight = 75+16
        self.searchTable.CellIdentifier = "DiscountCell"
        self.searchTable.httpHandle.modelClass = DiscountModel.self
        
        if(self.isSearchVC)
        {
            self.table.hidden = true
        }
        else
        {
            self.searchTable.hidden = true
            
            self.table.httpHandle.url = "http://101.201.169.38/api/Public/Found/?service=Discount.getList&category_id=\(classModel!.id)&perNumber=20&page=[page]"
            self.table.httpHandle.pageStr="[page]"
            self.table.cellHeight = 75+16
            self.table.CellIdentifier = "DiscountCell"
            self.table.httpHandle.modelClass = DiscountModel.self
            self.table.httpHandle.replace=nil
            self.table.httpHandle.keys=["data","info"]
            
            self.table.show()
        }
        
    }
    
    func showTable()
    {
        self.table.hidden = !self.table.hidden
        self.searchTable.hidden = !self.searchTable.hidden
    }
    
    
    @IBAction func searchClick(sender: AnyObject) {
        
        self.showTable()
        showSearch()
    }
    
    func showSearch()
    {
        self.navigationController?.navigationBar.addSubview(searchView)
        searchbar.becomeFirstResponder()
        self.searchIng = true
    }
    
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        
        searchbar.showsScopeBar = true;
        searchbar.setShowsCancelButton(true, animated: true)
        
        let arr=searchbar.subviews[0].subviews
        
        for view in arr
        {
            if(view is UIButton)
            {
                (view as! UIButton).enabled=true
                (view as! UIButton).setTitle("取消", forState: .Normal)
                (view as! UIButton).setTitleColor(腾讯颜色.图标蓝.rawValue.color, forState: .Normal)
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
                
                if(self.block != nil)
                {
                    self.block!("show")
                }
            }
        }
        else
        {
            self.searchIng = false
            searchView.removeFromSuperview()
            self.showTable()
            
        }
        
        
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        let url="http://101.201.169.38/api/Public/Found/?service=Discount.search"
        let body="key="+searchText
        XHttpPool.requestJson(url, body: body, method: .POST) { (o) -> Void in
            
            self.searchTable.httpHandle.listArr = []
            
            if(o?["data"]["info"] != nil)
            {
                for item in o!["data"]["info"].arrayValue
                {
                    let model:DiscountModel = DiscountModel.parse(json: item, replace: nil)
                    self.searchTable.httpHandle.listArr.append(model)
                }
            }
            
            self.searchTable.reloadData()
        }
        
        
        
        
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchbar.resignFirstResponder()
    }

    
    func setNavBar(a:Int)
    {
        var img:UIImage?
        if(a==0)
        {
            img=APPBlueColor.image
            UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        }
        else
        {
            img=UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0).image
            UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(img, forBarMetrics:.Default)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if(self.isSearchVC || self.searchIng)
        {
            showSearch()
        }
        
        
        
    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        searchbar.endEditing(true)
        searchView.removeFromSuperview()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
