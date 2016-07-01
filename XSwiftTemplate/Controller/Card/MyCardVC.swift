//
//  MyCardVC.swift
//  chengshi
//
//  Created by X on 16/6/7.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyCardVC: UIViewController,ReactionMenuDelegate,UITableViewDelegate {
    
    @IBOutlet var noView: UIView!
    
    let top = ReactionMenuView()
    var topCellArr:Array<Array<ReactionMenuItemModel>> = [[],[]]
    
    let table = XTableView(frame: CGRectMake(0, 45, swidth, sheight-64-45), style: .Grouped)
    
    weak var rightBtn:UIButton?
    
    weak var tabbar:UITabBarController?
    
    var category_id = ""
    
    var typeid = ""
    
    @IBAction func toGetCard(sender: AnyObject) {
        
        self.navigationController?.popToRootViewControllerAnimated(false)
        
        print(self.tabBarController)
        
       tabbar?.selectedIndex = 1
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.title = "我的会员卡"
        addBackButton()
        
        rightBtn = addSearchButton {
            [weak self](btn)->Void in
            
            self?.toSearch()
        }
        
        getCardCategory()
        setRight()
    }
    
    func toSearch()
    {
        let vc = "CardMoneyInfoVC".VC("Card")
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func http()
    {
        table.httpHandle.reSet()
        table.httpHandle.url = APPURL+"Public/Found/?service=Hyk.getUserList&category_id="+category_id+"&typeid="+typeid+"&page=[page]&perNumber=20&username=\(DataCache.Share().userModel.username)"
        table.httpHandle.handle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rightBtn?.hidden = true
        
        self.view.addSubview(table)
        
        self.addTopBootButton()
        
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
        table.cellHeight = 120 * screenFlag
        
        table.setHandle("", pageStr: "[page]", keys: ["data","info"], model: CardModel.self, CellIdentifier: "CardIndexCell")
        
        table.Delegate(self)
        
        table.httpHandle.BeforeBlock { [weak self](o) in
            
            if self?.table.hidden == false
            {
                return
            }
            
            for item in o
            {
                item.setValue(1, forKey: "orlq")
            }
            
            let b = o.count == 0
            
            self?.table.hidden = b
            self?.top.hidden = b
            self?.noView.hidden = !b
            
        }
        
        noView.hidden = true
        table.hidden = true
        top.hidden = true
        
        self.http()
        
        
    }
    
    ////顶部button
    func addTopBootButton(){
        
        top.tbHeight = 200.0
        top.tbWidth = swidth * 0.5
        top.frame = CGRectMake(0, 0, swidth, 43.0 * screenFlag)
        
        top.delegate = self
        
        //设置菜单的父视图
        top.superView = self.view
        //菜单的选项
        top.titles = ["全部分类","会员卡分类"]
        
        //菜单的个数  决定动态宽度
        top.tableWidths = [[1.0],[1.0]]
        top.onlyOne = false
        
        self.view.addSubview(top)
        
        
    }
    
    func getCardCategory()
    {
        if DataCache.Share().cardCategory.count > 0
        {
            self.setLeft()
            return
        }
        
        let url = APPURL+"Public/Found/?service=Hyk.getCategory"
        
        XHttpPool.requestJson(url, body: nil, method: .POST) {[weak self] (json) in
            
            if let arr = json?["data"]["info"].array
            {
                for item in arr{
                    
                    let model = CategoryModel.parse(json: item, replace: nil)
                    
                    DataCache.Share().cardCategory.append(model)
                }
                
                self?.setLeft()
            }
        }
    }
    
    func setLeft()
    {
        var arr:[ReactionMenuItemModel] = []
        
        var i = 0
        for item in DataCache.Share().cardCategory
        {
            let model = ReactionMenuItemModel()
            model.id = item.id.numberValue.integerValue
            model.title = item.title
            model.img = item.url
            arr.append(model)
            i += 1
        }
        
        topCellArr[0] = arr
        
        self.top.items = topCellArr
    }
    
    func setRight()
    {
        let tarr = ["打折卡","计次卡","充值卡","积分卡"]
        let idArr = [3,1,2,4]
        
        var arr:[ReactionMenuItemModel] = []
        
        var i = 0
        for item in tarr
        {
            let model = ReactionMenuItemModel()
            model.id = idArr[i]
            model.title = item
            model.img = "right_type_\(i)@2x.png"
            model.sid = "0"
            arr.append(model)
            i += 1
        }
        
        topCellArr[1] = arr
        
        self.top.items = topCellArr
    }
    
    func ReactionBeforeShow(view: ReactionMenuView) {
        
        if view.selectRow == 1
        {
            view.tableBG.frame.origin.x = swidth*0.5
        }
        
    }
    
    
    func ReactionTableHeight(table: UITableView, indexPath: NSIndexPath) -> CGFloat {
        
        if table.frame.size.width != swidth*0.5
        {
            table.frame.size.width = swidth*0.5
        }
        
        if indexPath.row == 0 && top.selectRow == 1
        {
            return 0
        }
        
        return 50.0
    }
    
    func ReactionTableCell(cell: UITableViewCell, model: ReactionMenuItemModel) {
        
        cell.backgroundColor=UIColor.whiteColor()
        
        cell.layer.masksToBounds = true
        cell.clipsToBounds = true
        
        cell.contentView.layer.masksToBounds = true
        cell.contentView.clipsToBounds = true
        
        cell.textLabel?.text = ""
        
        let label = UILabel()
        label.text = model.title
        label.textColor = APPBlackColor
        label.textAlignment = .Center
        cell.contentView.addSubview(label)
        
        let img = UIImageView()
        if model.sid == "0"
        {
            img.image = model.img.image
        }
        else
        {
            img.url = model.img
        }
        
        img.layer.masksToBounds = true
        cell.contentView.addSubview(img)
        
        label.snp_makeConstraints { (make) in
            make.centerY.equalTo(cell.contentView)
        }
        
        img.snp_makeConstraints { (make) in
            make.leading.equalTo(20.0)
            make.centerY.equalTo(cell.contentView)
            make.trailing.equalTo(label.snp_leading).offset(-10.0)
            make.height.equalTo(20.0)
            make.width.equalTo(20.0)
        }
        
    }
    
    func ReactionMenuChoose(arr: Array<ReactionMenuItemModel>, index: Int) {
        
        if index == 0
        {
            top.reSetColumn(1)
            typeid = ""
            category_id = "\(arr[0].id)"
            http()
        }
        else
        {
            typeid = "\(arr[0].id)"
            http()
        }
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let vc = "CardGetedInfoVC".VC("Card") as! CardGetedInfoVC
        
        vc.model = table.httpHandle.listArr[indexPath.row] as! CardModel
        
//        vc.id = model.id
//        
//        vc.SuccessBlock {[weak self]()->Void in
//            
//            if self == nil {return}
//            
//            model.orlq = 1
//            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
//            
//        }
        
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    deinit
    {
        print("MyCardVC deinit !!!!!!!!!!!")
    }
    
}
