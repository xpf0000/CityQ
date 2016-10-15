//
//  FlipAnimation.swift
//  OA
//
//  Created by X on 15/7/8.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit

class FlipAnimation:NSObject
{
    var type:JumpType=JumpType.Navigation
    var reverse:Bool=false
    var color:UIColor?
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
        containerView.sendSubviewToBack(toView)
        
        var transform:CATransform3D  = CATransform3DIdentity
        transform.m34 = (-0.002)
        containerView.layer.sublayerTransform = transform
        
        let initialFrame: CGRect = transitionContext.initialFrameForViewController(fromVC!)
        fromView.frame =  initialFrame
        toView.frame = initialFrame
        
        let toViewSnapshots:Array<UIView>=self.createSnapshotFromView(toView, afterUpdates: true)
        var flippedSectionOfToView:UIView=toViewSnapshots[self.reverse ? 0 : 1]
        
        let fromViewSnapshots:Array<UIView>=self.createSnapshotFromView(fromView, afterUpdates: false)
        var flippedSectionOfFromView:UIView=fromViewSnapshots[self.reverse ? 1 : 0]
        
        
        flippedSectionOfFromView=self.addShadowToView(flippedSectionOfFromView, reverse: !self.reverse, afterUpdates: false)
        (flippedSectionOfFromView.subviews[1] ).alpha=0.0
        
        flippedSectionOfToView=self.addShadowToView(flippedSectionOfToView, reverse: self.reverse, afterUpdates: true)
        (flippedSectionOfToView.subviews[1] ).alpha=1.0
        
        self.updateAnchorPointAndOffset(CGPointMake(self.reverse ? 0.0 : 1.0, 0.5), view: flippedSectionOfFromView)
        self.updateAnchorPointAndOffset(CGPointMake(self.reverse ? 1.0 : 0.0, 0.5), view: flippedSectionOfToView)
        
        flippedSectionOfToView.layer.transform = self.rotate(self.reverse ? CGFloat(M_PI_2) : CGFloat(-M_PI_2))
        
        UIView.animateKeyframesWithDuration(self.duration, delay: 0, options:UIViewKeyframeAnimationOptions.CalculationModeLinear, animations: { () -> Void in
            
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.5, animations: { () -> Void in
                
                flippedSectionOfFromView.layer.transform = self.rotate(self.reverse ? CGFloat(-M_PI_2) : CGFloat(M_PI_2))
                (flippedSectionOfFromView.subviews[1] ).alpha=1.0
                
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: { () -> Void in
                
                flippedSectionOfToView.layer.transform = self.rotate(self.reverse ? CGFloat(0.001) : CGFloat(-0.001))
                (flippedSectionOfToView.subviews[1] ).alpha=0.0
                
            })
            
            
        }) { (finished) -> Void in
            
            if(transitionContext.transitionWasCancelled())
            {
                self.removeOtherViews(fromView)
                toView.removeFromSuperview()
            }
            else
            {
                self.removeOtherViews(toView)
                fromView.removeFromSuperview()
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
        
        
        
    }
    
    func rotate(angle:CGFloat)->CATransform3D
    {
        return  CATransform3DMakeRotation(angle, 0.0, 1.0, 0.0)
    }
    
    func updateAnchorPointAndOffset(anchorPoint:CGPoint,view:UIView)
    {
        view.layer.anchorPoint = anchorPoint
        let xOffset:CGFloat =  anchorPoint.x - 0.5
        view.frame = CGRectOffset(view.frame, xOffset * view.frame.size.width, 0)
    }
    
    func createSnapshotFromView(view:UIView,afterUpdates:Bool)->Array<UIView>
    {
        let containerView:UIView=view.superview!
        var snapshotRegion:CGRect = CGRectMake(0, 0, view.frame.size.width / 2, view.frame.size.height)
        let leftHandView:UIView = view.resizableSnapshotViewFromRect(snapshotRegion, afterScreenUpdates: afterUpdates, withCapInsets: UIEdgeInsetsZero)!
        leftHandView.frame = snapshotRegion;
        containerView.addSubview(leftHandView)
        
        snapshotRegion = CGRectMake(view.frame.size.width / 2, 0, view.frame.size.width / 2, view.frame.size.height)
        let rightHandView:UIView = view.resizableSnapshotViewFromRect(snapshotRegion, afterScreenUpdates: afterUpdates, withCapInsets: UIEdgeInsetsZero)!
        rightHandView.frame = snapshotRegion;
        containerView.addSubview(rightHandView)
        
        containerView.sendSubviewToBack(view)
        
        return [leftHandView, rightHandView]

    }
    
    func addShadowToView(view:UIView,reverse:Bool,afterUpdates:Bool)->UIView
    {
        let containerView:UIView=view.superview!
        let viewWithShadow:UIView = UIView(frame: view.frame)
        containerView.insertSubview(viewWithShadow, aboveSubview: view)
        view.removeFromSuperview()

        let shadowView:UIView=UIView(frame: viewWithShadow.bounds)
        
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame = shadowView.bounds
        gradient.colors = [UIColor(white: 0.0, alpha: 0.0).CGColor,UIColor(white: 0.0, alpha: 0.5).CGColor]
        gradient.startPoint = CGPointMake(reverse ? 0.0 : 1.0, 0.0);
        gradient.endPoint = CGPointMake(reverse ? 1.0 : 0.0, 0.0);
        shadowView.layer.insertSublayer(gradient, atIndex: 1)
        
        view.frame = view.bounds;
//        
//        if(!self.reverse && self.type==JumpType.Navigation && afterUpdates)
//        {
//            let v:UIView=UIView(frame:view.bounds)
//            v.backgroundColor=self.color
//            
//            let vv:UIView=UIView(frame:CGRectMake(0, 64, view.bounds.width, view.bounds.height-64))
//            vv.backgroundColor=self.color
//            vv.addSubview(view)
//            vv.layer.masksToBounds=true
//            
//            v.addSubview(vv)
//            viewWithShadow.addSubview(v)
//            
//        }
//        else
//        {
            viewWithShadow.addSubview(view)
        //}
        
        viewWithShadow.addSubview(shadowView)
        
        return viewWithShadow;
        
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
