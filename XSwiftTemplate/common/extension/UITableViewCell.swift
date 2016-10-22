//
//  UITableViewCell.swift
//  TJQS
//
//  Created by X on 16/8/13.
//  Copyright © 2016年 QS. All rights reserved.
//

import Foundation
import UIKit


extension UITableViewCell{
    
    func deSelect()
    {
        if let table = UIView.findTableView(self)
        {
            if let index = table.indexPathForCell(self)
            {
                table.deselectRowAtIndexPath(index, animated: true)
            }
        }
    }
    
    
}