//
//  PhoneVC.swift
//  chengshi
//
//  Created by X on 15/11/23.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class PhoneVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var menu: XHorizontalMenuView!
    
    @IBOutlet var searchTxt: XCornerRadiusTextField!
    
    @IBOutlet var searchBtn: UIButton!
    
    @IBOutlet var main: XHorizontalMainView!
    
    
    var httpHandle:XHttpHandle=XHttpHandle()
    lazy var classArr:[XHorizontalMenuModel] = []
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.title = "常用电话"
        self.getCategory()
        
        
    }
    
    
    func getCategory()
    {
        self.classArr.removeAll(keepCapacity: false)
        
        
        let m = XHorizontalMenuModel()
        m.id = 0
        m.title = "热门号码"
        
        let table = XTableView()
        
        table.registerNib("PhoneCell".Nib, forCellReuseIdentifier: "PhoneCell")
        table.cellHeight = 75+16
        
        let u = APPURL+"Public/Found/?service=Tel.getHot&page=[page]&perNumber=20"
        
        table.setHandle(u, pageStr: "[page]", keys: ["data","info"], model: PhoneModel.self, CellIdentifier: "PhoneCell")
        
        table.show()
        
        m.view = table
        
        self.classArr.append(m)
        
        
        let url=APPURL+"Public/Found/?service=Tel.getCategory"
        
        XHttpPool.requestJson(url, body: nil, method: .GET) { (o) -> Void in
            
            if(o == nil)
            {
                self.menu.menuArr = self.classArr
                return
            }
            
            for item in o!["data"]["info"].arrayValue
            {
                let model:CategoryModel = CategoryModel.parse(json: item, replace: nil)
                
                let m = XHorizontalMenuModel()
                m.id = model.id.numberValue.integerValue
                m.title = model.title
                
                let table = XTableView()
                
                table.registerNib("PhoneCell".Nib, forCellReuseIdentifier: "PhoneCell")
                table.cellHeight = 75+16
                
                let url = APPURL+"Public/Found/?service=Tel.getList&category_id=\(m.id)&perNumber=20&page=[page]"
                
                table.setHandle(url, pageStr: "[page]", keys: ["data","info"], model: PhoneModel.self, CellIdentifier: "PhoneCell")
                
                table.show()
                
                m.view = table
                
                self.classArr.append(m)
            }

            self.menu.menuArr = self.classArr

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBackButton()
        
        let v = UIView(frame: CGRectMake(0,0,12,30))
        searchTxt.leftViewMode = .Always
        searchTxt.leftView = v
        
        searchTxt.addEndButton()
        
        let m = XCornerRadiusModel()
        m.CornerRadiusType = [.TopLeft,.BottomLeft]
        m.BorderSidesType = [.Left,.Top,.Bottom]
        m.BorderLineWidth = 1.5
        m.StrokeColor = APPBlueColor
        m.StrokePath = true
        m.CornerRadius = 8.0
   
        searchTxt.XCornerRadius = m
        
        let m1 = XCornerRadiusModel()
        m1.CornerRadiusType = [.TopRight,.BottomRight]
        m1.FillColor = APPBlueColor
        m1.FillPath = true
        m1.CornerRadius = 8.0
        
        searchBtn.XCornerRadius = m1
        
        searchBtn.click {[weak self] (sender) in
            
            self?.toSearch()
        }
        
        main.menu = menu
        menu.menuSelectColor = APPBlueColor
        menu.menuTextColor = APPBlackColor
        menu.menuBGColor = UIColor.whiteColor()
        menu.line.hidden = true
        menu.menuMaxScale = 1.2
        menu.mutableMenuWidth = true
        menu.menuArr = classArr
 
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.endEdit()
        
        toSearch()
        
        return true
    }
    
    func toSearch()
    {
        let vc:PhoneSearchVC = "PhoneSearchVC".VC as! PhoneSearchVC
        vc.isSearchVC = true
        
        if searchTxt.text!.trim() != ""
        {
            vc.searchText = searchTxt.text!.trim()
        }
        
        let nv:XNavigationController = XNavigationController(rootViewController: vc)
        
        self.presentViewController(nv, animated: true, completion: { () -> Void in
            
        })

    }

    deinit
    {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

    

}
