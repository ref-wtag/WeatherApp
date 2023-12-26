//
//  WeatherForecastDataTableViewCell.swift
//  WeatherApp
//
//  Created by Refat E Ferdous on 12/11/23.
//

import UIKit
import RealmSwift

class WeatherForecastDataTableViewCell: UITableViewCell {

    var weatherForecastResponse : WeatherForecastResponse?
    let realm = try! Realm()
    @IBOutlet var dateValue : UILabel!
    @IBOutlet var timeValue : UILabel!
    @IBOutlet var minMaxTemperature : UILabel!
    @IBOutlet var weatherType : UILabel!
    @IBOutlet var iconImage : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        
    }

    func getWeatherForecastDataInTableView(){
        let weatherData = realm.objects(WeatherForecast.self)
        
        for weatherInfo in weatherData {
        self.dateValue.text = weatherInfo.currentDate
        self.timeValue.text = weatherInfo.time
        self.weatherType.text = weatherInfo.weatherType
        self.minMaxTemperature.text = "weatherInfo.minTemperature" + " weatherInfo.maxTemperature"
        
        let imageUrlString2 = "https://openweathermap.org/img/w/" + (weatherInfo.icon ?? "") + ".png"
        let imageUrl2 = URL(string:  imageUrlString2)
        
        URLSession.shared.dataTask(with: imageUrl2!) { data, _, error in
            if let imageData = data, let image = UIImage(data: imageData){
                DispatchQueue.main.sync{
                    self.imageView?.image = image
                }
            }
        }.resume()
        
    }
    }
    
    func updateCellWithApiData(withData data : WeatherInfoList){
        
        let dateString = data.dt_txt
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let time = timeFormatter.date(from: dateString) {
            timeFormatter.dateFormat = "h:mm a"
            let formattedTimeString = timeFormatter.string(from: time)
            self.timeValue.text =  formattedTimeString
        }
        

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: dateString) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "MMM d"
            let formattedDate = outputDateFormatter.string(from: date)
            self.dateValue.text = "\(formattedDate)"
        }

        self.weatherType.text = data.weather[0].main
        
        let minTempInCelcious = (data.main.temp_min ) - 273.15
        let minTemp = Int(minTempInCelcious)
        let maxTempInCelcious = (data.main.temp_max ) - 273.15
        let maxTemp = Int(maxTempInCelcious)
        let temp = "\(minTemp)°C /" + " \(maxTemp)"
        self.minMaxTemperature.text = String(temp) + "°C"
        
        let imageUrlString = "https://openweathermap.org/img/w/" + (data.weather[0].icon ) + ".png"
        let imageUrl = URL(string:  imageUrlString)
        
        URLSession.shared.dataTask(with: imageUrl!) { data, _, error in
            if let imageData = data, let image = UIImage(data: imageData){
                DispatchQueue.main.sync{
                    self.iconImage.image = image
                }
            }
        }.resume()
    }
}
