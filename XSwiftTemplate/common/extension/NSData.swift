//
//  NSData.swift
//  lejia
//
//  Created by X on 15/11/3.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import Foundation
import UIKit

extension NSData{

    var string:String?
        {
    
          return  String(data: self, encoding: NSUTF8StringEncoding)

    }
}

