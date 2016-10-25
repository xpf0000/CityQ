//
//  XHorizontalMenuView.swift
//  XHorizontalView
//
//  Created by X on 16/5/16.
//  Copyright © 2016年 XHorizontalView. All rights reserved.
//

import UIKit

extension UIColor
{
    func getRGB() -> (r:CGFloat,g:CGFloat,b:CGFloat)
    {
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        
        var resultingPixel:[CUnsignedChar] = [0,0,0,0]
        
        let context = CGBitmapContextCreate(&resultingPixel,
                                            1,
                                            1,
                                            8,
                                            4,
                                            rgbColorSpace,
                                            CGImageAlphaInfo.NoneSkipLast.rawValue)
        
        CGContextSetFillColorWithColor(context!, self.CGColor)
        CGContextFillRect(context!, CGRectMake(0, 0, 1, 1))
        
        return (CGFloat(resultingPixel[0]),CGFloat(resultingPixel[1]),CGFloat(resultingPixel[2]))
        
    }
}

typealias XHorizontalMenuBlock = (Int)->Void

class XHorizontalMenuModel: NSObject {
    
    var title:String=""
    var id:Int=0
    var view:UIView?
    
    deinit
    {
        
    }
}


class XHorizontalMenuView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    let line:UIView = UIView()
    
    let menuLayout = UICollectionViewFlowLayout()
    
    var mutableMenuWidth = false
        {
        didSet
        {
            changeUI()
        }
    }
    
    private var block:XHorizontalMenuBlock?
    
    func selectBlock(b:XHorizontalMenuBlock)
    {
        self.block = b
    }
    
    var menuWidthArr:[NSIndexPath:CGSize] = [:]
        {
        willSet
        {
            if(mutableMenuWidth && selectIndex == 0)
            {
                let index = NSIndexPath(forRow: 0, inSection: 0)
                if self.menuWidthArr[index] == nil && newValue[index] != nil
                {
                    line.frame.size.width = newValue[index]!.width-10
                    line.center.x = newValue[index]!.width / 2.0 + menuLayout.sectionInset.left
                }
            }
            
        }
        
    }
    
    var menuTextColor : UIColor = UIColor(red: 86.0/255.0, green: 86.0/255.0, blue: 86.0/255.0, alpha: 1.0)
        {
        didSet
        {
            doRefresh()
        }
    }
    
    var menuSelectColor:UIColor = UIColor(red: 223.0/255.0, green: 48.0/255.0, blue: 49.0/255.0, alpha: 1.0)
        {
        didSet
        {
            line.backgroundColor=menuSelectColor
            doRefresh()
        }
    }
    
    var menuBGColor : UIColor = UIColor(red: 246.0/255.0, green: 244.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        {
        didSet
        {
            backgroundColor = menuBGColor
            doRefresh()
        }
    }
    
    var menuMaxScale : CGFloat = 1.0
        {
        didSet
        {
            if menuMaxScale < 1.0 {menuMaxScale = 1.0}
            doRefresh()
        }
        
    }
    
    var menuFontSize : CGFloat = 16.0
        {
        didSet
        {
            doRefresh()
        }
    }
    
    var menuWidth:CGFloat
    {
        return frame.size.width/self.menuPageNum
    }
    
    func doRefresh()
    {
        dispatch_async(dispatch_get_main_queue()) {
            
            self.reloadData()
        }
    }
    
    var offy:CGFloat = 0.0
        {
        didSet
        {
            var a = Int(floor(offy))
            var a1 = Int(ceil(offy))
            
            a = a < 0 ? 0 : a
            a1 = a1 < 0 ? 0 : a1
            
            a = a >= menuArr.count ? menuArr.count-1 : a
            
            a1 = a1 >= menuArr.count ? menuArr.count-1 : a1
            
            var rp = offy - CGFloat(a)
            
            let nowW = menuWidthArr[NSIndexPath.init(forRow: a, inSection: 0)]!.width
            
            let nextW = menuWidthArr[NSIndexPath.init(forRow: a1, inSection: 0)]!.width
            
            let p = nextW - nowW
            
            let addw = rp*p
            let addx = rp*(nextW + nowW) / 2.0
            
            if mutableMenuWidth
            {
                line.frame.size.width = (nowW + addw)-10
            }
            
            var sum:CGFloat = 0.0
            for i in 0...a
            {
                if i < a
                {
                    sum += menuWidthArr[NSIndexPath.init(forRow: i, inSection: 0)]!.width
                }
                else
                {
                    sum += menuWidthArr[NSIndexPath.init(forRow: i, inSection: 0)]!.width / 2.0
                }
                
            }
            
            line.center.x = sum + addx + menuLayout.sectionInset.left
            
            rp = fabs(rp)
            if a == a1
            {
                if a == 0
                {
                    a1 = -1
                }
                else
                {
                    a1 = menuWidthArr.count
                }
                
            }
            
            var r ,g ,b : CGFloat
            var r1,g1,b1:CGFloat
            
            (r,g,b) = menuTextColor.getRGB()
            (r1,g1,b1) = menuSelectColor.getRGB()
            
            let nowLabel=viewWithTag(30+a)
            let nextLabel=viewWithTag(30+a1)
            
            (nowLabel as? UILabel)?.textColor=UIColor(red: (r1+((r-r1)*rp))/255.0, green: (g1-((g1-g)*rp))/255.0, blue: (b1-((b1-b)*rp))/255.0, alpha: 1.0)
            
            (nextLabel as? UILabel)?.textColor=UIColor(red: (r-((r-r1)*rp))/255.0, green: (g+((g1-g)*rp))/255.0, blue: (b+((b1-b)*rp))/255.0, alpha: 1.0)
            
            let s = menuMaxScale - 1.0
            
            nowLabel?.transform = CGAffineTransformMakeScale(menuMaxScale-(s*rp), menuMaxScale-(s*rp))
            nextLabel?.transform = CGAffineTransformMakeScale(1.0+(s*rp), 1.0+(s*rp))
            
            
        }
    }
    
    var taped = false
    
    var selectIndex : Int = 0
        {
        didSet
        {
            self.lastIndex = oldValue
            
            block?(selectIndex)
            
            doRefresh()
            
            selectItemAtIndexPath(NSIndexPath(forRow: self.selectIndex, inSection: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                
                if(self.mutableMenuWidth)
                {
                    self.line.frame.size.width = self.menuWidthArr[NSIndexPath.init(forRow: self.selectIndex, inSection: 0)]!.width-10
                    
                    var sum:CGFloat = 0.0
                    
                    for (key,value) in self.menuWidthArr
                    {
                        let i = key.row
                        if i < self.selectIndex
                        {
                            sum += value.width
                        }
                        else if(i == self.selectIndex)
                        {
                            sum += value.width / 2.0
                        }
                        
                    }
                    
                    self.line.center.x = sum + self.menuLayout.sectionInset.left
                    
                }
                else
                {
                    self.line.center.x = self.menuWidth*CGFloat(self.selectIndex)+self.menuWidth/2.0 + self.menuLayout.sectionInset.left
                }
                
                
                
                self.main?.contentOffset=CGPointMake(self.main!.frame.size.width*CGFloat(self.selectIndex), 0);
                
                }, completion: { (finish) -> Void in
                    
            })
            
        }
    }
    
    
    
    var lastIndex = 0
    
    weak var main:XHorizontalMainView?
        {
        didSet
        {
            if main?.menu != self
            {
                main?.menu = self
                doRefresh()
            }
        }
    }
    
    var menuPageNum:CGFloat = 3
    
    var menuArr:[XHorizontalMenuModel] = []
        {
        didSet
        {
            menuWidthArr.removeAll(keepCapacity: false)
            self.changeUI()
            self.main?.menuArr = menuArr
            if selectIndex >= menuArr.count
            {
                selectIndex = menuArr.count-1
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
    
    var lineHeight:CGFloat = 2.0
        {
        didSet
        {
            line.frame.size.height = lineHeight
            line.frame.origin.y = self.frame.size.height - lineHeight
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setValue(true, forKey: "UIChanged")
        
    }
    
    func UINeedChange()
    {
        UIChanged = false
    }
    
    var lineWidthScale:CGFloat = 0.8
    {
        didSet
        {
            if !mutableMenuWidth
            {
                line.frame.size.width = self.menuWidth*lineWidthScale
                line.center.x = self.menuWidth*CGFloat(self.selectIndex)+self.menuWidth/2.0 + self.menuLayout.sectionInset.left
            }
            
        }
    }
    
    func changeUI()
    {
        
        let size = (self.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize
        
        if !mutableMenuWidth && (size?.width != menuWidth || size?.height != frame.size.height)
        {
            menuWidthArr.removeAll(keepCapacity: false)
            for i in 0...menuArr.count-1
            {
                menuWidthArr[NSIndexPath.init(forRow: i, inSection: 0)] = CGSizeMake(menuWidth, frame.size.height)
            }
            
            line.frame.size.width = self.menuWidth*lineWidthScale
            line.center.x = self.menuWidth*CGFloat(self.selectIndex)+self.menuWidth/2.0 + self.menuLayout.sectionInset.left
            
            
        }
        
        line.frame.size.height = lineHeight
        line.frame.origin.y = self.frame.size.height - lineHeight
        
        doRefresh()
        
        
    }
    
    func initSelf()
    {
        menuLayout.scrollDirection = .Horizontal
        menuLayout.minimumLineSpacing = 0.0
        menuLayout.minimumInteritemSpacing = 0.0
        menuLayout.itemSize = CGSizeMake(frame.size.width, frame.size.height)
        
        collectionViewLayout = menuLayout
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UINeedChange), name: UIApplicationDidChangeStatusBarFrameNotification, object: nil)
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        backgroundColor = menuBGColor
        
        registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "headMenuCell")
        
        delegate = self
        dataSource = self
        
        line.backgroundColor=menuSelectColor
        line.frame=CGRectMake(0, frame.size.height-lineHeight, self.menuWidth*lineWidthScale, lineHeight);
        line.center.x = frame.size.width/menuPageNum/2.0 + self.menuLayout.sectionInset.left
        addSubview(line)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initSelf()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.initSelf()
        
    }
    
    init()
    {
        super.init(frame: CGRectMake(0, 0, 1, 1), collectionViewLayout: UICollectionViewLayout())
        
        self.initSelf()
    }
    
    convenience init(frame: CGRect,arr:[XHorizontalMenuModel]) {
        
        self.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
        
        menuArr = arr
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if let size = menuWidthArr[indexPath]
        {
            return size
        }
        else
        {
            
            if mutableMenuWidth
            {
                let label = UILabel()
                label.frame = CGRectMake(0,0,10,frame.size.height)
                label.text = menuArr[indexPath.row].title
                label.sizeToFit()
                let size = CGSizeMake(label.frame.size.width+24, frame.size.height)
                menuWidthArr[indexPath] = size
                
                return size
            }
            else
            {
                let size = CGSizeMake(menuWidth, frame.size.height)
                menuWidthArr[indexPath] = size
                
                return size
            }
            
        }
        
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return menuArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let obj = menuArr[indexPath.row]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("headMenuCell", forIndexPath: indexPath)
        
        for item in cell.contentView.subviews
        {
            item.removeFromSuperview()
        }
        
        let titleLabel = UILabel()
        titleLabel.frame = cell.bounds
        titleLabel.text=obj.title
        titleLabel.textAlignment=NSTextAlignment.Center;
        titleLabel.backgroundColor=UIColor.clearColor()
        titleLabel.textColor = menuTextColor
        titleLabel.font=UIFont.systemFontOfSize(menuFontSize)
        titleLabel.tag = 30+indexPath.row
        
        titleLabel.sizeToFit()
        //titleLabel.center = CGPointMake(cell.frame.size.width / 2.0, cell.frame.size.height / 2.0)
        
        if(indexPath.row==self.selectIndex)
        {
            if taped
            {
                UIView.animateWithDuration(0.25, animations: {
                    
                    titleLabel.textColor=self.menuSelectColor
                    
                    titleLabel.transform = CGAffineTransformMakeScale(self.menuMaxScale, self.menuMaxScale)
                    
                })
            }
            else
            {
                titleLabel.textColor=menuSelectColor
                titleLabel.transform = CGAffineTransformMakeScale(self.menuMaxScale, self.menuMaxScale)
            }
            
        }
        else if(indexPath.row==lastIndex)
        {
            if lastIndex != selectIndex && taped
            {
                titleLabel.textColor=self.menuSelectColor
                titleLabel.transform = CGAffineTransformMakeScale(self.menuMaxScale, self.menuMaxScale)
                UIView.animateWithDuration(0.25, animations: {
                    
                    titleLabel.textColor = self.menuTextColor
                    titleLabel.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    
                })
            }
            else
            {
                titleLabel.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }
            
        }
        else
        {
            titleLabel.transform = CGAffineTransformMakeScale(1.0, 1.0)
        }
        
        cell.contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints=false
        
        let centerX = NSLayoutConstraint(item: titleLabel, attribute: .CenterX, relatedBy: .Equal, toItem: cell.contentView, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        
        let centerY = NSLayoutConstraint(item: titleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: cell.contentView, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        
        cell.contentView.addConstraints([centerX,centerY])
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.taped = true
        self.selectIndex=indexPath.row;
        
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
