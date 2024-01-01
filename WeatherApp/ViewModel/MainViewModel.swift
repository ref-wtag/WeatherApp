//
//  MainViewModel.swift
//  WeatherApp
//
//  Created by Refat E Ferdous on 12/25/23.
//

import Foundation
import RealmSwift

class MainViewModel {
    
  
    var realmManager : RealmManagerDelegate!
    var networkManager : NetworkManagerDelegate!
    
    var weatherForecastInfo : WeatherForecastResponse? = nil
    var currentWeatherInfo : CurrentWeatherInfoResponse? = nil
    var collectionViewData : Observable<WeatherForecastResponse> = Observable(nil)
    var currentWeatherData : Observable<CurrentWeatherInfoResponse> = Observable(nil)
    
    
    init(realmManager : RealmManagerDelegate, networkManager : NetworkManagerDelegate){
        self.realmManager = realmManager
        self.networkManager = networkManager
        
    }
    
    func fetchCurrentWeatherInfo(lat : Double, lon : Double) {
        networkManager.fetchCurrentWeatherInfo(latitude : lat, longitude : lon){ result in
            switch result{
            case .success(let currentWeatherInfo):
                self.currentWeatherInfo = currentWeatherInfo
                DispatchQueue.main.async {
                    self.mapCurrentWeatherData()
                    self.realmManager.deleteWeatherInfoData()
                    self.saveWeatherInfoData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchWeatherForecastInfo(lat : Double, lon : Double){
        networkManager.fetchWeatherForecastInfo(latitude: lat, longitude: lon){ result in
            switch result{
            case .success(let hourlyWeatherInfo):
                self.weatherForecastInfo = hourlyWeatherInfo
                DispatchQueue.main.async {
                    self.mapCollectionViewData()
                    self.realmManager.deleteWeatherForecastData()
                    self.saveHourlyWeatherForecastData()
                }
                
                
            case .failure(let error):
                self.mapCollectionViewData()
                print(error.localizedDescription)
            }
        }
    }
    
    func mapCollectionViewData(){
        self.collectionViewData.value = self.weatherForecastInfo
    }
    
    func mapCurrentWeatherData(){
        self.currentWeatherData.value = self.currentWeatherInfo
    }
    
    
    func saveWeatherInfoData(){
        let realm = try! Realm()
    let weatherInfo = WeatherDataInfo()
        weatherInfo.cityName = ConstantKeys.shared.cityName
        weatherInfo.temperature = "\(currentWeatherInfo?.main.temp)"
        weatherInfo.icon = currentWeatherInfo?.weather[0].icon
        weatherInfo.weatherType = currentWeatherInfo?.weather[0].main
        
      try! realm.write{
      realm.add(weatherInfo)
      }
  }
    
    func saveHourlyWeatherForecastData(){
        let realm = try! Realm()
        let weatherForecastInfoSize : Int? = weatherForecastInfo?.list.count
    
        for weatherData in 0..<(weatherForecastInfoSize ?? 0){
                let weatherForecastData = HourlyWeatherForecast()
                weatherForecastData.time = weatherForecastInfo?.list[weatherData].dt_txt
                weatherForecastData.temperature = "\(weatherForecastInfo?.list[weatherData].main.temp)"
                weatherForecastData.icon = weatherForecastInfo?.list[weatherData].weather[0].icon
                weatherForecastData.windSpeed = "\(weatherForecastInfo?.list[weatherData].wind.speed)"
                
                try! realm.write{
                    realm.add(weatherForecastData)
                }
        }
    }
    
    
}
