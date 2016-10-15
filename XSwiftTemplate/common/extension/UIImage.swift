//
//  UIImage.swift
//  OA
//
//  Created by X on 15/4/29.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit
extension UIImage{
    
    func scaledToSize(size:CGSize)->UIImage
    {
        var w:CGFloat=size.width
        var h:CGFloat=size.height
        
        w = w == 0 ? 1 : w
        h = h == 0 ? 1 : h
        
        let size:CGSize=CGSizeMake(w, h)
        
        //UIGraphicsBeginImageContext(size);
        
        // 创建一个bitmap的context
        // 并把它设置成为当前正在使用的context
        //Determine whether the screen is retina
        let scale = UIScreen.mainScreen().scale
        if(scale >= 2.0){
            UIGraphicsBeginImageContextWithOptions(size, false, scale);
        }else{
            UIGraphicsBeginImageContext(size);
        }
        // 绘制改变大小的图片
        self.drawInRect(CGRectMake(0, 0, size.width, size.height))
        
        
        let newImage:UIImage=UIGraphicsGetImageFromCurrentImageContext()!;
        
        // End the context
        UIGraphicsEndImageContext();
        
        // Return the new image.
        return newImage;

    }
    
    func data(zip:CGFloat)->NSData?
    {
        return UIImageJPEGRepresentation(self, zip)
    }
    
    var data:NSData?
        {
            if (UIImagePNGRepresentation(self) == nil) {
                
                return UIImageJPEGRepresentation(self, 1)
                
            } else {
                
               return UIImagePNGRepresentation(self)
            }
    }
    
    func fixOrientation() -> UIImage {
        if (self.imageOrientation == .Up) {
            return self
        }
        var transform = CGAffineTransformIdentity
        switch (self.imageOrientation) {
        case .Down, .DownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
            break
        case .Left, .LeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
            break
        case .Right, .RightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
            break
        default:
            break
        }
        switch (self.imageOrientation) {
        case .UpMirrored, .DownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
            break
        case .LeftMirrored, .RightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
            break
        default:
            break
        }
        
        let ctx = CGBitmapContextCreate(nil, Int(self.size.width), Int(self.size.height),
                                        CGImageGetBitsPerComponent(self.CGImage!), 0,
                                        CGImageGetColorSpace(self.CGImage!)!,
                                        CGImageGetBitmapInfo(self.CGImage!).rawValue)
        CGContextConcatCTM(ctx!, transform)
        
        
        switch (self.imageOrientation) {
        case .Left, .LeftMirrored, .Right, .RightMirrored:
            CGContextDrawImage(ctx!, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage!)
            break
        default:
            CGContextDrawImage(ctx!, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage!)
            break
        }
        // And now we just create a new UIImage from the drawing context
        let cgimg = CGBitmapContextCreateImage(ctx!)
        return UIImage(CGImage: cgimg!)
    }
}
