//
//  XProgressView.swift
//  chengshi
//
//  Created by X on 15/11/28.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class XProgressView: UIView {
    
    var label:UILabel=UILabel(frame: CGRectMake(0, 0, swidth*0.4, swidth*0.4))
    var progress:ProgressView = ProgressView(frame: CGRectMake(swidth/2, (sheight-64)/2-32, swidth*0.4, swidth*0.4))
    
    class func Share() ->XProgressView! {
        
        struct Once {
            static var token:dispatch_once_t = 0
            static var dataCenterObj:XProgressView! = nil
        }
        dispatch_once(&Once.token, {
            Once.dataCenterObj = XProgressView(frame: CGRectMake(0, 0, swidth, sheight))
        })
        return Once.dataCenterObj
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        
        super.willMoveToSuperview(newSuperview)
        
        self.progress.EndAngle = 0.0
        
    }
    
    func setAngle(angle:CGFloat)
    {
        self.label.text = "\(Int(angle))%"
        self.progress.EndAngle = angle/CGFloat(100)*CGFloat(2)*PI
        self.progress.setNeedsDisplay()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.65)
        self.userInteractionEnabled = true
        
        progress.backgroundColor = UIColor.whiteColor()
        progress.center = CGPointMake(swidth/2, (sheight-64)/2-32);
        
        self.label.textAlignment=NSTextAlignment.Center;
        self.label.backgroundColor=UIColor.clearColor()
        self.label.font=UIFont.systemFontOfSize(14.0)
        self.label.textColor=UIColor.grayColor()
        
        progress.addSubview(self.label)
        
        progress.layer.masksToBounds=true
        progress.layer.cornerRadius = 8.0
        
        self.addSubview(progress)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    

}

class ProgressView:UIView
{
    var EndAngle:CGFloat=0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext();
        
        CGContextSetLineCap(context, CGLineCap.Round);
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor);
        
        //CGContextSetRGBStrokeColor(context,1,0,0,1.0);//画笔线的颜色
        CGContextSetLineWidth(context, 1.8);//线的宽度
        //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
        // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
        let radius = self.frame.size.width > self.frame.size.height ? self.frame.size.height/4.7 : self.frame.size.width/4.7;
        
        CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2, radius, 0, self.EndAngle, 0); //添加一个圆
        
        CGContextDrawPath(context, CGPathDrawingMode.Stroke);
    }
}
