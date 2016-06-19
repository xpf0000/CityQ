//
//  MyHouseCell.swift
//  chengshi
//
//  Created by X on 16/2/19.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class MyHouseCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    
    @IBOutlet var address: UILabel!
    
    @IBOutlet var lineH: NSLayoutConstraint!
    
    @IBOutlet var defaultButton: UIButton!
    
    @IBOutlet var dlabel: UILabel!
    
    @IBOutlet var dicon: UIImageView!
    
    @IBOutlet var dbutton: UIButton!
    
    
    var model:MyHouseModel!
    {
        didSet
        {
            show()
        }
    }
    
    
    @IBAction func delClick(sender: UIButton) {
       
        self.viewController?.view.showWaiting()
        
        let url="http://101.201.169.38/api/Public/Found/?service=User.delHouse"
        let body="uid=\(DataCache.Share().userModel.uid)&username=\(DataCache.Share().userModel.username)&id=\(model.id)"

        XHttpPool.requestJson(url, body: body, method: .POST) {[weak self] (o) -> Void in
            
            RemoveWaiting()
            
            if o?["data"].dictionaryValue.count > 0 && o?["data"]["code"].intValue == 0
            {
                (self?.viewController as? UserHouseVC)?.del(self!)
                return
            }
            
            var msg = o?["data"]["msg"].stringValue
            msg = (msg==nil || msg=="") ? "删除失败" : msg
            
            self?.viewController?.view.showAlert(msg!, block: nil)

        }
        
        
    }
    
    @IBAction func defaultClick(sender: UIButton) {
        
        if(sender.selected){return}
        
        self.viewController?.view.showWaiting()
        
        let url="http://101.201.169.38/api/Public/Found/?service=User.updateHouse"
        let body="uid=\(DataCache.Share().userModel.uid)&username=\(DataCache.Share().userModel.username)&houseid=\(model.houseid)&fanghaoid=\(model.fanghaoid)"

        XHttpPool.requestJson(url, body: body, method: .POST) {[weak self] (o) -> Void in
            
            RemoveWaiting()
            
            if(self == nil){return}
            
            if o?["data"].dictionaryValue.count > 0 && o?["data"]["code"].intValue == 0
            {
                (self?.viewController as? UserHouseVC)?.setDefault(self!)
                sender.selected = true
                DataCache.Share().userModel.houseid =  self!.model.houseid
                DataCache.Share().userModel.fanghaoid =  self!.model.fanghaoid
                DataCache.Share().userModel.house = self!.model
                DataCache.Share().userModel.save()
                DataCache.Share().userModel.house.checkStatus(false)
                return
            }
            
            var msg = o?["data"]["msg"].stringValue
            msg = (msg==nil || msg=="") ? "设置失败,请重试" : msg
            
            self?.viewController?.view.showAlert(msg!, block: nil)
            
        }

    }
    
    private func show() {
        
        if let m = self.model
        {
            self.name.text = m.xiaoqu
            self.address.text = "房屋地址: "+m.louhao+m.danyuan+m.louceng+m.fanghao
            defaultButton.selected = (DataCache.Share().userModel.fanghaoid == m.fanghaoid)
        }
   
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lineH.constant=0.34
        self.address.preferredMaxLayoutWidth = swidth - 40.0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
