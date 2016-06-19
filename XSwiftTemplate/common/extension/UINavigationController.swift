//
//  UINavigationController.swift
//  OA
//
//  Created by X on 15/7/8.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit
extension UINavigationController{
    
    func pushVC(viewController: UIViewController, animated: Bool,type:AnimatorType)
    {
        if(self is XNavigationController)
        {
            (self as! XNavigationController).pushViewController(viewController, animated: animated, type: type)
        }
    }
}