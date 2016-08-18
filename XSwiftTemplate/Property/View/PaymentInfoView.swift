//
//  PaymentInfoView.swift
//  chengshi
//
//  Created by X on 16/2/26.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class PaymentInfoView: UIView {

    @IBOutlet var table: XTableView!
    
    @IBOutlet var line: UIView!
    
    @IBOutlet var lineH: NSLayoutConstraint!
    
    @IBOutlet var label1: UILabel!
    
    @IBOutlet var label2: UILabel!
    
    var type = 0
    var status = 0
    
    func initSelf()
    {
        let containerView:UIView=("PaymentInfoView".Nib.instantiateWithOwner(self, options: nil))[0] as! UIView
        
        let newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        containerView.frame = newFrame
        self.addSubview(containerView)
        
        self.line.backgroundColor = self.table.separatorColor
        self.lineH.constant = 0.34
    
        table.registerNib("PaymentInfoCell".Nib, forCellReuseIdentifier: "PaymentInfoCell")
        
        self.table.httpHandle.pageStr = "[page]"
        self.table.httpHandle.keys = ["data","info"]
        self.table.cellHeight = 60.0
        self.table.CellIdentifier = "PaymentInfoCell"
        self.table.httpHandle.modelClass = PropertyPaymentModel.self
        self.table.httpHandle.pageSize = 10000
          
    }
    
    func show()
    {
        if self.type == 3 || self.type == 2
        {
            label1.text = "使用量"
            label2.text = "应缴金额"
        }
        else
        {
            label1.text = "应缴金额"
            label2.text = "实缴金额"
        }
        
        self.table.postDict = ["type":type]
        self.table.httpHandle.url = APPURL+"Public/Found/?service=Wuye.getPayList&uid=\(DataCache.Share.userModel.uid)&username=\(DataCache.Share.userModel.username)&fanghaoid="+DataCache.Share.userModel.house.fanghaoid+"&type=\(type)&status=\(status)"
        
        self.table.show()
        self.table.headRefresh?.block = nil
        self.table.footRefresh?.block = nil
        self.table.headRefresh?.removeFromSuperview()
        self.table.footRefresh?.removeFromSuperview()
        self.table.headRefresh = nil
        self.table.footRefresh = nil

    }
    
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.initSelf()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initSelf()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }

}
