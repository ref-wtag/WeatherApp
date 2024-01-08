import XCTest
import RealmSwift
@testable import WeatherApp

class WeatherForecastViewModelTest: XCTestCase {
    var sut: WeatherForecastViewModel!
    var networkManagerMock : NetworkManagerMock!
    var realmManagerMock : RealmManagerMock!
    var mockRealm : Realm!
    
    override func setUpWithError() throws {
      networkManagerMock = NetworkManagerMock()
      realmManagerMock = RealmManagerMock()
      sut = WeatherForecastViewModel(netWorkManager: networkManagerMock, realmManager: realmManagerMock)
      mockRealm = try? Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealm"))
      try? super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try? super.tearDownWithError()
        sut = nil
        realmManagerMock = nil
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
    
    func testSaveWeatherForecastData_Success(){
        sut.saveWeatherForecastData()
        let countWeatherData = mockRealm.objects(WeatherForecast.self).count
        let mockWeatherData = mockRealm.objects(WeatherForecast.self).first
        XCTAssertNotNil(mockWeatherData)
        XCTAssertEqual(countWeatherData, 1)
    }
}
