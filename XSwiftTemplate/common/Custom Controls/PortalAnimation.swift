//
//  PortalAnimation.swift
//  OA
//
//  Created by X on 15/7/8.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit

class PortalAnimation:NSObject
{
    var type:JumpType=JumpType.Navigation
    var reverse:Bool=false
    var duration:NSTimeInterval=0.0
    
    override init() {
        self.reverse=jumpAnim.reverse
        self.duration=jumpAnim.duration
        self.type=JumpInteraction.Share.jumpType
    }
    
    func animation(transitionContext:UIViewControllerContextTransitioning,fromView:UIView,toView:UIView)
    {
        let containerView=transitionContext.containerView()
        if(!self.reverse)
        {
           
            let scale:CATransform3D  = CATransform3DIdentity;
            toView.layer.transform = CATransform3DScale(scale, 0.7, 0.7, 0.8)
            containerView!.addSubview(toView)
         
            let leftSnapshotRegion:CGRect  = CGRectMake(0, 0, fromView.frame.size.width / 2, fromView.frame.size.height)
            let leftHandView:UIView=fromView.resizableSnapshotViewFromRect(leftSnapshotRegion, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
            
            leftHandView.frame = leftSnapshotRegion
            containerView!.addSubview(leftHandView)
            
            let rightSnapshotRegion:CGRect  = CGRectMake(fromView.frame.size.width / 2, 0, fromView.frame.size.width / 2, fromView.frame.size.height)
            
            let rightHandView:UIView=fromView.resizableSnapshotViewFromRect(rightSnapshotRegion, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
            
            rightHandView.frame = rightSnapshotRegion;
            containerView!.addSubview(rightHandView)
            
            fromView.removeFromSuperview()
            
            UIView.animateWithDuration(self.duration, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                
                leftHandView.frame = CGRectOffset(leftHandView.frame, -leftHandView.frame.size.width, 0)
                rightHandView.frame = CGRectOffset(rightHandView.frame, rightHandView.frame.size.width, 0)
                
                toView.layer.transform = CATransform3DScale(scale, 1.0, 1.0, 1)
             
                }) { (finished) -> Void in
                    
                    if(transitionContext.transitionWasCancelled())
                    {
                        self.removeOtherViews(fromView)
                        toView.removeFromSuperview()
                    }
                    else
                    {
                        containerView!.addSubview(toView)
                        self.removeOtherViews(toView)
                        fromView.removeFromSuperview()
                    }
                    
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                    
            }
        }
        else
        {
            containerView!.addSubview(fromView)
            toView.frame = CGRectOffset(toView.frame, toView.frame.size.width, 0);
            containerView!.addSubview(toView)

            let leftSnapshotRegion:CGRect = CGRectMake(0, 0, toView.frame.size.width / 2, toView.frame.size.height);
            let leftHandView:UIView = toView.resizableSnapshotViewFromRect(leftSnapshotRegion, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
            leftHandView.frame = leftSnapshotRegion;
            leftHandView.frame = CGRectOffset(leftHandView.frame, -leftHandView.frame.size.width, 0);
            containerView!.addSubview(leftHandView)
  
            
            // snapshot the right-hand side of the to- view
            let rightSnapshotRegion:CGRect = CGRectMake(toView.frame.size.width / 2, 0, toView.frame.size.width / 2, toView.frame.size.height);
            let rightHandView:UIView = toView.resizableSnapshotViewFromRect(rightSnapshotRegion, afterScreenUpdates: true, withCapInsets:UIEdgeInsetsZero)
            rightHandView.frame = rightSnapshotRegion
            rightHandView.frame = CGRectOffset(rightHandView.frame, rightHandView.frame.size.width, 0)
            containerView!.addSubview(rightHandView)

            
            UIView.animateWithDuration(self.duration, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                
                leftHandView.frame = CGRectOffset(leftHandView.frame, leftHandView.frame.size.width, 0)
                rightHandView.frame = CGRectOffset(rightHandView.frame, -rightHandView.frame.size.width, 0);
                
                let scale:CATransform3D = CATransform3DIdentity
                fromView.layer.transform = CATransform3DScale(scale, 0.8, 0.8, 1)
                
                }) { (finished) -> Void in
                    
                    if(transitionContext.transitionWasCancelled())
                    {
                        self.removeOtherViews(fromView)
                        toView.removeFromSuperview()
                    }
                    else
                    {
                        self.removeOtherViews(toView)
                        toView.frame = containerView!.bounds
                        fromView.removeFromSuperview()
                    }
                    
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                    
            }
        }
        
        
        
        
        
    }
    
    func removeOtherViews(view:UIView)
    {
        let containerView:UIView = view.superview!
        for v in containerView.subviews
        {
            if (v != view) {
                v.removeFromSuperview()
            }
        }
    }

    
}
