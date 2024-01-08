import Foundation
@testable import WeatherApp

class MockURLSessionDataTask: URLSessionDataTask {
    var completionHandler: (() -> Void)?

    override func resume() {
        completionHandler?()
    }
}
