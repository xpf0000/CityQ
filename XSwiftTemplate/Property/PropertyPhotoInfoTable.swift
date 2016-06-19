//
//  PropertyPhotoInfoTable.swift
//  chengshi
//
//  Created by X on 16/2/24.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class PropertyPhotoInfoTable: UITableViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIImageViewGroupDelegate {

    @IBOutlet var table: UITableView!
    
    @IBOutlet var typeView: UIView!
    
    @IBOutlet var type: UILabel!
    
    @IBOutlet var time: UILabel!
    
    @IBOutlet var content: UILabel!
    
    @IBOutlet var collection: UICollectionView!
    
    @IBOutlet var replyView: PropertyPhotoInfoView!
  
    
    let typeStr=["0":"反映问题","1":"建议","2":"表扬"]
    let typeColor = ["0":"fe4400".color,"1":"00a9fe".color,"2":"26cb3a".color]
    
    var imageArr:Array<String> = []
    
    var contentH:CGFloat = 0.0
    
    var model:PropertyPhoteModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        typeView.layer.cornerRadius = 5.0
        typeView.layer.masksToBounds = true
        
        content.preferredMaxLayoutWidth = swidth - 24
        
        collection.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        table.tableFooterView=view1
        table.tableHeaderView=view1
        
        
        //replyTable.delegate=self
        //replyTable.dataSource=self
        
        table.separatorInset=UIEdgeInsetsZero
        if #available(iOS 8.0, *) {
            table.layoutMargins=UIEdgeInsetsZero
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    
    func show()
    {
        for item in model.picList
        {
            imageArr.append(item.url)
        }
        
        typeView.backgroundColor = typeColor[model.type]!
        type.text = typeStr[model.type]
        time.text = model.create_time
        content.text=model.content
        var h = content.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        h = h+((swidth-75)/4.0+15)*CGFloat(ceil(Double(model.picList.count)/4.0))
        contentH = h+25
        collection.reloadData()
        table.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
        
        
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 4)
        {
            cell.separatorInset=UIEdgeInsetsMake(0, swidth, 0, 0)
            if #available(iOS 8.0, *) {
                cell.layoutMargins=UIEdgeInsetsMake(0, swidth, 0, 0)
            } else {
                // Fallback on earlier versions
            }
        }
        else
        {
            cell.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0)
            if #available(iOS 8.0, *) {
                cell.layoutMargins=UIEdgeInsetsMake(0, 0, 0, 0)
            } else {
                // Fallback on earlier versions
            }
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        table.separatorInset=UIEdgeInsetsZero
        if #available(iOS 8.0, *) {
            table.layoutMargins=UIEdgeInsetsZero
        } else {
            // Fallback on earlier versions
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return model.picList.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 15.0
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        
        return CGSizeMake((swidth-75)/4.0, (swidth-75)/4.0);
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        
        cell.contentView.removeAllSubViews()
        
        let image:UIImageView=UIImageView(frame: CGRectMake(0, 0, (swidth-75)/4.0, (swidth-75)/4.0))
        
        image.isGroup = true
        image.groupDelegate = self
        image.url = model.picList[indexPath.row].url
        
        imgArr[indexPath.row] = image
        cell.contentView.addSubview(image)
        
        return cell
        
    }
    
    var imgArr:[Int:UIImageView] = [:]
    
    func UIImageViewGroupTap(obj: UIImageView) {
        
        var arr:[UIImageView] = []
        for i in 0..<model.picList.count
        {
            arr.append(imgArr[i]!)
        }
        
        XImageBrowse.Share.imageArr = arr
        XImageBrowse.Share.show(obj)
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
//        let vc:FriendDelPicVC = "FriendDelPicVC".VC("Friend") as! FriendDelPicVC
//        vc.canDel = false
//        vc.showBack = false
//        vc.imgArr = []
//        for item in model.picList
//        {
//            vc.imgArr.append(item.url)
//        }
//
//        vc.nowIndex = indexPath.row+1
//        vc.hidesBottomBarWhenPushed = true
//        
//        let nv:XNavigationController = XNavigationController(rootViewController: vc)
//        
//        self.presentViewController(nv, animated: true, completion: { () -> Void in
// 
//        })
        
        
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 5
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch indexPath.row
        {
        case 0:
            ""
            return 50.0
        case 1:
            ""
            return contentH
        case 2:
            ""
            return 12.0
        case 3:
            ""
            return 50.0
        case 4:
            ""
            var h = sheight - contentH - 112.0 - 50 - 64.0
            h = h < 300 ? 300 : h
            return h
        default:
            ""
            return 0.0
        }
        
    }

    deinit
    {

    }
    

}
