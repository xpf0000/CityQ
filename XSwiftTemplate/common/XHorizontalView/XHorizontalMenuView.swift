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
    
    var mutableMenuWidth = false
    
    private var block:XHorizontalMenuBlock?
    
    func selectBlock(b:XHorizontalMenuBlock)
    {
        self.block = b
    }
    
    lazy var menuWidthArr:[NSIndexPath:CGSize] = [:]
    
    var menuTextColor : UIColor = UIColor(red: 86.0/255.0, green: 86.0/255.0, blue: 86.0/255.0, alpha: 1.0)
        {
        didSet
        {
            reloadData()
        }
    }
    
    var menuSelectColor:UIColor = UIColor(red: 223.0/255.0, green: 48.0/255.0, blue: 49.0/255.0, alpha: 1.0)
        {
        didSet
        {
            reloadData()
        }
    }
    
    var menuBGColor : UIColor = UIColor(red: 246.0/255.0, green: 244.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        {
        didSet
        {
            backgroundColor = menuBGColor
            reloadData()
        }
    }
    
    var menuMaxScale : CGFloat = 1.3
        {
        didSet
        {
            if menuMaxScale < 1.0 {menuMaxScale = 1.0}
            reloadData()
        }
        
    }
    
    var menuFontSize : CGFloat = 16.0
    {
        didSet
        {
            reloadData()
        }
    }
    
    var menuWidth:CGFloat
    {
        return frame.size.width/self.menuPageNum
    }
    
    var taped = false
    
    var selectIndex : Int = 0
        {
        didSet
        {
            self.lastIndex = oldValue
            
            block?(selectIndex)
            
            reloadData()
            
            selectItemAtIndexPath(NSIndexPath(forRow: self.selectIndex, inSection: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)

            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                
                self.line.center.x = self.menuWidth*CGFloat(self.selectIndex)+self.menuWidth/2.0
                
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
                reloadData()
            }
        }
    }
    
    var menuPageNum:CGFloat = 3
    
    var menuArr:[XHorizontalMenuModel] = []
        {
        didSet
        {
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
    
    func changeUI()
    {
        let size = (self.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize
        
        if size?.width != menuWidth || size?.height != frame.size.height
        {
            (self.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSizeMake(menuWidth, frame.size.height)
            line.frame.size.width = self.menuWidth*0.8
            line.center.x = self.menuWidth*CGFloat(self.selectIndex)+self.menuWidth/2.0
            
            line.frame.size.height = lineHeight
            line.frame.origin.y = self.frame.size.height - lineHeight
        }
        
        reloadData()
        
    }
    
    func initSelf()
    {
        
        let menulayout = UICollectionViewFlowLayout()
        menulayout.scrollDirection = .Horizontal
        menulayout.minimumLineSpacing = 0.0
        menulayout.minimumInteritemSpacing = 0.0
        menulayout.itemSize = CGSizeMake(frame.size.width, frame.size.height)
        
        collectionViewLayout = menulayout
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeUI), name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        backgroundColor = menuBGColor
        
        registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "headMenuCell")
        
        delegate = self
        dataSource = self
        
        line.backgroundColor=menuSelectColor
        line.frame=CGRectMake(0, frame.size.height-lineHeight, self.menuWidth*0.8, lineHeight);
        line.center.x = frame.size.width/menuPageNum/2.0
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
        
        if mutableMenuWidth
        {
            if let size = menuWidthArr[indexPath]
            {
                return size
            }
            else
            {
                let label = UILabel()
                label.frame = CGRectMake(0,0,10,frame.size.height)
                label.text = menuArr[indexPath.row].title
                label.sizeToFit()
                let size = CGSizeMake(label.frame.size.width+24, frame.size.height)
                menuWidthArr[indexPath] = size
                
                return size
            }
        }
        else
        {
            return CGSizeMake(menuWidth, frame.size.height)
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
