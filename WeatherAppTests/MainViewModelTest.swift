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
    var realmMock : RealmManagerMock!
    var networkManagerMock : NetworkManagerMock!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        realmMock = RealmManagerMock()
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


