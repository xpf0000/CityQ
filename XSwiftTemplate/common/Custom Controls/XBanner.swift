//
//  XBanner.swift
//  lejia
//
//  Created by X on 15/9/11.
//  Copyright (c) 2015年 XSwiftTemplate. All rights reserved.
//import UIKit

class XBannerModel:NSObject
{
    var url:String=""
    var title:String=""
    var image:String=""
    var obj:AnyObject?
}

typealias XBannerBlock = (AnyObject?)->Void

//@IBDesignable
class XBanner: UIView , UIScrollViewDelegate{

    @IBInspectable var AutoScroll: Bool = false
    @IBInspectable var LeftToRight:Bool = false
    @IBInspectable var scrollTime:Double = 2.0
    
    
    @IBOutlet var time: UILabel!
    
    @IBOutlet var timeH: NSLayoutConstraint!
    
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var titleView: UIView!
    
    @IBOutlet var ctitle: UILabel!
    
    @IBOutlet var page: UIPageControl!
    
    @IBOutlet var titleTop: NSLayoutConstraint!
    
   // @IBOutlet var pageLeft: NSLayoutConstraint!
    
    private var timer:NSTimer?
    var block:XBannerBlock?
    var width:CGFloat=0.0
    var index:Int=0
    dynamic var arr:Array<XBannerModel>=[]
    dynamic var hiddenTitle:Bool=false
    
    var showUserDots=false
    
    func initBanner()
    {
        let containerView:UIView=("XBanner".Nib.instantiateWithOwner(self, options: nil))[0] as! UIView
        
        let newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        containerView.frame = newFrame
        self.addSubview(containerView)
        
        self.addObserver(self, forKeyPath: "arr", options: .New , context: nil)
        self.addObserver(self, forKeyPath: "index", options: [.New, .Old] , context: nil)
        self.addObserver(self, forKeyPath: "hiddenTitle", options: [.New, .Old] , context: nil)
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.initBanner()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initBanner()
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.width=self.frame.size.width
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if(keyPath == "hiddenTitle")
        {
            self.titleView.hidden=self.hiddenTitle
            self.ctitle.hidden=self.hiddenTitle
        }
        
        if(keyPath == "arr")
        {
            for view in self.scrollView.subviews
            {
                view.removeFromSuperview()
            }
            self.timer?.invalidate()
            self.timer=nil
            
            self.scrollView.contentSize=CGSizeMake(0, 0)
            self.scrollView.contentOffset=CGPointMake(0, 0)
            self.page.numberOfPages=0
            
            let k = arr.count > 1 ? 4 : 0
            for i in 0..<arr.count+k
            {
                var tt=0
                if(i==0)
                {
                    tt=arr.count-2
                }
                else if (i==1)
                {
                    tt=arr.count-1
                }
                else if(i==arr.count+2)
                {
                    tt=0
                }
                else if (i==arr.count+3)
                {
                    tt=1
                }
                else
                {
                    tt=i-2
                }
                
                tt = tt < 0 ? 0 : tt
                tt = tt >= arr.count ? arr.count-1 : tt
                
                let model:XBannerModel=self.arr[tt]
                
                var img:UIImageView?
                if(model.image != "")
                {
                    img=UIImageView(frame: CGRectMake(0, 0, self.width, self.frame.size.height))
                    
                    img?.image=model.image.image
                }
                else
                {
                    img = UIImageView(frame: CGRectMake(0, 0, self.width, self.frame.size.height))
                    img?.url = model.url
                }
                

                let button:UIButton=UIButton(type: UIButtonType.Custom)
                button.frame=CGRectMake(self.width*CGFloat(i), 0, self.width, self.frame.size.height)
                button.backgroundColor=UIColor.clearColor()
                button.addTarget(self, action: #selector(XBanner.buttonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
                button.addSubview(img!)

                self.scrollView.addSubview(button)
 
            }
            
            self.scrollView.contentSize=CGSizeMake(arr.count > 1 ? CGFloat(arr.count+4) * width : width,0);
            self.page.numberOfPages=self.arr.count
            self.page.currentPage=0
            
            if(self.arr.count>1)
            {
                self.scrollView.contentOffset=CGPointMake(self.width*2, 0)
                if(self.AutoScroll)
                {
                    
                    let delayInSeconds:Double=self.scrollTime
                    let popTime:dispatch_time_t=dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
                    
                    dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
                        
                        self.timer=NSTimer.scheduledTimerWithTimeInterval(self.scrollTime, target: self, selector: #selector(XBanner.doScroll), userInfo: nil, repeats: true)
                        self.timer!.fire()
                        
                    })
                    
                }
                self.scrollView.scrollEnabled = true
            }
            else
            {
                self.scrollView.contentOffset=CGPointMake(0, 0)
                self.scrollView.scrollEnabled = false
            }
            
            self.setValue(0, forKeyPath: "index")
            
            
        }
        
        if(keyPath == "index")
        {
            if(self.arr.count > 0)
            {
                self.ctitle.text=self.arr[index].title
                self.page.currentPage=index
                
                if(self.showUserDots)
                {
                    updateDots()
                }
                
            }
            
        }
        
        
    }
    
    func updateDots()
    {
        var i:CGFloat=0
        let j:CGFloat=3.5
        for item in self.page.subviews
        {
           item.removeAllSubViews()
            item.backgroundColor = UIColor.whiteColor()
            let  frame=item.frame
            
            let view:UIView=UIView()
            item.addSubview(view)
            
            if(Int(i) != index)
            {
                view.backgroundColor = UIColor.lightGrayColor()
                view.frame=CGRectMake(0, 0, 3.0, 3.0)
                view.layer.masksToBounds = true
                view.layer.cornerRadius = 2.0
            }
            else
            {
                view.backgroundColor = APPBlueColor
                view.frame=CGRectMake(0, 0, 5.0, 5.0)
                view.layer.cornerRadius = 2.0
                view.layer.cornerRadius = 2.9
            }
            
            view.center = CGPointMake(frame.width/2.0-j*i, frame.height/2.0)
            
            i++
            
        }
    }
    
    func doScroll()
    {
        let add:CGFloat = self.LeftToRight ? self.width * CGFloat(-1) : self.width
        
        self.scrollView.setContentOffset(CGPointMake(self.scrollView.contentOffset.x+add, self.scrollView.contentOffset.y), animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if !scrollView.scrollEnabled{return}
        
        if(scrollView.contentOffset.x<=width)
        {
            scrollView.contentOffset.x=CGFloat(1+arr.count)*width
        }
        
        if(scrollView.contentOffset.x >= width*CGFloat(arr.count+2))
        {
            scrollView.contentOffset.x=CGFloat(2)*width
        }
        
        if(Int(scrollView.contentOffset.x*100)%Int(width*100)==0)
        {
            let nowIndex:Int=Int(Int(scrollView.contentOffset.x*100)/Int(width*100))-2;
            if(nowIndex != index)
            {
                self.setValue(nowIndex, forKeyPath: "index")
            }
        }
        
        
    }
    
    
    func buttonClick(sender: AnyObject) {
        
        if(self.block != nil)
        {
            self.block!(self.arr[self.index].obj)
        }
    }
    
    deinit
    {
        self.removeObserver(self, forKeyPath: "arr")
        self.removeObserver(self, forKeyPath: "index")
        self.removeObserver(self, forKeyPath: "hiddenTitle")
        self.scrollView.delegate=nil
        self.block=nil
        self.timer?.invalidate()
        self.timer=nil
        
    }

}
