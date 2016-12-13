//
//  GroupSearchBarCell.swift
//  chengshi
//
//  Created by X on 2016/11/14.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class GroupSearchBarCell: UITableViewCell,UITextFieldDelegate {

    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet var txtfield: UITextField!
    
    @IBOutlet var btn: UIButton!
    
    var block:XHTMLBlock?
    
    @IBAction func click(_ sender: AnyObject) {
        let str = txtfield.text ?? ""
        block?(str)
    }

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.masksToBounds = true
        mainView.layer.borderColor = "21adfd".color?.CGColor
        mainView.layer.borderWidth = 1.0
        mainView.layer.cornerRadius = 6.0
        
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 6.0
        
        txtfield.delegate = self
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.endEdit()
        
        return true
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
