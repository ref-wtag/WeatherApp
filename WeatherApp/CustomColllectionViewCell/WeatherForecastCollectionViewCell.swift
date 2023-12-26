//
//  WeatherForecastCollectionViewCell.swift
//  WeatherApp
//
//  Created by Refat E Ferdous on 12/10/23.
//

import UIKit
import RealmSwift

class WeatherForecastCollectionViewCell: UICollectionViewCell {

    let realm = try! Realm()
    @IBOutlet var time : UILabel!
    @IBOutlet var temperature: UILabel!
    @IBOutlet var windSpeed : UILabel!
    @IBOutlet var imageView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 12
    }
    
    func getHourlyWeatherForecastData(){
        let weatherForecastData = realm.objects(HourlyWeatherForecast.self)
        
        for i in weatherForecastData {
            self.time.text = i.time
            self.temperature.text = i.temperature
            
            let imageUrlString = "https://openweathermap.org/img/w/" + (i.icon ?? "") + ".png"
            let imageUrl = URL(string:  imageUrlString)
            
            URLSession.shared.dataTask(with: imageUrl!) { data, _, error in
                if let imageData = data, let image = UIImage(data: imageData){
                    DispatchQueue.main.sync{
                        self.imageView.image = image
                    }
                }
            }.resume()
            
            self.windSpeed.text = i.windSpeed
        }
    }
    
    func updateCollectionViewWithData(withData data : WeatherInfoList){
        let dateString = data.dt_txt

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "h:mm a"
            let formattedDateString = dateFormatter.string(from: date)
            self.time.text =  formattedDateString
        }
       
        let tempInCelcious = (data.main.temp ) - 273.15
        let temp = String(format: "%.2f", tempInCelcious)
        self.temperature.text = String(temp) + "°C"
    
        let windSpeed = data.wind.speed
        self.windSpeed.text = "\(windSpeed) Km/H"
        
        
        var imageUrlString = "https://openweathermap.org/img/w/" + (data.weather[0].icon) + ".png"
        let imageUrl = URL(string:  imageUrlString)
        
        URLSession.shared.dataTask(with: imageUrl!) { data, _, error in
            if let imageData = data, let image = UIImage(data: imageData){
                DispatchQueue.main.sync{
                    self.imageView.image = image
                }
            }
        }.resume()
        
    
    }

}
