//
//  WeatherForecastViewController.swift
//  WeatherApp
//
//  Created by Refat E Ferdous on 12/11/23.
//

import UIKit

class WeatherForecastViewController: UIViewController{

    let networkManager = NetworkManager()
    var weatherForecastInfo : WeatherForecastResponse? = nil
    
    @IBOutlet var tablewView : UITableView!
    
    @IBOutlet var cityName : UILabel!
    @IBOutlet var temperature : UILabel!
    @IBOutlet var weatherType : UILabel!
    @IBOutlet var currentDate : UILabel!
    @IBOutlet var minMaxTemperature : UILabel!
    @IBOutlet var iconImage : UIImageView!
    
    var cityNameString : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "WeatherForecastDataTableViewCell", bundle: nil)
        tablewView.register(nib, forCellReuseIdentifier: "cell")
        
        tablewView.dataSource = self
        tablewView.delegate = self
        fetchWeatherForecastInfo()
    
    }
    
    func fetchWeatherForecastInfo(){
        networkManager.fetchWeatherForecastInfo{ result in
            switch result{
            case .success(let weatherForecastInfo):
                DispatchQueue.main.async {
                    self.weatherForecastInfo = weatherForecastInfo
                    self.tablewView.reloadData()
                    self.loadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    func loadData(){
        cityName.text = self.cityNameString
        
        let tempInCelcious = (weatherForecastInfo?.list[0].main.temp ?? 0.0) - 273.15
        let formattedTemprature = String(format: "%.0f", tempInCelcious)
        temperature.text = "\(formattedTemprature)"
        
        if let weatherType = weatherForecastInfo?.list[0].weather[0].main {
            self.weatherType.text = weatherType
        } else {

            self.weatherType.text = "N/A"
        }
        
        let dateString = weatherForecastInfo?.list[0].dt_txt ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: dateString) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "MMM d"
            let formattedDate = outputDateFormatter.string(from: date)
           currentDate.text = "\(formattedDate)"
        }
        
        
        let minTempInCelcious = (weatherForecastInfo?.list[0].main.temp_min ?? 0.0) - 273.15
        let minTemp = String(format: "%.2f", minTempInCelcious)
        let maxTempInCelcious = (weatherForecastInfo?.list[0].main.temp_max ?? 0) - 273.15
        let maxTemp = String(format: "%.2f", maxTempInCelcious)
        let temp = "\(minTemp)°C " + " \(maxTemp)"
        minMaxTemperature.text = String(temp) + "°C"
        
        
        let imageUrlString = "https://openweathermap.org/img/w/" + (weatherForecastInfo?.list[0].weather[0].icon ?? "") + ".png"
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

extension WeatherForecastViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherForecastInfo?.list.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeatherForecastDataTableViewCell
        guard indexPath.row < (weatherForecastInfo?.list.count)! else{
            return cell
        }
        
        
        let dateString = weatherForecastInfo?.list[indexPath.row].dt_txt ?? ""
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let time = timeFormatter.date(from: dateString) {
            timeFormatter.dateFormat = "h:mm a"
            let formattedTimeString = timeFormatter.string(from: time)
            cell.timeValue.text =  formattedTimeString
        }
        

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: dateString) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "MMM d"
            let formattedDate = outputDateFormatter.string(from: date)
            cell.dateValue.text = "\(formattedDate)"
        }

        cell.weatherType.text = weatherForecastInfo?.list[indexPath.row].weather[0].main
        
        let minTempInCelcious = (weatherForecastInfo?.list[indexPath.row].main.temp_min ?? 0.0) - 273.15
        let minTemp = String(format: "%.2f", minTempInCelcious)
        let maxTempInCelcious = (weatherForecastInfo?.list[indexPath.row].main.temp_max ?? 0) - 273.15
        let maxTemp = String(format: "%.2f", maxTempInCelcious)
        let temp = "\(minTemp)°C " + " \(maxTemp)"
        cell.minMaxTemperature.text = String(temp) + "°C"
        
        let imageUrlString = "https://openweathermap.org/img/w/" + (weatherForecastInfo?.list[indexPath.row].weather[0].icon ?? "") + ".png"
        let imageUrl = URL(string:  imageUrlString)
        
        URLSession.shared.dataTask(with: imageUrl!) { data, _, error in
            if let imageData = data, let image = UIImage(data: imageData){
                DispatchQueue.main.sync{
                    cell.iconImage.image = image
                }
            }
        }.resume()
        
        return cell
    }
}
