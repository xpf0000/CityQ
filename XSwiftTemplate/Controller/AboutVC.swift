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

    @IBOutlet var textView: UITextView!
    
    @IBOutlet var version: UILabel!
    
    @IBOutlet var right: UILabel!
    
    @IBOutlet var icon: UIImageView!
    
    
    @IBAction func toRight(sender: AnyObject) {
    }
    
    
    lazy var model:AboutModel = AboutModel()
    
    func http()
    {
        let url="http://101.201.169.38/api/Public/Found/?service=News.getAbout"
        XHttpPool.requestJson(url, body: nil, method: .GET) { [weak self](o) -> Void in
            
            if(o?["data"]["info"][0]["value"] != nil)
            {
                self?.model.value = o!["data"]["info"][0]["value"].stringValue
                self?.textView.text = self?.model.value
                AboutModel.save(obj: self!.model, name: "AboutModel")
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        self.textView.editable = false
        self.textView.selectable = false
        
        let m=AboutModel.read(name: "AboutModel")
        if(m != nil)
        {
            model = m as! AboutModel
        }
        
        self.textView.text = model.value
        
        http()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    
}
