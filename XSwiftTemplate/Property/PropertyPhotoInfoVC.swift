//
//  PropertyPhotoInfoVC.swift
//  chengshi
//
//  Created by X on 16/2/24.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class PropertyPhotoInfoVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var tableView: UIView!
    
    @IBOutlet var textField: UITextField!
    
    @IBOutlet var lineH: NSLayoutConstraint!
    
    @IBOutlet var bottomH: NSLayoutConstraint!
    
    @IBOutlet var bottomLine: UIView!
    
    
    
    var subVC:PropertyPhotoInfoTable!
    var model:PropertyPhoteModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        textField.autoHeightOpen(8.0)
        textField.delegate = self
        textField.returnKeyType = .Send
        
        subVC = self.childViewControllers[0] as! PropertyPhotoInfoTable
        
        lineH.constant = 0.34
        bottomLine.backgroundColor = subVC.table.separatorColor
        
        subVC.model = self.model
        subVC.replyView.model = self.model
        subVC.replyView.show()
        subVC.show()
        
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if(textField.text?.trim().length() > 0)
        {
            UIApplication.sharedApplication().keyWindow?.showWaiting()
            
            let txt = textField.text?.trim()
            
            let url = APPURL+"Public/Found/?service=Wuye.addFeedBack"
            
            let body="uid=\(DataCache.Share().userModel.uid)&username=\(DataCache.Share().userModel.username)&fid=\(model.id)&content="+txt!
            
            XHttpPool.requestJson(url, body: body, method: .POST, block: {[weak self] (o) -> Void in
                
                RemoveWaiting()
                
                if(self == nil){return}
                
                if o?["data"].dictionaryValue.count > 0 && o?["data"]["code"].intValue == 0
                {
                    
                    self?.subVC.replyView.toBottom = true
                    self?.subVC.replyView.httpHandle.reSet()
                    self?.subVC.replyView.httpHandle.handle()
                    self?.subVC.table.scrollToRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0), atScrollPosition: .Top, animated: true)
                    
                    textField.text = ""
                    self?.view.endEditing(true)
                    return
                }
                
                var msg = o?["data"]["msg"].stringValue
                msg = (msg==nil || msg=="") ? "发送失败,请重试" : msg
                
                self?.view.showAlert(msg!, block: nil)
                
            })
            
        }
        
        textField.text = ""
        self.view.endEditing(true)
        
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    deinit
    {
        self.textField.autoHeightClose()
        
    }
    

}
