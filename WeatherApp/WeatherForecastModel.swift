//
//  Model.swift
//  WeatherApp
//
//  Created by Refat E Ferdous on 12/10/23.
//

import Foundation

struct WeatherForecastResponse : Codable{
    let list : [WeatherInfoList]
}

struct WeatherInfoList : Codable{
    let main : Main
    let weather : [Weather]
    let wind : Wind
    let dt_txt : String
}

struct Main : Codable{
    let temp : Double
    let temp_max : Double
    let temp_min : Double
}

struct Weather : Codable{
    let icon :  String
    let main : String
}

struct Wind : Codable{
    let speed : Double
}
