//
//  XHorizontalswift
//  XHorizontalView
//
//  Created by X on 16/5/17.
//  Copyright © 2016年 XHorizontalView. All rights reserved.
//

import UIKit

class XHorizontalMainView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate {
    
    weak var menu:XHorizontalMenuView?
        {
        didSet
        {
            if menu?.main != self
            {
                menu?.main = self
                reloadData()
            }
        }
    }
    
    var UIChanged:Bool = false
        {
        willSet
        {
            if newValue != UIChanged
            {
                changeUI()
            }
            
        }
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setValue(true, forKey: "UIChanged")
        
    }
    
    func changeUI()
    {
        let size = (self.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize
        
        if size?.width != frame.size.width || size?.height != frame.size.height
        {
            (self.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSizeMake(frame.size.width, frame.size.height)
        }
        
        reloadData()
        
    }
    
    func initSelf()
    {
        let mainLayout = UICollectionViewFlowLayout()
        mainLayout.scrollDirection = .Horizontal
        mainLayout.minimumLineSpacing = 0.0
        mainLayout.minimumInteritemSpacing = 0.0
        mainLayout.itemSize = CGSizeMake(frame.size.width, frame.size.height)
        
        collectionViewLayout = mainLayout
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeUI), name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        backgroundColor = UIColor.whiteColor()
        bounces = true
        clipsToBounds = true
        layer.masksToBounds = true
        pagingEnabled = true
        delegate = self
        dataSource = self
        
        registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "mainViewCell")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initSelf()
        
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        initSelf()
        
    }
    
    init()
    {
        super.init(frame: CGRectMake(0, 0, 1, 1), collectionViewLayout: UICollectionViewLayout())
        
        self.initSelf()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return menu == nil ? 0 : menu!.menuArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("mainViewCell", forIndexPath: indexPath)
        
        for item in cell.contentView.subviews
        {
            item.removeFromSuperview()
        }
        
        let obj = menu?.menuArr[indexPath.row]
        
        if let view = obj?.view
        {
            view.frame = CGRectZero
            cell.contentView.addSubview(view)
            
            view.translatesAutoresizingMaskIntoConstraints=false
            
            let top = NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: cell.contentView, attribute: .Top, multiplier: 1.0, constant: 0.0)
            
            let bottom = NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: cell.contentView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
            
            let Leading = NSLayoutConstraint(item: view, attribute: .Leading, relatedBy: .Equal, toItem: cell.contentView, attribute: .Leading, multiplier: 1.0, constant: 0.0)
            
            let trailing = NSLayoutConstraint(item: view, attribute: .Trailing, relatedBy: .Equal, toItem: cell.contentView, attribute: .Trailing, multiplier: 1.0, constant: 0.0)
            
            cell.contentView.addConstraints([top,bottom,Leading,trailing])
            
        }
        
        return cell
        
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if menu == nil {return}
        
        let currentPage : Int = Int(floor((scrollView.contentOffset.x - frame.size.width/2)/frame.size.width))+1;
        
        var i : CGFloat = scrollView.contentOffset.x/(frame.size.width*CGFloat(menu!.menuArr.count))
        
        menu?.line.center.x = menu!.menuWidth*CGFloat(menu!.menuArr.count)*i+menu!.menuWidth/2.0
        
        var nextIndex=0
        
        if(scrollView.contentOffset.x>CGFloat(currentPage)*frame.size.width)
        {
            nextIndex=currentPage+1
            i=(scrollView.contentOffset.x-CGFloat(currentPage)*frame.size.width)/frame.size.width
        }
        else
        {
            nextIndex=currentPage-1
            i=(CGFloat(currentPage)*frame.size.width-scrollView.contentOffset.x)/frame.size.width
        }
        
        var r ,g ,b : CGFloat
        var r1,g1,b1:CGFloat
        
        if(nextIndex>=0 && nextIndex<menu!.menuArr.count)
        {
            (r,g,b) = menu!.menuTextColor.getRGB()
            (r1,g1,b1) = menu!.menuSelectColor.getRGB()
            
            let nowLabel=menu!.viewWithTag(30+currentPage)
            let nextLabel=menu!.viewWithTag(30+nextIndex)
            
            (nowLabel as? UILabel)?.textColor=UIColor(red: (r1+((r-r1)*i))/255.0, green: (g1-((g1-g)*i))/255.0, blue: (b1-((b1-b)*i))/255.0, alpha: 1.0)
            
            (nextLabel as? UILabel)?.textColor=UIColor(red: (r-((r-r1)*i))/255.0, green: (g+((g1-g)*i))/255.0, blue: (b+((b1-b)*i))/255.0, alpha: 1.0)
            
            let p = menu!.menuMaxScale - 1.0
            nowLabel?.transform = CGAffineTransformMakeScale(menu!.menuMaxScale-(p*i), menu!.menuMaxScale-(p*i))
            nextLabel?.transform = CGAffineTransformMakeScale(1.0+(p*i), 1.0+(p*i))
            
        }
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if menu == nil {return}
        
        let currentPage : Int = Int(floor((scrollView.contentOffset.x - frame.size.width/2)/frame.size.width))+1;
        
        if(menu!.selectIndex != currentPage)
        {
            menu?.lastIndex = currentPage;
            menu!.selectIndex=currentPage;
            menu?.lastIndex = currentPage;
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        menu?.taped = false
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
