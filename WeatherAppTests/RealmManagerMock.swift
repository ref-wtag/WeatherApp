import Foundation
import RealmSwift
@testable import WeatherApp

class RealmManagerMock : RealmManagerDelegate{
    var isDeleteWeatherInfoDataCalled = false
    var isDeleteWeatherForecastDataCalled = false
    var mockRealm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealm"))
    
    func saveWeatherInfoData(weatherDataInfo: WeatherApp.WeatherDataInfo) {
        let mockWeatherInfoData = WeatherDataInfo()
        mockWeatherInfoData.cityName = "Dhaka"
        mockWeatherInfoData.temperature = "24.0"
        mockWeatherInfoData.icon = "011d"
        mockWeatherInfoData.weatherType = "Haze"
        
        try! mockRealm.write{
            mockRealm.add(mockWeatherInfoData)
        }
    }
    
    func saveHourlyWeatherForecastData(hourlyWeatherForecast: HourlyWeatherForecast) {
        let mockHourlyWeatherInfoData = HourlyWeatherForecast()
        mockHourlyWeatherInfoData.time = "12.30"
        mockHourlyWeatherInfoData.temperature = "24.0"
        mockHourlyWeatherInfoData.icon = "011d"
        mockHourlyWeatherInfoData.windSpeed = "23.4"
        
        try! mockRealm.write{
            mockRealm.add(mockHourlyWeatherInfoData)
        }
    }
    
    func saveWeatherForecastData(weatherForecast: WeatherForecast) {
        let weatherForecastData = WeatherForecast()
        weatherForecastData.cityName = "Dhaka"
        weatherForecastData.temperature = "12.30"
        weatherForecastData.weatherType = "clear"
        weatherForecastData.icon = "012d"
        weatherForecastData.currentDate = "11-11-23"
        weatherForecastData.minTemperature = "10.03"
        weatherForecastData.maxTemperature = "8.09"
        weatherForecastData.time = "1.20"
        
        try! mockRealm.write{
            mockRealm.add(weatherForecastData)
        }
    }

    func deleteWeatherInfoData() {
        try? mockRealm.write{
            mockRealm.delete(mockRealm.objects(WeatherDataInfo.self))
            mockRealm.delete(mockRealm.objects(HourlyWeatherForecast.self))
        }
    }
    
    func deleteWeatherForecastData() {
        try? mockRealm.write{
            mockRealm.delete(mockRealm.objects(WeatherForecast.self))
        }
    }
    
}
