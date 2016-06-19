//
//  XActivityView.swift
//  swiftTest
//
//  Created by X on 15/3/18.
//  Copyright (c) 2015年 swiftTest. All rights reserved.
//

import Foundation
import UIKit
class XActivityView:UIView
{
    //var point:CGPoint?
    var radius:CGFloat?
    var isPlus:Bool=false
    var start:Double=0.0
    var end:Double=0.0
    var stage:Int=0
    var timer:NSTimer?
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor=UIColor.clearColor()
        startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pointOnInnerCirecleWithAngel(angel:Int)->CGPoint
    {
        let r:Double = Double(self.frame.size.height/2/2)
        let cx:Double = Double(self.frame.size.width/2)
        let cy:Double = Double(self.frame.size.height/2)
        let x:Double = Double(cx + r * cos((M_PI/15.0) * Double(angel)))
        let y:Double = Double(cy + r * sin(M_PI/15.0 * Double(angel)))
        return CGPointMake(CGFloat(x), CGFloat(y))
    }
    func pointOnOuterCirecleWithAngel(angel:Int)->CGPoint
    {
        let r:Double = Double(self.frame.size.height/2)
        let cx:Double = Double(self.frame.size.width/2)
        let cy:Double = Double(self.frame.size.height/2)
        let x:Double = Double(cx + r * cos((M_PI/15.0) * Double(angel)))
        let y:Double = Double(cy + r * sin(M_PI/15.0 * Double(angel)))
        return CGPointMake(CGFloat(x), CGFloat(y))
    }
    
    func startAnimating()
    {
        if (self.timer==nil)
        {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "setNeedsDisplay", userInfo: nil, repeats: true)
            NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
        }

    }
    
    func stopAnimating()
    {
        self.timer?.invalidate()
    }

    
    override func drawRect(rect: CGRect) {
       let context=UIGraphicsGetCurrentContext()
        UIGraphicsGetCurrentContext();
        
        CGContextSetLineCap(context, CGLineCap.Round);
       CGContextSetStrokeColorWithColor(context, UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8).CGColor);
        //CGContextSetRGBStrokeColor(context,1,0,0,1.0);//画笔线的颜色
        CGContextSetLineWidth(context, 2.5);//线的宽度
//        //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
        // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
         radius=(self.frame.size.width>self.frame.size.height) ? self.frame.size.height/4.2 : self.frame.size.width/4.2
        CGContextAddArc(context, CGFloat(self.frame.size.width/2.0), CGFloat(self.frame.size.height/2.0-12.0), radius!, 0, CGFloat(2*M_PI), 0)
        CGContextDrawPath(context, CGPathDrawingMode.Stroke);
  
        
        if(isPlus==true)
        {
            start=start+Double(stage)*1.8/360.0
            end=end+Double(stage)/360.0
            if(start+Double(stage)*1.8/360.0 >= end+Double(stage)/360.0)
            {
                end=end-Double(stage)/360.0
                isPlus=false
                start=end
                stage=0
            }
            
        }
        else
        {
            start=start+Double(stage)/360.0
            end=end+Double(stage)*1.8/360.0
            if(end-start>=0.7)
            {
                isPlus=true
            }
        }
        
        stage += 1
        
        CGContextSetStrokeColorWithColor(context, greenBGC.CGColor)
        CGContextSetLineWidth(context, 2.0);//线的宽度
        CGContextAddArc(context, self.frame.size.width/2.0, self.frame.size.height/2.0-12.0, radius!, CGFloat(start*2*M_PI), CGFloat(end*2*M_PI), 0)
        
        CGContextDrawPath(context, CGPathDrawingMode.Stroke);

        
    }
}

