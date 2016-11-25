//
//  CardGetedMainVC.swift
//  chengshi
//
//  Created by X on 2016/11/19.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class CardGetedMainVC: UIViewController {

    weak var subvc:CardGetedInfoVC?
    var model:CardModel!
    
    @IBOutlet var btn: UIButton!
    
    @IBOutlet var btnH: NSLayoutConstraint!
    
    @IBAction func submit(sender: UIButton) {
        
        subvc?.doChongzhi(sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.title = "会员卡详情"
        
        subvc = self.childViewControllers[0] as! CardGetedInfoVC
        subvc?.supervc = self
        subvc?.model = model
        
        
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
