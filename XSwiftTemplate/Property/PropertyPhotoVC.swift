//
//  PropertyPhotoVC.swift
//  chengshi
//
//  Created by X on 16/2/23.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class PropertyPhotoVC: UIViewController,XPhotoDelegate {

    let table:XTableView = XTableView(frame: CGRectMake(0, 0, swidth, sheight-64), style: .Plain)
    var imageIng:Bool = false
    lazy var imgArr:Array<UIImage> = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.title = "物业报修"
        self.navigationItem.hidesBackButton=true
        self.addBackButton()
        
        let button=UIButton(type: UIButtonType.Custom)
        button.frame=CGRectMake(10, 2, 24, 24);
        button.setBackgroundImage("camera_icon_blue.png".image, forState: UIControlState.Normal)
        button.showsTouchWhenHighlighted = true
        button.exclusiveTouch = true
        
        button.addTarget(self, action: #selector(choosePhoto), forControlEvents: UIControlEvents.TouchUpInside)
        let rightItem=UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem=rightItem;
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor="#f0f0f0".color
        self.view.addSubview(table)
        
        let url = APPURL+"Public/Found/?service=Wuye.getFeedList&uid=\(DataCache.Share.userModel.uid)&username=\(DataCache.Share.userModel.username)&houseid=\(DataCache.Share.userModel.house.houseid)&page=[page]&perNumber=20"
        
        table.registerNib("PropertyPhptoCell".Nib, forCellReuseIdentifier: "PropertyPhptoCell")
        
        table.setHandle(url, pageStr: "[page]", keys: ["data","info"], model: PropertyPhoteModel.self, CellIdentifier: "PropertyPhptoCell")
        self.table.cellHeight = 100
        self.table.show()

    }
    
    func choosePhoto()
    {
        if(!self.checkIsLogin())
        {
            return
        }
        
        
        let vc:PostPhotoVC = "PostPhotoVC".VC("Wuye") as! PostPhotoVC
        //vc.imageArr = self.imgArr
        let nv:XNavigationController = XNavigationController(rootViewController: vc)
        
        vc.block = {
            [weak self](o)->Void in
            
            self?.table.httpHandle.reSet()
            self?.table.httpHandle.handle()
        }
        
        self.presentViewController(nv, animated: true, completion: { () -> Void in
            
            //self.imgArr.removeAll(keepCapacity: false)
            
        })
        
//        UIApplication.sharedApplication().keyWindow?.addSubview(XPhotoChoose.Share())
//        XPhotoChoose.Share().vc = self
//        XPhotoChoose.Share().delegate = self
//        XPhotoChoose.Share().maxNum = UInt(9 - self.imgArr.count)
        
    }
    
    func XPhotoResult(o: AnyObject?) {
        
        if(o == nil)
        {
            let vc:PostPhotoVC = "PostPhotoVC".VC("Wuye") as! PostPhotoVC
            vc.imageArr = self.imgArr
            let nv:XNavigationController = XNavigationController(rootViewController: vc)
            
            vc.block = {
                [weak self](o)->Void in
                
                self?.table.httpHandle.reSet()
                self?.table.httpHandle.handle()
            }
            
            self.presentViewController(nv, animated: true, completion: { () -> Void in
                
                self.imgArr.removeAll(keepCapacity: false)
                
            })
        }
        
        if(o is UIImage)
        {
            imgArr.append(o as! UIImage)
        }
        
        if(o is Array<AnyObject>)
        {
            for item in (o! as! Array<AnyObject>)
            {
                if(item is ALAsset)
                {
                    
                    let cgImg =  (item as! ALAsset).defaultRepresentation().fullScreenImage().takeUnretainedValue()
                    let image = UIImage(CGImage:cgImg)
                    
                    imgArr.append(image)
                }
                
            }
            
        }
    }
    

    deinit
    {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
 
        
    }


}
