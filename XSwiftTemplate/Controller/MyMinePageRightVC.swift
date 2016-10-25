//
//  MyMinePageRightVC.swift
//  chengshi
//
//  Created by X on 2016/10/25.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyMinePageRightVC: UIViewController {

    @IBOutlet var sex: UILabel!
    
    @IBOutlet var birthday: UILabel!
    
    @IBOutlet var tel: UILabel!
    
    
    @IBAction func btnClick(sender: UIButton) {
        
        let vc:EditUserInfoVC = "EditUserInfoVC".VC("User") as! EditUserInfoVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(DataCache.Share.userModel.sex == "0")
        {
            self.sex.text = "女"
        }
        else
        {
            self.sex.text = "男"
        }

        birthday.text = DataCache.Share.userModel.birthday
        
        
        if Umobile.length() > 7
        {
            tel.text = Umobile.subStringToIndex(3)+"****"+Umobile.subStringFromIndex(7)
        }
        else
        {
            tel.text = "暂未绑定手机号"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }


}
