//
//  MockURLSessionDataTask.swift
//  WeatherAppTests
//
//  Created by Refat E Ferdous on 1/2/24.
//

import Foundation
@testable import WeatherApp

class MockURLSessionDataTask: URLSessionDataTask {
    var completionHandler: (() -> Void)?

    override func resume() {
        completionHandler?()
    }
}
