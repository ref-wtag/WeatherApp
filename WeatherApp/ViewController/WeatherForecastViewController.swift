//
//  WeatherForecastViewController.swift
//  WeatherApp
//
//  Created by Refat E Ferdous on 12/11/23.
//

import UIKit
import RealmSwift

class WeatherForecastViewController: UIViewController{

    
    let networkManager = NetworkManager()
    var realmManager = RealmManager()
    let realm = try! Realm()
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
        networkManager.fetchWeatherForecastInfo(latitude : ConstantKeys.shared.latitude, longitude : ConstantKeys.shared.longitude){ result in
            
            switch result{
            case .success(let weatherForecastInfo):
                DispatchQueue.main.async {
                    self.weatherForecastInfo = weatherForecastInfo
                    self.tablewView.reloadData()
                    self.loadData()
                    self.realmManager.deleteWeatherForecastData()
                    self.saveWeatherForecastData()
                }
            case .failure(let error):
                 self.getWeatherForecastData()
                 self.tablewView.reloadData()
                print("error is : \(error.localizedDescription)")
            }
            
        }
    }
    
    
    func loadData(){
        cityName.text = self.cityNameString
        
        let tempInCelcious = (weatherForecastInfo?.list[0].main.temp ?? 0.0) - 273.15
        let formattedTemprature = Int(tempInCelcious)
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
        let minTemp = Int(minTempInCelcious)
        let maxTempInCelcious = (weatherForecastInfo?.list[0].main.temp_max ?? 0) - 273.15
        let maxTemp = Int(maxTempInCelcious)
        let temp = "\(minTemp)°C /" + " \(maxTemp)"
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
    
    
    //realm
    func saveWeatherForecastData(){
        var weatherForecastInfoSize : Int? = weatherForecastInfo?.list.count
        
        for i in 0...weatherForecastInfoSize!{
            
            let weatherForecastData = WeatherForecastRealm()
                weatherForecastData.cityName = self.cityNameString
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
    func getWeatherForecastData(){
        let weatherData = realm.objects(WeatherForecastRealm.self)
        
        for i in weatherData {
            self.cityName.text = i.cityName
            self.temperature.text = i.temperature
            self.weatherType.text = i.weatherType
            self.currentDate.text = i.currentDate
            self.minMaxTemperature.text = "i.minTemperature" + " i.maxTemperature"
            
            let imageUrlString = "https://openweathermap.org/img/w/" + (i.icon ?? "") + ".png"
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
        
        guard weatherForecastInfo?.list.count != 0 else{
            cell.getWeatherForecastDataInTableView()
            return cell
        }
        
        let weatherData = weatherForecastInfo?.list[indexPath.row]
        cell.updateCellWithApiData(withData: weatherData!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
