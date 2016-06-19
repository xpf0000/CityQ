//
//  WeatherModel.swift
//  lejia
//
//  Created by X on 15/9/12.
//  Copyright (c) 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class WeatherModel: NSObject {
    
    var day:String=""
    var day_air_temperature:String=""
    var day_weather:String=""
    var day_weather_pic:String=""
    var day_wind_direction:String=""
    var day_wind_power:String=""
    var night_air_temperature:String=""
    var night_weather:String=""
    var night_weather_pic:String=""
    var night_wind_direction:String=""
    var night_wind_power:String=""
    var sun_begin_end:String=""
    var weekday:NSNumber=0
    
    var aqi:NSNumber=0
    var co:NSNumber=0.0
    var no2:NSNumber=0
    var o3:NSNumber=0
    var o3_8h:NSNumber=0
    var pm10:NSNumber=0
    var pm2_5:NSNumber=0
    var quality:String=""
    var primary_pollutant:String=""
    var so2:NSNumber=0
    var sd:String=""
    var temperature:String=""
    var temperature_time:String=""
    var weather:String=""
    var weather_pic:String=""
    var wind_direction:String=""
    var wind_power:String=""
    

    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
   
}
