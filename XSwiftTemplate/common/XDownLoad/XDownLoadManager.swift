//
//  XDownLoadManager.swift
//  ImageLoaderIndicator
//
//  Created by X on 16/2/3.
//  Copyright © 2016年 Rounak Jain. All rights reserved.
//

import UIKit

func MainDo(block:AnyBlock)
{
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        block(nil)
    })
}

func DelayDo(time:NSTimeInterval,block:AnyBlock)
{
    let delayInSeconds:Double=time
    let popTime:dispatch_time_t=dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
    
    dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
        
        block(nil)
        
    })
    
}


@objc
enum DownLoadState:Int {
    case None
    case Running
    case Pause
    case Cancel
    case Complete
}

let FileManager = NSFileManager.defaultManager()

var localPath:String
{
get
{
    let path = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString).stringByAppendingPathComponent("XDownLoad")
    
    if(!path.fileExistsInPath())
    {
        try! NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
    }
    
    
    return path
}
}

 let config = NSURLSessionConfiguration.backgroundSessionConfiguration("XDownLoad-xpf")

class XDownLoadManager: NSObject,NSURLSessionDataDelegate {

    static let Share = XDownLoadManager.init()
    
    var session:NSURLSession!
    
    lazy var taskList:XDownLoad = XDownLoad()
    
    private override init() {
        super.init()
        
        config.timeoutIntervalForRequest = 0
        config.timeoutIntervalForResource = 0
        config.HTTPMaximumConnectionsPerHost = 5
        config.HTTPAdditionalHeaders = ["User-Agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36","Content-Type":"text/plain; charset=utf-8 ","Accept":"*/*","Accept-Encoding":"gzip, deflate, sdch"]
        
        session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue())
        
        let model = XDownLoad.read(name: "XDownLoad")
        if(model != nil)
        {
            taskList = model as! XDownLoad
            
            for (_,value) in taskList.taskList
            {
                value.InitReceiveLength()
            }
        }
        
    }
    
    func refresh()
    {
        for (_,value) in taskList.taskList
        {
            value.InitReceiveLength()
        }
    }
    
    func refresh(url:String)
    {
        for (_,value) in taskList.taskList
        {
            if(value.url == url)
            {
                value.InitReceiveLength()
            }
        }
    }
    
    func createTask(url:String)->XDownLoad
    {
        for (key,value) in self.taskList.taskList
        {
            if(key == url)
            {
                return value
            }
        }
        
        let down = XDownLoad(url: url)
        self.taskList.taskList[url] = down
        self.taskList.save()
        return down
    }
    

    func runningTask(task:NSURLSessionTask) -> XDownLoad? {
        
        for (key,value) in self.taskList.taskList
        {
            if(key == "\(task.response!.URL!)")
            {
                return value
            }
        }
        
        return nil
    }

    func unFinishedTask() -> [XDownLoad] {
        
        var arr:[XDownLoad] = []
        
        for (_,value) in self.taskList.taskList
        {
            if(value.state != .Complete)
            {
                arr.append(value)
            }
        }

        return arr
        
    }
    
    func finishedTask() -> [XDownLoad] {
        
        var arr:[XDownLoad] = []
        
        for (_,value) in self.taskList.taskList
        {
            if(value.state == .Complete)
            {
                arr.append(value)
            }
        }
        
        return arr
        
    }
    
    
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {

        if(error==nil)
        {
            let down = self.runningTask(task)
            if(down == nil)
            {
                task.cancel()
                return
            }

            for (_,value) in down!.taskArr
            {
                if value.task == nil || value.complete{continue}
                
                if value.task!.state != .Completed && value.needReStart
                {
                    value.task?.cancel()
                    value.task = nil
                    
                    let r = NSMutableURLRequest(URL: task.response!.URL!)
                    let requestRange = String(format: "bytes=%llu-%llu", value.newBegin,value.end)
                    
                    r.setValue(requestRange, forHTTPHeaderField: "Range")

                    r.timeoutInterval = 0
                    
                    let task:NSURLSessionDataTask = self.session!.dataTaskWithRequest(r)
                    
                    task.resume()
                    
                    value.task = task
                    
                }
            }

            
        }
        
        
        
    }
    
    
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        
        //认证服务器（这里不使用服务器证书认证，只需地址是我们定义的几个地址即可信任）
        if challenge.protectionSpace.authenticationMethod
            == NSURLAuthenticationMethodServerTrust
        {

            let credential = NSURLCredential(forTrust:
                challenge.protectionSpace.serverTrust!)
            credential.certificates
            completionHandler(.UseCredential, credential)
        }
            
            //认证客户端证书
        else if challenge.protectionSpace.authenticationMethod
            == NSURLAuthenticationMethodClientCertificate
        {

        }
            
        // 其它情况（不接受认证）
        else {
            completionHandler(.CancelAuthenticationChallenge, nil);
        }
        
    }
    
    func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        
        let down = self.runningTask(dataTask)
        if(down == nil)
        {
            dataTask.cancel()
            return
        }
        
       down!.progress(Int64(data.length))
        
        for (_,value) in down!.taskArr
        {
            if value.task == dataTask
            {
                //value.data.appendData(data)
                //向文件追加数据
                let fileHandle = NSFileHandle(forUpdatingAtPath: value.path)
                fileHandle?.seekToEndOfFile()
                fileHandle?.writeData(data)
                fileHandle?.synchronizeFile()
                fileHandle?.closeFile()
                
                if dataTask.countOfBytesReceived == dataTask.countOfBytesExpectedToReceive
                {
                    value.complete = true
                    down!.taskComplete()
                }
                
            }
        }
        
    }
    
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        
        completionHandler(.Allow)
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, willCacheResponse proposedResponse: NSCachedURLResponse, completionHandler: (NSCachedURLResponse?) -> Void) {
        
    }

    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {

        backgroundSessionCompletionHandler?()
    }
    
    
    
}
