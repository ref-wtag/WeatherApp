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
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MainViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    
    func testfetchCurrentWeatherInfo_Success(){
        let mockLat = 0.0
        let mockLong = 0.0
        sut.fetchCurrentWeatherInfo(lat: mockLat, lon: mockLong)
        
        XCTAssertNotNil(sut.currentWeatherData)
    }
    
    func testfetchCurrentWeatherInfo_Success(){
        let mockLat = 0.0
        let mockLong = 0.0
        
        sut.fetchCurrentWeatherInfo(lat: mockLat, lon: mockLong)
        
        XCTAssertNil(sut.currentWeatherData)
    }

}
