//
//  JumpInteraction.swift
//  OA
//
//  Created by X on 15/7/6.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation

class JumpInteraction : UIPercentDrivenInteractiveTransition
{
    weak var navigationController:XNavigationController?
    var recognizer:UIPanGestureRecognizer?
    var interacting:Bool=false
    var beginPoint:CGPoint?
    var complete:Bool=false
    var completeProgress:CGFloat = 0.45
    weak var fromVC:UIViewController?
    weak var toVC:UIViewController?
    var jumpType:JumpType=JumpType.Navigation
    var running = false
    var reserve = false
    static let Share = JumpInteraction.init()
    
    private override init() {
        super.init()
        
        recognizer = UIPanGestureRecognizer(target: self, action: "handlePopRecognizer:")
        
        //self.completionSpeed = 0.9
        
        //self.completionCurve = .EaseIn
    }
    
  
    func addRecognizer()
    {
        
        UIApplication.sharedApplication().keyWindow?.removeGestureRecognizer(self.recognizer!)
        recognizer?.delaysTouchesBegan
        UIApplication.sharedApplication().keyWindow?.addGestureRecognizer(recognizer!)
    }
    
    func removeRecognizer()
    {
        UIApplication.sharedApplication().keyWindow?.removeGestureRecognizer(self.recognizer!)
        completeProgress = 0.45
    }

    
    func handlePopRecognizer(recoginzer:UIPanGestureRecognizer)
    {
        // we get the touch position by the window's coordinate
        // 我们得到的触摸位置的窗口的坐标
        let touchPoint:CGPoint = recoginzer.locationInView(UIApplication.sharedApplication().keyWindow)
        // begin paning, show the backgroundView(last screenshot),if not exist, create it.
        // 开始位置调整，显示backgroundView （最后一个截图） ，如果不存在，则创建它。
        
        switch recoginzer.state
        {
        case .Began:
            
            if running {return}
            running=true
            reserve = false
            beginPoint=touchPoint

            self.interacting = true
            // If the viewControllers has only one vc or disable the interaction, then return.
            //如果viewControllers只有一个VC或禁用的交互，然后返回。
            
            switch self.jumpType
            {
            case .Navigation:
                if (self.navigationController?.viewControllers.count <= 1)
                {
                    return
                }
                self.navigationController!.popViewControllerAnimated(true)
                
            case .Model:
                
                self.toVC?.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                })
                
            case .TabBar:
                ""
            }
            
           
            
        case .Changed:
            
            if(self.interacting)
            {
                let juli:CGFloat=touchPoint.x-self.beginPoint!.x
                
                if(juli>0)
                {
                    self.updateInteractiveTransition(juli/swidth)
                    self.complete=(juli/swidth>completeProgress)
                }
                else
                {
                    reserve = true
                }
            }
            
        case .Ended,.Cancelled :
            
            if(self.interacting)
            {
                self.interacting=false
                
                if(!self.complete)
                {
                    self.cancelInteractiveTransition()
                }
                else
                {
                    if !reserve
                    {
                        self.finishInteractiveTransition()
                        self.removeRecognizer()
                    }
                    else
                    {
                        self.cancelInteractiveTransition()
                    }
                    
                }
                
            }
    
        default:
            
            self.cancelInteractiveTransition()
        }
        
    }
    
    
    
    

    deinit
    {
        removeRecognizer()
    }
    
}


