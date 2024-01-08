import XCTest
import RealmSwift
@testable import WeatherApp

class MainViewModelTest: XCTestCase {
    var sut : MainViewModel!
    var realmManagerMock : RealmManagerMock!
    var networkManagerMock : NetworkManagerMock!
    var mockRealm : Realm!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        realmManagerMock = RealmManagerMock()
        networkManagerMock = NetworkManagerMock()
        mockRealm = try? Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealm"))
        sut = MainViewModel(realmManager : realmManagerMock, networkManager : networkManagerMock)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        realmManagerMock = nil
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
        XCTAssertEqual(sut.weatherForecastInfo?.list[0].main.temp, 25.0)
    }
    
    func testSaveWeatherInfoData_Success(){
        sut.saveWeatherInfoData()
        let countWeatherInfoData = mockRealm.objects(WeatherDataInfo.self).count
        let mockWeatherInfoData = mockRealm.objects(WeatherDataInfo.self).first
        XCTAssertNotNil(mockWeatherInfoData)
        XCTAssertEqual(countWeatherInfoData, 1)
    }
    
    func testSaveHourlyWeatherForecastData_Success(){
        sut.saveHourlyWeatherForecastData()
        let countWeatherInfoData = mockRealm.objects(HourlyWeatherForecast.self).count
        let mockWeatherInfoData = mockRealm.objects(HourlyWeatherForecast.self).first
        XCTAssertNotNil(mockWeatherInfoData)
        XCTAssertEqual(countWeatherInfoData, 1)
    }
}


