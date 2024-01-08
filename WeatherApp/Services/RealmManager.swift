import Foundation
import RealmSwift
import Realm

protocol RealmManagerDelegate {
    func deleteWeatherInfoData()
    func deleteWeatherForecastData()
    func saveWeatherInfoData(weatherDataInfo : WeatherDataInfo)
    func saveHourlyWeatherForecastData(hourlyWeatherForecast : HourlyWeatherForecast)
    func saveWeatherForecastData(weatherForecast : WeatherForecast)
}

class RealmManager : RealmManagerDelegate{
    var realm : Realm
    var shouldDeleteRealm = true
    var shouldSaveRealm = true
    
    init(realm : Realm = try! Realm()){
        self.realm = realm
    }
    func deleteWeatherInfoData(){
        try? realm.write{
                realm.delete(realm.objects(WeatherDataInfo.self))
                realm.delete(realm.objects(HourlyWeatherForecast.self))
        }
    }
    
    func deleteWeatherForecastData(){
        try? realm.write{
                realm.delete(realm.objects(WeatherForecast.self))
        }
    }
    
    func saveWeatherInfoData(weatherDataInfo : WeatherDataInfo){
        try? realm.write{
                realm.add(weatherDataInfo)
        }
    }
    
    func saveHourlyWeatherForecastData(hourlyWeatherForecast : HourlyWeatherForecast){
        try? realm.write{
                realm.add(hourlyWeatherForecast)
        }
    }
    
    func saveWeatherForecastData(weatherForecast : WeatherForecast){
        try? realm.write{
                realm.add(weatherForecast)
        }
    }
}
