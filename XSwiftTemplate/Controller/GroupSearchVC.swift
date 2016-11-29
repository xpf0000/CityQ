//
//  GroupSearchVC.swift
//  chengshi
//
//  Created by X on 2016/11/12.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class GroupSearchVC: UIViewController {

    @IBOutlet var search: GroupSearchView!
    
    @IBOutlet var table: XTableView!
    
    var key:String = ""
    {
        didSet
        {
            search?.txtfield.text = key
            http()
        }
    
    }
    
    func http()
    {
        let url = APPURL+"Public/Found/?service=Hyk.getShopSearch&page=[page]&perNumber=20&keyword="+key
        
        table?.httpHandle.url = url
        table?.httpHandle.reSet()
        table?.httpHandle.handle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "商家搜索"
        self.addBackButton()
        
        search.txtfield.text = key
        
        let url = APPURL+"Public/Found/?service=Hyk.getShopSearch&page=[page]&perNumber=20&keyword="+key
        table.separatorStyle = .None
        table.setHandle(url, pageStr: "[page]", keys: ["data","info"], model: GroupModel.self, CellIdentifier: "GroupSearchCell")
        table.cellHeight = 120
        
        table.show()
        
        search.block = {
        [weak self](str)->Void in
            
            self?.key = str
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
