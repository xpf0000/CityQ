//
//  UIViewController.swift
//  OA
//
//  Created by X on 15/5/18.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit

private var backButtonKey : CChar?

extension UIViewController{
    
    func removeAllSubView()
    {
        for view in self.view.subviews
        {
            view.removeFromSuperview()
        }
    }
    
    func checkIsLogin()->Bool
    {
        if(DataCache.Share.userModel.uid == "")
        {
            if(self is XViewController)
            {
                (self as! XViewController).jumpAnimType=AnimatorType.Default
            }
            
            
            let vc:LoginVC = "LoginVC".VC("User") as! LoginVC
            
            let nav:XNavigationController = XNavigationController(rootViewController: vc)
            
            self.presentViewController(nav, animated: true, completion: { () -> Void in
                
                
            })
            
            return false
        }
        
        return true
    }
    
    weak var backButton:UIButton?
        {
        get
        {
            return objc_getAssociatedObject(self, &backButtonKey) as? UIButton
        }
        set(newValue) {
            self.willChangeValueForKey("backButtonKey")
            objc_setAssociatedObject(self, &backButtonKey, newValue,
                .OBJC_ASSOCIATION_ASSIGN)
            self.didChangeValueForKey("backButtonKey")
            
        }
    }
    
    func pop()
    {
        self.view.endEditing(true)
        
        self.navigationController?.popViewControllerAnimated(true)
        
        if(self.navigationController?.viewControllers.count > 1)
        {
            return
        }
        
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    func addBackButton()
    {
        let button=UIButton(type: UIButtonType.Custom)
        button.frame=CGRectMake(0, 0, 22, 22);
        button.setBackgroundImage("back@2x.png".image, forState: UIControlState.Normal)
        button.showsTouchWhenHighlighted = true
        button.exclusiveTouch = true
        button.addTarget(self, action: #selector(pop), forControlEvents: UIControlEvents.TouchUpInside)
        let leftItem=UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem=leftItem;
        
        self.backButton=button
    }
    
    func addSearchButton(block:XButtonBlock)->UIButton
    {
        let button=UIButton(type: UIButtonType.Custom)
        button.click(block)
        button.frame=CGRectMake(0, 0, 21, 21);
        button.setBackgroundImage("search@3x.png".image, forState: UIControlState.Normal)
        button.showsTouchWhenHighlighted = true
        button.exclusiveTouch = true
        let rightItem=UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem=rightItem;
        
        return button
    }
    
    
    func getCamera(block:AnyBlock)
    {
        XCamera.Share().vc = self
        XCamera.Share().block = block
        XCamera.Share().CameraImage()
        
    }
    
    func getPhoteLib(maxNum:UInt,block:AnyBlock)
    {
        XPhotoLib.Share().vc = self
        XPhotoLib.Share().block = block
        XPhotoLib.Share().maxNum = maxNum
        XPhotoLib.Share().getPhoto()
    }
    

}