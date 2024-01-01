//
//  NetManagerTest.swift
//  WeatherAppTests
//
//  Created by Refat E Ferdous on 1/1/24.
//

import XCTest
@testable import WeatherApp

class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockError: Error?

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let mockDataTask = MockURLSessionDataTask()
        mockDataTask.completionHandler = {
            completionHandler(self.mockData, nil, self.mockError)
        }
        return mockDataTask
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    var completionHandler: (() -> Void)?

    override func resume() {
        completionHandler?()
    }
}

class NetworkManagerTest: XCTestCase {

    var sut: NetworkManager!
    var mockURLSession: MockURLSession!

    override func setUpWithError() throws {
        super.setUp()
        mockURLSession = MockURLSession()
        sut = NetworkManager(urlSession: mockURLSession)
    }
    
    override func tearDownWithError() throws {
        try? super.tearDownWithError()
        mockURLSession = nil
        sut = nil
    }
    
    func testFetcCurrenthWeatherInfo_Success() {
        
       let weatherInfoData = CurrentWeatherInfoResponse(weather: [WeatherInfo(main: "clear", icon: "012d")], main: MainWeather(temp: 12.0))
       let mockData = try? JSONEncoder().encode(weatherInfoData)
        
        mockURLSession.mockData = mockData
        sut.fetchCurrentWeatherInfo(latitude: 0.0, longitude: 0.0) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.weather[0].main, "clear")
            case .failure(let error):
                XCTFail("Expected success, got failure with error: \(error.localizedDescription)")
            }
        }
    }
    
    func testFetchCurrentWeatherInfo_Failure() {
        let mockError = NSError(domain: "com.example.error", code: 42, userInfo: [NSLocalizedDescriptionKey: "Simulated error"])
        mockURLSession.mockError = mockError
        sut.fetchCurrentWeatherInfo(latitude: 0.0, longitude: 0.0) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                XCTAssertEqual(error as NSError, mockError)
            }
        }

    }
    
    

    func testFetchWeatherForecastInfo_Success() {
        let weatherInfoList : WeatherInfoList = WeatherInfoList(main: Main(temp: 11.0, temp_max: 12.0, temp_min: 13.0), weather: [Weather(icon: "012d", main: "clear")], wind: Wind(speed: 22.3), dt_txt: "11289")
   
       let weatherForecastData = WeatherForecastResponse(list: [weatherInfoList])
       let mockData = try? JSONEncoder().encode(weatherForecastData)
        
        
        mockURLSession.mockData = mockData
        sut.fetchWeatherForecastInfo(latitude: 0.0, longitude: 0.0) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.list[0].main.temp, 11.0)
            case .failure(let error):
                XCTFail("Expected success, got failure with error: \(error.localizedDescription)")
            }
        }
    }

    func testFetchWeatherForecastInfo_Failure() {
        let mockError = NSError(domain: "com.example.error", code: 42, userInfo: [NSLocalizedDescriptionKey: "Simulated error"])
        mockURLSession.mockError = mockError

        sut.fetchWeatherForecastInfo(latitude: 0.0, longitude: 0.0) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                XCTAssertEqual(error as NSError, mockError)
            }
        }

    }
    
    
}
