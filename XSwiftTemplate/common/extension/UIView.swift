//
//  UIView.swift
//  swiftTest
//
//  Created by X on 15/3/14.
//  Copyright (c) 2015年 swiftTest. All rights reserved.
//

import Foundation
import UIKit


private var XCornerRadiusKey:CChar = 0

class XCornerRadiusModel: NSObject {
    
    var BorderSidesType:XBorderSidesType = []
    var CornerRadiusType:UIRectCorner = []
    var CornerRadius:CGFloat = 0.0
    var FillPath:Bool = false
    var StrokePath:Bool = false
    var FillColor:UIColor?
    var StrokeColor:UIColor = UIColor.clearColor()
    var BorderLineWidth : CGFloat = 0.0
    
}

struct XBorderSidesType : OptionSetType {
    
    let rawValue:Int
    
    static var None: XBorderSidesType = XBorderSidesType(rawValue: 0)
    static var Left: XBorderSidesType = XBorderSidesType(rawValue: 1)
    static var Top: XBorderSidesType = XBorderSidesType(rawValue: 2)
    static var Right: XBorderSidesType = XBorderSidesType(rawValue: 3)
    static var Bottom: XBorderSidesType = XBorderSidesType(rawValue: 4)
    static var All: XBorderSidesType = XBorderSidesType(rawValue: 5)
    
}

extension UIView
{
    var XCornerRadius:XCornerRadiusModel?
    {
        get
        {
            let r = objc_getAssociatedObject(self, &XCornerRadiusKey) as? XCornerRadiusModel
            
            return r
        }
        set {
            
            newValue?.FillColor = newValue?.FillColor ?? backgroundColor
            
            newValue?.FillColor = newValue?.FillColor ?? UIColor.clearColor()
            
            self.willChangeValueForKey("XCornerRadiusKey")
            objc_setAssociatedObject(self, &XCornerRadiusKey, newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.didChangeValueForKey("XCornerRadiusKey")
            
            backgroundColor = UIColor.clearColor()
            
            setNeedsDisplay()
  
        }
        
    }
    
    
    public override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
        
    }
    
    func endEdit()
    {
        self.endEditing(true)
    }
    
    func addEndButton()
    {
        // 键盘添加一下Done按钮
        let topView : UIToolbar = UIToolbar(frame: CGRectMake(0, 0, swidth, 38))
        
        topView.layer.shadowColor = UIColor.clearColor().CGColor
        topView.layer.masksToBounds = true
        topView.translucent = true
        
        let btn = UIButton(type: .Custom)
        
        btn.setTitleColor("007AFF".color, forState: .Normal)
        btn.setTitle("完成", forState: .Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(16.0)
        
        btn.frame = CGRectMake(swidth-60, 0, 48, 38)
        topView.addSubview(btn)
        
        btn.click {[weak self] (b) in
            
            self?.endEdit()
        }
        
        self.setValue(topView, forKey: "inputAccessoryView")
    }
    
    
    var rootView:UIView{
        
        var rootview=self
        while ((rootview.superview) != nil) {
            
            if (rootview.superview is UIWindow) {
                
                break
                
            }
            
            rootview = rootview.superview!
            
        }
        
        return rootview
    }
    
    var viewController:UIViewController?
        {
            var next:UIView = self.superview == nil ? self : self.superview!
            
            while(!(next is UIWindow))
            {
                let nextResponder:UIResponder=next.nextResponder()!
                if (nextResponder is UIViewController)
                {
                    return nextResponder as? UIViewController;
                }
                
                next=next.superview!
            }
            
            
            return nil
        }
    
    
    func removeAllSubViews()
    {
        for view in self.subviews
        {
            view.removeFromSuperview()
        }
    }
    
    
    func initWithNibName(name:String)
    {
        let containerView:UIView = (name.Nib.instantiateWithOwner(self, options: nil))[0] as! UIView
        let newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        containerView.frame = newFrame;
        self.addSubview(containerView)
    }
    
    func showAlert(str:String, block:AnyBlock?)
    {
        let alert:XAlertView = XAlertView(msg: str, flag: 0)
        alert.block = block
        self.addSubview(alert)
    }
    
    func showWaiting()
    {
        self.addSubview(XWaitingView.Share())
    }

    //旋转 时间 角度
    func revolve(time:NSTimeInterval,angle:CGFloat)
    {
        if(angle == 0.0)
        {
            UIView.animateWithDuration(time, animations: { () -> Void in
                self.transform=CGAffineTransformIdentity
            })
        }
        else
        {
            UIView.animateWithDuration(time, animations: { () -> Void in
                self.transform=CGAffineTransformMakeRotation(CGFloat(M_PI)*CGFloat(angle))
            })
        }
        
       

    }
    
    
    
    //抖动动画
    func shake()
    {
        // 获取到当前的View
        
        let viewLayer:CALayer = self.layer;
        
        // 获取当前View的位置
        
        let position = viewLayer.position;
        
        // 移动的两个终点位置
        
        let x = CGPointMake(position.x + 8, position.y);
        
        let y = CGPointMake(position.x - 8, position.y);
        
        let  animation = CABasicAnimation(keyPath: "position")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        animation.fromValue = NSValue(CGPoint: x)
        animation.toValue = NSValue(CGPoint: y)
        animation.autoreverses = true
        animation.duration = 0.05
        animation.repeatCount = 4
        viewLayer.addAnimation(animation, forKey: nil)
        
    }
    
    func alertAnimation(dur:NSTimeInterval,delegate:AnyObject?)
    {
        let  animation = CAKeyframeAnimation(keyPath: "transform")
        
        animation.duration = dur;
  
        animation.removedOnCompletion = false;
        
        animation.fillMode = kCAFillModeForwards;
        
        var values : Array<AnyObject> = []
        values.append(NSValue(CATransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0)))
        values.append(NSValue(CATransform3D: CATransform3DMakeScale(1.2, 1.2, 1.0)))
        values.append(NSValue(CATransform3D: CATransform3DMakeScale(0.9, 0.9, 0.9)))
        values.append(NSValue(CATransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = values;
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.delegate = delegate
        self.layer.addAnimation(animation, forKey: nil)
     
    }
    
    func bounceAnimation(dur:NSTimeInterval,delegate:AnyObject?)
    {
        let  animation = CAKeyframeAnimation(keyPath: "transform")
        
        animation.duration = dur;
        
        animation.removedOnCompletion = false;
        
        animation.fillMode = kCAFillModeForwards;
        
        var values : Array<AnyObject> = []
        values.append(NSValue(CATransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        values.append(NSValue(CATransform3D: CATransform3DMakeScale(2.0, 2.0, 1.0)))
        values.append(NSValue(CATransform3D: CATransform3DMakeScale(0.9, 0.9, 0.9)))
        values.append(NSValue(CATransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = values;
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.delegate = delegate
        self.layer.addAnimation(animation, forKey: nil)
        
    }
    
    func drawCornerRadius(rect:CGRect)
    {
        
        if let m = XCornerRadius
        {
            let  halfLineWidth = m.BorderLineWidth / 2.0
            
            let topInsets = m.BorderSidesType.contains(.Top) || m.BorderSidesType.contains(.All) ? halfLineWidth : 0.0
            
            let leftInsets = m.BorderSidesType.contains(.Left) || m.BorderSidesType.contains(.All) ? halfLineWidth : 0.0
            
            let rightInsets = m.BorderSidesType.contains(.Right) || m.BorderSidesType.contains(.All) ? halfLineWidth : 0.0
            
            let bottomInsets = m.BorderSidesType.contains(.Bottom) || m.BorderSidesType.contains(.All) ? halfLineWidth : 0.0
            
            let insets = UIEdgeInsetsMake(topInsets, leftInsets, bottomInsets, rightInsets)
            
            let properRect = UIEdgeInsetsInsetRect(rect, insets)
            
            let c = UIGraphicsGetCurrentContext()
            CGContextSetShouldAntialias(c, true)
            
            if m.StrokePath
            {
    
                CGContextSetLineCap(c, .Round)
                CGContextSetLineWidth(c, 1.5)
                
                CGContextSetStrokeColorWithColor(c, m.StrokeColor.CGColor);
                CGContextSetFillColorWithColor(c, m.FillColor!.CGColor)
                
                addPath(c!, rect: properRect,m: m)
                
                CGContextFillPath(c);
                
                addPath(c!, rect: properRect,m: m)
                
                CGContextStrokePath(c);
                
                
                return
            }
            
            if m.FillPath
            {
                CGContextSetFillColorWithColor(c, m.FillColor!.CGColor)
                
                addPath(c!, rect: properRect,m: m)
                
                CGContextFillPath(c);
            }
            
            
        }


        
//        var arr:UIRectCorner = []
//        if XTopLeftRadius{arr.insert(.TopLeft)}
//        if XTopRightRadius{arr.insert(.TopRight)}
//        if XBottomLeftRadius{arr.insert(.BottomLeft)}
//        if XBottomRightRadius{arr.insert(.BottomRight)}
//        
//        let p = UIBezierPath(roundedRect: rect, byRoundingCorners: arr, cornerRadii: CGSizeMake(XCornerRadius, 0.0))
//
//        let c = UIGraphicsGetCurrentContext()
////        CGContextAddPath(c, p.CGPath);
////        CGContextClosePath(c);
//        //CGContextClip(c);
//        //CGContextAddRect(c, rect);
//        CGContextSetShouldAntialias(c, true)
//        if XStrokePath
//        {
//            
////            p.lineCapStyle = .Round
////            p.lineJoinStyle = .Round
//            
//            CGContextSetLineCap(c, .Round)
//            CGContextSetLineWidth(c, 1.5)
//            
//            CGContextSetStrokeColorWithColor(c, XStrokeColor.CGColor);
//            CGContextSetFillColorWithColor(c, XFillColor.CGColor)
//            
//            addPath(c!, rect: rect)
//            
//            CGContextFillPath(c);
//            
//            addPath(c!, rect: rect)
//
//            CGContextStrokePath(c);
//            
//            
//            return
//        }
//        
//        if XFillPath
//        {
//            CGContextSetFillColorWithColor(c, XFillColor.CGColor)
//            
//            addPath(c!, rect: rect)
//            
//            CGContextFillPath(c);
//        }
        
    }
    
    private func addPath(c:CGContextRef,rect:CGRect,m:XCornerRadiusModel)
    {
        let minx = CGRectGetMinX(rect)
        let midx = CGRectGetMidX(rect)
        let maxx = CGRectGetMaxX(rect)
        
        let miny = CGRectGetMinY(rect)
        let midy = CGRectGetMidY(rect)
        let maxy = CGRectGetMaxY(rect)

        
        CGContextMoveToPoint(c, minx, midy)
        
        
        if (m.CornerRadiusType.contains(.TopLeft)) {
            CGContextAddArcToPoint(c, minx, miny, midx, miny, m.CornerRadius);
            CGContextAddLineToPoint(c, midx, miny);
        }
        else{
            
            CGContextAddLineToPoint(c, minx, miny)
        }
        
        if (m.CornerRadiusType.contains(.TopRight)) {
            CGContextAddArcToPoint(c, maxx, miny, maxx, midy, m.CornerRadius)
            CGContextAddLineToPoint(c, maxx, midy)
        }
        else{
            
            CGContextAddLineToPoint(c, maxx, miny)
        }
        
        if (m.CornerRadiusType.contains(.BottomRight)) {
            
            CGContextAddArcToPoint(c, maxx, maxy, midx, maxy, m.CornerRadius);
            CGContextAddLineToPoint(c, midx, maxy)
            
        }
        else{
            
            CGContextAddLineToPoint(c, maxx, maxy)
        }
        
        if (m.CornerRadiusType.contains(.BottomLeft)) {
            CGContextAddArcToPoint(c, minx, maxy, minx, midy, m.CornerRadius);
            CGContextAddLineToPoint(c, minx, midy)
        }
        else{
            
            CGContextAddLineToPoint(c, minx, maxy)
            
        }
            
        CGContextClosePath(c)
            
    }
    
    
    static func printAllSubView(v:UIView)
    {
        for item in v.subviews
        {
            print(item)
            if item.subviews.count > 0
            {
                printAllSubView(item)
            }
        }
        
    }
    
    static func findTableView(v:UIView)->UITableView?
    {
        if v is UITableView
        {
            return v as! UITableView
        }
        
        if v.superview != nil
        {
            return findTableView(v.superview!)
        }
        else
        {
            return nil
        }
        
    }
    
    
    
    
    
}