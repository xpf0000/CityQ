//
//  MutalReactionMenuView.swift
//  lejia
//
//  Created by X on 15/9/21.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

typealias reactionMenuBlock = (Array<ReactionMenuItemModel>,Int)->Void

@objc protocol ReactionMenuDelegate:NSObjectProtocol{
    //回调方法
    optional func ReactionMenuChoose(arr:Array<ReactionMenuItemModel>,index:Int)
    
    optional func ReactionTableHeight(table:UITableView,indexPath:NSIndexPath)->CGFloat
    
    optional func ReactionTableCell(cell:UITableViewCell,model:ReactionMenuItemModel)
    
    optional func ReactionBeforeShow(view:ReactionMenuView)
}

class ReactionMenuItemModel :NSObject{
    var title:String=""
    var id:Int=0
    var sid = ""
    var img = ""
    var fatherid:Int=0

    func toString()
    {
        
    }
}

class ReactionMenuView: UIView,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate{
    
    @IBOutlet var bottomLine: UIView!
    @IBOutlet var LineHeight: NSLayoutConstraint!
    @IBOutlet var collection: UICollectionView!
    
    var block:reactionMenuBlock?
    
    weak var superView:UIView?
    
    var bgView: UIView=UIView(frame: CGRectMake(0, 0, swidth, 0))
    
    var tableBG: SkyRadiusView=SkyRadiusView(frame: CGRectMake(0, 0, swidth, 0))
    
    var titlesBack:Array<String>=[]
    var titles:Array<String>=[]
    
    var items:Array<Array<ReactionMenuItemModel>> = []
    
    var width:CGFloat=0.0
    var height:CGFloat=0.0
    var cellWidth:CGFloat=0.0
    var tableWidths:Array<Array<CGFloat>>=[];
    var selectRow:Int = -1
    var tapGR:UITapGestureRecognizer?
    var nowTable:UITableView?
    var tablesData:Array<Array<ReactionMenuItemModel>> = []
    
    weak var delegate:ReactionMenuDelegate?
    
    var onlyOne:Bool = false
    
    var tbWidth = swidth
    var tbHeight = sheight * 0.55
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func initSelf()
    {
        let containerView:UIView=("ReactionMenuView".Nib.instantiateWithOwner(self, options: nil))[0] as! UIView
        
        let newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        containerView.frame = newFrame
        self.addSubview(containerView)
        
        bottomLine.backgroundColor="d7d7d7".color
        LineHeight.constant=0.4
        
        self.collection.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        self.bgView.backgroundColor=UIColor(red: 80.0/255.0, green: 80.0/255.0, blue: 80.0/255.0, alpha: 0.5)
        self.bgView.userInteractionEnabled=true
        
        tableBG.bottomLeftRadius = true
        tableBG.bottomRightRadius = true
        tableBG.cornerRadius = 6.0
        self.tableBG.backgroundColor=UIColor.whiteColor()
        self.tableBG.layer.masksToBounds=true
        
        self.tableBG.layer.shadowOffset = CGSizeMake(0, 10); //设置阴影的偏移量
        self.tableBG.layer.shadowRadius = 5;  //设置阴影的半径
        self.tableBG.layer.shadowColor = UIColor.blackColor().CGColor; //设置阴影的颜色为黑色
        self.tableBG.layer.shadowOpacity = 0.4; //设置阴影的不透明度
        
        tapGR = UITapGestureRecognizer(target: self, action: #selector(ReactionMenuView.hideDropDown))
        tapGR!.delegate=self;
        tapGR!.numberOfTapsRequired = 1;
        
    }
    
    func doSelect(indexPath:NSIndexPath)
    {
        self.collection.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
        
        if(self.bgView.frame.size.height > 0)
        {
            self.hideDropDown()
            return
        }
        
        self.show(indexPath)
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initSelf()
        
    }
    
    func Block(block:reactionMenuBlock)
    {
        self.block = block
    }
    
    func setTable()
    {
        let frame=self.superview?.convertRect(self.frame, toView: self.superView!)
        
        if(self.bgView.frame.size.height > 0)
        {
            self.hideDropDown()
            
            return
        }
        
        
        self.bgView.frame=CGRectMake(frame!.origin.x, frame!.origin.y+frame!.size.height, swidth, 0)
        self.tableBG.frame=CGRectMake(frame!.origin.x, frame!.origin.y+frame!.size.height, tbWidth, 0)
        
        self.bgView.addGestureRecognizer(tapGR!)
        self.superView!.insertSubview(self.bgView, belowSubview: self)
        self.superView!.insertSubview(self.tableBG, belowSubview: self)
        
        if(self.selectRow < self.tableWidths.count)
        {
            let arr:Array<CGFloat>? = self.tableWidths[self.selectRow]
            if(arr != nil)
            {
                var i=0
                var c:CGFloat=0.0
                for w in arr!
                {
                    c=c+w
                    
                    let h = self.tbHeight > 0.0 ? self.tbHeight : sheight*0.55-self.height-10
                    
                    let table:UITableView=UITableView(frame: CGRectMake((c-arr![i])*swidth, 0, swidth*w, h))
                    
                    table.userInteractionEnabled = true;
                    table.scrollEnabled = true;
                    table.bounces=true;
                    table.backgroundColor = UIColor.whiteColor()
                    table.showsVerticalScrollIndicator=false;
                    table.showsHorizontalScrollIndicator=false;
                    table.separatorStyle=UITableViewCellSeparatorStyle.None;
                    
                    table.separatorInset=UIEdgeInsetsZero
                    if(IOS_Version>=8.0)
                    {
                        if #available(iOS 8.0, *) {
                            table.layoutMargins=UIEdgeInsetsZero
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    
                    table.tag=100+i
                    let view:UIView = UIView()
                    view.backgroundColor = UIColor.clearColor()
                    table.tableFooterView=view
                    table.tableHeaderView=view
                    
                    table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
                    self.tableBG.addSubview(table)

                    table.delegate = self;
                    table.dataSource = self;
                    
                    if(i==0)
                    {
                        table.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.None)
                    }
                    
                    i += 1
                }
            }
        }
        
        delegate?.ReactionBeforeShow?(self)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.bgView.frame.size.height=sheight
            
            self.tableBG.frame.size.height = self.tbHeight
            
        }) { (finish) -> Void in
            
            self.tableBG.layer.masksToBounds=false
        }
        
        
    }
    
    func hideDropDown()
    {
        self.tableBG.layer.masksToBounds=true
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.bgView.frame.size.height = 0.0
            self.tableBG.frame.size.height = 0.0
            
        }) { (finish) -> Void in
            
            self.tablesData.removeAll(keepCapacity: false)
            self.nowTable = nil
            self.tableBG.removeAllSubViews()
            self.tableBG.removeFromSuperview()
            self.bgView.removeFromSuperview()
            self.bgView.removeGestureRecognizer(self.tapGR!)
            self.selectRow = -1
        }
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if(self.cellWidth == 0)
        {
            self.titlesBack=self.titles
            self.superView?.clipsToBounds=false;
            self.superView?.layer.masksToBounds=false;
            
            self.width=self.frame.size.width
            self.height=self.frame.size.height
            self.cellWidth=self.width/CGFloat(titles.count)
            self.collection.reloadData()
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        
        return CGSizeMake(self.width/CGFloat(titles.count), self.height)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        
        cell.contentView.removeAllSubViews()
        
        let title:String=self.titles[indexPath.row]
        
        let label:UILabel=UILabel(frame: CGRectMake(0, 0, self.cellWidth, self.height))
        label.font=UIFont.systemFontOfSize(16*screenFlag)
        label.textAlignment=NSTextAlignment.Center
        
        if indexPath.row == selectRow
        {
            label.textColor=APPBlueColor
        }
        else
        {
            label.textColor=APPBlackColor
        }
        
        label.text=title
        
        cell.contentView.addSubview(label)
        //MARK: - 三角
        let sanjiao:UIImageView=UIImageView()
        sanjiao.image="more_sanjiao@2x.png".image
        sanjiao.frame=CGRectMake(self.cellWidth-29*screenFlag, self.frame.size.height-17*screenFlag, 9*screenFlag, 9*screenFlag)
        
        cell.contentView.addSubview(sanjiao)
        //MARK: - 优惠topButton里面的两条竖线
        if(indexPath.row != self.titles.count-1)
        {
            let line:UIView=UIView(frame: CGRectMake(self.cellWidth-0.4, 10, 0.4, self.height-20))
            line.backgroundColor=UIColor.grayColor()
            cell.contentView.addSubview(line)
        }
        
        return cell;
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if(self.bgView.frame.size.height > 0)
        {
            self.hideDropDown()
            return
        }
        
        self.show(indexPath)
    }
    
    func show(indexPath: NSIndexPath)
    {
        self.nowTable=nil
        self.selectRow=indexPath.row
        self.setTableDataSouce()
        self.setTable()
    }
    
    func setTableDataSouce()
    {
        if(self.items.count == 0 || self.selectRow >= self.items.count)
        {
            return
        }
        
        let arr:Array<ReactionMenuItemModel>=self.items[self.selectRow]
        
        if(self.nowTable == nil)
        {
            self.tablesData.removeAll(keepCapacity: false)
            
            for i in 0..<self.tableWidths[self.selectRow].count
            {
                self.tablesData.append([])
                
                if(i==0)
                {
                    let model:ReactionMenuItemModel=ReactionMenuItemModel()
                    model.title="全部"
                    self.tablesData[i].append(model)
                    
                    for item in arr
                    {
                        if(item.fatherid == 0)
                        {
                            self.tablesData[i].append(item)
                        }
                    }
                }
                else
                {
                    let model:ReactionMenuItemModel=ReactionMenuItemModel()
                    model.title="全部"
                    self.tablesData[i].append(model)
                    
                    for item1 in self.tablesData[i-1]
                    {
                        for item in arr
                        {
                            if(item.fatherid == item1.id && item.fatherid > 0)
                            {
                                self.tablesData[i].append(item)
                            }
                        }
                    }
                }
                
            }
            
            for view in self.tableBG.subviews
            {
                if(view is UITableView)
                {
                    (view as! UITableView).reloadData()
                }
            }
            
        }
        else
        {
            let index:Int=self.nowTable!.tag-100
            let model:ReactionMenuItemModel=self.tablesData[index][self.nowTable!.indexPathForSelectedRow!.row]
            
            self.tablesData.removeRange((index + 1)..<self.tableWidths[self.selectRow].count)
            
            for i in index+1..<self.tableWidths[self.selectRow].count
            {
                self.tablesData.append([])
                
                if(i==index+1)
                {
                    let model1:ReactionMenuItemModel=ReactionMenuItemModel()
                    model1.title="全部"
                    self.tablesData[i].append(model1)
                    
                    if(model.fatherid == 0 && model.id == 0)
                    {
                        for item1 in self.tablesData[index]
                        {
                            for item in arr
                            {
                                if(item.fatherid == item1.id && item.fatherid > 0)
                                {
                                    self.tablesData[i].append(item)
                                }
                            }
                        }
                        
                    }
                    else
                    {
                        for item in arr
                        {
                            if(item.fatherid == model.id)
                            {
                                self.tablesData[i].append(item)
                            }
                        }
                    }
                    
                    
                }
                else
                {
                    let model2:ReactionMenuItemModel=ReactionMenuItemModel()
                    model2.title="全部"
                    self.tablesData[i].append(model2)
                    
                    for item1 in self.tablesData[i-1]
                    {
                        for item in arr
                        {
                            if(item.fatherid == item1.id && item.fatherid > 0)
                            {
                                self.tablesData[i].append(item)
                            }
                        }
                    }
                }
                
                
            }
            
            for view in self.tableBG.subviews
            {
                if(view is UITableView)
                {
                    if(view.tag>100+index)
                    {
                        (view as! UITableView).reloadData()
                    }
                    
                }
            }
            
        }
        
        
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.separatorInset=UIEdgeInsetsZero
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                cell.layoutMargins=UIEdgeInsetsZero
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let tag:Int=tableView.tag-100
        
        let model:ReactionMenuItemModel=tablesData[tag][indexPath.row]

        var cell:UITableViewCell?=tableView.dequeueReusableCellWithIdentifier("tableCell")
        if(cell == nil)
        {
            cell=UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "tableCell")
        }
        
        cell!.contentView.removeAllSubViews()
        cell!.textLabel?.textAlignment=NSTextAlignment.Center
        cell!.selectedBackgroundView=UIView(frame: cell!.frame)
        
        if(tableView.tag % 2 == 0)
        {
            cell!.backgroundColor=UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.0)
            cell!.selectedBackgroundView?.backgroundColor=UIColor.whiteColor()
            
        }
        else
        {
            cell!.backgroundColor=UIColor.whiteColor()
            cell!.selectedBackgroundView?.backgroundColor=UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.0)
            
        }
        
        cell?.textLabel?.text=model.title
        
        delegate?.ReactionTableCell?(cell!, model: model)
        
        return cell!
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if let h = delegate?.ReactionTableHeight?(tableView, indexPath: indexPath)
        {
            return h
        }
        else
        {
            return 44
        }
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let tag:Int=tableView.tag-100
        
        if(tag < tablesData.count)
        {
            return tablesData[tag].count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.nowTable=tableView
        
        if(tableView.tag-100 <  self.tableWidths[self.selectRow].count-1)
        {
            self.setTableDataSouce()
        }
        else
        {
            if(onlyOne && indexPath.row==0)
            {
                return
            }
            
            var resultArr:Array<ReactionMenuItemModel>=[]
            
            var changed:Bool=false
            
            for i in 0..<self.tableWidths[self.selectRow].count
            {
                let table:UITableView=self.tableBG.viewWithTag(100+i) as! UITableView
                var index:Int?=table.indexPathForSelectedRow?.row
                index = index == nil ? 0 : index
                
                resultArr.append(self.tablesData[i][index!])
                
                if(self.tablesData[i][index!].id>0 || self.tablesData[i][index!].sid != "")
                {
                    self.titles[self.selectRow]=self.tablesData[i][index!].title
                    changed=true
                }
            }
            
            if(!changed)
            {
                self.titles[self.selectRow]=self.titlesBack[self.selectRow]
            }
            
            self.collection.reloadData()
            
            if(self.block != nil)
            {
                self.block!(resultArr,selectRow)
            }
            
            self.delegate?.ReactionMenuChoose?(resultArr, index: selectRow)
            
            self.hideDropDown()
        }
        
        
    }
    
    func reSetColumn(c:Int)
    {
        self.titles[c]=self.titlesBack[c]
        self.collection.reloadData()
    }
    
    
    
    deinit
    {
        self.block = nil
        self.delegate = nil
        self.titles.removeAll(keepCapacity: false)
        self.items.removeAll(keepCapacity: false)
        self.tableWidths.removeAll(keepCapacity: false)
        self.tablesData.removeAll(keepCapacity: false)
        self.nowTable = nil
        self.tableBG.removeAllSubViews()
        self.bgView.removeGestureRecognizer(self.tapGR!)
    }
    
}
