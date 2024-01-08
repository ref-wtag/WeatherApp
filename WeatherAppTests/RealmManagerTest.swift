@testable import WeatherApp
import Realm
import RealmSwift
import XCTest

class RealmManagerTest: XCTestCase {
    var sut : RealmManager!
    var mockRealm : Realm!
    
    override func setUpWithError() throws {
        try? super.setUpWithError()
        mockRealm = try? Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealmForRealmManager"))
        sut = RealmManager(realm: mockRealm)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockRealm = nil
        try? super.tearDownWithError()
    }
    
    func testDeleteWeatherInfoData_Success(){
        let mockWeatherinfoData = WeatherDataInfo()
        mockWeatherinfoData.cityName = "Rangpur"
        mockWeatherinfoData.temperature = "23.5"
        mockWeatherinfoData.icon = "01d"
        mockWeatherinfoData.weatherType = "clear"
        
        let mockWeatherForecastData = HourlyWeatherForecast()
        mockWeatherForecastData.time = "12.30"
        mockWeatherForecastData.temperature = "25.6"
        mockWeatherForecastData.icon = "012d"
        mockWeatherForecastData.windSpeed = "12.45"
        
        try! mockRealm.write{
            mockRealm.add(mockWeatherinfoData)
            mockRealm.add(mockWeatherForecastData)
        }
        
        let mockInfoData = mockRealm.objects(WeatherDataInfo.self).first
        let mockForecastData = mockRealm.objects(HourlyWeatherForecast.self).first
        XCTAssertNotNil(mockInfoData)
        XCTAssertNotNil(mockForecastData)
    
        sut.deleteWeatherInfoData()
        
        let countWeatherInfoData = mockRealm.objects(WeatherDataInfo.self).count
        let mockWeatherInfoData = mockRealm.objects(WeatherDataInfo.self).first
        let countWeatherForecastData = mockRealm.objects(HourlyWeatherForecast.self).count
        let mockWeatherForecast = mockRealm.objects(HourlyWeatherForecast.self).first
        
        XCTAssertNil(mockWeatherInfoData)
        XCTAssertEqual(countWeatherInfoData, 0)
        XCTAssertNil(mockWeatherForecast)
        XCTAssertEqual(countWeatherForecastData, 0)
    }
    
    func testDeleteWeatherInfoData_Error(){
        let mockWeatherinfoData = WeatherDataInfo()
        mockWeatherinfoData.cityName = "Rangpur"
        mockWeatherinfoData.temperature = "23.5"
        mockWeatherinfoData.icon = "01d"
        mockWeatherinfoData.weatherType = "clear"
        
        let mockWeatherForecastData = HourlyWeatherForecast()
        mockWeatherForecastData.time = "12.30"
        mockWeatherForecastData.temperature = "25.6"
        mockWeatherForecastData.icon = "012d"
        mockWeatherForecastData.windSpeed = "12.45"
    
        sut.deleteWeatherInfoData()
        
        XCTAssertFalse(mockWeatherinfoData.isInvalidated)
    }

    func testDeleteWeatherForecastData_Success(){
        let mockWeatherData = WeatherForecast()
        
        mockWeatherData.cityName = "Dhaka"
        mockWeatherData.temperature = "23.5"
        mockWeatherData.weatherType = "clear"
        mockWeatherData.icon = "01d"
        mockWeatherData.currentDate = "12-54-32"
        mockWeatherData.minTemperature = "11.98"
        mockWeatherData.maxTemperature = "13.40"
        mockWeatherData.time = "7.43"
        
        try! mockRealm.write{
            mockRealm.add(mockWeatherData)
        }
        
        let mockForecastData = mockRealm.objects(WeatherForecast.self).first
        XCTAssertNotNil(mockForecastData)
        
        sut.realm = mockRealm
        sut.deleteWeatherForecastData()
        
        let countWeatherForecastData = mockRealm.objects(WeatherForecast.self).count
        let mockWeatherForecastData = mockRealm.objects(WeatherForecast.self).first
        
        XCTAssertNil(mockWeatherForecastData)
        XCTAssertEqual(countWeatherForecastData, 0)
    }
    
    func testDeleteWeatherForecastData_Error(){
        let mockWeatherData = WeatherForecast()
        mockWeatherData.cityName = "Dhaka"
        mockWeatherData.temperature = "23.5"
        mockWeatherData.weatherType = "clear"
        mockWeatherData.icon = "01d"
        mockWeatherData.currentDate = "12-54-32"
        mockWeatherData.minTemperature = "11.98"
        mockWeatherData.maxTemperature = "13.40"
        mockWeatherData.time = "7.43"
        
        sut.deleteWeatherForecastData()
        
        XCTAssertFalse(mockWeatherData.isInvalidated)
    }
    
    func testSaveWeatherInfoData_Success(){
        let mockWeatherinfoData = WeatherDataInfo()
        mockWeatherinfoData.cityName = "Rangpur"
        mockWeatherinfoData.temperature = "23.5"
        mockWeatherinfoData.icon = "01d"
        mockWeatherinfoData.weatherType = "clear"
        
        sut.realm = mockRealm
        sut.saveWeatherInfoData(weatherDataInfo: mockWeatherinfoData)
        
        let countWeatherInfoData = mockRealm.objects(WeatherDataInfo.self).count
        let mockWeatherInfoData = mockRealm.objects(WeatherDataInfo.self).first
        XCTAssertNotNil(mockWeatherInfoData)
        XCTAssertEqual(countWeatherInfoData, 1)
    }
    
    func testSaveWeatherInfoData_Error(){
        let mockWeatherinfoData = WeatherDataInfo()
        sut.saveWeatherInfoData(weatherDataInfo: mockWeatherinfoData)
        XCTAssertNotEqual(mockWeatherinfoData.cityName, "Rangpur")
    }
    
    func testSaveHourlyWeatherForecastData_Success(){
        let mockWeatherForecastData = HourlyWeatherForecast()
        mockWeatherForecastData.time = "12.30"
        mockWeatherForecastData.temperature = "25.6"
        mockWeatherForecastData.icon = "012d"
        mockWeatherForecastData.windSpeed = "12.45"

        sut.saveHourlyWeatherForecastData(hourlyWeatherForecast: mockWeatherForecastData)
        
        let countWeatherInfoData = mockRealm.objects(HourlyWeatherForecast.self).count
        let mockWeatherInfoData = mockRealm.objects(HourlyWeatherForecast.self).first
        XCTAssertNotNil(mockWeatherInfoData)
        XCTAssertEqual(countWeatherInfoData, 1)
    }
    
    func testSaveHourlyWeatherForecastData_Error(){
        let mockWeatherForecastData = HourlyWeatherForecast()

        sut.realm = mockRealm
        sut.saveHourlyWeatherForecastData(hourlyWeatherForecast: mockWeatherForecastData)
        XCTAssertNotEqual(mockWeatherForecastData.time, "12.30")
    }
    
    func testSaveWeatherForecastData_Success(){
        let weatherForecastData = WeatherForecast()
        weatherForecastData.cityName = "Dhaka"
        weatherForecastData.temperature = "12.30"
        weatherForecastData.weatherType = "clear"
        weatherForecastData.icon = "012d"
        weatherForecastData.currentDate = "11-11-23"
        weatherForecastData.minTemperature = "10.03"
        weatherForecastData.maxTemperature = "8.09"
        weatherForecastData.time = "1.20"
        
        sut.saveWeatherForecastData(weatherForecast: weatherForecastData)
        let countWeatherData = mockRealm.objects(WeatherForecast.self).count
        let mockWeatherData = mockRealm.objects(WeatherForecast.self).first
        XCTAssertNotNil(mockWeatherData)
        XCTAssertEqual(countWeatherData, 1)
    }
    
    func testSaveWeatherForecastData_Error(){
        let weatherForecastData = WeatherForecast()
        
        sut.saveWeatherForecastData(weatherForecast: weatherForecastData)
        XCTAssertNotEqual(weatherForecastData.time, "12.30")
    }
}
