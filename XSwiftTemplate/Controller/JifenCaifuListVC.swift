//
//  JifenCaifuListVC.swift
//  chengshi
//
//  Created by X on 2016/10/21.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class JifenCaifuListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var table: UITableView!
    
    @IBOutlet var bview: UIView!
    
    @IBOutlet var order: UILabel!
    
    @IBOutlet var header: UIImageView!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var num: UILabel!
    
    
    var harr:[Int:CGFloat] = [:]
    
    let h = (swidth-20.0)*0.33*0.6+10+22+12.0+10+20+10+20+10+40

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()

        table.registerNib("JifenCaifuCell1".Nib, forCellReuseIdentifier: "JifenCaifuCell1")
        
        
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
