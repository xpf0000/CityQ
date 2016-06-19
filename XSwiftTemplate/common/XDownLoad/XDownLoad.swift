//
//  XDownLoad.swift
//  ImageLoaderIndicator
//
//  Created by X on 16/2/2.
//  Copyright © 2016年 Rounak Jain. All rights reserved.
//

import UIKit

typealias SendDoubleBlock = (Double)->Void
typealias CompletedBlock = (Bool)->Void


class TaskPartModel:Reflect {
    
    var begin:Int64 = 0
    
    var end:Int64 = 0
    var totalLength:Int64 = 0
    var task:NSURLSessionDataTask?
    
    var newBegin:Int64
    {
        return begin+NSData(contentsOfFile: path)!.length
    }
    
    var url:String=""
    var index = 0
    var needReStart=false
    var complete = false
    var path:String
        {
            
            return (localPath as NSString).stringByAppendingPathComponent(url.md5+"\(index)")
    }
    
    
    
    func createTempFile()
    {
        FileManager.createFileAtPath(path, contents: nil, attributes: nil)
    }
    
}


class XDownLoad: Reflect {
    
    var taskArr:Dictionary<Int,TaskPartModel> = [:]
    var speed:Array<Int64> = []
    var totalContentLength:Int64 = 0
    var receiveLength:Int64 = 0
    dynamic var state:DownLoadState = .None
    lazy var speedArr:Array<SendDoubleBlock> = []
    lazy var progressArr:Array<SendDoubleBlock> = []
    lazy var completedArr:Array<CompletedBlock> = []
    var url = ""
    var fileName = ""
    var timer:NSTimer?
    
    var customObj:AnyObject?
    
    func InitReceiveLength()
    {
        self.state = .None
        receiveLength = 0
        let savePath = (localPath as NSString).stringByAppendingPathComponent(url.md5+"."+url.fileType)
        if(savePath.fileExistsInPath())
        {
            self.state = .Complete
            self.receiveLength = self.totalContentLength
            return
        }
        
        for (_,value) in self.taskArr
        {
            if(value.path.fileExistsInPath())
            {
                let length = Int64(NSData(contentsOfFile: value.path)!.length)
                
                if length != value.totalLength {value.complete = false}
                else{value.complete = true}
                
                receiveLength += length
            }
            else
            {
                value.complete = false
                value.createTempFile()
            }
            
            
        }
        
        
    }
    
    func taskProgress()->Double
    {
        if self.totalContentLength == 0 {return 0.0}
        return Double(self.receiveLength) / Double(self.totalContentLength)
    }
    
    var taskList:Dictionary<String,XDownLoad> = [:]
    
    func save()
    {
        XDownLoad.delete(name: "XDownLoad")
        XDownLoad.save(obj: self, name: "XDownLoad")
    }
    
    
    func createTaskPart()
    {
        var URL = NSURL(string: url)!
        
        let request = NSMutableURLRequest(URL: URL)
        
        request.HTTPMethod = "HEAD"
        
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36", forHTTPHeaderField: "User-Agent")
        request.setValue("text/plain; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("gzip, deflate, sdch", forHTTPHeaderField: "Accept-Encoding")
        
        var response:NSURLResponse?
        
        
        var header=[:]
        
        do{
            try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
            
            URL = response!.URL!
            
            header = (response as! NSHTTPURLResponse).allHeaderFields
            
            self.totalContentLength = response!.expectedContentLength
            
        }
        catch{
            
            
        }
        
        let page = self.totalContentLength < 100 ? 1 : 5
        
        let Connection = header["Connection"] as? String
        
        let size = Int(ceil(Double(self.totalContentLength) / Double(page)))
        
        
        for i in 0...page-1
        {
            let r = NSMutableURLRequest(URL: URL)
            
            let begin = i*size
            let end = Int64(i*size+size-1) >= self.totalContentLength ? self.totalContentLength-1 : Int64(i*size+size-1)
            
            let requestRange = String(format: "bytes=%llu-%llu", begin,end)
            
            r.timeoutInterval = 0
            
            r.setValue(requestRange, forHTTPHeaderField: "Range")
            
            let model = TaskPartModel()
            
            model.begin = Int64(begin)
            model.end = Int64(end)
            model.totalLength = model.end - model.begin + 1
            
            if(Connection == "close")
            {
                model.needReStart = true
            }
            
            model.url = url
            model.index = i
            model.createTempFile()
            
            let task:NSURLSessionDataTask = XDownLoadManager.Share.session.dataTaskWithRequest(r)
            //task.resume()
            model.task = task
            
            self.taskArr[i] = model
            
        }
    }
    
    override func excludedKey() -> [String]? {
        
        return ["customObj","customBlock"]
    }
    
    init(url:String) {
        super.init()
        self.url = url
        self.fileName = url.fileName
        if taskArr.count == 0
        {
            self.createTaskPart()
        }
        
        
    }
    
    init(url:String,speed:SendDoubleBlock,progress:SendDoubleBlock,completed:CompletedBlock) {
        super.init()
        self.url = url
        self.fileName = url.fileName
        if taskArr.count == 0
        {
            self.createTaskPart()
        }
        block(speed: speed, progress: progress, completed: completed)
        
    }

    required init() {
        super.init()
    }
    
    func block(speed speed:SendDoubleBlock,progress:SendDoubleBlock,completed:CompletedBlock)
    {
        self.speedArr.append(speed)
        self.progressArr.append(progress)
        self.completedArr.append(completed)
    }
    
    func startDown()
    {
        self.InitReceiveLength()
        if(self.state == .Complete){return}

        for (_,value) in self.taskArr
        {
            
            if(value.complete)
            {
                continue
            }
            
            if(value.task == nil)
            {
                let r = NSMutableURLRequest(URL: NSURL(string: url)!)
                let requestRange = String(format: "bytes=%llu-%llu", value.newBegin,value.end)
                
                r.setValue(requestRange, forHTTPHeaderField: "Range")
                
                r.timeoutInterval = 0
                
                let task:NSURLSessionDataTask = XDownLoadManager.Share.session.dataTaskWithRequest(r)
                
                value.task = task
            }

            if(value.task?.state != .Canceling && value.task?.state != .Completed && value.task?.state != .Running)
            {
                value.task?.resume()
            }
            
        }
        
        timer?.invalidate()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
        self.state = .Running
    }
    
    func pauseDownLoad()
    {
        if(self.state == .Complete){return}
        
        for (_,value) in self.taskArr
        {
            if(value.complete || value.task == nil)
            {
                continue
            }
            
            if value.task!.state != .Completed && value.task!.state != .Canceling
            {
                value.task?.cancel()
                value.task = nil
                
                let r = NSMutableURLRequest(URL: NSURL(string: url)!)
                let requestRange = String(format: "bytes=%llu-%llu", value.newBegin,value.end)
                
                r.setValue(requestRange, forHTTPHeaderField: "Range")
                
                r.timeoutInterval = 0
                
                let task:NSURLSessionDataTask = XDownLoadManager.Share.session.dataTaskWithRequest(r)
                
                value.task = task
                
            }

            
        }
        
        self.speed = []
        self.timer?.invalidate()
        
        self.state = .Pause
    }
    
    func cancelDownLoad()
    {

        for (_,value) in self.taskArr
        {
            if(value.task?.state != .Canceling && value.task?.state != .Completed)
            {
                value.task?.cancel()
            }
            
        }
        
        self.speed = []
        self.timer?.invalidate()
        
        self.state = .Cancel
        
    }
    
    func getSpeed()->Double
    {
        var r:Int64 = 0
        for s in speed
        {
            r += s
        }
    
        speed = []
        
        return Double(r) / 256.0
    }
    
    func update()
    {
        for item in self.speedArr
        {
            item(getSpeed())
        }
        
    }
    
    
    func taskComplete()
    {
        for (_,value) in self.taskArr
        {
            if(!value.complete){return}
        }
        
        timer?.invalidate()
        
        let savePath = (localPath as NSString).stringByAppendingPathComponent(url.md5+"."+url.fileType)
        
        for i in 0...self.taskArr.count-1
        {
            self.taskArr[i]!.task?.cancel()
            self.taskArr[i]!.task = nil
            
            if(i == 0)
            {
                FileManager.createFileAtPath(savePath, contents: nil, attributes: nil)
            }
            
            //向文件追加数据
            let fileHandle = NSFileHandle(forUpdatingAtPath: savePath)
            fileHandle?.seekToEndOfFile()
            fileHandle?.writeData(NSData(contentsOfFile: self.taskArr[i]!.path)!)
            fileHandle?.synchronizeFile()
            fileHandle?.closeFile()
            
            do
            {
                try FileManager.removeItemAtPath(self.taskArr[i]!.path)
            }
            catch
            {
                
            }
            
        }
        
        for item in self.completedArr
        {
            MainDo({ (o) -> Void in
                item(true)
            })
        }
        
        XDownLoadManager.Share.taskList.save()
        
        self.DoCustomThings()
        
        MainDo({ (o) -> Void in
            
            "DownLoadSuccess".postNotice()
            
           self.state = .Complete
        })

    }
    
    
    func progress(bytesWritten: Int64)
    {
        self.speed.append(bytesWritten)
        
        self.receiveLength += bytesWritten
        
        let p = Double(self.receiveLength)/Double(self.totalContentLength)
        
        for item in self.progressArr
        {
            MainDo({ (o) -> Void in
                
                item(p)
            })
            
        }

    }
    
    func DoCustomThings()
    {
        if(customObj is OAFileModel)
        {
            if let o:OAFileModel = self.customObj as? OAFileModel
            {
                DataCache.Share().oaFile.arr.append(o)
                DataCache.Share().oaFile.save()
            }
            
            customObj=nil
            
            
        }
    }
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    
}
