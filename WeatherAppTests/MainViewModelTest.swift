//
//  MainViewModelTest.swift
//  WeatherAppTests
//
//  Created by Refat E Ferdous on 12/28/23.
//

import XCTest
@testable import WeatherApp

class MainViewModelTest: XCTestCase {

    var sut : MainViewModel!
    var realmMock : RealmMock!
    var networkManagerMock : NetworkManagerMock!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        realmMock = RealmMock()
        networkManagerMock = NetworkManagerMock()
        sut = MainViewModel(realmManager : realmMock, networkManager : networkManagerMock)
       
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        realmMock = nil
        networkManagerMock = nil
    }

    func testfetchCurrentWeatherInfo_Success(){
        let mockLat = 0.0
        let mockLong = 0.0
        sut.fetchCurrentWeatherInfo(lat: mockLat, lon: mockLong)
        XCTAssertNotNil(sut.currentWeatherInfo)
        XCTAssertEqual(sut.currentWeatherInfo?.weather[0].main, "clear")
       
    }
    
    
    func testfetchCurrentWeatherInfo_Error(){
        let mockLat = 0.0
        let mockLong = 0.0
        sut.fetchCurrentWeatherInfo(lat: mockLat, lon: mockLong)
        XCTAssertNil(sut.currentWeatherInfo)
        
    }
    
    func testfetchWeatherForecastInfo_Success(){
        let mockLat = 0.0
        let mockLong = 0.0
        sut.fetchWeatherForecastInfo(lat: mockLat, lon: mockLong)
        XCTAssertNotNil(sut.weatherForecastInfo)
        XCTAssertEqual(sut.weatherForecastInfo?.list[0].main.temp, 25.0)
    }
    
    
    func testfetchWeatherForecastInfo_Error(){
        let mockLat = 0.0
        let mockLong = 0.0
        sut.fetchCurrentWeatherInfo(lat: mockLat, lon: mockLong)
        XCTAssertNil(sut.weatherForecastInfo)
    }

}

class RealmMock : RealmManagerDelegate{
   
    func deleteWeatherInfoData() {
        
    }
    
    func deleteWeatherForecastData() {
        
    }
    
}

class NetworkManagerMock : NetworkManagerDelegate{
    
    func fetchWeatherForecastInfo(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherForecastResponse, Error>) -> ()) {
        
        //success
        var mockWeatherForecastData = WeatherInfoList(
            main: Main(temp: 25.0, temp_max: 28.0, temp_min: 22.0),
            weather: [Weather(icon: "01d", main: "clear")],
            wind: Wind(speed: 5.0),
            dt_txt: "2023-12-31 12:00:00"
        )
        let mockForecastResponse = WeatherForecastResponse(list: [mockWeatherForecastData])
        completion(.success(mockForecastResponse))
        
        //error
        let mockError = NSError(domain: "com.example.error", code: 42, userInfo: [NSLocalizedDescriptionKey: "Simulated error"])
        //completion(.failure(mockError))
    }
    
    func fetchCurrentWeatherInfo(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherApp.CurrentWeatherInfoResponse, Error>) -> ()) {
        
        //success
        var mockWeatherInfoData = CurrentWeatherInfoResponse(weather: [WeatherInfo(main: "clear", icon: "01d")], main: MainWeather(temp: 25.0))
       // completion(.success(mockWeatherInfoData))
        
        //error
        let mockError = NSError(domain: "com.example.error", code: 42, userInfo: [NSLocalizedDescriptionKey: "Simulated error"])
        completion(.failure(mockError))
    }
    
}
