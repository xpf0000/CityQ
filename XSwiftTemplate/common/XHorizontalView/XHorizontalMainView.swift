//
//  XHorizontalswift
//  XHorizontalView
//
//  Created by X on 16/5/17.
//  Copyright © 2016年 XHorizontalView. All rights reserved.
//

import UIKit

class XHorizontalMainView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate {
    
    let mainLayout = UICollectionViewFlowLayout()
    
    weak var menu:XHorizontalMenuView?
        {
        didSet
        {
            if menu?.main != self
            {
                menu?.main = self
                doRefresh()
            }
        }
    }
    
    func doRefresh()
    {
        dispatch_async(dispatch_get_main_queue()) {
            
            self.reloadData()
        }
    }
    
    
    private var block:XHorizontalMenuBlock?
    
    func selectBlock(b:XHorizontalMenuBlock)
    {
        self.block = b
    }
    
    var selectIndex : Int = 0
        {
        didSet
        {
            block?(selectIndex)
            
            selectItemAtIndexPath(NSIndexPath(forRow: self.selectIndex, inSection: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)
            
        }
    }
    
    
    var menuArr:[XHorizontalMenuModel] = []
        {
        didSet
        {
            self.changeUI()
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
        
        doRefresh()
        
    }
    
    func initSelf()
    {
        
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
        
        return menuArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("mainViewCell", forIndexPath: indexPath)
        
        for item in cell.contentView.subviews
        {
            item.removeFromSuperview()
        }
        
        let obj = menuArr[indexPath.row]
        
        if let view = obj.view
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
        let t = scrollView.contentOffset.x / frame.size.width
        menu?.offy = t
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let currentPage : Int = Int(floor((scrollView.contentOffset.x - frame.size.width/2)/frame.size.width))+1;
        
        if(menu?.selectIndex != currentPage)
        {
            menu?.lastIndex = currentPage;
            menu?.selectIndex=currentPage;
            menu?.lastIndex = currentPage;
        }
        
        selectIndex = currentPage;
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        menu?.taped = false
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
