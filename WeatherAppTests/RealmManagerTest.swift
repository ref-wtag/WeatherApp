//
//  RealmManagerTest.swift
//  WeatherAppTests
//
//  Created by Refat E Ferdous on 1/2/24.
//

import XCTest
@testable import WeatherApp


class RealmManagerTest: XCTestCase {

    var sut : RealmManager!
    
    override func setUpWithError() throws {
        try? super.setUpWithError()
        sut = RealmManager()
    }

    override func tearDownWithError() throws {
        try? super.tearDownWithError()
        sut = nil
    }
    
    func testDeleteWeatherInfoData_Success(){
        var mockWeatherInfodata = CurrentWeatherInfoResponse(weather: [WeatherInfo(main: "clear", icon: "01d")], main: MainWeather(temp: 23.0))
        
    }
    
    func testDeleteWeatherInfoData_Error(){
        
    }
    
    func testDeleteWeatherForecastData_Success(){
    var mockWeatherForecastdata = WeatherForecastResponse(list: [WeatherInfoList(main: Main(temp: 11.0, temp_max: 12.0, temp_min: 13.0), weather: [Weather(icon: "012d", main: "clear")], wind: Wind(speed: 34.8), dt_txt: "1452")])
    }
    
    func testDeleteWeatherForecastData_Error(){
        
    }
    
    
    
}
