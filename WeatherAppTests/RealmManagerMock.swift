//
//  RealmMockTest.swift
//  WeatherAppTests
//
//  Created by Refat E Ferdous on 1/2/24.
//

import Foundation
@testable import WeatherApp

class RealmManagerMock : RealmManagerDelegate{

    
    var isDeleteWeatherInfoDataCalled = false
    var isDeleteWeatherForecastDataCalled = false
    
    func deleteWeatherInfoData() {
        
        isDeleteWeatherInfoDataCalled = true
    }
    
    func deleteWeatherForecastData() {
        isDeleteWeatherForecastDataCalled = true
    }
    
}
