//
//  WeatherForecastViewModel.swift
//  WeatherApp
//
//  Created by Refat E Ferdous on 12/25/23.
//

import Foundation
import RealmSwift

class WeatherForecastViewModel{
    var realmManager : RealmManagerDelegate
    var netWorkManager : NetworkManagerDelegate
    
    var weatherForecastInfo : WeatherForecastResponse? = nil
    var weatherData : Observable<WeatherForecastResponse> = Observable(nil)
    var tableViewdata : Observable<WeatherForecastResponse> = Observable(nil)
    
    init(netWorkManager : NetworkManagerDelegate, realmManager : RealmManagerDelegate){
        self.netWorkManager = netWorkManager
        self.realmManager = realmManager
    }
    
    func fetchWeatherForecastInfo(){
        netWorkManager.fetchWeatherForecastInfo(latitude : ConstantKeys.shared.latitude, longitude : ConstantKeys.shared.longitude){ result in
            
            switch result{
            case .success(let weatherForecastInfo):
                self.weatherForecastInfo = weatherForecastInfo
                DispatchQueue.main.async {
                    self.mapTableViewdata()
                    self.mapWeatherForecastData()
                    self.realmManager.deleteWeatherForecastData()
                    self.saveWeatherForecastData()
                }
            case .failure(let error):
                print("error is : \(error.localizedDescription)")
            }
        }
    }
    
    func mapWeatherForecastData(){
        self.weatherData.value = self.weatherForecastInfo
    }
    
    func mapTableViewdata(){
        self.tableViewdata.value = self.weatherForecastInfo
    }
    
    func saveWeatherForecastData(){
        var weatherForecastInfoSize : Int? = weatherForecastInfo?.list.count
        let weatherForecastData = WeatherForecast()
        weatherForecastData.cityName = ConstantKeys.shared.cityName
        weatherForecastData.temperature = "\(weatherForecastInfo?.list[0].main.temp)"
        weatherForecastData.weatherType = weatherForecastInfo?.list[0].weather[0].main
        weatherForecastData.icon = weatherForecastInfo?.list[0].weather[0].icon
        weatherForecastData.currentDate = weatherForecastInfo?.list[0].dt_txt
        weatherForecastData.minTemperature = "\(weatherForecastInfo?.list[0].main.temp_min)"
        weatherForecastData.maxTemperature = "\(weatherForecastInfo?.list[0].main.temp_max)"
        weatherForecastData.time = weatherForecastInfo?.list[0].dt_txt
                
        realmManager.saveWeatherForecastData(weatherForecast : weatherForecastData)
      }
}
