//
//  NatGeoAnimation.swift
//  OA
//
//  Created by X on 15/7/8.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit


class CubeAnimation:NSObject
{
    var type:JumpType=JumpType.Navigation
    var reverse:Bool=false
    var duration:NSTimeInterval=0.0
    var fromVC:UIViewController?
    
    override init() {
        self.reverse=jumpAnim.reverse
        self.duration=jumpAnim.duration
        self.type=JumpInteraction.Share.jumpType
    }
    
    func animation(transitionContext:UIViewControllerContextTransitioning,fromView:UIView,toView:UIView)
    {
        let containerView=transitionContext.containerView()
        fromView.translatesAutoresizingMaskIntoConstraints = true
        toView.translatesAutoresizingMaskIntoConstraints = true
        
        if(self.type == .Navigation)
        {
            if(!self.reverse)
            {
                for v in toView.subviews
                {
                    v.translatesAutoresizingMaskIntoConstraints=false
                }
            }
        }
        
        
        

        let dir:CGFloat = self.reverse ? 1.0 : -1.0
        var viewFromTransform:CATransform3D?
        var viewToTransform:CATransform3D?
        
        viewFromTransform = CATransform3DMakeRotation(dir*CGFloat(M_PI_2), 0.0, 1.0, 0.0)
        viewToTransform = CATransform3DMakeRotation((-dir)*CGFloat(M_PI_2), 0.0, 1.0, 0.0)
        toView.layer.anchorPoint=CGPointMake(dir==1.0 ? 0 : 1, 0.5)
        fromView.layer.anchorPoint=CGPointMake(dir==1.0 ? 1 : 0, 0.5)

        containerView.transform=CGAffineTransformMakeTranslation(dir*(containerView.frame.size.width)/2.0, 0)
   
        viewFromTransform!.m34 = -1.0 / 200.0
        viewToTransform!.m34 = -1.0 / 200.0
        toView.layer.transform = viewToTransform!
        
        let fromShadow:UIView = self.addOpacityToView(fromView, color: "#000000".color!)
        let toShadow:UIView = self.addOpacityToView(toView, color: "#000000".color!)
        fromShadow.alpha=0.0
        toShadow.alpha=1.0
        containerView.addSubview(toView)
        
        UIView.animateWithDuration(self.duration, animations: { () -> Void in
            
            containerView.transform=CGAffineTransformMakeTranslation(-dir*containerView.frame.size.width/2.0, 0)
            fromView.layer.transform = viewFromTransform!
            toView.layer.transform = CATransform3DIdentity
            fromShadow.alpha=1.0
            toShadow.alpha=0.0
   
        }) { (finished) -> Void in
            
            toView.layer.transform = CATransform3DIdentity
            fromView.layer.transform = CATransform3DIdentity
            containerView.layer.transform = CATransform3DIdentity
            fromView.layer.anchorPoint=CGPointMake(0.5, 0.5)
            toView.layer.anchorPoint=CGPointMake(0.5, 0.5)
            fromShadow.removeFromSuperview()
            toShadow.removeFromSuperview()
            
            if(transitionContext.transitionWasCancelled())
            {
                toView.removeFromSuperview()
            }
            else
            {
                fromView.removeFromSuperview()
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            
        }
        
        
        
        
    }
    
    func addOpacityToView(view:UIView,color:UIColor)->UIView
    {
        let shadowView:UIView = UIView(frame: view.bounds)
        shadowView.backgroundColor=color.colorWithAlphaComponent(0.8)
        view.addSubview(shadowView)
        return shadowView
    }
    
    
}
