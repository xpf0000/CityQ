//
//  EditUserInfoVC.swift
//  lejia
//
//  Created by X on 15/10/12.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class EditUserInfoVC: UITableViewController,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    @IBOutlet var headPic: UIImageView!
    
    @IBOutlet var nickName: UITextField!
    
    @IBOutlet var sex: UITextField!
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var name: UITextField!
    
    @IBOutlet var phone: UITextField!
    
    @IBOutlet var birthday: UITextField!
    
    @IBOutlet var address: UITextField!
    
    
    var imageIng = false
    var headImage:UIImage?
    
    
    @IBAction func submit(sender: UIButton) {
        
        self.view.endEditing(true)
        self.view.showWaiting()
        sender.enabled = false
 
        let sexN = sex.text == "女" ? 0 : 1
        let nick = nickName.text!.trim()
        let truename = name.text!.trim()
        
        let url=APPURL+"Public/Found/?service=User.userEdit"
        
        let body="username="+DataCache.Share().userModel.username+"&nickname="+nick+"&sex=\(sexN)&truename=\(truename)"
        
        XHttpPool.requestJson(url, body: body, method: .POST) { (o) -> Void in
            
            RemoveWaiting()
            
            if(o?["data"].dictionaryValue.count > 0)
            {
                if(o!["data"]["code"].intValue == 0)
                {
                    DataCache.Share().userModel.nickname = nick
                    DataCache.Share().userModel.sex = "\(sexN)"
                    DataCache.Share().userModel.truename = truename
                    DataCache.Share().userModel.save()
                    UIApplication.sharedApplication().keyWindow?.showAlert("设置成功", block: { (o) -> Void in
                        
                        self.navigationController?.popViewControllerAnimated(true)
                        
                    })
                    
                    
                    
                    return
                }
                else
                {
                    self.navigationController?.view.showAlert(o!["data"]["msg"].stringValue, block: nil)
                    sender.enabled = true
                    return
                }
            }
            else
            {
                self.navigationController?.view.showAlert("设置失败", block: nil)
                sender.enabled = true
            }
            
        }
        
    }
    
    var picID:Int=0
    
    var image:UIImage?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        nickName.enabled = false
        self.headPic.url=DataCache.Share().userModel.headimage
        self.nickName.text = DataCache.Share().userModel.nickname
        self.name.text = DataCache.Share().userModel.truename
        if(DataCache.Share().userModel.sex == "0")
        {
            self.sex.text = "女"
        }
        else
        {
            self.sex.text = "男"
        }
        
        self.headPic.placeholder="tx.jpg".image
        self.headPic.layer.cornerRadius=41.0
        self.headPic.layer.masksToBounds=true
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        table.tableFooterView=view1
        table.tableHeaderView=view1
        
        self.nickName.addEndButton()
        
      
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
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
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        self.table.separatorInset=UIEdgeInsetsMake(0, 20, 0, 0)
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                self.table.layoutMargins=UIEdgeInsetsMake(0, 20, 0, 0)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    
    func endEdit()
    {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        endEdit()
        
        return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if(indexPath.row==1)
        {
            self.navigationController?.view.window?.addSubview(XPhotoChoose.Share())

            XPhotoChoose.Share().allowsEdit = true
            XPhotoChoose.Share().vc = self
            XPhotoChoose.Share().block =
                {
                    [weak self]
                    (o)->Void in
                    
                    if(self == nil)
                    {
                        return
                    }
                    
                    XPhotoChoose.Share().removeFromSuperview()
                    
                    if(o is UIImage)
                    {
                        self?.headImage = o! as? UIImage
                        self?.headPic.image = self?.headImage
                        self?.upLoadHeadPic()
                    }
                    else if(o is XPhotoChooseType)
                    {
                        if((o! as! XPhotoChooseType) == XPhotoChooseType.PhotoLib)
                        {
                            self?.getPhoteLib(1, block: { (o) -> Void in
                                
                                if(o != nil)
                                {
                                    for item in (o! as! Array<AnyObject>)
                                    {
                                        if(item is ALAsset)
                                        {
                                            
                                            let cgImg =  (item as! ALAsset).defaultRepresentation().fullScreenImage().takeUnretainedValue()
                                            
                                            let image = UIImage(CGImage:cgImg)
                                            
                                            self?.headImage = image
                                            
                                            self?.headPic.image = self?.headImage
                                            
                                            self?.upLoadHeadPic()
                                        }
                                        
                                    }
                                    
                                }
                                
                            })
                        }
                    }
                    
            }
        }
        
        else if(indexPath.row==3)
        {
            let cameraSheet:UIActionSheet=UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
            cameraSheet.tag = 16
            cameraSheet.addButtonWithTitle("男")
            cameraSheet.addButtonWithTitle("女")
            
            cameraSheet.actionSheetStyle = UIActionSheetStyle.BlackTranslucent;
            cameraSheet.showInView(UIApplication.sharedApplication().keyWindow!)
        }
        
    }
    
    func upLoadHeadPic()
    {
        let imgDataArr:Array<NSData> = [self.headImage!.data(0.5)!]
        let url=APPURL+"Public/Found/?service=User.headEdit"
        
        XHttpPool.upLoadWithMutableName(url, parameters: ["username":DataCache.Share().userModel.username], file: imgDataArr, name: "file", progress: nil) { [weak self](o) -> Void in
                
                if(o?["data"].dictionaryValue.count > 0)
                {
                    if(o!["data"]["code"].intValue == 0)
                    {
                        DataCache.Share().userModel.headimage = o!["data"]["msg"].stringValue
                        
                        return
                    }
                }
                
                self?.navigationController?.view.showAlert("头像设置失败", block: nil)
        }
        
    }
    
    
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        if(actionSheet.tag == 16)
        {
            if(buttonIndex==1) //男
            {
                self.sex.text = "男"
            }
            else if(buttonIndex==2) //女
            {
                self.sex.text = "女"
            }
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    deinit
    {
        RemoveWaiting()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
}
