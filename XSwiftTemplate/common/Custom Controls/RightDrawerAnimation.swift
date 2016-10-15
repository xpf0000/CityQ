//
//  RightDrawerAnimation.swift
//  OA
//
//  Created by X on 15/7/8.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit


class RightDrawerAnimation:NSObject
{
    var type:JumpType=JumpType.Navigation
    var reverse:Bool=false
    var duration:NSTimeInterval=0.0
    weak var fromVC:UIViewController?
    weak var toVC:UIViewController?
    
    override init() {
        self.reverse=jumpAnim.reverse
        self.duration=0.25
        self.type=JumpInteraction.Share.jumpType
    }
    
    func animation(transitionContext:UIViewControllerContextTransitioning,fromView:UIView,toView:UIView)
    {
        let containerView=transitionContext.containerView()
        
        if(self.reverse)
        {
            containerView.removeAllSubViews()
            
            containerView.addSubview(fromView)
            containerView.addSubview(toView)

            UIView.animateWithDuration(self.duration, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                
                toView.layer.transform = CATransform3DIdentity
                
                }, completion: { (complete) -> Void in
                    


                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                    
                    if(!transitionContext.transitionWasCancelled())
                    {
                        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: false)
                        
                        toView.userInteractionEnabled=true
                        toView.removeFromSuperview()
                        fromView.removeFromSuperview()
                        
                        if(self.toVC?.tabBarController != nil)
                        {
                            let index:Int = self.toVC!.tabBarController!.selectedIndex
                            var temp:Int = 0
                            if(index == 0)
                            {
                                temp = self.toVC!.tabBarController!.viewControllers!.count-1
                            }
                            
                            self.toVC?.tabBarController?.selectedIndex = temp
                            self.toVC?.tabBarController?.selectedIndex = index
                            
                        }
                    }
                    
                    JumpInteraction.Share.running=false
                    
                    
            })
            
        }
        else
        {
            fromView.userInteractionEnabled=false
            let frame: CGRect = CGRectMake(0, 0, swidth, sheight)
            toView.frame = frame
            fromView.frame = transitionContext.initialFrameForViewController(fromVC!)
            
            containerView.insertSubview(toView, belowSubview: fromView)
            containerView.sendSubviewToBack(toView)
            
            containerView.addSubview(fromView)

            let scale:CATransform3D = CATransform3DMakeTranslation(-swidth*0.55, 0, 0)
            let transform = CATransform3DScale(scale, 0.88, 0.88, 1)
            
            fromView.layer.transform = CATransform3DIdentity
        
            UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
            
            UIView.animateWithDuration(self.duration, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                
                fromView.layer.transform = transform
                
                
                }, completion: { (complete) -> Void in
                    
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                    
                    if(transitionContext.transitionWasCancelled())
                    {
                        fromView.layer.transform = CATransform3DIdentity
                        fromView.userInteractionEnabled=true
                        fromView.removeFromSuperview()
                        toView.removeFromSuperview()
                        if(self.fromVC?.tabBarController != nil)
                        {
                            let index:Int = self.fromVC!.tabBarController!.selectedIndex
                            var temp:Int = 0
                            if(index == 0)
                            {
                                temp = self.fromVC!.tabBarController!.viewControllers!.count-1
                            }
                            
                            self.fromVC?.tabBarController?.selectedIndex = temp
                            
                            self.fromVC?.tabBarController?.selectedIndex = index
                            
                        }
                        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
                    }
                    
                    
                    JumpInteraction.Share.running=false
            })
            
        }
        
    }

    
}
