//
//  TurnAnimation.swift
//  OA
//
//  Created by X on 15/7/8.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit

//旋转方向  轴向
enum TurnDirection : NSInteger{
    case Horizontal
    case Vertical
}


class TurnAnimation:NSObject
{
    var type:JumpType=JumpType.Navigation
    var reverse:Bool=false
    var direction:TurnDirection=TurnDirection.Vertical
    var duration:NSTimeInterval=0.0
    var fromVC:UIViewController?
    
    override init() {
        self.reverse=jumpAnim.reverse
        self.duration=jumpAnim.duration
        self.type=JumpInteraction.Share.jumpType
        self.direction=jumpAnim.turnDirection
    }
    
    func animation(transitionContext:UIViewControllerContextTransitioning,fromView:UIView,toView:UIView)
    {
        let containerView=transitionContext.containerView()
        containerView.addSubview(toView)

        var transform:CATransform3D  = CATransform3DIdentity
        transform.m34 = (-0.002)
        containerView.layer.sublayerTransform = transform
        
        let initialFrame: CGRect = transitionContext.initialFrameForViewController(fromVC!)
        fromView.frame =  initialFrame
        toView.frame = initialFrame
        
        let factor:CGFloat = self.reverse ? 1.0 : -1.0
        
        toView.layer.transform=self.rotate(factor * CGFloat(-M_PI_2))
        
        UIView.animateKeyframesWithDuration(self.duration, delay: 0, options:UIViewKeyframeAnimationOptions.CalculationModeLinear, animations: { () -> Void in
            
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.5, animations: { () -> Void in
                
                fromView.layer.transform = self.rotate(factor * CGFloat(M_PI_2))
                
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: { () -> Void in
                
                toView.layer.transform=self.rotate(0.0)
            })
            
            
            }) { (finished) -> Void in
                
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
    
    func rotate(angle:CGFloat)->CATransform3D
    {
        if (self.direction == TurnDirection.Horizontal)
        {
            return  CATransform3DMakeRotation(angle, 1.0, 0.0, 0.0);
        }
        else
        {
            return  CATransform3DMakeRotation(angle, 0.0, 1.0, 0.0);
        }
    }
    
    
}
