//
//  ViewController.swift
//  OA
//
//  Created by X on 15/4/27.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import UIKit



class XViewController: UIViewController,UIViewControllerTransitioningDelegate{
    
   
    var jumpAnimType:AnimatorType?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "cityChanged", name: "cityChanged", object: nil)
        
    }
    
    func cityChanged()
    {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func presentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        
        let c = completion
        
        viewControllerToPresent.transitioningDelegate=self
        JumpInteraction.Share.toVC=viewControllerToPresent
        JumpInteraction.Share.fromVC = self
        JumpInteraction.Share.addRecognizer()
        
        super.presentViewController(viewControllerToPresent, animated: flag, completion: { () -> Void in
            
            if(c != nil)
            {
                c!()
            }
        })
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if(self.jumpAnimType == .Default)
        {
            return nil
        }
        
        jumpAnim.reverse=false
        JumpInteraction.Share.jumpType=JumpType.Model
        if(self.jumpAnimType != nil)
        {
            jumpAnim.type=self.jumpAnimType!
        }
        return jumpAnim
        
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if(self.jumpAnimType == .Default)
        {
            return nil
        }
        
        jumpAnim.reverse=true
        if(self.jumpAnimType != nil)
        {
            jumpAnim.type=self.jumpAnimType!
        }
        return jumpAnim
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if(self.jumpAnimType == .Default)
        {
            return nil
        }
        
        let b = JumpInteraction.Share.interacting
        
        if(b)
        {
            return JumpInteraction.Share
            
        }
        else
        {
            //JumpInteraction.Share.removeRecognizer()
            return nil
        }
        
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if(self.jumpAnimType == .Default)
        {
            return nil
        }
        
        let b = JumpInteraction.Share.interacting
        
        if(b)
        {

            return JumpInteraction.Share
            
        }
        else
        {
            JumpInteraction.Share.removeRecognizer()
            return nil
        }
        
        
    }
    
    override func animationDidStart(anim: CAAnimation) {
        super.animationDidStart(anim)
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        super.animationDidStop(anim, finished: flag)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if(self.navigationController != nil)
        {
            JumpInteraction.Share.jumpType=JumpType.Navigation
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        NSURLCache.sharedURLCache().removeAllCachedResponses()
    }
    
    deinit
    {
        //NSNotificationCenter.defaultCenter().removeObserver(self)
    }
        
}

