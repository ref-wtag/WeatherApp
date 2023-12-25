//
//  WeatherForecastRealmClass.swift
//  WeatherApp
//
//  Created by Refat E Ferdous on 12/14/23.
//

import Foundation
import RealmSwift

class WeatherForecastRealm : Object {
    @objc dynamic var cityName : String?
    @objc dynamic var temperature : String?
    @objc dynamic var weatherType : String?
    @objc dynamic var icon : String?
    @objc dynamic var currentDate : String?
    @objc dynamic var minTemperature : String?
    @objc dynamic var maxTemperature : String?
    @objc dynamic var time : String?
}
