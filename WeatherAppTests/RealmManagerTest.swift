//
//  RealmManagerTest.swift
//  WeatherAppTests
//
//  Created by Refat E Ferdous on 1/2/24.
//

@testable import WeatherApp
import Realm
import RealmSwift
import XCTest



class RealmManagerTest: XCTestCase {

    var sut : RealmManager!
    var mockRealm : Realm!
    
    override func setUpWithError() throws {
        try? super.setUpWithError()
        mockRealm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealm"))
        sut = RealmManager()
    }

    override func tearDownWithError() throws {
        sut = nil
        mockRealm = nil
        try? super.tearDownWithError()
       
    }
    
    func testDeleteWeatherInfoData_Success(){
        let mockWeatherinfoData = WeatherDataInfo()
        
        mockWeatherinfoData.cityName = "Rangpur"
        mockWeatherinfoData.temperature = "23.5"
        mockWeatherinfoData.icon = "01d"
        mockWeatherinfoData.weatherType = "clear"
        
        let mockWeatherForecastData = HourlyWeatherForecast()
        
        mockWeatherForecastData.time = "12.30"
        mockWeatherForecastData.temperature = "25.6"
        mockWeatherForecastData.icon = "012d"
        mockWeatherForecastData.windSpeed = "12.45"
        
        
        try! mockRealm.write{
            mockRealm.add(mockWeatherinfoData)
            mockRealm.add(mockWeatherForecastData)
        }
        
        let mockInfoData = mockRealm.objects(WeatherDataInfo.self).first
        let mockForecastData = mockRealm.objects(HourlyWeatherForecast.self).first
        XCTAssertNotNil(mockInfoData)
        XCTAssertNotNil(mockForecastData)
    
        sut.realm = mockRealm
        sut.deleteWeatherInfoData()
        
        let countWeatherInfoData = mockRealm.objects(WeatherDataInfo.self).count
        let mockWeatherInfoData = mockRealm.objects(WeatherDataInfo.self).first
        
        let countWeatherForecastData = mockRealm.objects(HourlyWeatherForecast.self).count
        let mockWeatherForecast = mockRealm.objects(HourlyWeatherForecast.self).first
        
        
        XCTAssertNil(mockWeatherForecast)
        XCTAssertEqual(countWeatherForecastData, 0)
    }
    
    func testDeleteWeatherInfoData_Error(){
        
        let mockWeatherinfoData = WeatherDataInfo()
        
        mockWeatherinfoData.cityName = "Rangpur"
        mockWeatherinfoData.temperature = "23.5"
        mockWeatherinfoData.icon = "01d"
        mockWeatherinfoData.weatherType = "clear"
        
        let mockWeatherForecastData = HourlyWeatherForecast()
        
        mockWeatherForecastData.time = "12.30"
        mockWeatherForecastData.temperature = "25.6"
        mockWeatherForecastData.icon = "012d"
        mockWeatherForecastData.windSpeed = "12.45"
    
        sut.realm = mockRealm
        sut.deleteWeatherInfoData()
        
        let countWeatherInfoData = mockRealm.objects(WeatherDataInfo.self).count
        let mockWeatherInfoData = mockRealm.objects(WeatherDataInfo.self).first
        
        let countWeatherForecastData = mockRealm.objects(HourlyWeatherForecast.self).count
        let mockWeatherForecast = mockRealm.objects(HourlyWeatherForecast.self).first
        
        
        XCTAssertNil(mockWeatherForecast)
        XCTAssertEqual(countWeatherForecastData, 0)
    }
    
    func testDeleteWeatherForecastData_Success(){
        let mockWeatherData = WeatherForecast()
        
        mockWeatherData.cityName = "Dhaka"
        mockWeatherData.temperature = "23.5"
        mockWeatherData.weatherType = "clear"
        mockWeatherData.icon = "01d"
        mockWeatherData.currentDate = "12-54-32"
        mockWeatherData.minTemperature = "11.98"
        mockWeatherData.maxTemperature = "13.40"
        mockWeatherData.time = "7.43"
        
        
        try! mockRealm.write{
            mockRealm.add(mockWeatherData)
        }
        
        let mockForecastData = mockRealm.objects(WeatherForecast.self).first
        XCTAssertNotNil(mockForecastData)
        
        sut.realm = mockRealm
        sut.deleteWeatherForecastData()
        
        let countWeatherForecastData = mockRealm.objects(WeatherForecast.self).count
        let mockWeatherForecastData = mockRealm.objects(WeatherForecast.self).first
        
        XCTAssertNil(mockWeatherForecastData)
        XCTAssertEqual(countWeatherForecastData, 0)
    }
    
    func testDeleteWeatherForecastData_Error(){
        let mockWeatherData = WeatherForecast()
        
        mockWeatherData.cityName = "Dhaka"
        mockWeatherData.temperature = "23.5"
        mockWeatherData.weatherType = "clear"
        mockWeatherData.icon = "01d"
        mockWeatherData.currentDate = "12-54-32"
        mockWeatherData.minTemperature = "11.98"
        mockWeatherData.maxTemperature = "13.40"
        mockWeatherData.time = "7.43"
        
        
        sut.realm = mockRealm
        sut.deleteWeatherForecastData()
        
        let countWeatherForecastData = mockRealm.objects(WeatherForecast.self).count
        let mockWeatherForecastData = mockRealm.objects(WeatherForecast.self).first
        
        XCTAssertNil(mockWeatherForecastData)
        XCTAssertEqual(countWeatherForecastData, 0)
    }
    
    
    
}
