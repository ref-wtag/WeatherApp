//
//  RealmMockTest.swift
//  WeatherAppTests
//
//  Created by Refat E Ferdous on 1/2/24.
//

import Foundation
@testable import WeatherApp

class RealmManagerMock : RealmManagerDelegate{

    
    var mockWeatherInfodata : CurrentWeatherInfoResponse?
    var mockWeatherForecastdata : WeatherForecastResponse?
    
    func deleteWeatherInfoData() {
        
        mockWeatherInfodata = nil
    }
    
    func deleteWeatherForecastData() {
        mockWeatherForecastdata = nil
    }
    
}
