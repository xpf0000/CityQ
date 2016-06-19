
import Foundation
import UIKit
class XAlertView:UIView
{
    var message:String=""
    var visualEffectView:UIView?
    weak var delegate:commonDelegate?
    var flag:Int?
    let label=UILabel()
    weak var nav:XNavigationController?
    var block:AnyBlock?
    
    init(msg:String,flag:Int)
    {
        super.init(frame: CGRectMake(0, 0, swidth, sheight))
        self.flag=flag
        self.message=msg
        self.alpha = 0.0
        self.userInteractionEnabled=true
        self.creatView()
    }
    
    func creatView()
    {
        self.backgroundColor=UIColor(white: 0.0, alpha: 0.35)
        
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)) as UIVisualEffectView
            } else {
                // Fallback on earlier versions
            }
        }
        else
        {
            visualEffectView=UIView()
            visualEffectView?.backgroundColor=UIColor.whiteColor()
        }
        
        visualEffectView!.frame = CGRectMake(100, 100, swidth*0.7, swidth*0.7*0.44)
        visualEffectView!.center=CGPointMake(swidth/2.0, sheight/2.0-32)
        visualEffectView!.contentMode=UIViewContentMode.Center
        
        visualEffectView!.layer.masksToBounds=true
        visualEffectView!.layer.cornerRadius=5.0
        self.addSubview(visualEffectView!)
 
        label.frame=CGRectMake(100, 100, swidth*0.6, swidth*0.6*0.44)
        label.center=CGPointMake(swidth/2.0, sheight/2.0-32)
        label.numberOfLines=0
        label.font = UIFont.systemFontOfSize(15.0)
        label.text=message
        label.textAlignment=NSTextAlignment.Center
        label.backgroundColor=UIColor.clearColor()
        label.alpha=0.0
        self.addSubview(label)
        
        self.animateAppearance()
        
        
        
    }
    
    func animateAppearance()
    {
        
        self.visualEffectView?.alertAnimation(0.3, delegate: nil)
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.alpha = 1.0
            self.label.alpha=0.6
        
        }) { (finished) -> Void in
            if(finished)
            {
                UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                
                    self.label.alpha=1.0
                }) { (finished) -> Void in
                    
                    if(finished)
                    {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                            
                            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                                self.alpha=0.0
                                }) { (finished) -> Void in
                                    
                                    if(finished)
                                    {
                                        if(self.block != nil)
                                        {
                                            self.block!(nil)
                                        }
                                        self.delegate?.doSameThingWithFlag!(self.flag!)
                                        self.removeFromSuperview()
                                    }
                            }

                            
                            });
                    }
                }
            }

        }
    
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        if(newSuperview != nil)
        {
            if(newSuperview!.viewController is XNavigationController)
            {
                nav = (newSuperview!.viewController as! XNavigationController)
            }
            else if(newSuperview!.viewController?.navigationController is XNavigationController)
            {
                nav = (newSuperview!.viewController?.navigationController as! XNavigationController)
            }
            
        }
      
    }


    deinit
    {
        self.visualEffectView=nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}