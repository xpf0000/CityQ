//
//  BootView.swift
//  chengshi
//
//  Created by X on 15/12/26.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class XBootView: UIView,UIScrollViewDelegate {

    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var content: UIView!
    
    @IBOutlet var contentW: NSLayoutConstraint!
    
    @IBOutlet var page: UIPageControl!
    
    var index=0
    var block:AnyBlock?
    
    func initBanner()
    {
        let containerView:UIView=("XBootView".Nib.instantiateWithOwner(self, options: nil))[0] as! UIView
        
        let newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        containerView.frame = newFrame
        self.addSubview(containerView)
        
        self.scrollView.delegate = nil
        
        page.hidden = true

    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.initBanner()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initBanner()
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if(keyPath == "contentOffset")
        {
            let x:CGFloat = scrollView!.contentOffset.x
            
            if(Int(x*100) % Int(swidth*100) == 0)
            {
                let nowIndex:Int=Int(Int(x*100)/Int(swidth*100))
                
                self.page.currentPage = nowIndex
            }
            
            if(x > swidth * CGFloat(DataCache.Share().welcom.info.count-1))
            {
                self.scrollView.removeObserver(self, forKeyPath: "contentOffset")
                
                DataCache.Share().welcom.reSet()
                self.block?(true)
                self.block=nil
                self.removeFromSuperview()
                return
            }
            
        }
    }
    
    func show(view:UIView?)
    {
        self.scrollView.addObserver(self, forKeyPath: "contentOffset", options: .New, context: nil)
        
        self.contentW.constant = swidth * CGFloat(DataCache.Share().welcom.info.count)
        self.page.numberOfPages = DataCache.Share().welcom.info.count
        self.page.currentPage = 0
        
        var i:CGFloat=0
        for item in DataCache.Share().welcom.info
        {
            let imageView:UIImageView = UIImageView()
            imageView.image = item.image
            imageView.contentMode = .ScaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.masksToBounds = true
            
            self.content.addSubview(imageView)
            
            imageView.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(swidth)
                make.height.equalTo(sheight)
                make.centerY.equalTo(self.content)
                make.centerX.equalTo(self.scrollView).offset(swidth*CGFloat(i))
                
            })
            
            i++
        }

        view?.addSubview(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    
    deinit
    {
        self.scrollView.delegate = nil
        self.block = nil
    }

    
}
