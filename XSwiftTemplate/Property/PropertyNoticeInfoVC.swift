//
//  NewsInfoVC.swift
//  chengshi
//
//  Created by X on 15/10/19.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit
import WebKit

class PropertyNoticeInfoVC: XViewController {
    
    let htmlView: HtmlView = HtmlView(frame: CGRectMake(0,0,swidth,sheight-64))
    
    lazy var model:PropertyNoticeModel = PropertyNoticeModel()
    
    var url:String = ""
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.title = "公告详情"
 
        self.view.addSubview(htmlView)
        
        self.url=WapUrl+"/city/wuyeNotice.html?uid=\(DataCache.Share.userModel.uid)&username=\(DataCache.Share.userModel.username)&id=\(model.id)"
        
        htmlView.url = self.url
        htmlView.show()
        
        htmlView.block =
            {
                [weak self]
                (o)->Void in
                
                if(o is Dictionary<String,AnyObject>)
                {
                    let dic:Dictionary<String,AnyObject> = o as! Dictionary<String,AnyObject>
                    
                    if(dic["index"] != nil)
                    {
                        let vc:FriendDelPicVC = "FriendDelPicVC".VC("Friend") as! FriendDelPicVC
                        vc.canDel = false
                        vc.showBack = false
                        vc.nowIndex = (dic["index"] as! Int)+1
                        vc.imgArr = dic["list"] as! Array<String>
                        vc.hidesBottomBarWhenPushed = true
                        
                        let nv:XNavigationController = XNavigationController(rootViewController: vc)
                        
                        self?.jumpAnimType = .Alpha
                        self?.presentViewController(nv, animated: true, completion: { () -> Void in
                            
                        })
                    }
                    
                }
                
                
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    deinit
    {
        //print(NSStringFromClass(self.dynamicType)+" "+__FUNCTION__+" !!!!!!!!!")
    }
    
}
