//
//  AboutVC.swift
//  chengshi
//
//  Created by X on 15/12/21.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class AboutModel: Reflect {
    
    var value=""

    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if(value == nil)
        {
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    
}



class AboutVC: UIViewController {
    
    @IBOutlet var version: UILabel!
    
    @IBOutlet var right: UILabel!
    
    @IBOutlet var icon: UIImageView!
    
    
    @IBAction func toRight(sender: AnyObject) {
        
        let vc = HtmlVC()
        vc.title = "免责声明"
        vc.url = "http://101.201.169.38/city/news_info.php?id=6243&type=108"
        
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    lazy var model:AboutModel = AboutModel()
    
    func http()
    {
//        let url=APPURL+"Public/Found/?service=News.getAbout"
//        XHttpPool.requestJson(url, body: nil, method: .GET) { [weak self](o) -> Void in
//            
//            if(o?["data"]["info"][0]["value"] != nil)
//            {
//                self?.model.value = o!["data"]["info"][0]["value"].stringValue
//                self?.textView.text = self?.model.value
//                AboutModel.save(obj: self!.model, name: "AboutModel")
//            }
//            
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        let infoDictionary = NSBundle.mainBundle().infoDictionary
   
        let majorVersion : AnyObject? = infoDictionary! ["CFBundleShortVersionString"]
        
        //let minorVersion : AnyObject? = infoDictionary! ["CFBundleVersion"]
        
        let appversion = majorVersion as! String
        

        version.text = "怀府网 V\(appversion)"
        
//        self.textView.editable = false
//        self.textView.selectable = false
        
//        let m=AboutModel.read(name: "AboutModel")
//        if(m != nil)
//        {
//            model = m as! AboutModel
//        }
        
//        self.textView.text = model.value
//        
//        http()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    
}
