//
//  MockURLSession.swift
//  WeatherAppTests
//
//  Created by Refat E Ferdous on 1/2/24.
//

import Foundation
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