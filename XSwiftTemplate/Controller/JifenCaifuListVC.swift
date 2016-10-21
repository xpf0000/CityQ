//
//  JifenCaifuListVC.swift
//  chengshi
//
//  Created by X on 2016/10/21.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class JifenCaifuListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var bgImage: UIImageView!

    @IBOutlet var table: UITableView!
    
    @IBOutlet var bview: UIView!
    
    @IBOutlet var order: UILabel!
    
    @IBOutlet var header: UIImageView!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var num: UILabel!
    
    
    var harr:[Int:CGFloat] = [:]
    
    let h = (swidth-20.0)*0.33*0.56+15+22+12.0+10+20+10+20+10+32

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        bgImage.image = "caifupaihang_\(Int(swidth * screenScale))@2x.jpg".image
        
        table.separatorStyle = .None
        
        let v = UIView()
        v.frame = CGRectMake(0, 0, swidth, 156.0)
        table.tableHeaderView = v

        table.registerNib("JifenCaifuCell1".Nib, forCellReuseIdentifier: "JifenCaifuCell1")
        
        print("table.separatorColor: \(table.separatorColor)")
        
        bview.layer.shadowColor = table.separatorColor?.CGColor
        bview.layer.shadowOffset = CGSizeMake(0, -1.0)
        bview.layer.shadowOpacity = 1.0
        bview.layer.shadowRadius = 1.0

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("bview.frame: \(bview.frame)")
        
        
        
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
//        if let h = harr[indexPath.row]
//        {
//            return h
//        }
//        else
//        {
//            let cell = tableView.dequeueReusableCellWithIdentifier("JifenCaifuCell1") as? JifenCaifuCell1
//            
//            if let h = cell?.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
//            {
//                harr[indexPath.row] = h
//                
//                return h
//            }
//        }
        
        
        return h
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("JifenCaifuCell1", forIndexPath: indexPath)
        
        
        return cell
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
