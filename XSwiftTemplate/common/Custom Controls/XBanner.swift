//
//  XBanner.swift
//  lejia
//
//  Created by X on 15/9/11.
//  Copyright (c) 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class XBannerModel:NSObject
{
    var clickURL=""
    var title=""
    var image:UIImage?
    var imageURL = ""
    var obj:AnyObject?
}

typealias XBannerBlock = (XBannerModel)->Void

//@IBDesignable
class XBanner: UIView , UIScrollViewDelegate{
    
    @IBInspectable var AutoScroll: Bool = false
    @IBInspectable var LeftToRight:Bool = false
    @IBInspectable var scrollTime:Double = 2.0
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var titleButton: UIButton!
    
    @IBOutlet var ctitle: UILabel!
    
    @IBOutlet var page: UIPageControl!
    
    
    private var timer:NSTimer?
    private var block:XBannerBlock?
    
    func click(b:XBannerBlock)
    {
        self.block = b
    }
    
    var width:CGFloat=0.0
        {
        didSet
        {
            if width == 0 {return}
            
            self.scrollView.contentSize=CGSizeMake(arr.count > 1 ? CGFloat(arr.count+4) * width : width,0);
            
            var i = 0
            for item in btnArr
            {
                item.frame = CGRectMake(self.width*CGFloat(i), 0, self.width, self.frame.size.height)
                
                i += 1
            }
            
            if index == 0
            {
                if(self.arr.count>1)
                {
                    self.scrollView.contentOffset=CGPointMake(self.width*2, 0)
                }
                else
                {
                    self.scrollView.contentOffset=CGPointMake(0, 0)
                    
                }
            }
        }
    }
    
    var index:Int=0
        {
        didSet
        {
            if(self.arr.count > 0)
            {
                self.ctitle.text=self.arr[index].title
                self.page.currentPage=index
                //updateDots()
            }
        }
    }
    
    
    var arr:Array<XBannerModel>=[]
        {
        didSet
        {
            btnArr.removeAll(keepCapacity: false)
            self.scrollView.removeAllSubViews()
            scrollView.delegate = nil
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
                
                let img:UIImageView = UIImageView()
                
                if(model.image != nil)
                {
                    img.image=model.image
                }
                else
                {
                    img.url = model.imageURL
                }
                
                
                let button:UIButton=UIButton(type: UIButtonType.Custom)
                button.frame=CGRectMake(self.width*CGFloat(i), 0, self.width, self.frame.size.height)
                button.backgroundColor=UIColor.clearColor()
                
                button.addTarget(self, action: #selector(buttonClick), forControlEvents: .TouchUpInside)
                button.enabled = true
                self.scrollView.addSubview(button)
                
                button.layer.masksToBounds = true
                button.clipsToBounds = true
                
                //img.userInteractionEnabled = false
                
                button.addSubview(img)
                
                img.snp_makeConstraints(closure: { (make) in
                    make.top.equalTo(0.0)
                    make.bottom.equalTo(0.0)
                    make.leading.equalTo(0.0)
                    make.trailing.equalTo(0.0)
                })
                
                btnArr.append(button)
                
            }
            
            self.page.numberOfPages=self.arr.count
            self.page.currentPage=0
            
            self.index = 0
            self.width=self.frame.size.width
            
            
            if(self.AutoScroll)
            {
                
                let delayInSeconds:Double=self.scrollTime
                let popTime:dispatch_time_t=dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
                
                dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
                    
                    self.timer=NSTimer.scheduledTimerWithTimeInterval(self.scrollTime, target: self, selector: #selector(XBanner.doScroll), userInfo: nil, repeats: true)
                    self.timer!.fire()
                    
                })
                
            }
            
            scrollView.delegate = self
        }
    }
    
    dynamic var hiddenTitle:Bool=false
    
    func initBanner()
    {
        let containerView:UIView=("XBanner".Nib.instantiateWithOwner(self, options: nil))[0] as! UIView
        
        let newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        containerView.frame = newFrame
        self.addSubview(containerView)
        
        self.addObserver(self, forKeyPath: "hiddenTitle", options: [.New, .Old] , context: nil)
        
        userInteractionEnabled = true
        scrollView.userInteractionEnabled = true
        
        titleButton.addTarget(self, action: #selector(buttonClick), forControlEvents: .TouchUpInside)
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
    
    lazy var btnArr:[UIButton] = []
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if(keyPath == "hiddenTitle")
        {
            self.titleButton.hidden=self.hiddenTitle
            self.ctitle.hidden=self.hiddenTitle
        }
        
    }
    
    //    func updateDots()
    //    {
    //        var i:CGFloat=0
    //        //TODO:j原来为3.5
    //        let j:CGFloat=0.0
    //        for item in self.page.subviews
    //        {
    //           item.removeAllSubViews()
    //            //颜色原来为lightGary
    //            item.backgroundColor = UIColor.whiteColor()
    //            let  frame=item.frame
    //
    //            let view:UIView=UIView()
    //            item.addSubview(view)
    //
    //            if(Int(i) != index)
    //            {
    //                view.backgroundColor = UIColor.whiteColor()
    //                view.frame=CGRectMake(0, 0, 3.0, 3.0)
    //                view.layer.masksToBounds = true
    //                view.layer.cornerRadius = 2.0
    //            }
    //            else
    //            {
    //                view.backgroundColor = redTXT
    //                view.frame=CGRectMake(0, 0, 5.0, 5.0)
    //                view.layer.cornerRadius = 2.0
    //                view.layer.cornerRadius = 2.9
    //            }
    //
    //
    //            view.center = CGPointMake(frame.width/2.0-j*i, frame.height/2.0)
    //
    //            i++
    //
    //        }
    //    }
    
    
    
    func doScroll()
    {
        let add:CGFloat = self.LeftToRight ? self.width * CGFloat(-1) : self.width
        
        self.scrollView.setContentOffset(CGPointMake(self.scrollView.contentOffset.x+add, self.scrollView.contentOffset.y), animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        
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
                index = nowIndex
            }
        }
        
    }
    
    
    func buttonClick() {
        
        if index < arr.count
        {
            self.block?(self.arr[self.index])
        }
        
    }
    
    deinit
    {
        self.removeObserver(self, forKeyPath: "hiddenTitle")
        self.scrollView.delegate=nil
        self.block=nil
        self.timer?.invalidate()
        self.timer=nil
        
        print("XBanner deinit !!!!!!!!!")
    }
    
}
