//
//  ChooseHouseVC.swift
//  chengshi
//
//  Created by X on 16/2/20.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class ChooseHouseVC: XViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var head: UIImageView!
    
    @IBOutlet var button: UIButton!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var tel: UILabel!
    
    @IBOutlet var table: XTableView!
    
    let bgPathLayer = CAShapeLayer()
    weak var pushVC:PropertyIndexVC?
    
    let httpHandle = XHttpHandle()
    
    @IBAction func toBack(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) { () -> Void in
            
            
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        head.layer.cornerRadius = swidth*0.61*0.2*0.5
        head.layer.borderColor = UIColor.whiteColor().CGColor
        head.layer.borderWidth = 1.8
        head.layer.masksToBounds = true
        head.placeholder = "userHeader.png".image
        head.url = DataCache.Share.userModel.headimage
        
        name.text = "业主"+DataCache.Share.userModel.nickname
        var txt = DataCache.Share.userModel.mobile
        
        if(DataCache.Share.userModel.uid == "")
        {
            txt = "请先登录"
        }
        else
        {
            txt = txt == "" ? "尚未绑定号码" : txt
        }
        
        tel.text = txt
        
        bgPathLayer.frame = CGRectMake(0, 0, 24, 24)
        bgPathLayer.lineWidth = 2.0
        bgPathLayer.fillColor = UIColor.clearColor().CGColor
        bgPathLayer.strokeColor = UIColor.whiteColor().CGColor
        bgPathLayer.strokeEnd = 1.0
        bgPathLayer.lineCap = kCALineCapRound
        button.layer.addSublayer(bgPathLayer)
        
        let path1 = CGPathCreateMutable();
        
        CGPathMoveToPoint(path1, nil, 10, 0)
        CGPathAddLineToPoint(path1, nil, 24, 14);
        CGPathMoveToPoint(path1, nil, 24, 0)
        CGPathAddLineToPoint(path1, nil, 10, 14);
        
        bgPathLayer.path = path1
        
        
        let view=UIView()
        view.backgroundColor=UIColor.clearColor()
        table.tableFooterView = view
        table.tableHeaderView = view
        
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        httpHandle.url = APPURL+"Public/Found/?service=User.getHouseList&uid=\(DataCache.Share.userModel.uid)&username=\(DataCache.Share.userModel.username)"
        httpHandle.pageStr = "[page]"
        httpHandle.keys = ["data","info"]
        httpHandle.modelClass = MyHouseModel.self
        httpHandle.pageSize = 10000
        httpHandle.scrollView = self.table
        
        httpHandle.handle()
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return httpHandle.listArr.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 56.0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view=UIView()
        view.frame = CGRectMake(0, 0, swidth*0.61, 44.0)
        view.backgroundColor = "4669b3".color
        
        let label=UILabel()
        label.frame = CGRectMake(8, 0, swidth*0.61-8,44.0 )
        label.font = UIFont.systemFontOfSize(14.0)
        label.textColor = UIColor.whiteColor()
        label.text = "业主小区"
        
        view.addSubview(label)
        
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.selectionStyle = .None
        
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.contentView.removeAllSubViews()
        
        let model = httpHandle.listArr[indexPath.row] as! MyHouseModel
        
        let xiaoqu=UILabel()
        xiaoqu.frame = CGRectMake(12, 8, swidth*0.61-12-28, 20.0)
        xiaoqu.font = UIFont.systemFontOfSize(15.5)
        xiaoqu.textColor = UIColor.whiteColor()
        xiaoqu.text = model.xiaoqu
        
        let fanghao=UILabel()
        fanghao.frame = CGRectMake(12, 28, swidth*0.61-12-28,20.0)
        fanghao.font = UIFont.systemFontOfSize(14.0)
        fanghao.textColor = UIColor.whiteColor()
        fanghao.text = model.louhao+model.fanghao
        
        let rimg=UIImageView()
        rimg.frame=CGRectMake(swidth*0.61-26, (60-16)/2.0, 16, 16)
        rimg.image="go_arrow_icon.png".image
        cell.contentView.addSubview(rimg)
        
        cell.contentView.addSubview(xiaoqu)
        cell.contentView.addSubview(fanghao)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        MainDo { (o) -> Void in
            
            DataCache.Share.userModel.house = self.httpHandle.listArr[indexPath.row] as! MyHouseModel
            
            self.dismissViewControllerAnimated(true) { () -> Void in
                
                
            }
        }
        
        
        
    }
    

    deinit
    {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
