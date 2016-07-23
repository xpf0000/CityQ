//
//  XCamera.swift
//  chengshi
//
//  Created by X on 15/11/26.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class XCamera: NSObject ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    lazy var imagePicker:UIImagePickerController = UIImagePickerController()
    weak var vc:UIViewController?
    var block:AnyBlock?
    weak var delegate:XPhotoDelegate?
    
    
    class func Share() ->XCamera! {
        
        struct Once {
            static var token:dispatch_once_t = 0
            static var dataCenterObj:XCamera! = nil
        }
        dispatch_once(&Once.token, {
            Once.dataCenterObj = XCamera()
        })
        return Once.dataCenterObj
    }
    
    override init()
    {
        super.init()
        imagePicker.delegate=self
        imagePicker.sourceType=UIImagePickerControllerSourceType.Camera
        
        imagePicker.allowsEditing=false
        imagePicker.modalTransitionStyle=UIModalTransitionStyle.CoverVertical
    }

    func CameraImage()
    {
        self.vc?.presentViewController(imagePicker, animated: true) { () -> Void in
            
            XPhotoChoose.Share().removeFromSuperview()
        }
    }
    
    func  CameraImage(vc:UIViewController, block:AnyBlock)
    {
        self.vc=vc
        self.block = block
        
        CameraImage()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        vc?.dismissViewControllerAnimated(true, completion: { () -> Void in
            
            self.clean()
            
        })
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        autoreleasepool { 
            
            var image = image
            
            let imageOrientation=image.imageOrientation;
            
            if(imageOrientation != .Up)
            {
                // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
                // 以下为调整图片角度的部分
                
                let size = CGSizeMake(swidth*screenScale, image.size.height/image.size.width*swidth*screenScale)
                
                //print(size)
                
                // 打开图片编辑模式
                
                UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
                
                // 修改图片长和宽
                
                image.drawInRect(CGRect(origin: CGPointZero, size: size))
                
                // 生成新图片
                
                image = UIGraphicsGetImageFromCurrentImageContext()
                
                // 关闭图片编辑模式
                
                UIGraphicsEndImageContext()
                
                // 压缩图片
                
                
                // 调整图片角度完毕
            }
            
            self.block?(image)
            self.delegate?.XPhotoResult!(image)
            
            vc?.dismissViewControllerAnimated(true, completion: { () -> Void in
                
                self.block?(nil)
                self.delegate?.XPhotoResult!(nil)
                
                self.clean()
            })
        }
 
    }
    
    func clean()
    {
        self.delegate = nil
        self.vc = nil
        self.block = nil
        XPhotoChoose.Share().allowsEdit = false
        imagePicker.sourceType=UIImagePickerControllerSourceType.Camera
        imagePicker.allowsEditing=false
        imagePicker.modalTransitionStyle=UIModalTransitionStyle.CoverVertical
    }


}
