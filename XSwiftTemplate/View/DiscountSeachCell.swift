//
//  PhoneSeachCell.swift
//  chengshi
//
//  Created by X on 15/11/23.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class DiscountSeachCell: UITableViewCell {

    var block:AnyBlock?
    
    @IBOutlet var textField: UITextField!
    
    
    @IBAction func search(sender: AnyObject) {
        
        if(block != nil)
        {
            self.block!("search")
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.layer.masksToBounds=true
        textField.layer.cornerRadius = 16.0
        textField.layer.borderColor = borderBGC.CGColor
        textField.layer.borderWidth = 0.7
        
        let view=UIView()
        view.frame=CGRectMake(0, 0, 12, 32)
        
        textField.leftViewMode = .Always
        textField.leftView = view
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
