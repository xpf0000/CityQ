//
//  position.swift
//  OA
//
//  Created by X on 15/5/9.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation

typealias coordinateBlock = (CLLocationCoordinate2D?)->Void
typealias positionBlock = (BMKReverseGeoCodeResult?)->Void

class position:NSObject,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate {
    
    var locationService:BMKLocationService?
    var searcher:BMKGeoCodeSearch?
    var delegate:commonDelegate?
    var dict:Dictionary<String,AnyObject>=[:]
    var block:positionBlock?
    var cblock:coordinateBlock?
    
    class func Share() ->position! {
        
        struct Once {
            static var token:dispatch_once_t = 0
            static var dataCenterObj:position! = nil
        }
        dispatch_once(&Once.token, {
            Once.dataCenterObj = position()
        })
        return Once.dataCenterObj
    }
    
    override init()
    {
        super.init()
    }
    
    func getCoordinate(block:coordinateBlock)
    {
        self.cblock = block
        self.getLocation()
    }
    
    func getLocationInfo(block:positionBlock)
    {
        self.block=block
        self.getLocation()
    }
    
    func getLocation()
    {
        locationService=BMKLocationService()
        locationService?.distanceFilter = 100.0
        locationService?.desiredAccuracy = kCLLocationAccuracyBest
        locationService!.delegate=self
        searcher=BMKGeoCodeSearch()
        searcher!.delegate = self
        locationService!.startUserLocationService()
    }
    
    func stop()
    {
        locationService!.stopUserLocationService()
        locationService!.delegate=nil
        locationService=nil
        searcher!.delegate = nil
        searcher=nil
    }

    func didFailToLocateUserWithError(error: NSError!) {

        if(self.cblock != nil)
        {
            self.cblock!(nil)
        }
        
        if(self.block != nil)
        {
            self.block!(nil)
        }

    }
    
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        
        if(self.cblock != nil)
        {
            self.cblock!(userLocation.location.coordinate)
            
            return
        }
        
        let reverseGeoCodeSearchOption=BMKReverseGeoCodeOption();
        reverseGeoCodeSearchOption.reverseGeoPoint = userLocation.location.coordinate
        let flag:Bool=searcher!.reverseGeoCode(reverseGeoCodeSearchOption)
        
        if(flag)
        {
            //println("反geo检索发送成功");
        }
        else
        {
            //println("反geo检索发送失败");
            
            if(self.block != nil)
            {
                self.block!(nil)
            }
            
            //dict["Address"]="位置获取失败"
            self.delegate?.selectWithDict!(nil, flag: 14)
            
        }
        
    }
    
    func onGetReverseGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if(error.rawValue==BMK_SEARCH_NO_ERROR.rawValue)
        {
            if(self.block != nil)
            {
                self.block!(result)
            }
            
            dict["Address"]=result
            self.delegate?.selectWithDict!(dict, flag: 14)
        }
        else
        {
            if(self.block != nil)
            {
                self.block!(nil)
            }
            
            //dict["Address"]="位置获取失败"
            self.delegate?.selectWithDict!(nil, flag: 14)
        }
    }
    
}
