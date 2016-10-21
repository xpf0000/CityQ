//
//  JifenCenterMainVC.swift
//  chengshi
//
//  Created by X on 2016/10/20.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class JifenCenterMainVC: UIViewController {

    
    @IBAction func leftClick(sender: UIButton) {
        
        let vc = "JifenCaifuListVC".VC("Jifen")
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func rightClick(sender: UIButton) {
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
