//
//  FriendReplyView.swift
//  chengshi
//
//  Created by X on 15/11/25.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class FriendReplyView: UIView,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var likedPeople: UILabel!
    
    @IBOutlet var lineH: NSLayoutConstraint!
    
    @IBOutlet var line: UIView!
  
    @IBOutlet var replyTable: UITableView!
    
    @IBOutlet var likedH: NSLayoutConstraint!
    
    var replyOtherBlock:AnyBlock?
    
    var attributedString1:NSMutableAttributedString?
    lazy var cArrs:Array<FriendCommentModel> = []
    lazy var zArrs:Array<FriendZanModel> = []
    lazy var replyCellHs:Array<CGFloat> = []
    
    var likep=""
    
    
    func initSelf()
    {
        let containerView:UIView=("FriendReplyView".Nib.instantiateWithOwner(self, options: nil))[0] as! UIView
        
        let newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        containerView.frame = newFrame
        self.addSubview(containerView)
        
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.initSelf()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initSelf()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func show(width:CGFloat)->CGFloat
    {
        
        self.likedPeople.preferredMaxLayoutWidth = width
        self.likedPeople.layoutIfNeeded()
        
        likep=""
        var i=0
        for s in self.zArrs
        {
            if(i == self.zArrs.count-1)
            {
                likep += s.nickname
            }
            else
            {
                likep += s.nickname+","
            }
            
            i += 1
        }
        
        likep += "等\(self.zArrs.count)人".trim()
        
        let rang=(likep as NSString).rangeOfString("\(self.zArrs.count)", options: NSStringCompareOptions.BackwardsSearch)
        
        attributedString1 = NSMutableAttributedString(string: likep)
        let paragraphStyle1:NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle1.lineSpacing = 5.0
            
        attributedString1!.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle1, range: NSMakeRange(0, likep.length()))
        attributedString1!.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: rang)
        
        likedPeople.attributedText = attributedString1
        
        return getReplyCellsH(width)
    }
    
    func getReplyCellsH(width:CGFloat)->CGFloat
    {
        var cellW:CGFloat = 0.0
        
        if(width == swidth-24-30-16)
        {
            cellW = swidth - 40
        }
        else
        {
            cellW = swidth - (60+12+16)
        }

        
        var h:CGFloat=0.0
        if(self.zArrs.count == 0)
        {
            self.likedH.constant = 0.0
        }
        else
        {
            let label = UILabel()
            label.frame = CGRectMake(0, 0, width, 1)
            label.font = UIFont(name: "HYQiHei", size: 13.0)
            label.attributedText = attributedString1
            label.numberOfLines = 0
            label.sizeToFit()
            self.likedH.constant = label.frame.height+21
            h += label.frame.height+21
            self.lineH.constant = 0.34
        }
        
        if(self.cArrs.count == 0)
        {
            self.lineH.constant = 0.0
        }
        
        
        var count:CGFloat=0.0
        replyCellHs.removeAll(keepCapacity: false)
        for item in self.cArrs
        {
            
            let str=((item.nickname+":"+item.content).trim()).trim()

            let attributedString1:NSMutableAttributedString = NSMutableAttributedString(string: str)
            let paragraphStyle1:NSMutableParagraphStyle = NSMutableParagraphStyle()
            
            paragraphStyle1.lineSpacing = 5.0
            
            attributedString1.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle1, range: NSMakeRange(0, (str as NSString).length))
            
            let label = UILabel()
            label.frame = CGRectMake(0, 0, cellW, 1)
            label.font = UIFont(name: "HYQiHei", size: 13.0)
            label.attributedText = attributedString1
            label.numberOfLines = 0
            label.sizeToFit()
            replyCellHs.append(label.frame.height+16)
            count += label.frame.height+16
        }
        
        if(count > 0)
        {
            count = count+10
        }
        
        h += count
        
        self.replyTable.reloadData()
        
        return h
    }
    
    
    ////////////////////////////////回复table///////////////////
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.separatorInset=UIEdgeInsetsZero
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                cell.layoutMargins=UIEdgeInsetsZero
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return replyCellHs[indexPath.row]
  
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return replyCellHs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:FrientReplyCell = tableView.dequeueReusableCellWithIdentifier("FrientReplyCell", forIndexPath: indexPath) as! FrientReplyCell
        
        cell.replyOtherBlock = self.replyOtherBlock
        cell.model = cArrs[indexPath.row]
        cell.show()
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 4.0
        self.layer.masksToBounds = true
        
        self.replyTable.registerNib("FrientReplyCell".Nib, forCellReuseIdentifier: "FrientReplyCell")
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        self.replyTable.tableFooterView=view1
        self.replyTable.tableHeaderView=view1
        
        self.replyTable.separatorInset=UIEdgeInsetsZero
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                self.replyTable.layoutMargins=UIEdgeInsetsZero
            } else {
                // Fallback on earlier versions
            }
        }
        
        line.backgroundColor = replyTable.separatorColor
        lineH.constant = 0.34
        
    }


}
