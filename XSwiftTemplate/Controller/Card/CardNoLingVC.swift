//
//  CardNoLingVC.swift
//  chengshi
//
//  Created by X on 16/6/7.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit


class CardNoLingVC: UIViewController,ReactionMenuDelegate,UITableViewDelegate {
    
    let top = ReactionMenuView()
    
    var topCellArr:Array<Array<ReactionMenuItemModel>> = [[],[]]
    
    let table = XTableView(frame: CGRectMake(0, 43.0*screenFlag, swidth, sheight-64-43.0*screenFlag), style: .Grouped)
    
    
    var category_id = ""
    
    var typeid = ""
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initSelf()
        
    }
    
    func initSelf()
    {
        self.title = "会员卡"
        
        addSearchButton {
            [weak self](btn)->Void in
            
            self?.toSearch()
        }
        
        getCardCategory()
        setRight()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        initSelf()
    }
    
    func toSearch()
    {
        let vc = CardSearchVC()
        let nv = XNavigationController(rootViewController: vc)
        
        self.presentViewController(nv, animated: true) {
            
        }
    }
    
    func http()
    {
        table.httpHandle.reSet()
        table.httpHandle.url = APPURL+"Public/Found/?service=Hyk.getList&category_id="+category_id+"&typeid="+typeid+"&page=[page]&perNumber=20&username=\(DataCache.Share.userModel.username)"
        table.httpHandle.handle()
    }
    
    func userChange()
    {
        http()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(table)
        
        self.addTopBootButton()
        self.view.backgroundColor = APPBGColor
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(userChange), name: NoticeWord.LogoutSuccess.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(userChange), name: NoticeWord.LoginSuccess.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(userChange), name: NoticeWord.CardChanged.rawValue, object: nil)
        
        
        
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
        
        table.Delegate(self)
        
        table.setHandle("", pageStr: "[page]", keys: ["data","info"], model: CardModel.self, CellIdentifier: "CardIndexCell")
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
        if DataCache.Share.cardCategory.count > 0
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
                    
                    var has = false
                    for item in DataCache.Share.cardCategory
                    {
                        if item.id == model.id
                        {
                            has = true
                        }
                    }
                    
                    if !has
                    {
                        DataCache.Share.cardCategory.append(model)
                    }
   
                }
                
                self?.setLeft()
            }
        }
    }
    
    func setLeft()
    {
        var arr:[ReactionMenuItemModel] = []
        
        var i = 0
        for item in DataCache.Share.cardCategory
        {
            let model = ReactionMenuItemModel()
            model.id = item.id.numberValue.integerValue
            model.title = item.title
            model.img = item.url
            arr.append(model)
            i += 1
        }
        
        
        let model = ReactionMenuItemModel()
        model.id = 0
        model.title = "全部"
        model.img = "left_type_0@3x.png"
        arr.insert(model, atIndex: 0)
        
        topCellArr[0] = arr
        
        self.top.items = topCellArr
    }
    
    func setRight()
    {
        let tarr = ["会员卡分类","打折卡","计次卡","充值卡","积分卡"]
        let idArr = [0,3,1,2,4]
        
        var arr:[ReactionMenuItemModel] = []
        
        var i = 0
        for item in tarr
        {
            let model = ReactionMenuItemModel()
            model.id = idArr[i]
            model.title = item
            
            if i != 0
            {
                model.img = "right_type_\(i-1)@2x.png"
            }
            else
            {
                model.img = "left_type_0@3x.png"
            }
            
            
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
        
        if indexPath.row == 0 {return 0}

        return 50.0
    }
    
    
    
    
    func ReactionTableCell(indexPath: NSIndexPath,cell: UITableViewCell, model: ReactionMenuItemModel) {
        
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
        
        if indexPath.row == 0
        {
            img.image = "left_type_0@3x.png".image
        }
        else
        {
            if model.sid == "0"
            {
                img.image = model.img.image
            }
            else
            {
                if indexPath.row == 1
                {
                    img.image = model.img.image
                }
                else
                {
                    img.url = model.img
                }
               
            }

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
