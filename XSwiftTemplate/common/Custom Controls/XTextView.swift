//
//  XTextView.swift
//  lejia
//
//  Created by X on 15/10/15.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class XTextView: UITextView,UITextViewDelegate {

    var placeHolderView:UITextField?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.addEndButton()
    }
    
    func textViewDidChange(textView: UITextView) {
        
        
        
        if(textView.text.length() > 0)
        {
            self.placeHolderView?.hidden = true
        }
        else
        {
            self.placeHolderView?.hidden = false
        }
    }
    
    func placeHolder(str:String)
    {
        self.delegate = self
        placeHolderView = UITextField()
        placeHolderView?.font = UIFont.systemFontOfSize(14.0)
        placeHolderView?.placeholder = str
        placeHolderView?.enabled = false
        self.addSubview(placeHolderView!)
        
        placeHolderView?.frame = CGRectMake(5, 8, 30, 20)
        placeHolderView?.sizeToFit()
        placeHolderView?.frame = CGRectMake(5, 8, (placeHolderView?.frame.size.width)!, (placeHolderView?.frame.size.height)!)
        
    }
    
}
