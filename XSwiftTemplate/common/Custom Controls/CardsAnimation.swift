//
//  NatGeoAnimation.swift
//  OA
//
//  Created by X on 15/7/8.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit


class CardsAnimation:NSObject
{
    var type:JumpType=JumpType.Navigation
    var reverse:Bool=false
    var duration:NSTimeInterval=0.0
    weak var fromVC:UIViewController?
    
    override init() {
        self.reverse=jumpAnim.reverse
        self.duration=jumpAnim.duration
        self.type=JumpInteraction.Share.jumpType
    }
    
    func animation(transitionContext:UIViewControllerContextTransitioning,fromView:UIView,toView:UIView)
    {
        let containerView=transitionContext.containerView()
        
        if(self.reverse)
        {
            
            let frame: CGRect = transitionContext.initialFrameForViewController(fromVC!)
            toView.frame = frame
            let scale:CATransform3D = CATransform3DIdentity;
            toView.layer.transform = CATransform3DScale(scale, 0.6, 0.6, 1)
            toView.alpha = 0.6
            
            containerView!.insertSubview(toView, belowSubview: fromView)
            
            var frameOffScreen: CGRect=frame
            frameOffScreen.origin.y = frameOffScreen.size.height
            
            let t1:CATransform3D=self.firstTransform()
            
            UIView.animateKeyframesWithDuration(self.duration, delay: 0, options:UIViewKeyframeAnimationOptions.CalculationModeCubic, animations: { () -> Void in
                
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.5, animations: { () -> Void in
                    fromView.frame = frameOffScreen;
                })
                
                UIView.addKeyframeWithRelativeStartTime(0.35, relativeDuration: 0.35, animations: { () -> Void in
                    toView.layer.transform = t1;
                    toView.alpha = 1.0;
                })
                
                UIView.addKeyframeWithRelativeStartTime(0.75, relativeDuration: 0.25, animations: { () -> Void in
                    toView.layer.transform = CATransform3DIdentity;
                })
 
                }) { (finished) -> Void in
                    
                    toView.layer.transform = CATransform3DIdentity
                    fromView.layer.transform = CATransform3DIdentity
                    containerView!.layer.transform = CATransform3DIdentity
                    toView.alpha = 1.0
                    fromView.alpha = 1.0
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
        else
        {
            
            let frame: CGRect = transitionContext.initialFrameForViewController(fromVC!)
            var offScreenFrame: CGRect=frame
            offScreenFrame.origin.y = offScreenFrame.size.height
            toView.frame = offScreenFrame
            
            containerView!.insertSubview(toView, aboveSubview: fromView)
            
            let t1:CATransform3D=self.firstTransform()
            let t2:CATransform3D=self.secondTransformWithView(fromView)
            
            UIView.animateKeyframesWithDuration(self.duration, delay: 0, options:UIViewKeyframeAnimationOptions.CalculationModeCubic, animations: { () -> Void in
                
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.4, animations: { () -> Void in
                    fromView.layer.transform = t1
                    fromView.alpha = 0.6
                })
                
                UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.4, animations: { () -> Void in
                    fromView.layer.transform = t2
                })
                
                UIView.addKeyframeWithRelativeStartTime(0.6, relativeDuration: 0.2, animations: { () -> Void in
                    toView.frame = CGRectOffset(toView.frame, 0.0, -30.0);
                })
                
                UIView.addKeyframeWithRelativeStartTime(0.8, relativeDuration: 0.2, animations: { () -> Void in
                    toView.frame = frame;
                })
                
                
                }) { (finished) -> Void in
                    
                    toView.layer.transform = CATransform3DIdentity
                    fromView.layer.transform = CATransform3DIdentity
                    containerView!.layer.transform = CATransform3DIdentity
                    
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
        
        
        
        
        
    }
    
    func firstTransform()->CATransform3D
    {
        var t1:CATransform3D = CATransform3DIdentity
        t1.m34 = 1.0/(-900)
        t1 = CATransform3DScale(t1, 0.95, 0.95, 1)
        t1 = CATransform3DRotate(t1, 15.0 * CGFloat(M_PI/180.0), 1, 0, 0)
        return t1
    }

    func secondTransformWithView(view:UIView)->CATransform3D
    {
        var t2:CATransform3D = CATransform3DIdentity
        t2.m34 = self.firstTransform().m34
        t2 = CATransform3DTranslate(t2, 0, view.frame.size.height*(-0.08), 0)
        t2 = CATransform3DScale(t2, 0.8, 0.8, 1)
        
        return t2
    }
    
    
    
}
