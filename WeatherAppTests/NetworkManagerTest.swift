//
//  NetworkManagerTest.swift
//  WeatherAppTests
//
//  Created by Refat E Ferdous on 12/31/23.
//

import XCTest
@testable import WeatherApp

class NetworkManagerTest: XCTestCase {

   

}

class MockNetworkManager : NetworkManagerDelegate{
    func fetchWeatherForecastInfo(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherApp.WeatherForecastResponse, Error>) -> ()) {
        
    }
    
    func fetchCurrentWeatherInfo(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherApp.CurrentWeatherInfoResponse, Error>) -> ()) {
        
    }
    
    
}
