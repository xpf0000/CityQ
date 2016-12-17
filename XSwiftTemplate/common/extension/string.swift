/*
* @String扩展
* @Date:2014/06/17
*/
import Foundation
import UIKit

enum RegularType : String{

    case NickName="[~!/@#$%^&#$%^&amp;*()-_=+\\|[{}];:\'\",&#$%^&amp;*()-_=+\\|[{}];:\'\",&lt;.&#$%^&amp;*()-_=+\\|[{}];:\'\",&lt;.&gt;/?]+"
    
    case Phone="^(1)[0-9]{10}$"
    case Email="^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
}

extension String{
    
    mutating func selfReplace(str1:String,with:String)
    {
        var temp:NSString = NSString(string: self)
        temp = temp.stringByReplacingOccurrencesOfString(str1, withString: with)
        
        self = temp as String
    }
    
    func replace(str1:String,with:String)->String
    {
        var temp:NSString = NSString(string: self)
        temp = temp.stringByReplacingOccurrencesOfString(str1, withString: with)
        
        return temp as String
    }

    func subStringToIndex(i:Int) -> String
    {
        if(i<=self.length())
        {
            let t:NSString = NSString(string: self)
            return t.substringToIndex(i) as String
        }
        else
        {
            return self
        }
        
    }
    
    func subStringFromIndex(i:Int) -> String
    {
        let t:NSString = NSString(string: self)
        return t.substringFromIndex(i) as String
    }
    
    //分割字符
    func split(s:String)->[String]{
        if s.isEmpty{
            var x=[String]()
            for y in self.characters{
                x.append(String(y))
            }
            return x
        }
        return self.componentsSeparatedByString(s)
    }
    //去掉左右空格
    func trim()->String{
        
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    //是否包含字符串
    func has(s:String)->Bool{
        if (self.rangeOfString(s) != nil) {
            return true
        }else{
            return false
        }
    }
    //是否包含前缀
    func hasBegin(s:String)->Bool{
        if self.hasPrefix(s) {
            return true
        }else{
            return false
        }
    }
    //是否包含后缀
    func hasEnd(s:String)->Bool{
        if self.hasSuffix(s) {
            return true
        }else{
            return false
        }
    }
    
    func isChinese()->Bool
    {
        var strlength=0
        
        let p:[CChar]=self.cStringUsingEncoding(NSUnicodeStringEncoding)!
        for i in 0...(self.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding)-1)
        {
            if(p[i] != 0)
            {
                strlength += 1
            }
            else
            {
            }
        }
        
        return ((strlength/2)==1) ? true : false
    }

    
    //统计字节长度 一个汉字两个字节算
    var btyeLength:Int
    {
        var length=0;
        for str in self.characters
        {
            if(String(str).isChinese())
            {
                length+=2
            }
            else
            {
                length += 1
            }
            
        }
        
        return length
        
    }
    
    //统计长度
    func length()->Int{
        return self.characters.count
    }
    //统计长度(别名)
    func size()->Int{
        return self.characters.count
    }
    
    //重复字符串
    func `repeat`(times: Int) -> String{
        var result:String = ""
        for _ in 0...times {
            result += self
        }
        return result
    }
    //反转
    func reverse()-> String{
        let s=Array(self.split("").reverse())
        var x=""
        for y in s{
            x+=y
        }
        return x
    }
    
    var md5 : String{
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        
        var hash = String()
        for i in 0 ..< digestLen {
            hash=hash+String(format: "%02x", result[i])
        }
        free(result)
        
        return hash

    }
    
    func fileExistsInBundle()->Bool
    {
        let filePath=NSBundle.mainBundle().pathForResource(self, ofType:"")
        if(filePath == nil)
        {
            return false
        }
        
        let fileManager=NSFileManager.defaultManager()
        if(fileManager.fileExistsAtPath(filePath!))
        {
            return true
        }
        else
        {
            return false
        }
        
    }
    
    func fileExistsInPath()->Bool
    {
        let fileManager=NSFileManager.defaultManager()
        if(fileManager.fileExistsAtPath(self))
        {
            return true
        }
        else
        {
            return false
        }

    }
    
    var data:NSData?
        {
        return self.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    var path:String
    {
        var str:String?
        str=NSBundle.mainBundle().pathForResource(self, ofType: nil)
        str=(str==nil) ? "" : str
        return str!
    }
    
    var url:NSURL?
    {
        return NSURL(string: self)
        
    }
    
    var urlRequest:NSURLRequest?
    {
        let str = self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        if let u = str?.url
        {
            return NSURLRequest(URL: u)
        }
        
        return nil
    }
    
    var image:UIImage?
        {
            var image:UIImage?
            image = UIImage(contentsOfFile: self.path)
            
            if(image != nil)
            {
                return image
            }
            
            image = UIImage(contentsOfFile: self)
            
            if(image != nil)
            {
                return image
            }
            
            image = UIImage(contentsOfFile:(XImageSavePath as NSString).stringByAppendingPathComponent("\(self.hash)"))
            
            if(image != nil)
            {
                return image
            }

            image = UIImage(contentsOfFile:(TempPath as NSString).stringByAppendingPathComponent(self.md5))
            
            if(image != nil)
            {
                return image
            }
            
            
        return image
    }
    
    var color:UIColor?
        {
        var cStr=self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
            
            if(cStr.length()<6)
            {
                return UIColor.clearColor()
            }
            
            if(cStr.hasPrefix("0X"))
            {
                let index:String.Index=cStr.startIndex.advancedBy(2)
                
                cStr=cStr.substringFromIndex(index)
            }
            
            if(cStr.hasPrefix("#"))
            {
                let index:String.Index=cStr.startIndex.advancedBy(1)
                cStr=cStr.substringFromIndex(index)
            }
            
            if(cStr.length() != 6)
            {
                return UIColor.clearColor()
            }
            
            var rang:Range=Range(start: cStr.startIndex, end: cStr.startIndex.advancedBy(2))
            
            let rSt=cStr.substringWithRange(rang)
            rang=Range(start: cStr.startIndex.advancedBy(2), end: cStr.startIndex.advancedBy(4))
            let gStr=cStr.substringWithRange(rang)
            rang=Range(start: cStr.startIndex.advancedBy(4), end: cStr.startIndex.advancedBy(6))
            let bStr=cStr.substringWithRange(rang)
            
            var r:UInt32=0
            var g:UInt32=0
            var b:UInt32=0
            NSScanner(string: rSt).scanHexInt(&r)
            NSScanner(string: gStr).scanHexInt(&g)
            NSScanner(string: bStr).scanHexInt(&b)
            
            return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
            
    }
    
    var date:NSDate?
        {
            let dateFormatter:NSDateFormatter=NSDateFormatter()
            dateFormatter.dateFormat="yyyy-MM-dd HH:mm"
            return dateFormatter.dateFromString(self)
    }
    
    func toDate(format:String)->NSDate?
    {
        let dateFormatter:NSDateFormatter=NSDateFormatter()
        dateFormatter.dateFormat=format
        return dateFormatter.dateFromString(self)
    }
    
    var fileType:String
        {
            var str=""
            for s in self.characters
            {
                if(s==".")
                {
                    str=""
                    continue
                }
                str=str+String(s)
            }
            
            return str
    }
    
    var fileName:String
    {
            var str=""
            for s in self.characters
            {
                if(s=="/")
                {
                    str=""
                    continue
                }
                str=str+String(s)
            }
            
            return str
    }
    
    var VC:UIViewController
    {
            return board.instantiateViewControllerWithIdentifier(self)
    }
    
    func VC(name:String)->UIViewController
    {
        let board:UIStoryboard=UIStoryboard(name: name, bundle: nil)
        return board.instantiateViewControllerWithIdentifier(self)
    }
    
    
    func VC(p:Teamer)->UIViewController
    {
        let board:UIStoryboard=UIStoryboard(name: p.rawValue, bundle: nil)
        return board.instantiateViewControllerWithIdentifier(self)
    }
    
    var Nib:UINib
    {
        return UINib(nibName: self, bundle: nil)
    }
    
    var View:UIView
    {
        let arr:Array = NSBundle.mainBundle().loadNibNamed(self, owner: nil, options: nil)!
        
        return arr[0] as! UIView 
    }
    
    func postNotice()
    {
        NSNotificationCenter.defaultCenter().postNotificationName(self, object: nil)
    }
    
    func UserDefaultsValue()->AnyObject?
    {
        return NSUserDefaults.standardUserDefaults().valueForKey(self)
    }
    
    var createModel: NSObject?
    {
        let temp = NSClassFromString(self)
            as? NSObject.Type
        
        if let type = temp {
            let my = type.init()
            
            return my
        }

        return nil
    }
    
    var createClass:AnyClass!
        {
        
            if  var appName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as? String {
                
                if appName == "" {appName = ((NSBundle.mainBundle().bundleIdentifier!).characters.split{$0 == "."}.map { String($0) }).last ?? ""}
                
                var clsStr = self
                
                if !self.contain(subStr: "\(appName)."){
                    clsStr = appName + "." + self
                }
                
                let strArr = clsStr.explode(".")
                
                var className = ""
                
                let num = strArr.count
                
                if num > 2 || strArr.contains(appName) {
                    
                    var nameStringM = "_TtC" + "C".repeatTimes(num - 2)
                    
                    for (_, s): (Int, String) in strArr.enumerate(){
                        
                        nameStringM += "\(s.characters.count)\(s)"
                    }
                    
                    className = nameStringM
                    
                }else{
                    
                    className = clsStr
                }
                
                return NSClassFromString(className)
            }
        
       
            return nil;

    }
    
    func match(str:String)->Bool
    {
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",str)
        
        if ((regextestmobile.evaluateWithObject(self) == true)
            )
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func match(str:RegularType)->Bool
    {
        return self.match(str.rawValue)
    }
    
    func checkLength(min:Int,max:Int)->Bool
    {
        if(self.trim().length() < min  || self.trim().length() > max)
        {
            return false
        }
        
        return true
    }
    
    //Non-optional number
    var numberValue: NSNumber {
        
        let decimal = NSDecimalNumber(string: self)
        if decimal == NSDecimalNumber.notANumber() {  // indicates parse error
            return NSDecimalNumber.zero()
        }
        return decimal
    
    }
    

    
}


