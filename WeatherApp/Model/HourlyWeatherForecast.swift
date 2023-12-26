//
//  HourlyWeatherForecastRealmClass.swift
//  WeatherApp
//
//  Created by Refat E Ferdous on 12/14/23.
//

import Foundation
import RealmSwift

class HourlyWeatherForecast : Object{
    @objc dynamic var time : String?
    @objc dynamic var temperature : String?
    @objc dynamic var icon : String?
    @objc dynamic var windSpeed : String?
}
