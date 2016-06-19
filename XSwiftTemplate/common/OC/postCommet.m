//
//  postCommet.m
//  rexian V1.0
//
//  Created by X on 15/1/7.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "postCommet.h"

#define swidth ([[UIScreen mainScreen] bounds].size.width)
#define sheight ([[UIScreen mainScreen] bounds].size.height)

@implementation postCommet

-(id)init
{
    self=[super init];
    if(self)
    {
        _bgView = [[UIView alloc]init];
        self.frame=CGRectMake(0, 0, swidth, sheight);
        
        self.tintColor = [UIColor darkGrayColor];
        self.dynamic = false;
        self.blurRadius = 12.5;
        self.iterations = 1;
        _bgView.alpha=1.0;
        self.alpha = 0.0;
        
        kbHeight=0;
        anmationIng=NO;
        _offsetY=0.0;
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideView)];
        tap.delegate=self;
        [self addGestureRecognizer:tap];
        [self initView];
    }
    return  self;
}

-(void)setOffsetY:(float)offsetY
{
    _offsetY=offsetY;
    [self initView];
}

-(void)initView
{
    [self registerForKeyboardNotifications];
    
    for(UIView *view in [self subviews])
    {
        [view removeFromSuperview];
    }
    
    
    _bgView.frame=self.frame;
    _bgView.backgroundColor = [UIColor colorWithRed:0.13 green:0.14 blue:0.2 alpha:0.6];
    [self addSubview:_bgView];
    
    mainView=[[UIView alloc]initWithFrame:CGRectMake(0, sheight, swidth, 0)];
    mainView.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
    
    UIButton *noButton=[UIButton buttonWithType:UIButtonTypeCustom];
    noButton.frame=CGRectMake(4, 6, 42, 42);
    
    UIImageView *noImg=[[UIImageView alloc]initWithFrame:CGRectMake(4, 4, 34, 34)];
    noImg.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"newsPostNo" ofType:@"png"]];
    [noButton addSubview:noImg];
    [noButton addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    [noButton setExclusiveTouch:YES];
    [mainView addSubview:noButton];
    
    UIButton *YesButton=[UIButton buttonWithType:UIButtonTypeCustom];
    YesButton.frame=CGRectMake(swidth-8-38, 6, 42, 42);
    
    UIImageView *yesImg=[[UIImageView alloc]initWithFrame:CGRectMake(4, 4, 34, 34)];
    yesImg.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"newsPostYes" ofType:@"png"]];
    [YesButton addSubview:yesImg];
    [YesButton addTarget:self action:@selector(postClick) forControlEvents:UIControlEventTouchUpInside];
    [YesButton setExclusiveTouch:YES];
    [mainView addSubview:YesButton];

    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake((swidth-100)/2, 10, 100, 34)];
    title.backgroundColor=[UIColor clearColor];
    title.text=@"写跟帖";
    title.font=[UIFont fontWithName:@"HYQiHei" size:16.5];
    title.textColor=[UIColor blackColor];
    title.textAlignment=NSTextAlignmentCenter;
    
    [mainView addSubview:title];
    
    _context=[[UITextView alloc]initWithFrame:CGRectMake(10, 10+34+10, swidth-20, 1.0/6.0*sheight)];
    _context.font=[UIFont fontWithName:@"HYQiHei" size:14.5];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ (float)190/(float)255, (float)190/(float)255, (float)190/(float)255, 1 });
    
    [_context.layer setMasksToBounds:YES];
    //[_context.layer setCornerRadius:17];
    [_context.layer setBorderWidth:0.5];   //边框宽度
    [_context.layer setBorderColor:colorref];//边框颜色
    CGColorSpaceRelease( colorSpace);
    CGColorRelease(colorref);
    [mainView addSubview:_context];
    [_context becomeFirstResponder];
    
    
    
    
    
   
    [self addSubview:mainView];
}

-(void)showView
{
    if(anmationIng)
        return;
    anmationIng=YES;
    mainView.frame=CGRectMake(0, sheight, swidth, mainView.frame.size.height);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.alpha = 1.0;
        mainView.frame=CGRectMake(0, sheight-(kbHeight+135+1.0/6.0*sheight)+_offsetY, swidth, mainView.frame.size.height);
           } completion:^(BOOL finished){
        if(finished)
        {
            anmationIng=NO;
        }
    }];

}

-(void)hideView
{
    if(anmationIng)
        return;
    [self endEditing:YES];
    [self.delegate postWithTxt:_context.text andType:0];
    anmationIng=YES;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0.0;
        [self updateAsynchronously:true completion:^{
            
        }];
        mainView.frame=CGRectMake(0, sheight-64+_offsetY, swidth, sheight-64-100);
    } completion:^(BOOL finished){
        if(finished)
        {
            anmationIng=NO;
            [self removeFromSuperview];
        }
    }];
    
}

-(void)postClick
{
    if(_context.text.length==0)
    {
//        ShowLabel *lable = [[ShowLabel alloc] initWithContent:@"请输入评论内容" andType:0 andFlag:0];
//        [[self superview] addSubview:lable];
//        return;
    }
    
    [self endEditing:YES];
    [self.delegate postWithTxt:_context.text andType:1];
    anmationIng=YES;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.backgroundColor=[UIColor colorWithRed:80.0/255.0 green:80.0/255.0 blue:115.0/255.0 alpha:0.0];
        mainView.frame=CGRectMake(0, sheight-64+_offsetY, swidth, sheight-64-100);
    } completion:^(BOOL finished){
        if(finished)
        {
            anmationIng=NO;
            [self removeFromSuperview];
        }
    }];

}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"]) {
        return NO;
    }
    return  YES;
}

- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShow:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}


//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    kbHeight=kbSize.height;

    if(mainView.frame.size.height==0.0)
        mainView.frame=CGRectMake(0, swidth, swidth, kbHeight+74+1.0/6.0*sheight);
    else
        mainView.frame=CGRectMake(0, sheight-(kbHeight+135+1.0/6.0*sheight)+_offsetY, swidth, kbHeight+74+1.0/6.0*sheight);
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    //do something
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    mainView=nil;
    self.delegate=nil;
    self.context=nil;
}


@end
