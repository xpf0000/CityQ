//
//  JumpAnimator.swift
//  JumpAnimator
//
//  Created by xupengfei on 23/10/14.
//  Copyright (c) 2014 Rounak Jain. All rights reserved.
//

import UIKit

enum AnimatorType : NSInteger{
    case Null       //使用系统的
    case Default    //默认
    case Alpha      //透明度
    case Scale      //放大缩小
    case Fold       //折叠  push时 如果显示导航条的话 自动布局的页面会因为view还没有处理好约束而和跳转完后的页面显示有差异 建议全屏时候用
    case Portal     //开门
    case Flip       //中间翻页
    case Turn       //翻转
    case NatGeo     //左右卡片
    case Cards      //前后卡片
    case Cube       //立体魔方
    case Goods      //淘宝选择规格
    case RightDrawer      //右侧侧滑
}

//跳转方式
enum JumpType : NSInteger{
    case Navigation    //导航栏跳转 push pop
    case Model      //模态视图 present
    case TabBar      //tabbar跳转  tabbar.selectindex
}


class JumpAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  
  weak var transitionContext: UIViewControllerContextTransitioning?
    var type:AnimatorType=AnimatorType.Default
    weak var fromView:UIView?
    weak var toView:UIView?
    weak var containerView:UIView?
    var reverse:Bool=false
    var turnDirection:TurnDirection=TurnDirection.Vertical  //转动轴向
    let duration:NSTimeInterval=0.45
    
    init(type:AnimatorType) {
        super.init()
        self.type=type
    }
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return self.duration
  }
  
    
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

    self.transitionContext = transitionContext
    containerView = transitionContext.containerView()
    fromView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view
    toView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)?.view
    
    switch self.type
    {
    case .Default:
          self.Default()
    case .Alpha:
        self.Alpha()
    case .Scale:
        self.Scale()
    case .Fold:
        
        let animation:FoldAnimation=FoldAnimation()
    animation.animation(self.transitionContext!, fromView: fromView!, toView: toView!)
        
    case .Portal:
        let animation:PortalAnimation=PortalAnimation()
        animation.animation(self.transitionContext!, fromView: fromView!, toView: toView!)
      
    case .Flip:
        let animation:FlipAnimation=FlipAnimation()
        animation.fromVC=transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        animation.animation(self.transitionContext!, fromView: fromView!, toView: toView!)
    case .Turn:
        let animation:TurnAnimation=TurnAnimation()
        animation.fromVC=transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        animation.animation(self.transitionContext!, fromView: fromView!, toView: toView!)
    case .NatGeo:
        let animation:NatGeoAnimation=NatGeoAnimation()
        animation.animation(self.transitionContext!, fromView: fromView!, toView: toView!)
    case .Cards:
        let animation:CardsAnimation=CardsAnimation()
        animation.fromVC=transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        animation.animation(self.transitionContext!, fromView: fromView!, toView: toView!)
    case.Goods:
        let animation:GoodsAnimation=GoodsAnimation()
        animation.fromVC=transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        animation.toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        animation.animation(self.transitionContext!, fromView: fromView!, toView: toView!)
        
    case.RightDrawer:
        let animation:RightDrawerAnimation=RightDrawerAnimation()
        animation.fromVC=transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        animation.toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        animation.animation(self.transitionContext!, fromView: fromView!, toView: toView!)
        
    case .Cube:
        let animation:CubeAnimation=CubeAnimation()
        animation.animation(self.transitionContext!, fromView: fromView!, toView: toView!)
    default:
        ""
    }
    
    
}
    
    func Default()
    {
        if(self.reverse)
        {
            fromView!.frame=CGRectMake(0, 0, swidth, sheight)
            toView!.frame=CGRectMake(swidth*(-0.35), 0, swidth, sheight)
            containerView!.insertSubview(toView!, belowSubview: fromView!)
            
            UIView.animateWithDuration(self.transitionDuration(self.transitionContext!), delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                
                self.fromView!.frame=CGRectMake(swidth, 0, swidth, sheight)
                self.toView!.frame=CGRectMake(0, 0, swidth, sheight)
                
                }) { (finished) -> Void in
                    
                    if(self.transitionContext!.transitionWasCancelled())
                    {
                        self.toView!.removeFromSuperview()
                        //self.fromView!.frame=CGRectMake(0, 0, swidth, sheight)
                    }
                    else
                    {
                        self.fromView!.removeFromSuperview()
                    }
                    
                    self.transitionContext!.completeTransition(!self.transitionContext!.transitionWasCancelled())
                    
            }
            
            return
            
        }
        
        fromView!.frame=CGRectMake(0, 0, swidth, sheight)
        toView!.frame=CGRectMake(swidth, 0, swidth, sheight)
        containerView!.addSubview(toView!)
        
        UIView.animateWithDuration(self.transitionDuration(self.transitionContext!), delay: 0.0, options: UIViewAnimationOptions.CurveLinear,animations: { () -> Void in
           
            self.fromView!.frame=CGRectMake(swidth*(-0.35), 0, swidth, sheight)
            self.toView!.frame=CGRectMake(0, 0, swidth, sheight)
            
            }) { (finished) -> Void in
                
                if(self.transitionContext!.transitionWasCancelled())
                {
                    self.toView!.removeFromSuperview()
                    //self.fromView!.frame=CGRectMake(0, 0, swidth, sheight)
                }
                else
                {
                    self.fromView!.removeFromSuperview()
                }
                
                self.transitionContext!.completeTransition(!self.transitionContext!.transitionWasCancelled())
                
        }
        
        
    }
    
    func Scale()
    {
        if(self.reverse)
        {
            self.fromView!.frame=CGRectMake(0, 0, swidth, sheight)
            self.toView!.frame=CGRectMake(0, 0, swidth, sheight)
            containerView!.insertSubview(self.toView!, belowSubview: self.fromView!)
            
            self.fromView!.transform=CGAffineTransformMakeScale(1.0, 1.0)
            self.toView!.transform=CGAffineTransformMakeScale(0.7, 0.7)
            
            UIView.animateWithDuration(self.transitionDuration(self.transitionContext!), delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                
                self.fromView!.frame=CGRectMake(swidth, 0, swidth, sheight)
                self.fromView!.transform=CGAffineTransformMakeScale(0.7,0.7)
                self.toView!.transform=CGAffineTransformMakeScale(1.0, 1.0)
 
                }) { (finished) -> Void in
                    
                    
                    if(self.transitionContext!.transitionWasCancelled())
                    {
                        self.toView!.removeFromSuperview()
                    }
                    else
                    {
                        self.fromView!.removeFromSuperview()
                    }
                    
                    self.fromView!.transform=CGAffineTransformMakeScale(1.0, 1.0)
                    self.toView!.transform=CGAffineTransformMakeScale(1.0, 1.0)
                    
                    self.transitionContext!.completeTransition(!self.transitionContext!.transitionWasCancelled())
                    
            }
            
            return
            
        }
        
        fromView!.frame=CGRectMake(0, 0, swidth, sheight)
        toView!.frame=CGRectMake(swidth, 0, swidth, sheight)
        containerView!.addSubview(toView!)
        
        fromView!.transform=CGAffineTransformMakeScale(1.0, 1.0)
        toView!.transform=CGAffineTransformMakeScale(0.7, 0.7)
        
        UIView.animateWithDuration(self.transitionDuration(self.transitionContext!), delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.fromView!.transform=CGAffineTransformMakeScale(0.7, 0.7)
            self.toView!.transform=CGAffineTransformMakeScale(1.0, 1.0)
            self.toView!.frame=CGRectMake(0, 0, swidth, sheight)
            
            }) { (finished) -> Void in
                
                self.fromView!.transform=CGAffineTransformMakeScale(1.0, 1.0)
                self.toView!.transform=CGAffineTransformMakeScale(1.0, 1.0)
                
                if(self.transitionContext!.transitionWasCancelled())
                {
                    self.toView!.removeFromSuperview()
                    //self.fromView!.frame=CGRectMake(0, 0, swidth, sheight)
                }
                else
                {
                    self.fromView!.removeFromSuperview()
                }
                
                self.transitionContext!.completeTransition(!self.transitionContext!.transitionWasCancelled())
                
        }
    }
    
    func Alpha()
    {
        containerView!.insertSubview(toView!, belowSubview: fromView!)
   
        fromView!.alpha = 1.0;
        toView!.alpha = 0.0;
        
        UIView.animateWithDuration(self.transitionDuration(self.transitionContext!), delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.fromView!.alpha = 0.0;
            self.toView!.alpha = 1.0;
            
            }) { (finished) -> Void in
                
                if(self.transitionContext!.transitionWasCancelled())
                {
                    self.toView!.removeFromSuperview()
                    self.fromView!.alpha = 1.0
                }
                else
                {
                    self.fromView!.removeFromSuperview()
                }
                
                self.transitionContext!.completeTransition(!self.transitionContext!.transitionWasCancelled())
            
        }
        
    }
    
    
  override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
    
    self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled())
    self.transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
  }
    

    
    
}
