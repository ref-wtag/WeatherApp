//
//  WeatherForecastViewModelTest.swift
//  WeatherAppTests
//
//  Created by Refat E Ferdous on 1/2/24.
//

import XCTest
@testable import WeatherApp

class WeatherForecastViewModelTest: XCTestCase {
    
    var sut: WeatherForecastViewModel!
    var networkManagerMock : NetworkManagerMock!
    var realmMock : RealmManagerMock!
    
    
    override func setUpWithError() throws {
      networkManagerMock = NetworkManagerMock()
      realmMock = RealmManagerMock()
      sut = WeatherForecastViewModel(netWorkManager: networkManagerMock, realmManager: realmMock)
      try? super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try? super.tearDownWithError()
        sut = nil
        realmMock = nil
        networkManagerMock = nil
    }

    func testFetchWeatherForecastInfo_Success(){
        
        let mockLat = 0.0
        let mockLong = 0.0
        sut.fetchWeatherForecastInfo()
        XCTAssertNotNil(sut.weatherForecastInfo)
        XCTAssertEqual(sut.weatherForecastInfo?.list[0].weather[0].main, "clear")
    }
    
    func testFetchWeatherForecastInfo_Error(){
        
        let mockLat = 0.0
        let mockLong = 0.0
        sut.fetchWeatherForecastInfo()
        XCTAssertNil(sut.weatherForecastInfo)
        
    }
    
}
