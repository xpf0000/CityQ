//
//  CardIndexVC.swift
//  chengshi
//
//  Created by X on 16/6/7.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

let screenFlag = swidth / 375.0

class CardIndexVC: UIViewController,ReactionMenuDelegate,UITableViewDelegate {

    let main = XHorizontalMainView()

    let v = UIView()
    let v1 = UIView()
    
    @IBOutlet var segment: UISegmentedControl!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.title = "会员卡"
    
        addSearchButton { 
            [weak self](btn)->Void in
            
            self?.toSearch()
        }
 
    }
    
    func toSearch()
    {
        let vc = CardSearchVC()
        let nv = XNavigationController(rootViewController: vc)
        
        self.presentViewController(nv, animated: true) { 
            
        }
    }
    
    func userChange()
    {
        //http()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.view.addSubview(main)

        self.view.backgroundColor = APPBGColor
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(userChange), name: NoticeWord.LogoutSuccess.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(userChange), name: NoticeWord.LoginSuccess.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(userChange), name: NoticeWord.CardChanged.rawValue, object: nil)
        
        
        segment.addTarget(self, action: #selector(changePage(_:)), forControlEvents: .ValueChanged)
        
        main.frame = CGRectMake(0, 0, swidth, sheight-64)
        
        main.selectBlock {[weak self] (index) in
            
            self?.segment.selectedSegmentIndex = index
        }
        
        let model = XHorizontalMenuModel()
        let vc = CardNoLingVC()
        self.addChildViewController(vc)
        model.view = vc.view
        
        let model1 = XHorizontalMenuModel()
        let vc1 = "MyCardVC".VC("User") as! MyCardVC
        vc1.superVC = self
        self.addChildViewController(vc1)
        model1.view = vc1.view

        main.menuArr = [model,model1]
        
    }
    

    
    func changePage(sender:UISegmentedControl)
    {
        
        let index = sender.selectedSegmentIndex
        
        if main.selectIndex != index
        {
            main.selectIndex = index
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}
