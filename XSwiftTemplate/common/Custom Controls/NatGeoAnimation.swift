//
//  NatGeoAnimation.swift
//  OA
//
//  Created by X on 15/7/8.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit


class NatGeoAnimation:NSObject
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
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        
        var fromLayer:CALayer?
        var toLayer:CALayer?
        
        if(self.reverse)
        {
            toView.userInteractionEnabled=true
            fromLayer = toView.layer
            toLayer = fromView.layer
            
            NatGeoAnimation.sourceLastTransform(fromLayer!)
            NatGeoAnimation.destinationLastTransform(toLayer!)
            
            UIView.animateKeyframesWithDuration(self.duration, delay: 0, options:UIViewKeyframeAnimationOptions.CalculationModeCubic, animations: { () -> Void in
                
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.8, animations: { () -> Void in
                    
                    NatGeoAnimation.sourceFirstTransform(fromLayer!)
                    
                })
                
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1.0, animations: { () -> Void in
                    
                    NatGeoAnimation.destinationFirstTransform(toLayer!)
                })
                
                
                }) { (finished) -> Void in
                    
                    toView.layer.transform = CATransform3DIdentity
                    fromView.layer.transform = CATransform3DIdentity
                    containerView.layer.transform = CATransform3DIdentity
                    
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
            
            fromView.userInteractionEnabled = false
            
            fromLayer = fromView.layer
            toLayer = toView.layer
            
            let oldFrame:CGRect = fromLayer!.frame
            fromLayer!.anchorPoint=CGPointMake(0.0,0.5)
            fromLayer!.frame=oldFrame
     
            NatGeoAnimation.sourceFirstTransform(fromLayer!)
            NatGeoAnimation.destinationFirstTransform(toLayer!)
            
            
            UIView.animateKeyframesWithDuration(self.duration, delay: 0, options:UIViewKeyframeAnimationOptions.CalculationModeCubic, animations: { () -> Void in
                
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1.0, animations: { () -> Void in
                    NatGeoAnimation.destinationLastTransform(toLayer!)
                })
                
                UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.8, animations: { () -> Void in
                    NatGeoAnimation.sourceLastTransform(fromLayer!)
                })
                
                
                }) { (finished) -> Void in
                    
                    toView.layer.transform = CATransform3DIdentity
                    fromView.layer.transform = CATransform3DIdentity
                    containerView.layer.transform = CATransform3DIdentity
                    
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
    
    static func sourceFirstTransform(layer:CALayer) {
    var t:CATransform3D = CATransform3DIdentity
    t.m34 = 1.0 / -500
    t = CATransform3DTranslate(t, 0.0, 0.0, 0.0)
    layer.transform = t
    }
    
    static func sourceLastTransform(layer:CALayer) {
    var t:CATransform3D = CATransform3DIdentity
    t.m34 = 1.0 / -500.0;
    t = CATransform3DRotate(t, radianFromDegree(80), 0.0, 1.0, 0.0);
    t = CATransform3DTranslate(t, 0.0, 0.0, -30.0);
    t = CATransform3DTranslate(t, 170.0, 0.0, 0.0);
    layer.transform = t;
    }
    
    static func destinationFirstTransform(layer:CALayer)
    {
    var t:CATransform3D = CATransform3DIdentity
    t.m34 = 1.0 / -500.0
    // Rotate 5 degrees within the axis of z axis
    t = CATransform3DRotate(t, radianFromDegree(5.0), 0.0, 0.0, 1.0)
    // Reposition toward to the left where it initialized
    t = CATransform3DTranslate(t, 320.0, -40.0, 150.0)
    // Rotate it -45 degrees within the y axis
    t = CATransform3DRotate(t, radianFromDegree(-45), 0.0, 1.0, 0.0)
    // Rotate it 10 degrees within thee x axis
    t = CATransform3DRotate(t, radianFromDegree(10), 1.0, 0.0, 0.0)
    layer.transform = t
    }
    
    static func destinationLastTransform(layer:CALayer) {
        var t:CATransform3D = CATransform3DIdentity
        t.m34 = 1.0/(-500)
        // Rotate to 0 degrees within z axis
        t = CATransform3DRotate(t, radianFromDegree(0), 0.0, 0.0, 1.0)
        // Bring back to the final position
        t = CATransform3DTranslate(t, 0.0, 0.0, 0.0)
        // Rotate 0 degrees within y axis
        t = CATransform3DRotate(t, radianFromDegree(0), 0.0, 1.0, 0.0)
        // Rotate 0 degrees within  x axis
        t = CATransform3DRotate(t, radianFromDegree(0), 1.0, 0.0, 0.0)
        layer.transform = t;
    }

    
    static func radianFromDegree(degrees:CGFloat)->CGFloat
    {
        return CGFloat(degrees / 180.0) * CGFloat(M_PI)
    }
    
    
}
