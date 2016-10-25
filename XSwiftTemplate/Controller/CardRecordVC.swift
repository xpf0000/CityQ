//
//  CardRecordVC.swift
//  chengshi
//
//  Created by X on 2016/10/25.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class CardRecordVC: UIViewController {

    @IBOutlet var seg: UISegmentedControl!
    let main = XHorizontalMainView()
    
    var id = ""
    
    func choose(sender: UISegmentedControl) {
        
        main.selectIndex = sender.selectedSegmentIndex
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()

        seg.addTarget(self, action: #selector(choose(_:)), forControlEvents: .ValueChanged)
        
        main.frame = CGRectMake(0, 0, swidth, sheight-64)
        self.view.addSubview(main)
        
        let vc = MyWalletVC()
        vc.id = id
        let vc1 = CardJifenRecordVC()
        vc1.id = id
        
        self.addChildViewController(vc)
        self.addChildViewController(vc1)
        
        let m=XHorizontalMenuModel()
        m.view=vc.view
        
        let m1=XHorizontalMenuModel()
        m1.view=vc1.view
        
        main.menuArr = [m,m1]
        
        main.selectBlock {[weak self] (index) in
        
            if self?.seg.selectedSegmentIndex != index
            {
                self?.seg.selectedSegmentIndex = index
            }
        }
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
}
