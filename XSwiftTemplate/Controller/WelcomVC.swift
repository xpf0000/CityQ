//
//  WelcomVC.swift
//  lejia
//
//  Created by X on 15/11/6.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class WelcomVC: XViewController ,UIScrollViewDelegate{

    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var content: UIView!
    
    @IBOutlet var page: UIPageControl!
    
    @IBOutlet var width: NSLayoutConstraint!
    
    var index=0
    var block:AnyBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.width.constant = swidth * CGFloat(DataCache.Share().welcom.info.count)
        self.page.numberOfPages = DataCache.Share().welcom.info.count
        self.page.currentPage = 0
        
        var i:CGFloat=0
        for item in DataCache.Share().welcom.info
        {
            let imageView:UIImageView = UIImageView()
            imageView.image = item.image
            
            self.content.addSubview(imageView)
            
           imageView.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(swidth)
                make.height.equalTo(sheight)
                make.centerY.equalTo(self.content)
                make.centerX.equalTo(self.scrollView).offset(swidth*CGFloat(i))
                
            })
            
            i++
        }

        
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if(Int(scrollView.contentOffset.x*100) % Int(swidth*100) == 0)
        {
            let nowIndex:Int=Int(Int(scrollView.contentOffset.x*100)/Int(swidth*100))
            
            self.page.currentPage = nowIndex
        }
        
        if(scrollView.contentOffset.x > swidth * CGFloat(DataCache.Share().welcom.info.count-1))
        {
            self.dismissViewControllerAnimated(false, completion: { () -> Void in

                DataCache.Share().welcom.reSet()
                
                if(self.block != nil)
                {
                    self.block!(true)
                    self.block=nil
                }
                
            
            })
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
