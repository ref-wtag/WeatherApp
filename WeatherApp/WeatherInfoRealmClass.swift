//
//  WeatherInfoRealmClass.swift
//  WeatherApp
//
//  Created by Refat E Ferdous on 12/14/23.
//

import Foundation
import RealmSwift

class WeatherInfoRealmClass : Object {
    @objc dynamic var cityName : String?
    @objc dynamic var temperature : String?
    @objc dynamic var icon : String?
    @objc dynamic var weatherType : String?
}

