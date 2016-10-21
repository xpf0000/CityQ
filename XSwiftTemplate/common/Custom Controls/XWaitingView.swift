
import Foundation
import UIKit
class XWaitingView:UIView
{
    var visualEffectView:UIView?
    var now=0
    var view:NVActivityIndicatorView!
    
    static let Share = XWaitingView(frame: CGRectMake(0, 0, swidth, sheight))
    
    class func show()
    {
        UIApplication.sharedApplication().keyWindow?.addSubview(Share)
    }
    
    class func showBlack()
    {
        Share.black()
        UIApplication.sharedApplication().keyWindow?.addSubview(Share)
    }
    
    class func hide()
    {
        Share.removeFromSuperview()
    }
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
        
        self.alpha = 1.0
        self.userInteractionEnabled=true
        self.creatView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func creatView()
    {
        self.backgroundColor=UIColor(white: 0.0, alpha: 0.35)
        
        visualEffectView=UIView(frame: CGRectMake(100, 100, swidth*0.24, swidth*0.24))
        visualEffectView!.center=CGPointMake(swidth/2.0, sheight/2.0-32)
        visualEffectView!.contentMode=UIViewContentMode.Center
        visualEffectView!.layer.masksToBounds=true
        visualEffectView!.layer.cornerRadius=5.0
        
        self.white()
        //        let button = UIButton(type: .Custom)
        //        button.frame = CGRectMake(0, 0, swidth*0.24, swidth*0.24)
        //        button.addTarget(self, action: "change", forControlEvents: UIControlEvents.TouchUpInside)
        //
        //        visualEffectView?.addSubview(button)
        
    }
    
    func white()
    {
        view?.stopAnimation()
        view?.removeFromSuperview()
        view=nil
        view = NVActivityIndicatorView(frame: CGRectMake(0, 0, swidth*0.24, swidth*0.24), type: .BallClipRotate, color: APPBlueColor, size: CGSizeMake(swidth*0.24*0.5, swidth*0.24*0.5))
        visualEffectView?.backgroundColor=UIColor.whiteColor()
        visualEffectView?.addSubview(view)
    }
    
    func black()
    {
        view?.stopAnimation()
        view?.removeFromSuperview()
        view=nil
        view = NVActivityIndicatorView(frame: CGRectMake(0, 0, swidth*0.24, swidth*0.24), type: .BallClipRotate, color: UIColor.whiteColor(), size: CGSizeMake(swidth*0.24*0.5, swidth*0.24*0.5))
        visualEffectView?.backgroundColor="#333749".color
        visualEffectView?.addSubview(view)
        
    }
    
    func change()
    {
        view.stopAnimation()
        view.removeFromSuperview()
        view=nil
        now += 1
        
        if(now==NVActivityIndicatorType.allValues.count)
        {
            now = 0
        }
        
        var i=0
        for item in NVActivityIndicatorType.allValues
        {
            if(i == now)
            {
                view = NVActivityIndicatorView(frame: CGRectMake(0, 0, swidth*0.24, swidth*0.24), type: item, color: APPBlueColor, size: CGSizeMake(swidth*0.24*0.5, swidth*0.24*0.4))
                visualEffectView?.addSubview(view)
                //visualEffectView?.sendSubviewToBack(view)
                view.startAnimation()
                return
            }
            
            i += 1
        }
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        if(newSuperview != nil)
        {
            self.visualEffectView!.alpha=0.0
            self.visualEffectView!.alertAnimation(0.3, delegate: nil)
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.visualEffectView!.alpha=1.0
            })
            
        }
        else
        {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                self.visualEffectView!.alpha=0.0
                
                }, completion: { (finish) -> Void in
                    
                    self.visualEffectView!.removeFromSuperview()
                    if self.visualEffectView!.backgroundColor != UIColor.whiteColor()
                    {
                        self.white()
                    }
                    
            })
            
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if(self.superview != nil)
        {
            UIApplication.sharedApplication().keyWindow?.addSubview(self.visualEffectView!)
            self.view.startAnimation()
        }
        
    }
    
    
    deinit
    {
        self.visualEffectView=nil
    }
    
}
