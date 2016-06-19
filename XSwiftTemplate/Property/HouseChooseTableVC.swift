//
//  HouseChooseTableVC.swift
//  chengshi
//
//  Created by X on 16/3/26.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class HouseChooseTableVC: UITableViewController {

    
    @IBOutlet var button1: UIButton!
    
    @IBOutlet var button2: UIButton!
    
    @IBOutlet var button3: UIButton!
    
    @IBOutlet var button4: UIButton!
    
    @IBOutlet var button5: UIButton!
    
    @IBOutlet var button6: UIButton!
    
    @IBOutlet var title3: UILabel!
    
    @IBOutlet var title4: UILabel!
    
    @IBOutlet var title5: UILabel!
    
    @IBOutlet var title6: UILabel!
    
    
    var model1:MyHouseModel?
    var model2:MyHouseModel?
    var model3:MyHouseModel?
    var model4:MyHouseModel?
    var model5:MyHouseModel?
    var model6:MyHouseModel?
    
    var type = 1
    
    func typeChange(i:Int)
    {
        model1 = nil
        model2 = nil
        model3 = nil
        model4 = nil
        model5 = nil
        model6 = nil
        
        self.type = i+1
        
        let s1 = "点击选择区/镇"
        let s2 = "点击选择小区"
        var s3 = "点击选择楼号"
        var s4 = "点击选择单元"
        let s5 = "点击选择楼层"
        let s6 = "点击选择房号"
        
        
        if i == 0
        {
            title5.hidden = false
            title6.hidden = false
            button5.hidden = false
            button6.hidden = false
            title3.text = "楼号:"
            title4.text = "单元:"
        }
        else
        {
            title5.hidden = true
            title6.hidden = true
            button5.hidden = true
            button6.hidden = true
            title3.text = "区域:"
            title4.text = "门牌:"
            
            s3 = "点击选择区域"
            s4 = "点击选择门牌号"
            
        }
        
        button1.setTitle(s1, forState: .Normal)
        button2.setTitle(s2, forState: .Normal)
        button3.setTitle(s3, forState: .Normal)
        button4.setTitle(s4, forState: .Normal)
        button5.setTitle(s5, forState: .Normal)
        button6.setTitle(s6, forState: .Normal)
    }
    
    func showChoose()
    {
        var s3 = ""
        var s4 = ""
        
        let s1 = model1 == nil ? "点击选择区/镇" : model1?.title
        let s2 = model2 == nil ? "点击选择小区" : model2?.title
        if self.type == 1
        {
            s3 = model3 == nil ? "点击选择楼号" : model3!.title
            s4 = model4 == nil ? "点击选择单元" : model4!.title
        }
        else
        {
            s3 = model3 == nil ? "点击选择区域" : model3!.title
            s4 = model4 == nil ? "点击选择门牌" : model4!.title
        }
        
        let s5 = model5 == nil ? "点击选择楼层" : model5?.title
        let s6 = model6 == nil ? "点击选择房号" : model6?.title
        
        button1.setTitle(s1, forState: .Normal)
        button2.setTitle(s2, forState: .Normal)
        button3.setTitle(s3, forState: .Normal)
        button4.setTitle(s4, forState: .Normal)
        button5.setTitle(s5, forState: .Normal)
        button6.setTitle(s6, forState: .Normal)
    }

    @IBAction func buttonClick(sender: UIButton) {
        
        var vc:UserHouseChooseVC?
        var ptitle = ""
        
        if(sender == button1)
        {
            vc = UserHouseChooseVC()
            vc?.pushVC = self
            vc?.pid = "0"
            vc?.index = "0"
            ptitle = "选择区镇"
        }
        else if(sender == button2)
        {
            if let model = model1
            {
                vc = UserHouseChooseVC()
                vc?.pushVC = self
                vc?.pid = model.id
                ptitle = "选择小区"
                vc?.index = "1"
            }
            else
            {
                ShowMessage("请先选择区镇")
                return
            }
        }
        else if(sender == button3)
        {
            if let model = model2
            {
                vc = UserHouseChooseVC()
                vc?.pushVC = self
                vc?.pid = model.id
                ptitle = type == 1 ? "选择楼号" : "选择区域"
                vc?.index = "2"
            }
            else
            {
                ShowMessage("请先选择小区")
                return
            }
        }
        else if(sender == button4)
        {
            if let model = model3
            {
                vc = UserHouseChooseVC()
                vc?.pushVC = self
                vc?.pid = model.id
                ptitle = type == 1 ? "选择单元" : "选择门牌"
                vc?.index = "3"
            }
            else
            {
                ShowMessage("请先选择楼号")
                return
            }
        }
        else if(sender == button5)
        {
            if let model = model4
            {
                vc = UserHouseChooseVC()
                vc?.pushVC = self
                vc?.pid = model.id
                ptitle = "选择楼层"
                vc?.index = "4"
            }
            else
            {
                ShowMessage("请先选择单元")
                return
            }
        }
        else if(sender == button6)
        {
            if let model = model5
            {
                vc = UserHouseChooseVC()
                vc?.pushVC = self
                vc?.pid = model.id
                ptitle = "选择房号"
                vc?.index = "5"
            }
            else
            {
                ShowMessage("请先选择楼层")
                return
            }
        }
        
        
        vc?.type = "\(type)"
        vc?.title = ptitle
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        button1.layer.borderColor = UIColor.lightGrayColor().CGColor
        button1.layer.borderWidth = 0.7
        button1.layer.masksToBounds = true
        button1.layer.cornerRadius = 8.0
        
        button2.layer.borderColor = UIColor.lightGrayColor().CGColor
        button2.layer.borderWidth = 0.7
        button2.layer.masksToBounds = true
        button2.layer.cornerRadius = 8.0
        
        button3.layer.borderColor = UIColor.lightGrayColor().CGColor
        button3.layer.borderWidth = 0.7
        button3.layer.masksToBounds = true
        button3.layer.cornerRadius = 8.0
        
        button4.layer.borderColor = UIColor.lightGrayColor().CGColor
        button4.layer.borderWidth = 0.7
        button4.layer.masksToBounds = true
        button4.layer.cornerRadius = 8.0
        
        button5.layer.borderColor = UIColor.lightGrayColor().CGColor
        button5.layer.borderWidth = 0.7
        button5.layer.masksToBounds = true
        button5.layer.cornerRadius = 8.0
        
        button6.layer.borderColor = UIColor.lightGrayColor().CGColor
        button6.layer.borderWidth = 0.7
        button6.layer.masksToBounds = true
        button6.layer.cornerRadius = 8.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }


}
