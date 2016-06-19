//
//  UserHouseVC.swift
//  chengshi
//
//  Created by X on 16/2/19.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class UserHouseVC: UIViewController {

    @IBOutlet var table: XTableView!
    
    @IBOutlet var addButton: SkyRadiusView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBackButton()
    
        let url = "http://101.201.169.38/api/Public/Found/?service=User.getHouseList&uid=\(DataCache.Share().userModel.uid)&username=\(DataCache.Share().userModel.username)"
        
        table.setHandle(url, pageStr: "[page]", keys: ["data","info"], model: MyHouseModel.self, CellIdentifier: "MyHouseCell")
        
        self.table.cellHeight = 166-0.68
        self.table.CellIdentifier = "MyHouseCell"
        self.table.httpHandle.pageSize = 10000
        self.table.show()
        self.table.footRefresh?.hidden = true
        self.table.footRefresh?.alpha = 0.0
        
        self.table.httpHandle.AfterBlock(
            {[weak self]
                (o)->Void in
                
                if(self == nil)
                {
                    return
                }
                
                if(self!.table.httpHandle.listArr.count == 1)
                {
                    
                    if(DataCache.Share().userModel.house.houseid.numberValue.intValue == 0)
                    {
                        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                        var temp = self?.table.cellForRowAtIndexPath(indexPath) as? MyHouseCell
                        
                        if temp == nil
                        {
                            temp = self?.table.dequeueReusableCellWithIdentifier("MyHouseCell", forIndexPath: indexPath) as? MyHouseCell
                            temp?.model = self!.table.httpHandle.listArr[0] as! MyHouseModel
                        }
                        
                        temp?.defaultClick(temp!.defaultButton)
                    }
                    
                    DataCache.Share().userModel.house = self!.table.httpHandle.listArr[0] as! MyHouseModel
                    
                    
                }
                
                
        })

        
    }
    
    
    func del(cell:MyHouseCell)
    {
        let model = cell.model
        
        var indexPath = self.table.indexPathForCell(cell)
        
        if(indexPath != nil)
        {
            self.table.httpHandle.listArr.removeAtIndex(indexPath!.row)
            self.table.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Left)
        }
        
        if self.table.httpHandle.listArr.count == 0
        {
            DataCache.Share().userModel.house = MyHouseModel()
            DataCache.Share().userModel.houseid =  ""
            DataCache.Share().userModel.fanghaoid =  ""
            DataCache.Share().userModel.save()
            self.clearnDefault()
            return
        }
        
        indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let temp = self.table.cellForRowAtIndexPath(indexPath!) as? MyHouseCell

        if DataCache.Share().userModel.house.fanghaoid == model.fanghaoid
        {
            if temp != nil{
                DataCache.Share().userModel.house = temp!.model
            }
            else{

                DataCache.Share().userModel.house = MyHouseModel()
                
            }
            
            temp?.defaultClick(temp!.defaultButton)
        }
        
        DataCache.Share().userModel.houseid =  DataCache.Share().userModel.house.houseid
        DataCache.Share().userModel.fanghaoid =  DataCache.Share().userModel.house.fanghaoid
        
        DataCache.Share().userModel.save()
        
        
    }
    
    func clearnDefault()
    {
        let url="http://101.201.169.38/api/Public/Found/?service=User.updateHouse"
        let body="uid=\(DataCache.Share().userModel.uid)&username=\(DataCache.Share().userModel.username)&houseid=&fanghaoid="
        
        XHttpPool.requestJson(url, body: body, method: .POST) { (o) -> Void in
            
        }
    }
    
    func setDefault(cell:MyHouseCell)
    {
        for i in 0...self.table.httpHandle.listArr.count-1
        {
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            let temp = self.table.cellForRowAtIndexPath(indexPath) as? MyHouseCell
            
            if(temp != cell)
            {
                temp?.defaultButton.selected = false
            }
  
        }

    }
    
    
    deinit
    {

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    


}
