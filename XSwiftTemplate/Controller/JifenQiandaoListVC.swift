//
//  JifenQiandaoListVC.swift
//  chengshi
//
//  Created by X on 2016/10/21.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class JifenQiandaoListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var bgImage: UIImageView!
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var bview: UIView!
    
    @IBOutlet var order: UILabel!
    
    @IBOutlet var header: UIImageView!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var num: UILabel!
    
    let httpHandle = XHttpHandle()
    
    var harr:[Int:CGFloat] = [:]
    
    let h = (swidth-20.0)*0.33*0.56+15+22+12.0+10+20+10+20+10+32
    
    var userPH:HFBModel?
        {
        didSet
        {
            header.url = userPH?.headimage
            order.text = userPH?.pm
            name.text = userPH?.nick
            num.text = "\(userPH!.qdday)天"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        bgImage.image = "qiandaopaihang_\(Int(swidth * screenScale))@2x.jpg".image
        
        let img = "home_head.png".image
        header.placeholder = img
        
        table.separatorStyle = .None
        
        let v = UIView()
        v.frame = CGRectMake(0, 0, swidth, 156.0)
        table.tableHeaderView = v
        
        table.registerNib("JifenCaifuCell1".Nib, forCellReuseIdentifier: "JifenCaifuCell1")
        table.registerNib("JifenCaifuCell2".Nib, forCellReuseIdentifier: "JifenCaifuCell2")
        
        print("table.separatorColor: \(table.separatorColor)")
        
        bview.layer.shadowColor = table.separatorColor?.CGColor
        bview.layer.shadowOffset = CGSizeMake(0, -1.0)
        bview.layer.shadowOpacity = 1.0
        bview.layer.shadowRadius = 1.0
        
        let url = "http://182.92.70.85/hfapi/Public/Found/?service=Jifen.getQDPM&page=[page]&pernumber=20&uid=5"
        
        httpHandle.setHandle(table, url: url, pageStr: "[page]", keys: ["data","info"], model: HFBModel.self)
        
        httpHandle.ResultBlock {[weak self] (o) in
            
            self?.userPH = HFBModel.parse(json: o?["data"]["uinfo"], replace: nil)
        }
        
        table.setHeaderRefresh {
            [weak self] in
            
            self?.httpHandle.reSet()
            self?.httpHandle.handle()
            
        }
        
        table.setFooterRefresh {
            [weak self] in
            
            self?.httpHandle.handle()
        }
        
        httpHandle.handle()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("bview.frame: \(bview.frame)")
        
        
        
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if httpHandle.listArr.count > 0
        {
            let c = httpHandle.listArr.count - 2
            
            if c <= 0 {return 1}
            
            return c
            
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0
        {
            return h
        }
        else
        {
            return 60.0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("JifenCaifuCell1", forIndexPath: indexPath) as! JifenCaifuCell1
            
            cell.dw = "天"
            
            let m1 = httpHandle.listArr[0] as! HFBModel
            m1.pm = "1"
            
            let m2 = httpHandle.listArr[1] as! HFBModel
            m2.pm = "2"
            
            let m3 = httpHandle.listArr[2] as! HFBModel
            m3.pm = "3"
            
            cell.model1 = m1
            cell.model2 = m2
            cell.model3 = m3
            
            
            
            return cell
            
        }
        else
        {
            let m = httpHandle.listArr[indexPath.row+2] as! HFBModel
            
            m.pm = "\(indexPath.row+3)"

            let cell = tableView.dequeueReusableCellWithIdentifier("JifenCaifuCell2", forIndexPath: indexPath) as! JifenCaifuCell2
            
            cell.dw = "天"
            cell.model = m
            
            cell.lasted = indexPath.row+3 == httpHandle.listArr.count
            
            return cell
            
        }
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
