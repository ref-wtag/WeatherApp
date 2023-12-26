//
//  RealmManager.swift
//  RealmDemo
//
//  Created by Refat E Ferdous on 12/14/23.
//

import Foundation
import RealmSwift

class RealmManager{
    
    let realm = try! Realm()
    
    //delete
    func deleteWeatherInfoData(){
        try! realm.write{
            realm.delete(realm.objects(WeatherDataInfo.self))
        }
        
        try! realm.write{
            realm.delete(realm.objects(HourlyWeatherForecast.self))
        }
    }
    
    func deleteWeatherForecastData(){
        try! realm.write{
            realm.delete(realm.objects(WeatherForecast.self))
        }
    }
    
}
