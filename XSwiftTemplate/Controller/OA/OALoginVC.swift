
import Foundation
import UIKit

class OALoginVC: UIViewController,UITextFieldDelegate{
    
    var user:UITextField=UITextField()
    var pass:UITextField=UITextField()
    var submit:UIButton=UIButton()
    var showBackButton:Bool=true
    var delegate:commonDelegate?
    
    var block:AnyBlock?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title="OA登录"
        self.addBackButton()
    }
 
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func pop() {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true) { () -> Void in
            
            self.block?(nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.registerForKeyboardNotifications()
        
        if(self.tabBarController?.selectedIndex != 0)
        {
            
        }
        
        var h:CGFloat=0.0
        self.view.backgroundColor="#f0f0f0".color
        
        let log:UIImageView=UIImageView(image: UIImage(contentsOfFile: "logo.png".path))
        log.frame=CGRectMake((50.0/320.0)*swidth, (28.0/480.0)*sheight, swidth-((50.0/320.0)*swidth)*2, (swidth-((50.0/320.0)*swidth)*2)*(94.0/320.0))
        log.contentMode = UIViewContentMode.ScaleAspectFit
        //log.layer.borderWidth=0.5
        log.layer.borderColor=UIColor.blackColor().CGColor
        self.view.addSubview(log)
        
        h=(28.0/480.0)*sheight+(swidth-((50.0/320.0)*swidth)*2)*(94.0/320.0)+20
        
        user.frame=CGRectMake((20.0/320.0)*swidth, h, swidth-(20.0/320.0)*swidth*2, 60)
        user.backgroundColor=UIColor.whiteColor()
        user.layer.cornerRadius=6.0
        user.layer.borderWidth=0.5
        user.layer.borderColor=UIColor(red: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1.0).CGColor
        
        var leftimg:UIImageView=UIImageView(image: UIImage(contentsOfFile: "user.png".path))
        leftimg.frame=CGRectMake(8, 13, 34, 34)
        
        var leftview:UIView=UIView(frame: CGRectMake(0, 0, 50, 60))
        leftview.backgroundColor=UIColor.whiteColor()
        leftview.addSubview(leftimg)
        
        user.leftView=leftview
        user.leftViewMode = UITextFieldViewMode.Always
        
        user.clearButtonMode=UITextFieldViewMode.WhileEditing
        
        self.view.addSubview(user)
        
        h=h+60+15;
        
        pass.frame=CGRectMake((20.0/320.0)*swidth, h, swidth-(20.0/320.0)*swidth*2, 60)
        pass.backgroundColor=UIColor.whiteColor()
        pass.layer.cornerRadius=6.0
        pass.layer.borderWidth=0.5
        pass.layer.borderColor=UIColor(red: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1.0).CGColor
        
        leftimg=UIImageView(image: UIImage(contentsOfFile: "pass.png".path))
        leftimg.frame=CGRectMake(8, 13, 34, 34)
        
        leftview=UIView(frame: CGRectMake(0, 0, 50, 60))
        leftview.backgroundColor=UIColor.whiteColor()
        leftview.addSubview(leftimg)
        
        pass.leftView=leftview
        pass.leftViewMode = UITextFieldViewMode.Always
        pass.clearButtonMode=UITextFieldViewMode.WhileEditing
        
        pass.secureTextEntry=true
        
        self.view.addSubview(pass)
        
        user.delegate=self
        pass.delegate=self
        
        h=h+60+25;
        
        submit.frame=CGRectMake((20.0/320.0)*swidth, h, swidth-(20.0/320.0)*swidth*2, 60)
        
        submit.backgroundColor=UIColor(red: 102.0/255.0, green: 150.0/255.0, blue: 232.0/255.0, alpha: 1.0)
        
        submit.setTitle("提交登录", forState: UIControlState.Normal)
        submit.setTitle("登录中...", forState: UIControlState.Selected)
        
        submit.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        submit.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
        
        submit.titleLabel?.font=UIFont.systemFontOfSize(20)
        submit.layer.cornerRadius=6.0
        
        submit.addTarget(self, action: "login", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(submit)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
       
        if(textField==user)
        {
            pass.becomeFirstResponder()
        }
        else
        {
            self.view.endEditing(true)
        }
        
        return true
    }
    
    func registerForKeyboardNotifications()
    {
    //使用NSNotificationCenter 鍵盤出現時
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    
    //使用NSNotificationCenter 鍵盤隐藏時
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    
    
    }
    
    
    //实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
    func keyboardWillShow(aNotification:NSNotification)
    {
        let info:Dictionary = aNotification.userInfo!
        let kbSize:CGSize=info[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        var h:CGFloat=kbSize.height
        let th=pass.frame.size.height+pass.frame.origin.y+64
        
        h=(sheight-h)-th
        
        if(h<0)
        {
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                
                self.view.frame=CGRectMake(0, h, swidth, sheight)
                
            }, completion: { (finished) -> Void in
                
            })
        }
    }
    
    //当键盘隐藏的时候
    func keyboardWillBeHidden(aNotification:NSNotification)
    {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            
            self.view.frame=CGRectMake(0, 64, swidth, sheight)
            
            }, completion: { (finished) -> Void in
                
        })
    }
    
    
    func login()
    {
        self.view.endEditing(true)
        if(!user.checkNull() || !pass.checkNull())
        {
            
            return
        }
        submit.enabled = false
        submit.selected = true
        
        let u=user.text!.trim()
        let p=pass.text!.trim()
        
        self.view.showWaiting()
        
        let url="http://101.201.169.38/apioa/Public/OA/?service=User.login&username="+u+"&password="+p
        
       XHttpPool.requestJson(url, body: nil, method: .GET) {[weak self] (o) -> Void in
        
            RemoveWaiting()
        
            if(o?["data"]["info"].arrayValue.count>0 && o?["data"]["code"].intValue == 0)
            {
                DataCache.Share().oaUserModel = OAUserModel.parse(json: o!["data"]["info"][0], replace: nil)
                DataCache.Share().oaUserModel.pass = p
                DataCache.Share().oaUserModel.save()
                
                SetUMessageTag()
                
                self?.pop()
                return
            }
        
            self?.submit.enabled = true
            self?.submit.selected = false
        
            var msg = o?["data"]["msg"].stringValue
            msg = msg == "" ? "登录失败" : msg
        
            self!.view.showAlert(msg!, block: nil)
        
        
        }
        
        
        
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        RemoveWaiting()
        self.delegate=nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

