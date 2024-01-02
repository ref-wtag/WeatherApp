//
//  RealmManager.swift
//  RealmDemo
//
//  Created by Refat E Ferdous on 12/14/23.
//

import Foundation
import RealmSwift
import Realm

protocol RealmManagerDelegate {
    func deleteWeatherInfoData()
    func deleteWeatherForecastData()
}

class RealmManager : RealmManagerDelegate{
    
    var realm = try! Realm()
    
    func deleteWeatherInfoData(){
        try? realm.write{
            realm.delete(realm.objects(WeatherDataInfo.self))
            realm.delete(realm.objects(HourlyWeatherForecast.self))
        }
    }
    
    func deleteWeatherForecastData(){
        
        try? realm.write{
            realm.delete(realm.objects(WeatherForecast.self))
        }
    }
    
    
}
