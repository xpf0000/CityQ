//
//  CircularLoaderView.swift
//  ImageLoaderIndicator
//
//  Created by Richard Turton on 17/02/2015.
//  Copyright (c) 2015 Rounak Jain. All rights reserved.
//

import UIKit


let s = "http://a.hiphotos.baidu.com/baike/c0%3Dbaike272%2C5%2C5%2C272%2C90/sign=938219ef8f1001e95a311c5dd9671089/95eef01f3a292df5d0b0fc13be315c6034a87340.jpg"

let s1 = "http://img1.imgtn.bdimg.com/it/u=381107085,1683754138&fm=21&gp=0.jpg"

let s2 = "http://dlsw.baidu.com/sw-search-sp/soft/e6/30657/myworldV1.7.2.1432024071.1450848491.exe"

let s3 = "http://p1.pichost.me/i/40/1639665.png"

let s4 = "http://dlsw.baidu.com/sw-search-sp/soft/2a/25677/QQ_V4.0.5.1446465388.dmg"

let s5 = "http://img0.imgtn.bdimg.com/it/u=2338566287,3339538133&fm=21&gp=0.jpg"

let s6 = "http://dl.ke8u.com/down.php?sid=358"



class XDownLoadView: UIView,CAAnimationDelegate {
    
    let circlePathLayer = CAShapeLayer()
    let bgPathLayer = CAShapeLayer()
    let startLayer = CAShapeLayer()
    let pauseLayer = CAShapeLayer()
    var circleRadius: CGFloat = 1.0
    var lineWidth: CGFloat = 1.0
    var prossColor = "2b61c0".color!
    let button = UIButton(type: .Custom)
    var down:XDownLoad!
    var block:AnyBlock?
    
    var url:String
    {
        get{
            
            return down.url
        }
        set{
            
            if(down?.url == newValue){return}
            down?.removeObserver(self, forKeyPath: "state")
            down = XDownLoadManager.Share.createTask(newValue)
            self.setBlock()
            
        }
    }
    
    var progress: CGFloat {
        get {
            return circlePathLayer.strokeEnd
        }
        set {
            if (newValue >= 1) {
                circlePathLayer.strokeEnd = 1
                //self.toComplete()
            } else if (newValue < 0) {
                circlePathLayer.strokeEnd = 0
            } else {
                circlePathLayer.strokeEnd = newValue
            }
        }
    }

    init(frame: CGRect,url:String) {
        super.init(frame: frame)
        configure()
        self.url = url
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func setBlock()
    {
        self.progress = CGFloat(down.receiveLength) / CGFloat(down.totalContentLength)
        down.addObserver(self, forKeyPath: "state", options: .New, context: nil)
        
        down.block(speed: {[weak self] (s) -> Void in
            
            }, progress: {[weak self] (p) -> Void in
                
                self?.progress = CGFloat(p)

            }) {[weak self] (finish) -> Void in

                self?.progress = 1.0
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if(keyPath == "state")
        {
            switch down.state
            {
            case .Running:
                ""
                self.toRunning()
                self.button.selected =  true
                self.button.enabled = true
            case .Pause,.None,.Cancel:
                ""
                self.toPause()
                self.button.selected =  false
                self.button.enabled = true
            case .Complete:
                ""
                self.toComplete()
                self.button.selected =  false
                self.button.enabled = false

            }
        }
        
    }
    
    func configure() {
        progress = 0
        self.userInteractionEnabled = true
        
        bgPathLayer.frame = bounds
        bgPathLayer.lineWidth = lineWidth
        bgPathLayer.fillColor = UIColor.clearColor().CGColor
        bgPathLayer.strokeColor = UIColor.lightGrayColor().CGColor
        layer.addSublayer(bgPathLayer)
        bgPathLayer.strokeEnd = 1
        
        circlePathLayer.frame = bounds
        circlePathLayer.lineWidth = lineWidth
        circlePathLayer.fillColor = UIColor.clearColor().CGColor
        circlePathLayer.strokeColor = prossColor.CGColor
        circlePathLayer.lineCap = kCALineCapRound
        layer.addSublayer(circlePathLayer)
        
        startLayer.frame = button.bounds
        startLayer.lineWidth = self.lineWidth
        startLayer.fillColor = UIColor.clearColor().CGColor
        startLayer.strokeColor = prossColor.CGColor
        startLayer.strokeEnd = 1.0
        
        
        pauseLayer.frame = button.bounds
        pauseLayer.lineWidth = lineWidth
        pauseLayer.fillColor = UIColor.lightGrayColor().CGColor
        pauseLayer.strokeColor = prossColor.CGColor
        pauseLayer.strokeEnd = 0
        
        startLayer.lineCap = kCALineCapRound
        pauseLayer.lineCap = kCALineCapRound
        
        button.layer.addSublayer(startLayer)
        button.layer.addSublayer(pauseLayer)
        
        button.addTarget(self, action: #selector(XDownLoadView.click(_:)), forControlEvents: .TouchUpInside)
        button.backgroundColor = UIColor.clearColor()
        self.addSubview(button)

        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.circleRadius = bounds.size.height > bounds.size.width ? bounds.size.width : bounds.size.height
        self.lineWidth = self.circleRadius * 0.05
        
        self.circleRadius = self.circleRadius / 2.0-self.lineWidth*1.5
        
        circlePathLayer.frame = bounds
        circlePathLayer.path = circlePath().CGPath
        circlePathLayer.lineWidth = self.lineWidth
        
        bgPathLayer.frame = bounds
        bgPathLayer.path = circlePath().CGPath
        bgPathLayer.lineWidth = self.lineWidth
        
        let point = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
        button.frame = CGRectMake(0, 0, self.circleRadius*0.8, self.circleRadius*0.8)
        button.center = point
        button.contentEdgeInsets = UIEdgeInsetsMake(self.circleRadius, self.circleRadius, self.circleRadius, self.circleRadius)
        
        let path = CGPathCreateMutable();
        
        let rx = self.circleRadius*0.4/0.57735
        let lx = self.circleRadius*0.4-self.circleRadius*0.4*0.57735
        
        CGPathMoveToPoint(path, nil, rx+lx, self.circleRadius*0.4)
        CGPathAddLineToPoint(path, nil, lx, self.circleRadius*0.8)
        CGPathAddLineToPoint(path, nil, lx, 0);
        CGPathCloseSubpath(path)
        
        let path1 = CGPathCreateMutable();
        
        CGPathMoveToPoint(path1, nil, lx, self.circleRadius*0.8)
        CGPathAddLineToPoint(path1, nil, lx, 0);
        
        startLayer.path = path
        pauseLayer.path = path1
        
        startLayer.frame = button.bounds
        pauseLayer.frame = button.bounds
        
        startLayer.lineWidth = self.lineWidth
        pauseLayer.lineWidth = self.lineWidth
        
        if(self.progress == 1.0){
            
            self.button.enabled = false

            self.pauseLayer.strokeStart = 0.1
            self.pauseLayer.strokeEnd = 0.6

            self.startLayer.strokeStart = 0.66666666666
            self.startLayer.strokeEnd = 1.0
            
            self.startLayer.lineWidth = self.lineWidth
            self.pauseLayer.lineWidth = self.lineWidth
            
            
            //DelayDo(0.1, block: { (o) -> Void in
                
                var translation = CATransform3DMakeTranslation(-13.0*self.circleRadius/85.0, -10*self.circleRadius/85.0, 0)
                self.pauseLayer.transform = CATransform3DRotate(translation, DEGREES_TO_RADIANS(-45.0), 0, 0, 1)
                
                translation = CATransform3DMakeTranslation(3*self.circleRadius/85.0, -15*self.circleRadius/85.0, 0)
                self.startLayer.transform = CATransform3DRotate(translation, DEGREES_TO_RADIANS(60.0+45.0), 0, 0, 1)
                
            //})

            return
        }
        
        if(down?.state == .Running)
        {
            self.pauseLayer.strokeStart = 0.1
            self.pauseLayer.strokeEnd = 0.9
            
            self.startLayer.strokeStart = 0.6666666666666+0.1/3.0
            self.startLayer.strokeEnd = 1.0-0.1/3.0
            
            self.startLayer.lineWidth = self.lineWidth*1.5
            self.pauseLayer.lineWidth = self.lineWidth*1.5
            
            let translation = CATransform3DMakeTranslation(0, 0, 0)
            self.pauseLayer.transform = CATransform3DRotate(translation, DEGREES_TO_RADIANS(0.0), 0, 0, 1)
            self.startLayer.transform = CATransform3DRotate(translation, DEGREES_TO_RADIANS(60.0), 0, 0, 1)
            
//            DelayDo(0.1, block: { (o) -> Void in
//                
//                
//                
//                
//            })
            
        }
        
        
    }

    
    func toRunning()
    {
        let topTransform = CABasicAnimation(keyPath: "transform")
        topTransform.timingFunction = CAMediaTimingFunction(controlPoints: 0.5, -0.8, 0.5, 1.85)
        topTransform.duration = 0.6
        topTransform.fillMode = kCAFillModeBackwards
        
        let translation = CATransform3DMakeTranslation(0, 0, 0)
        
        topTransform.toValue = NSValue(CATransform3D: CATransform3DRotate(translation, DEGREES_TO_RADIANS(60.0), 0, 0, 1))
        topTransform.beginTime = CACurrentMediaTime() + 0.1
        
        self.startLayer.ocb_applyAnimation(topTransform)
        topTransform.toValue = NSValue(CATransform3D: CATransform3DRotate(translation, DEGREES_TO_RADIANS(0.0), 0, 0, 1))
        self.pauseLayer.ocb_applyAnimation(topTransform)
        
        let strokeStart = CABasicAnimation(keyPath: "strokeStart")
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")

        strokeStart.toValue = 0.6666666666666+0.1/3.0
        strokeStart.duration = 0.6
        strokeStart.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, -0.4, 0.5, 1)
        
        strokeEnd.toValue = 1.0-0.1/3.0
        strokeEnd.duration = 0.6
        strokeEnd.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, -0.4, 0.5, 1)
        
        self.startLayer.ocb_applyAnimation(strokeStart)
        self.startLayer.ocb_applyAnimation(strokeEnd)
        
        strokeStart.toValue = 0.1
        strokeEnd.toValue = 0.9
        self.pauseLayer.ocb_applyAnimation(strokeStart)
        self.pauseLayer.ocb_applyAnimation(strokeEnd)
        
        
        let lineWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
        lineWidthAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, -0.4, 0.5, 1)
        lineWidthAnimation.duration = 0.6
        lineWidthAnimation.toValue = self.lineWidth * 1.5
        
        self.startLayer.ocb_applyAnimation(lineWidthAnimation)
        self.pauseLayer.ocb_applyAnimation(lineWidthAnimation)
    }
    
    func toPause()
    {
        let topTransform = CABasicAnimation(keyPath: "transform")
        topTransform.timingFunction = CAMediaTimingFunction(controlPoints: 0.5, -0.8, 0.5, 1.85)
        topTransform.duration = 0.6
        topTransform.fillMode = kCAFillModeBackwards
        
        let translation = CATransform3DMakeTranslation(0, 0, 0)
        
        topTransform.toValue = NSValue(CATransform3D: CATransform3DRotate(translation, DEGREES_TO_RADIANS(0.0), 0, 0, 1))
        topTransform.beginTime = CACurrentMediaTime() + 0.1
        
        self.startLayer.ocb_applyAnimation(topTransform)
        
        
        let strokeStart = CABasicAnimation(keyPath: "strokeStart")
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        
        strokeStart.toValue = 0.0
        strokeStart.duration = 0.6
        strokeStart.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, -0.4, 0.5, 1)
        
        strokeEnd.toValue = 1.0
        strokeEnd.duration = 0.6
        strokeEnd.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, -0.4, 0.5, 1)
        
        self.startLayer.ocb_applyAnimation(strokeStart)
        self.startLayer.ocb_applyAnimation(strokeEnd)
        
        
        strokeEnd.toValue = 0.0
        self.pauseLayer.ocb_applyAnimation(strokeEnd)
        
        
        let lineWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
        lineWidthAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, -0.4, 0.5, 1)
        lineWidthAnimation.duration = 0.6
        lineWidthAnimation.toValue = self.lineWidth
        
        self.startLayer.ocb_applyAnimation(lineWidthAnimation)
        self.pauseLayer.ocb_applyAnimation(lineWidthAnimation)
    }
    
    
    func toComplete()
    {
        self.button.enabled = false
        let topTransform = CABasicAnimation(keyPath: "transform")
        topTransform.timingFunction = CAMediaTimingFunction(controlPoints: 0.5, -0.8, 0.5, 1.85)
        topTransform.duration = 0.6
        topTransform.fillMode = kCAFillModeBackwards
        
        var translation = CATransform3DMakeTranslation(-13*self.circleRadius/85.0, -10*self.circleRadius/85.0, 0)

        topTransform.toValue = NSValue(CATransform3D: CATransform3DRotate(translation, DEGREES_TO_RADIANS(-45.0), 0, 0, 1))
        topTransform.beginTime = CACurrentMediaTime() + 0.25
        
        self.pauseLayer.ocb_applyAnimation(topTransform)
        
        translation = CATransform3DMakeTranslation(3*self.circleRadius/85.0, -15*self.circleRadius/85.0, 0)
        topTransform.toValue = NSValue(CATransform3D: CATransform3DRotate(translation, DEGREES_TO_RADIANS(60.0+45.0), 0, 0, 1))
        
        self.startLayer.ocb_applyAnimation(topTransform)
        
        let strokeStart = CABasicAnimation(keyPath: "strokeStart")
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        
        strokeStart.toValue = 0.1
        strokeStart.duration = 0.6
        strokeStart.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, -0.4, 0.5, 1)
        
        strokeEnd.toValue = 0.6
        strokeEnd.duration = 0.6
        strokeEnd.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, -0.4, 0.5, 1)
        
        self.pauseLayer.ocb_applyAnimation(strokeStart)
        self.pauseLayer.ocb_applyAnimation(strokeEnd)
        
        strokeStart.toValue = 0.66666666666
        strokeEnd.toValue = 1.0
        self.startLayer.ocb_applyAnimation(strokeStart)
        self.startLayer.ocb_applyAnimation(strokeEnd)
        
        let lineWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
        lineWidthAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, -0.4, 0.5, 1)
        lineWidthAnimation.duration = 0.6
        lineWidthAnimation.toValue = self.lineWidth
        
        self.startLayer.ocb_applyAnimation(lineWidthAnimation)
        self.pauseLayer.ocb_applyAnimation(lineWidthAnimation)
        
    }
    
    func click(sender:UIButton)
    {
        if(down == nil || down.url=="")
        {
            return
        }
        
        sender.selected = !sender.selected
        
        if(sender.selected)
        {
            down.startDown()

            self.toRunning()
            
        }
        else
        {
            down.pauseDownLoad()
            
            self.toPause()

        }
        
        
    }
    
    func circlePath() -> UIBezierPath {
        
        let point = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
        
        let path = UIBezierPath(arcCenter: point, radius: circleRadius, startAngle: CGFloat(M_PI * 1.0), endAngle: CGFloat(M_PI * 3.0), clockwise: true)

        return path
    }
    
    func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        
        superview?.layer.mask = nil
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        if(newSuperview == nil)
        {
            down?.removeObserver(self, forKeyPath: "state")
        }
        
    }
 
    
}

func DEGREES_TO_RADIANS(angle:CGFloat)->CGFloat
{
    return angle / 180.0 * CGFloat(M_PI)
}

func RADIANS_TO_DEGREES(radians:CGFloat)->CGFloat
{
    return radians * 180.0 / CGFloat(M_PI)
}



extension CALayer {
    func ocb_applyAnimation(animation: CABasicAnimation) {
        
        if(self.presentationLayer() == nil){return}
        
        let copy = animation.copy() as! CABasicAnimation
        
        if copy.fromValue == nil {
            copy.fromValue = self.presentationLayer()!.valueForKeyPath(copy.keyPath!)
        }
        
        self.addAnimation(copy, forKey: copy.keyPath)
        self.setValue(copy.toValue, forKeyPath:copy.keyPath!)
    }
}
