//
//  DiscountVC.swift
//  chengshi
//
//  Created by X on 15/11/23.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class DiscountVC: XViewController ,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet var top: NSLayoutConstraint!
    
    @IBOutlet var nvTitle: UINavigationItem!
    
    @IBOutlet var leftButton: UIButton!
    
    @IBOutlet var table: UITableView!
    
    var httpHandle:XHttpHandle=XHttpHandle()
    lazy var classArr:Array<CategoryModel> = []
    
    
    @IBAction func back(sender: AnyObject) {
    }
    
    @IBAction func history(sender: AnyObject) {
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.getCategory()
    }
    
    
    func getCategory()
    {
        self.classArr.removeAll(keepCapacity: false)
        
        let url=APPURL+"Public/Found/?service=Discount.getCategory"
        
        XHttpPool.requestJson(url, body: nil, method: .GET) { (o) -> Void in
            
            if(o == nil)
            {
                return
            }
            
            for item in o!["data"]["info"].arrayValue
            {
                let model:CategoryModel = CategoryModel.parse(json: item, replace: nil)
                self.classArr.append(model)
            }
            
            self.table?.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBackButton()
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        self.table.tableFooterView=view1
        self.table.tableHeaderView=view1
        
        httpHandle.url=APPURL+"Public/Found/?service=Discount.getHot&page=[page]&perNumber=20"
        httpHandle.pageStr="[page]"
        httpHandle.scrollView=self.table
        httpHandle.replace=nil
        httpHandle.keys=["data","info"]
        httpHandle.modelClass=DiscountModel.self
        
        self.table.registerNib("DiscountSeachCell".Nib, forCellReuseIdentifier: "DiscountSeachCell")
        self.table.registerNib("DiscountCollectionCell".Nib, forCellReuseIdentifier: "DiscountCollectionCell")
        self.table.registerNib("DiscountCell".Nib, forCellReuseIdentifier: "DiscountCell")
        
        
        self.table.setHeaderRefresh { [weak self] () -> Void in
            
            if(self == nil)
            {
                return
            }
            
            self!.httpHandle.reSet()
            
            self!.httpHandle.handle()
        }
        
        //self.table.beginHeaderRefresh()
        
        self.table.setFooterRefresh {[weak self] () -> Void in
            
            self!.httpHandle.handle()
        }
        
        self.table.hideFootRefresh()
        
        self.httpHandle.handle()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section == 2)
        {
            return self.httpHandle.listArr.count
        }
        else
        {
            return 1
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(indexPath.section == 0)
        {
            return 44+8
        }
        else if(indexPath.section == 1)
        {
            return swidth/4.0*CGFloat(ceil(Double(classArr.count)/4.0))+8
        }
        else
        {
            return 75+16
        }
        
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if(section==2)
        {
            return 52
        }
        else
        {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if(section == 2)
        {
            let bgView=UIView()
            bgView.frame=CGRectMake(0, 0, swidth, 52)
            bgView.backgroundColor="#F2F2F2".color
            
            let view=UIView()
            view.frame=CGRectMake(0, 8, swidth, 44)
            view.backgroundColor=UIColor.whiteColor()
            bgView.addSubview(view)
            
            let label=UILabel()
            label.frame=CGRectMake(12, 0, 100, 44)
            label.textColor=blackTXT
            label.font=UIFont.systemFontOfSize(15.0)
            label.text="热门机构"
            
            view.addSubview(label)
            
            let line=UIView()
            line.frame=CGRectMake(0, 44-0.34, swidth, 0.34)
            line.backgroundColor=self.table.separatorColor
            view.addSubview(line)
            
            return bgView
        }
        
        return nil
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section
        {
        case 0:
            
            let cell:DiscountSeachCell = tableView.dequeueReusableCellWithIdentifier("DiscountSeachCell") as! DiscountSeachCell
            
            cell.block = {
                [weak self]
                (o)->Void in
                
                if(self == nil)
                {
                    return
                }
                
                self!.nvTitle.title=""
                
                UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    
                    (self?.navigationController as! XNavigationController).setAlpha(0.0)
                    self?.leftButton.alpha = 0.0
                    self?.top.constant = -52
                    self?.table.layoutIfNeeded()
                    
                    
                    }, completion: { (finish) -> Void in
                        
                })
                
                self?.jumpAnimType = .Alpha
                
                let vc:DiscountSearchVC = "DiscountSearchVC".VC("Discount") as! DiscountSearchVC
                vc.isSearchVC = true
                let nv:XNavigationController = XNavigationController(rootViewController: vc)
                
                self?.presentViewController(nv, animated: true, completion: { () -> Void in
                    
                    
                })
                
                vc.block =
                    {
                        [weak self]
                        (o)->Void in
                        
                        if(self == nil)
                        {
                            return
                        }
                        
                        self!.nvTitle.title="培训结构"
                        UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                            
                            (self?.navigationController as! XNavigationController).setAlpha(1.0)
                            self?.leftButton.alpha = 1.0
                            self?.top.constant = 0
                            self?.table.layoutIfNeeded()
                            
                            
                            }, completion: { (finish) -> Void in
                                
                        })
                        
                }
                
                
                
            }
            
            return cell
            
        case 1:
            
            let cell:DiscountCollectionCell = tableView.dequeueReusableCellWithIdentifier("DiscountCollectionCell") as! DiscountCollectionCell
            cell.arr=classArr
            cell.collectionView.reloadData()
            
            return cell
            
        default:
            
            let cell:DiscountCell = tableView.dequeueReusableCellWithIdentifier("DiscountCell") as! DiscountCell
            
            cell.model = self.httpHandle.listArr[indexPath.row] as! DiscountModel
            cell.line.backgroundColor = self.table.separatorColor
            
            return cell
            
        }
        
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
}
