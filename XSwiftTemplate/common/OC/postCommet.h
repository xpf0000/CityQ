//
//  postCommet.h
//  rexian V1.0
//
//  Created by X on 15/1/7.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"

@protocol postCommentDelegate

-(void) postWithTxt:(NSString*)txt andType:(int)type;

@end

@interface postCommet : FXBlurView<UIGestureRecognizerDelegate>
{
    @private
    UIView *mainView;
    BOOL anmationIng;
    int kbHeight;
}
-(id)init;
-(void)showView;
@property(nonatomic,assign)float offsetY;
@property(nonatomic,weak)id<postCommentDelegate> delegate;
@property(nonatomic,strong)UITextView *context;
@property(nonatomic,strong)UIView* bgView;

@end
