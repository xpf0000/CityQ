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
    
    var rightBtn:UIButton?
    
    @IBAction func toGetCard(sender: AnyObject) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.title = "我的会员卡"
        addBackButton()
        rightBtn = addSearchButton {
            [weak self](btn)->Void in
            
            self?.toSearch()
        }
        
    }
    
    func toSearch()
    {
        let vc = "CardMoneyInfoVC".VC("Card")
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rightBtn?.hidden = true
        
        //self.view.addSubview(table)
        
        //self.addTopBootButton()
        
        table.backgroundColor = UIColor.whiteColor()
        
        let header = UIView()
        header.backgroundColor = UIColor.whiteColor()
        header.frame = CGRectMake(0, 0, swidth, 15.0)
        table.tableHeaderView = header
        
        let footer = UIView()
        footer.backgroundColor = UIColor.clearColor()
        footer.frame = CGRectMake(0, 0, swidth, 34.0)
        table.tableFooterView = footer
        
        table.separatorStyle = .None
        
        table.registerNib("CardIndexCell".Nib, forCellReuseIdentifier: "CardIndexCell")
        table.CellIdentifier = "CardIndexCell"
        table.cellHeight = 145
        
        for _ in 0...12
        {
            table.httpHandle.listArr.append(CardModel())
        }
        
        table.reloadData()
        
        table.Delegate(self)
        
        
    }
    
    ////顶部button
    func addTopBootButton(){
        
        top.tbHeight = 200.0
        top.tbWidth = swidth * 0.5
        top.frame = CGRectMake(0, 0, swidth, 45)
        
        top.delegate = self
        
        //设置菜单的父视图
        top.superView = self.view
        //菜单的选项
        top.titles = ["全部分类","会员卡分类"]
        
        //菜单的个数  决定动态宽度
        top.tableWidths = [[1.0],[1.0]]
        top.onlyOne = false
        
        var tarr = ["全部分类","汽车服务","丽人","服饰"]
        
        var arr:[ReactionMenuItemModel] = []
        var i = 0
        for str in tarr
        {
            let model = ReactionMenuItemModel()
            model.id = i+1
            model.title = str
            model.img = "left_type_\(i)@2x.png"
            
            arr.append(model)
            
            i += 1
        }
        
        topCellArr[0] = arr
        
        
        tarr.removeAll(keepCapacity: false)
        arr.removeAll(keepCapacity: false)
        
        tarr = ["打折卡","计次卡","充值卡","积分卡"]
        i = 0
        for str in tarr
        {
            let model = ReactionMenuItemModel()
            model.id = i+1
            model.title = str
            model.img = "right_type_\(i)@2x.png"
            
            arr.append(model)
            
            i += 1
        }
        
        topCellArr[1] = arr
        
        tarr.removeAll(keepCapacity: false)
        arr.removeAll(keepCapacity: false)
        
        self.top.items = topCellArr
        self.view.addSubview(top)
        
        
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
        
        if indexPath.row == 0
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
        img.image = model.img.image
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
        
        print(index)
        
        if index == 0
        {
            top.reSetColumn(1)
        }
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
