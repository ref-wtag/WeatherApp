//
//  CurrentWeatherInfoModel.swift
//  WeatherApp
//
//  Created by Refat E Ferdous on 12/10/23.
//

import Foundation

struct CurrentWeatherInfoResponse : Codable{
    let weather : [WeatherInfo]
    let main : MainWeather
}

struct WeatherInfo : Codable{
    let main : String
    let icon : String
}

struct MainWeather : Codable{
    let temp : Double
}
