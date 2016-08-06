//
//  UserAddHouseVC.swift
//  chengshi
//
//  Created by X on 16/2/19.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class UserAddHouseVC: UIViewController {

    weak var subVC:HouseChooseTableVC!
    weak var pushVC:UserHouseVC?
    
    @IBAction func submit(sender: UIButton) {
        
        var id = ""
        
        if subVC.type == 1
        {
            if subVC?.model6 == nil
            {
                ShowMessage("有选项尚未选择,请先选择")
                return
            }
            id = subVC!.model6!.id
        }
        else
        {
            if subVC?.model4 == nil
            {
                ShowMessage("有选项尚未选择,请先选择")
                return
            }
            id = subVC!.model4!.id
        }
        
        let houseid = subVC!.model2!.id
        
        sender.enabled = false
        self.view.showWaiting()
        
        let url=APPURL+"Public/Found/?service=User.addHouse"
        let body="uid=\(DataCache.Share.userModel.uid)&username=\(DataCache.Share.userModel.username)&fanghaoid=\(id)&houseid=\(houseid)"

        XHttpPool.requestJson(url, body: body, method: .POST) {[weak self] (o) -> Void in
            
            RemoveWaiting()
            
            if o?["data"].dictionaryValue.count > 0 && o?["data"]["code"].intValue == 0
            {
                self?.view.showAlert("添加成功", block: { (o) -> Void in
                    self?.pushVC?.table.httpHandle.reSet()
                    self?.pushVC?.table.httpHandle.handle()
                    self?.pop()
                })
                
                return
            }
            
            var msg = o?["data"]["msg"].stringValue
            msg = (msg==nil || msg=="") ? "添加失败" : msg
            
            self?.view.showAlert(msg!, block: nil)
            sender.enabled = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        subVC = self.childViewControllers[0] as? HouseChooseTableVC
        
        let index=self.navigationController?.viewControllers.indexOf(self)
        
        pushVC = self.navigationController?.viewControllers[index!-1] as? UserHouseVC
        
        
    }
    
    @IBAction func chooseType(sender: UISegmentedControl) {
        
        subVC.typeChange(sender.selectedSegmentIndex)
 
    }
    

    deinit
    {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
