import Foundation
@testable import WeatherApp

class NetworkManagerMock : NetworkManagerDelegate{
    func fetchCurrentWeatherInfo(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherApp.CurrentWeatherInfoResponse, Error>) -> ()) {
        
        var mockWeatherInfoData = CurrentWeatherInfoResponse(weather: [WeatherInfo(main: "clear", icon: "01d")], main: MainWeather(temp: 25.0))
       // completion(.success(mockWeatherInfoData))
        
        
        let mockError = NSError(domain: "com.example.error", code: 42, userInfo: [NSLocalizedDescriptionKey: "Simulated error"])
        completion(.failure(mockError))
    }
    
    func fetchWeatherForecastInfo(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherForecastResponse, Error>) -> ()) {
        var mockWeatherForecastData = WeatherInfoList(
            main: Main(temp: 25.0, temp_max: 28.0, temp_min: 22.0),
            weather: [Weather(icon: "01d", main: "clear")],
            wind: Wind(speed: 5.0),
            dt_txt: "2023-12-31 12:00:00"
        )
        let mockForecastResponse = WeatherForecastResponse(list: [mockWeatherForecastData])
        completion(.success(mockForecastResponse))
        
        //error
        let mockError = NSError(domain: "com.example.error", code: 42, userInfo: [NSLocalizedDescriptionKey: "Simulated error"])
        completion(.failure(mockError))
    }
}
