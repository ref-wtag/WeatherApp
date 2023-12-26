//
//  ConstantKeys.swift
//  WeatherApp
//
//  Created by Refat E Ferdous on 12/20/23.
//

import Foundation
class ConstantKeys{
    
    static let shared = ConstantKeys()
    
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    var cityName : String = ""

    static let BASE_URL : String = "https://api.openweathermap.org/data/2.5"
    static let APP_ID : String = "821f770339f2c200486a644b17bf970a"
    static let IMAGE_URL : String = "https://openweathermap.org/img/w/"
    static let IMAGE_EXTENSION : String = ".png"
    
}