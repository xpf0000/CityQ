//
//  PropertyPhotoInfoView.swift
//  chengshi
//
//  Created by X on 16/2/24.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class PropertyPhotoInfoView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    
    let httpHandle = XHttpHandle()
    
    var model:PropertyPhoteModel!
    
    var pcell:PropertyPhotoInfoCell!
    
    var harr:[CGFloat] = []
    
    var labelH:CGFloat = 0.0
    
    var toBottom = false
    
    func initSelf()
    {
        let containerView:UIView=("PropertyPhotoInfoView".Nib.instantiateWithOwner(self, options: nil))[0] as! UIView
        
        let newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        containerView.frame = newFrame
        self.addSubview(containerView)
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        table.tableFooterView=view1
        table.tableHeaderView=view1
        
        table.registerNib("PropertyPhotoInfoCell".Nib, forCellReuseIdentifier: "PropertyPhotoInfoCell")
        
        pcell = table.dequeueReusableCellWithIdentifier("PropertyPhotoInfoCell") as? PropertyPhotoInfoCell
        
        httpHandle.pageStr = "[page]"
        httpHandle.keys = ["data","info"]
        httpHandle.modelClass = PropertyPhoteModel.self
        httpHandle.pageSize = 10000
        
        pcell.label.text = "0"
        labelH = self.pcell.label.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        
        httpHandle.BeforeBlock {
        [weak self] (o)->Void in
            if self==nil{return}
            
            self?.harr.removeAll(keepCapacity: false)
            
            for item in self!.httpHandle.listArr
            {
                if let m = item as? PropertyPhoteModel
                {
                    //self?.pcell.model = m
                    self?.pcell.label.text = m.content
                    
                    var h = self?.pcell.label.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height

                    h = h! + 8 < swidth*0.15 ? swidth*0.15 : h! + 8
                    h = h!+12+26+13+12
                    
                    self?.harr.append(h!)
  
                }
            }
            
            self?.table.reloadData()
            
            if self!.toBottom
            {
                let num = self!.table.numberOfRowsInSection(0)
                
                if num > 0
                {
                    self?.table.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
                }
                
            }
            
        }
        
    }
    
    func show()
    {
        httpHandle.url = "http://101.201.169.38/api/Public/Found/?service=Wuye.getFeedBackList&fid=\(model.id)"
        httpHandle.handle()
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.httpHandle.listArr.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return harr[indexPath.row]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:PropertyPhotoInfoCell = tableView.dequeueReusableCellWithIdentifier("PropertyPhotoInfoCell", forIndexPath: indexPath) as! PropertyPhotoInfoCell
        
        cell.model = httpHandle.listArr[indexPath.row] as! PropertyPhoteModel
        cell.minH = self.labelH
        cell.show()
        
        return cell
    }


}
