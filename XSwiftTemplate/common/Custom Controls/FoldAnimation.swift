//
//  FoldAnimation.swift
//  OA
//
//  Created by X on 15/7/8.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit

class FoldAnimation:NSObject
{
    var type:JumpType=JumpType.Navigation
    var reverse:Bool=false
    var color:UIColor?
    var duration:NSTimeInterval=0.0
    
    override init() {
        self.reverse=jumpAnim.reverse
        self.duration=jumpAnim.duration
        self.type=JumpInteraction.Share.jumpType
    }
    
    func animation(transitionContext:UIViewControllerContextTransitioning,fromView:UIView,toView:UIView)
    {
        let containerView=transitionContext.containerView()
        self.color=toView.backgroundColor
        toView.frame = CGRectOffset(toView.frame, toView.frame.size.width, 0);
        
        containerView.addSubview(toView)
        
        var transform:CATransform3D  = CATransform3DIdentity
        transform.m34 = (-0.005)
        containerView.layer.sublayerTransform = transform
        
        let size:CGSize  = toView.frame.size
        
        let foldWidth:CGFloat  = size.width * CGFloat(0.5) / CGFloat(2.0)
        
        var fromViewFolds:Array<UIView>=[]
        var toViewFolds:Array<UIView>=[]
        
        for i in 0..<2
        {
            let offset:CGFloat  = CGFloat(i) * foldWidth * CGFloat(2)
            
            let leftFromViewFold:UIView=self.createSnapshotFromView(fromView, afterUpdates: false, offset: offset, left: true)
            leftFromViewFold.layer.position = CGPointMake(offset, size.height/2)
            fromViewFolds.append(leftFromViewFold)
            (leftFromViewFold.subviews)[1].alpha=0.0
            
            let rightFromViewFold:UIView=self.createSnapshotFromView(fromView, afterUpdates: false, offset: offset+foldWidth, left: false)
            rightFromViewFold.layer.position = CGPointMake(offset + foldWidth * 2, size.height/2)
            fromViewFolds.append(rightFromViewFold)
            (rightFromViewFold.subviews)[1].alpha=0.0
            
            let leftToViewFold:UIView=self.createSnapshotFromView(toView, afterUpdates: true, offset: offset, left: true)
            leftToViewFold.layer.position = CGPointMake(reverse ? size.width : 0.0, size.height/2)
            leftToViewFold.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI_2), CGFloat(0.0), CGFloat(1.0), CGFloat(0.0))
            
            toViewFolds.append(leftToViewFold)
            
            let rightToViewFold:UIView=self.createSnapshotFromView(toView, afterUpdates: true, offset: offset + foldWidth, left: false)
            rightToViewFold.layer.position = CGPointMake(reverse ? size.width : 0.0, size.height/2)
            rightToViewFold.layer.transform=CATransform3DMakeRotation(CGFloat(-M_PI_2), CGFloat(0.0), CGFloat(1.0), CGFloat(0.0))
            
            toViewFolds.append(rightToViewFold)
            
        }
        
        fromView.frame = CGRectOffset(fromView.frame, fromView.frame.size.width, 0);
  
        UIView.animateWithDuration(self.duration, animations: { () -> Void in
            
            for i in 0..<2
            {
                let offset:CGFloat  = CGFloat(i) * foldWidth * 2
                
                let leftFromView : UIView = fromViewFolds[i*2];
                leftFromView.layer.position = CGPointMake(self.reverse ? 0.0 : size.width, size.height/2);
                leftFromView.layer.transform = CATransform3DRotate(transform,CGFloat(M_PI_2), CGFloat(0.0), CGFloat(1.0), CGFloat(0));
                (leftFromView.subviews)[1].alpha=1.0
                
                let rightFromView:UIView = fromViewFolds[i*2+1];
                rightFromView.layer.position = CGPointMake(self.reverse ? 0.0 : size.width, size.height/2);
                rightFromView.layer.transform = CATransform3DRotate(transform,CGFloat(-M_PI_2), CGFloat(0.0), CGFloat(1.0), CGFloat(0))
                (rightFromView.subviews)[1].alpha=1.0
                
                
                let leftToView:UIView = toViewFolds[i*2];
                leftToView.layer.position = CGPointMake(offset, size.height/2);
                leftToView.layer.transform = CATransform3DIdentity;
                (leftToView.subviews)[1].alpha=0.0
                
                let rightToView:UIView = toViewFolds[i*2+1];
                rightToView.layer.position = CGPointMake(offset + foldWidth * 2, size.height/2);
                rightToView.layer.transform = CATransform3DIdentity;
                (rightToView.subviews)[1].alpha=0.0
                
                
            }
            
            
            }) { (finished) -> Void in
                
                for view in toViewFolds
                {
                    view.removeFromSuperview()
                }
                for view in fromViewFolds
                {
                    view.removeFromSuperview()
                }
                toViewFolds.removeAll(keepCapacity: false)
                fromViewFolds.removeAll(keepCapacity: false)
                toView.frame = containerView.bounds;
                fromView.frame = containerView.bounds;
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
    
    func createSnapshotFromView(view:UIView,afterUpdates:Bool,offset:CGFloat,left:Bool)->UIView
    {
        let size:CGSize  = view.frame.size
        let containerView:UIView  = view.superview!
        let foldWidth:CGFloat  = size.width * 0.5 / CGFloat(2.0)
        
        var snapshotView:UIView?
        
        if (!afterUpdates) {

            let snapshotRegion:CGRect  = CGRectMake(offset, 0.0, foldWidth, size.height);
            
            snapshotView=view.resizableSnapshotViewFromRect(snapshotRegion, afterScreenUpdates: afterUpdates, withCapInsets: UIEdgeInsetsZero)
            
        } else {
            
            snapshotView=UIView(frame: CGRectMake(0, 0, foldWidth, size.height))
            snapshotView!.backgroundColor = view.backgroundColor
            let snapshotRegion:CGRect  = CGRectMake(offset, 0.0, foldWidth, size.height)

            let snapshotView2=view.resizableSnapshotViewFromRect(snapshotRegion, afterScreenUpdates: afterUpdates, withCapInsets: UIEdgeInsetsZero)
     
            snapshotView?.addSubview(snapshotView2!)
            
        }
        
        let snapshotWithShadowView:UIView = self.addShadowToView(snapshotView!, reverse: left,afterUpdates:afterUpdates)
        containerView.addSubview(snapshotWithShadowView)
        
        snapshotWithShadowView.layer.anchorPoint = CGPointMake( left ? 0.0 : 1.0, 0.5);
        
        return snapshotWithShadowView;
    }
    
    func addShadowToView(view:UIView,reverse:Bool,afterUpdates:Bool)->UIView
    {
        // create a view with the same frame
        let viewWithShadow:UIView = UIView(frame: view.frame)
        let shadowView:UIView=UIView(frame: viewWithShadow.bounds)
        
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame = shadowView.bounds
        gradient.colors = [UIColor(white: 0.0, alpha: 0.0).CGColor,UIColor(white: 0.0, alpha: 1.0).CGColor]
        gradient.startPoint = CGPointMake(reverse ? 0.0 : 1.0, reverse ? 0.2 : 0.0)
        gradient.endPoint = CGPointMake(reverse ? 1.0 : 0.0, reverse ? 0.0 : 1.0)
        shadowView.layer.insertSublayer(gradient, atIndex: 1)
        
        // add the original view into our new view
        view.frame = view.bounds;
        
        if(!self.reverse && self.type==JumpType.Navigation && afterUpdates)
        {
            let v:UIView=UIView(frame:view.bounds)
            v.backgroundColor=self.color
            
            let vv:UIView=UIView(frame:CGRectMake(0, 64, view.bounds.width, view.bounds.height-64))
            vv.backgroundColor=self.color
            vv.addSubview(view)
            vv.layer.masksToBounds=true
            
            v.addSubview(vv)
            viewWithShadow.addSubview(v)

        }
        else
        {
            viewWithShadow.addSubview(view)
        }
        
        viewWithShadow.addSubview(shadowView)
        
        return viewWithShadow;
        
    }
}
