//
//  XNavigationController.swift
//  swiftTest
//
//  Created by X on 15/3/17.
//  Copyright (c) 2015年 swiftTest. All rights reserved.
//

import Foundation
import UIKit

class XNavigationController: UINavigationController,UINavigationControllerDelegate,UIGestureRecognizerDelegate
{
    var recognizer:UIPanGestureRecognizer?
    var backGroundView:UIView?
    var screenShotList:Array<AnyObject>=[]
    var isMoving:Bool?
    var lastScreenShotView:UIView?
    var startPoint:CGPoint?
    let alphaView:UIView = UIView()
    var type:AnimatorType=AnimatorType.Default
    let offset_float:CGFloat = 0.65;// 拉伸参数
    let min_distance:CGFloat = 200;// 最小回弹距离
    var block:AnyBlock?

    var leftEdgePan:UIScreenEdgePanGestureRecognizer!
    var rightEdgePan:UIScreenEdgePanGestureRecognizer!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.inita()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.inita()
    }
    
    
    func inita()
    {
        //取出设置主题的对象
        let navBar = UINavigationBar.appearance()
        //设置导航栏的背景图片
        //var navBarBg = ""
        //navBarBg = "nv_bg_7.png"
        navBar.tintColor=UIColor.whiteColor()
        
        navBar.setBackgroundImage(APPBlueColor.image, forBarMetrics:.Default)
        navBar.titleTextAttributes=[NSForegroundColorAttributeName:UIColor.whiteColor(),NSFontAttributeName:UIFont.boldSystemFontOfSize(20.0)]
        //self.navigationBar.layer.masksToBounds = true;
        //navBar.translucent = true
        //navBar.shadowImage = UIColor.clearColor().image
        
        
        
        JumpInteraction.Share.navigationController=self
        JumpInteraction.Share.jumpType=JumpType.Navigation
        
//        self.navigationBar.translucent = true
//        alphaView.frame=CGRectMake(0, 0, swidth, (self.navigationBar.frame.size.height)+20)
//        alphaView.backgroundColor = blueBGC
//        self.view.insertSubview(alphaView, belowSubview: self.navigationBar)
        
        recognizer = UIPanGestureRecognizer(target: self, action: #selector(paningGestureReceive(_:)))
        recognizer?.delaysTouchesBegan
        self.view.addGestureRecognizer(recognizer!)
        
        leftEdgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(leftEdgePanGesture(_:)))
        leftEdgePan.edges = UIRectEdge.Left
        self.view.addGestureRecognizer(leftEdgePan)
        
        rightEdgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(rightEdgePanGesture(_:)))
        rightEdgePan.edges = UIRectEdge.Right
        self.view.addGestureRecognizer(rightEdgePan)
        
    }
    
    func setAlpha(a:CGFloat)
    {
        var img:UIImage?
        if(a==1)
        {
            img=UIColor(red: 33.0/255.0, green: 173.0/255.0, blue: 253.0/255.0, alpha: 1.0).image
            self.navigationBar.shadowImage = nil
            self.navigationBar.translucent = false;
        }
        else
        {
            img=UIColor(red: 33.0/255.0, green: 173.0/255.0, blue: 253.0/255.0, alpha: 0.0).image
            self.navigationBar.shadowImage = UIColor.clearColor().image
            self.navigationBar.translucent = true;
        }
        
        self.navigationBar.setBackgroundImage(img, forBarMetrics:.Default)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setRecognizer()
    {
        removeRecognizer()
        
        recognizer?.delaysTouchesBegan
        self.view.addGestureRecognizer(recognizer!)
        self.view.addGestureRecognizer(leftEdgePan)
        self.view.addGestureRecognizer(rightEdgePan)
    }
    
    func removeRecognizer()
    {
        if(recognizer != nil)
        {
            self.view.removeGestureRecognizer(recognizer!)
        }
        
        if(leftEdgePan != nil)
        {
            self.view.removeGestureRecognizer(leftEdgePan)
        }
        
        if(rightEdgePan != nil)
        {
            self.view.removeGestureRecognizer(rightEdgePan)
        }
        
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        self.screenShotList.append(self.view.snapshotViewAfterScreenUpdates(true)!)
        super.pushViewController(viewController, animated: animated)
    }

    func pushViewController(viewController: UIViewController, animated: Bool,type:AnimatorType) {
        
        if(self.delegate != nil)
        {
        self.type=type
        jumpAnim.reverse=false
        super.pushViewController(viewController, animated: animated)
        }
        else
        {
            self.pushViewController(viewController, animated: animated)
        }
    }
    
    //非交互式动画
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        JumpInteraction.Share.toVC=toVC
        JumpInteraction.Share.fromVC = fromVC
        JumpInteraction.Share.addRecognizer()
        jumpAnim.type=self.type
        return jumpAnim
    }
    
    
    //交互式动画
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

        return JumpInteraction.Share.interacting ? JumpInteraction.Share : nil
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        
    }
    

    override func popViewControllerAnimated(animated: Bool) -> UIViewController? {
        
        // 有动画用自己的动画
        if (self.delegate == nil && animated) {
            self.popAnimation()
            return nil;
        }
        
        jumpAnim.reverse=true
        return super.popViewControllerAnimated(animated)
    }
    
   
    func popAnimation() {
        if (self.viewControllers.count == 1) {
            return
        }
        if (self.backGroundView==nil)
        {
            backGroundView = UIView(frame: CGRect(x: 0, y: 0, width: swidth, height: sheight))
            backGroundView!.backgroundColor = UIColor.whiteColor()
        }
        
        self.view.superview?.insertSubview(backGroundView!, belowSubview: self.view)
        backGroundView!.hidden = false
        
        if (lastScreenShotView != nil)
        {
            lastScreenShotView!.removeFromSuperview()
        }
        
        lastScreenShotView = self.screenShotList.last as? UIView
        lastScreenShotView!.frame = CGRect(x:-(swidth*offset_float),y:0,width:swidth,height:sheight)
        
        backGroundView!.addSubview(lastScreenShotView!)
        
        UIView.animateWithDuration(0.4, animations:
            { () -> Void in
                self.moveViewWithX(Double(swidth))
            })
            { (finished) -> Void in
                self.gestureAnimation(false)
        }
    }
    
    func gestureAnimation(animated:Bool)
    {
        self.screenShotList.removeLast()
        super.popViewControllerAnimated(animated)
        
        var frame = self.view.frame
        
        frame.origin.x = 0;
        
        self.view.frame = frame;
        
        isMoving = false;
        
        self.backGroundView!.hidden = true;
    }
    
    func moveViewWithX(xp:Double)
    {
        var x = xp>Double(swidth) ? Double(swidth) : xp
        
        x = x<0 ? 0 : x
        
        var frame = self.view.frame
        frame.origin.x = CGFloat(x)
        self.view.frame = frame
        // TODO
        lastScreenShotView?.frame=CGRect(x: -(Double(swidth)*Double(offset_float))+(x*Double(offset_float)), y: 0.0, width: Double(swidth), height: Double(sheight))
    }
    
    func paningGestureReceive(recoginzer:UIPanGestureRecognizer)
    {
        //    [self addTabBar];
        // If the viewControllers has only one vc or disable the interaction, then return.
        //如果viewControllers只有一个VC或禁用的交互，然后返回。
        if (self.viewControllers.count <= 1)
        {
            return
        }
        
        // we get the touch position by the window's coordinate
        // 我们得到的触摸位置的窗口的坐标
        let touchPoint:CGPoint = recoginzer.locationInView(UIApplication.sharedApplication().keyWindow)
        // begin paning, show the backgroundView(last screenshot),if not exist, create it.
        // 开始位置调整，显示backgroundView （最后一个截图） ，如果不存在，则创建它。
        
        if (recoginzer.state == UIGestureRecognizerState.Began)
        {
            isMoving = true
            startPoint = touchPoint
            
            if (self.backGroundView==nil)
            {
                backGroundView = UIView(frame: CGRect(x: 0, y: 0, width: swidth, height: sheight))
                backGroundView!.backgroundColor = UIColor.whiteColor()
            }
            
            self.view.superview?.insertSubview(backGroundView!, belowSubview: self.view)
            backGroundView!.hidden = false
            
            if (lastScreenShotView != nil)
            {
                lastScreenShotView!.removeFromSuperview()
            }
            
            lastScreenShotView = self.screenShotList.last as? UIView
            
            lastScreenShotView!.frame = CGRect(x:-(swidth*offset_float),y:0,width:swidth,height:sheight)
            
            backGroundView!.addSubview(lastScreenShotView!)
            
            //End paning, always check that if it should move right or move left automatically
            // 结束位置调整时，应检查它是否应该向右移动或自动向左移动
        }
        else if (recoginzer.state == UIGestureRecognizerState.Ended)
        {
            if (touchPoint.x - startPoint!.x > min_distance)
            {
                UIView.animateWithDuration(0.3, animations:
                    { () -> Void in
                        self.moveViewWithX(Double(swidth))
                    })
                    { (finished) -> Void in
                        self.gestureAnimation(false)
                }
            }
            else
            {
                UIView.animateWithDuration(0.3, animations:
                    { () -> Void in
                        self.moveViewWithX(0.0)
                    })
                    { (finished) -> Void in
                        self.isMoving = false
                        self.backGroundView!.hidden = true
                }
            }
            
            return;
            // cancal panning, alway move to left side automatically
            // 取消平移，是常常会自动移动到左侧
        }
        else if (recoginzer.state == UIGestureRecognizerState.Cancelled)
        {
            UIView.animateWithDuration(0.3, animations:
                { () -> Void in
                    self.moveViewWithX(0.0)
                })
                { (finished) -> Void in
                    self.isMoving = false
                    self.backGroundView!.hidden = true
            }
            return
        }
        // it keeps move with touch
        // 保持 移动 或 触摸
        if (self.isMoving==true)
        {
            self.moveViewWithX(Double(touchPoint.x - self.startPoint!.x))
        }
        
    }
    
    func leftEdgePanGesture(sender:UIScreenEdgePanGestureRecognizer)
    {
        self.block?(sender)
    }
    
    func rightEdgePanGesture(sender:UIScreenEdgePanGestureRecognizer)
    {
        self.block?(sender)
    }
    

    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        if(touch.view is XBanner)
        {
            return false
        }
        
        return true
        
    }
    
  
    
    deinit
    {
        self.view.removeGestureRecognizer(leftEdgePan)
        self.view.removeGestureRecognizer(rightEdgePan)
        
        leftEdgePan=nil
        rightEdgePan=nil
        
        removeRecognizer()
        backGroundView?.removeFromSuperview()
        backGroundView=nil
        lastScreenShotView?.removeFromSuperview()
        lastScreenShotView=nil
        startPoint=nil
        screenShotList.removeAll(keepCapacity: false)
        self.block = nil
        self.delegate=nil
        JumpInteraction.Share.removeRecognizer()
    }
    
   
}
