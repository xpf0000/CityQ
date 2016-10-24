//
//  XCommonAlert.swift
//  CardSJD
//
//  Created by X on 16/9/13.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

let SINGLE_LINE_WIDTH = 1 / screenScale
let SINGLE_LINE_ADJUST_OFFSET = 1/screenScale/2

public enum XAlertStyle : Int {
    
    case ActionSheet
    case Alert
}


typealias XAlertExpandBlock = ()->UIView
typealias XAlertClickBlock = (Int)->Bool

let XAlertWidth = swidth * 0.85

class XCommonAlert: UIView ,UITableViewDelegate,UITableViewDataSource{
    
    private var expandViewBlock:XAlertExpandBlock?
    private var clickBlock:XAlertClickBlock?
    
    func click(b:XAlertClickBlock)
    {
        clickBlock = b
    }

    var type:XAlertStyle = .Alert
    
    var mainView = UIToolbar()
    
    var btnArr:[String] = []
    
    var bgColor:UIColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.7)
    {
        didSet
        {
            self.backgroundColor = bgColor
        }
    }
    
    var alertBGColor:UIColor = UIColor.whiteColor()
        {
        didSet
        {
            self.mainView.backgroundColor = alertBGColor
        }
    }
    
    private var xtitle:String?
    private var xmessage:String?
    private var buttonArr:[UIButton] = []
    private var sepColor = "dadade".color!
    private let btnH:CGFloat=44.0
    private var lineH:CGFloat = SINGLE_LINE_WIDTH
    private var table:UITableView!
    
    func initSelf()
    {
        self.frame = CGRectMake(0, 0, swidth, sheight)
        self.backgroundColor = bgColor
        self.addSubview(mainView)
        
        mainView.frame = CGRectMake((swidth-XAlertWidth)*0.5, 0, XAlertWidth, 100)
        mainView.barTintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        mainView.translucent = true
        mainView.layer.shadowColor = UIColor.clearColor().CGColor
        mainView.barStyle = .BlackTranslucent
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 15.0
        
    }
    
    func initView()
    {
        var h:CGFloat = 0.0
        //mainView.removeAllSubViews()
        
        if xtitle == nil && xmessage != nil
        {
            xtitle = xmessage
            xmessage = nil
        }
        
        if let txt = xtitle
        {
            let title = UILabel()
            title.textAlignment = .Center
            title.font = UIFont.boldSystemFontOfSize(17.0)
            title.frame = CGRectMake(10, 0, XAlertWidth-20, 1)
            title.numberOfLines = 0
            title.text = txt
            title.sizeToFit()
            title.frame = CGRectMake(15, 20, XAlertWidth-30, title.frame.size.height)
            mainView.addSubview(title)
            
            h = 20+title.frame.size.height+7
        }
 
        if let txt = xmessage
        {
            let message = UILabel()
            message.textAlignment = .Center
            message.font = UIFont.systemFontOfSize(13.0)
            message.frame = CGRectMake(15, 0, XAlertWidth-30, 1)
            message.text = txt
            message.numberOfLines = 0
            message.sizeToFit()
            message.frame = CGRectMake(15, h, XAlertWidth-30, message.frame.size.height)
            mainView.addSubview(message)
            
            h += message.frame.size.height+12
        }

        
        if let expand = expandViewBlock?()
        {
            expand.frame.origin.y = h
            
            mainView.addSubview(expand)
            
            h += expand.frame.size.height
        }
        else
        {
            if xtitle != nil || xmessage != nil
            {
                h += 10
            }
            else
            {
                lineH = 0.0
            }
            
        }
        
        if btnArr.count == 2
        {
            let btnBG=UIView()
            btnBG.backgroundColor = UIColor.clearColor()
            mainView.addSubview(btnBG)
            btnBG.frame = CGRectMake(0, h, XAlertWidth, btnH+lineH)
            
            h += btnH+lineH
            
            
            let left = UIButton(type: .Custom)
            left.frame = CGRectMake(0, lineH, XAlertWidth/2.0+0.25, btnH)
            left.setTitleColor("007aff".color, forState: .Normal)
            left.setTitle(btnArr[0], forState: .Normal)
            left.titleLabel?.font = UIFont.systemFontOfSize(17.0)
            
            left.setBackgroundImage(UIColor.clearColor().image, forState: .Normal)
            left.setBackgroundImage("eaeaea".color?.image, forState: .Highlighted)
            
            btnBG.addSubview(left)
            
            buttonArr.append(left)
            
            let right = UIButton(type: .Custom)
            right.frame = CGRectMake(XAlertWidth/2.0-0.25, lineH, XAlertWidth/2.0+0.25, btnH)
            right.setTitleColor("007aff".color, forState: .Normal)
            right.setTitle(btnArr[1], forState: .Normal)
            right.titleLabel?.font = UIFont.systemFontOfSize(17.0)
            
            right.setBackgroundImage(UIColor.clearColor().image, forState: .Normal)
            right.setBackgroundImage("eaeaea".color?.image, forState: .Highlighted)
            
            btnBG.addSubview(right)
            
            buttonArr.append(right)
            
            left.layer.masksToBounds = true
            left.layer.borderColor = sepColor.CGColor
            left.layer.borderWidth = SINGLE_LINE_WIDTH
            
            right.layer.masksToBounds = true
            right.layer.borderColor = sepColor.CGColor
            right.layer.borderWidth = SINGLE_LINE_WIDTH
            
            
//            let lineTop = UIView()
//            lineTop.backgroundColor = sepColor
//            lineTop.frame = CGRectMake(0, -SINGLE_LINE_ADJUST_OFFSET, XAlertWidth, SINGLE_LINE_WIDTH)
//            btnBG.addSubview(lineTop)
//            
//            let line = UIView()
//            line.backgroundColor = sepColor
//            line.frame = CGRectMake(XAlertWidth/2.0-0.25-SINGLE_LINE_ADJUST_OFFSET, 0, SINGLE_LINE_WIDTH, btnH+0.5)
//            btnBG.addSubview(line)
            
            left.addTarget(self, action: #selector(btnClick(_:)), forControlEvents: .TouchUpInside)
            right.addTarget(self, action: #selector(btnClick(_:)), forControlEvents: .TouchUpInside)
            
        }
        else
        {
            table = UITableView(frame: CGRectZero)
            table.backgroundColor = UIColor.clearColor()
            table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
            let count:CGFloat = CGFloat(btnArr.count) * btnH+SINGLE_LINE_WIDTH
            table.frame = CGRectMake(0, h, XAlertWidth, count)
            table.delegate = self
            table.dataSource = self
            
            let view = UIView()
            table.tableFooterView = view
            table.tableHeaderView = view
            
            table.reloadData()
            mainView.addSubview(table)
            
            let mh = h+count
            
            if mh > sheight-20
            {
                table.frame.size.height = sheight-20-h
                h = sheight-20
                table.scrollEnabled = true
            }
            else
            {
                table.scrollEnabled = false
                h = mh
            }
        }
        
        
        mainView.frame.size.height = h
        
        
        mainView.center.y = sheight / 2.0
        
        mainView.alpha = 1.0
        
        
    }
    
    convenience init(title:String?,message:String?,buttons:String?...)
    {
        self.init(frame:CGRectZero)
        
        xtitle = title
        xmessage = message
        
        if buttons.count == 0
        {
            self.btnArr = ["取消","确定"]
        }
        else if buttons.count == 1
        {
            if buttons[0] == nil
            {
                self.btnArr = ["取消","确定"]
            }
            else
            {
                self.btnArr = [buttons[0]!]
            }
        }
        else
        {
            btnArr.removeAll(keepCapacity: false)
            for item in buttons
            {
                if item != nil
                {
                    btnArr.append(item!)
                }
            }
        }
        
        initView()
        
    }
    
    convenience init(title:String?,message:String?,expand:XAlertExpandBlock?,buttons:String?...)
    {
        self.init(frame:CGRectZero)
        self.expandViewBlock=expand
        
        xtitle = title
        xmessage = message
        
        if buttons.count == 0
        {
            self.btnArr = ["取消","确定"]
        }
        else if buttons.count == 1
        {
            if buttons[0] == nil
            {
                self.btnArr = ["取消","确定"]
            }
            else
            {
                self.btnArr = [buttons[0]!]
            }
        }
        else
        {
            btnArr.removeAll(keepCapacity: false)
            for item in buttons
            {
                if item != nil
                {
                    btnArr.append(item!)
                }
            }
            
            if btnArr.count == 0
            {
                self.btnArr = ["取消","确定"]
            }
        }
        
        initView()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initSelf()
    }
    
    @objc
    private func btnClick(sender:UIButton)
    {
        if let index = buttonArr.indexOf(sender)
        {
            hide(index)
        }
        
    }
    
    func hide(index:Int)
    {
        if clickBlock?(index) == false
        {
            return
        }
        
        
        UIView.animateWithDuration(0.3, animations: {
            
            self.alpha = 0.0
            
        }) { (finish) in
            
            self.removeFromSuperview()
            
        }

    }
    
    func show()
    {
        print(UIApplication.sharedApplication().keyWindow)
        UIApplication.sharedApplication().keyWindow?.addSubview(self)
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return btnArr.count+1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0
        {
            return SINGLE_LINE_WIDTH
        }
        
        return btnH
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if indexPath.row == 0
        {
            cell.textLabel?.text = ""
        }
        else
        {
            cell.textLabel?.text = btnArr[indexPath.row-1]
        }
        
        cell.textLabel?.font = UIFont.systemFontOfSize(17.0)
        cell.textLabel?.textColor = "007aff".color
        cell.textLabel?.textAlignment = .Center
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        hide(indexPath.row-1)
        
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0)
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                cell.layoutMargins=UIEdgeInsetsMake(0, 0, 0, 0)
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.table?.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0)
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                self.table?.layoutMargins=UIEdgeInsetsMake(0, 0, 0, 0)
            } else {
                // Fallback on earlier versions
            }
        }

    }
    
    
    override func willMoveToWindow(newWindow: UIWindow?) {
        super.willMoveToWindow(newWindow)
        mainView.alpha = 0.0
        mainView.shakeToShow(0.35)
        
        UIView.animateWithDuration(0.25) { 
            
            self.mainView.alpha = 1.0
        }
        
        
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if self.superview == nil
        {
            self.btnArr.removeAll(keepCapacity: false)
            self.buttonArr.removeAll(keepCapacity: false)
            expandViewBlock = nil
        }
        
    }
    
    
    
    deinit
    {
        print("XCommonAlert deinit !!!!!!!!!!!")
    }
    
}
