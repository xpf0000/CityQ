
import UIKit

class CSDN:AnyObject{
    var name:String?
    
    lazy var description:()->() =
    {
        [unowned self] in
        
        self.pre()
    
    }
    
    func pre()
    {
       print("闭包调用函数")
    }
    
    init(name:String?)
    {
        self.name = name
    }
    
    deinit{
        print("内存将要释放")
    }

}

class ViewController: UIViewController{
    
    var instance:CSDN? = CSDN(name:"hello hwc")
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        instance?.description()
        instance = nil//这里会进行内存释放
    
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

}