//
//  Model.swift
//  WeatherApp
//
//  Created by Refat E Ferdous on 12/10/23.
//

import Foundation

struct HourlyWeatherInfoResponse : Codable{
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
}
struct Weather : Codable{
    let icon :  String
}
struct Wind : Codable{
    let speed : Double
}
