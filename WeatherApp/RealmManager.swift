//
//  RealmManager.swift
//  RealmDemo
//
//  Created by Refat E Ferdous on 12/14/23.
//

import Foundation
import RealmSwift

class RealmManager{
    
    let realm = try! Realm()
    let viewController = ViewController()
    let cell = WeatherForecastCollectionViewCell()
    let tableViewCell = WeatherForecastDataTableViewCell()
    let weatherForecastViewController = WeatherForecastViewController()
    
    var weatherForecastInfo : WeatherForecastResponse? = nil
    var currentWeatherInfo : CurrentWeatherInfoResponse? = nil
    
    func deleteWeatherInfoData() async{
        try! realm.write{
            realm.delete(realm.objects(WeatherInfoRealmClass.self))
        }
        
        try! realm.write{
            realm.delete(realm.objects(HourlyWeatherForecastRealmClass.self))
        }
    }
    
    func deleteWeatherForecastData(){
        try! realm.write{
            realm.delete(realm.objects(WeatherForecastRealmClass.self))
        }
    }
    
    
    func saveWeatherInfoData(){
        
    let weatherInfo = WeatherInfoRealmClass()
        weatherInfo.cityName = viewController.cityNameString
        weatherInfo.temperature = "\(currentWeatherInfo?.main.temp)"
        weatherInfo.icon = currentWeatherInfo?.weather[0].icon
        weatherInfo.weatherType = currentWeatherInfo?.weather[0].main
        
      try! realm.write{
     realm.add(weatherInfo)
      }
        
        var weatherForecastInfoSize : Int? = weatherForecastInfo?.list.count
        
        for i in 0...weatherForecastInfoSize!
        {
            let weatherForecastData = HourlyWeatherForecastRealmClass()
            weatherForecastData.time = weatherForecastInfo?.list[i].dt_txt
            weatherForecastData.temperature = "\(weatherForecastInfo?.list[i].main.temp)"
            weatherForecastData.icon = weatherForecastInfo?.list[0].weather[i].icon
            weatherForecastData.windSpeed = "\(weatherForecastInfo?.list[i].wind.speed)"
            
            try! realm.write{
            realm.add(weatherForecastData)
            }
        }
  }
    
    func saveWeatherForecastData(){
        var weatherForecastInfoSize : Int? = weatherForecastInfo?.list.count
        
        for i in 0...weatherForecastInfoSize!{
            
            let weatherForecastData = WeatherForecastRealmClass()
                weatherForecastData.cityName = viewController.cityNameString
                weatherForecastData.temperature = "\(weatherForecastInfo?.list[0].main.temp)"
                weatherForecastData.weatherType = weatherForecastInfo?.list[0].weather[0].main
                weatherForecastData.icon = weatherForecastInfo?.list[0].weather[0].icon
                weatherForecastData.currentDate = weatherForecastInfo?.list[0].dt_txt
                weatherForecastData.minTemperature = "\(weatherForecastInfo?.list[0].main.temp_min)"
                weatherForecastData.maxTemperature = "\(weatherForecastInfo?.list[0].main.temp_max)"
                weatherForecastData.time = weatherForecastInfo?.list[0].dt_txt
                
              try! realm.write{
                realm.add(weatherForecastData)
              }
        }
    
  }
    
    
    
    func getWeatherInfoData(){
        let weatherInfoData = realm.objects(WeatherInfoRealmClass.self)

        for i in weatherInfoData {
            viewController.cityName.text = i.cityName
            viewController.temperature.text = i.temperature
            
            let imageUrlString = "https://openweathermap.org/img/w/" + (i.icon ?? "") + ".png"
            let imageUrl = URL(string:  imageUrlString)
            
            URLSession.shared.dataTask(with: imageUrl!) { data, _, error in
                if let imageData = data, let image = UIImage(data: imageData){
                    DispatchQueue.main.sync{
                        self.viewController.icon.image = image
                    }
                }
            }.resume()
            viewController.weatherType.text = i.weatherType
        }
        
        let weatherForecastData = realm.objects(HourlyWeatherForecastRealmClass.self)
        
        for i in weatherForecastData {
            cell.time.text = i.time
            cell.temperature.text = i.temperature
            
            let imageUrlString = "https://openweathermap.org/img/w/" + (i.icon ?? "") + ".png"
            let imageUrl = URL(string:  imageUrlString)
            
            URLSession.shared.dataTask(with: imageUrl!) { data, _, error in
                if let imageData = data, let image = UIImage(data: imageData){
                    DispatchQueue.main.sync{
                        self.cell.imageView.image = image
                    }
                }
            }.resume()
            
            cell.windSpeed.text = i.windSpeed
        }
    }
    
    func getWeatherForecastData(){
        let weatherData = realm.objects(WeatherForecastRealmClass.self)
        
        for i in weatherData {
            weatherForecastViewController.cityName.text = i.cityName
            weatherForecastViewController.temperature.text = i.temperature
            weatherForecastViewController.weatherType.text = i.weatherType
            weatherForecastViewController.currentDate.text = i.currentDate
            weatherForecastViewController.minMaxTemperature.text = "i.minTemperature" + " i.maxTemperature"
            
            let imageUrlString = "https://openweathermap.org/img/w/" + (i.icon ?? "") + ".png"
            let imageUrl = URL(string:  imageUrlString)
            
            URLSession.shared.dataTask(with: imageUrl!) { data, _, error in
                if let imageData = data, let image = UIImage(data: imageData){
                    DispatchQueue.main.sync{
                        self.weatherForecastViewController.iconImage.image = image
                    }
                }
            }.resume()
            
           
            tableViewCell.dateValue.text = i.currentDate
            tableViewCell.timeValue.text = i.time
            tableViewCell.weatherType.text = i.weatherType
            tableViewCell.minMaxTemperature.text = "i.minTemperature" + " i.maxTemperature"
            
            let imageUrlString2 = "https://openweathermap.org/img/w/" + (i.icon ?? "") + ".png"
            let imageUrl2 = URL(string:  imageUrlString2)
            
            URLSession.shared.dataTask(with: imageUrl2!) { data, _, error in
                if let imageData = data, let image = UIImage(data: imageData){
                    DispatchQueue.main.sync{
                        self.tableViewCell.imageView?.image = image
                    }
                }
            }.resume()
            
        }
    }
    
    
}
