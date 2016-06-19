//
//  CommentModel.swift
//  chengshi
//
//  Created by X on 15/11/24.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit


class CommentModel: Reflect {
    
    var id=""
    var descrip=""
    var comment=""
    var zan=""
    var create_time=""
    var category_id=""
    var title=""
    var nickname=""
    var picList:Array<FriendPicModel> = []
    var zanList:Array<FriendZanModel> = []
    var commentList:Array<FriendCommentModel> = []
    var content=""
    var url=""
    var headimage=""
    var width:CGFloat=0.0
    var height:CGFloat=0.0
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if(value == nil)
        {
            return
        }
        
        if(key == "description")
        {
            self.descrip = value as! String
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    
}
