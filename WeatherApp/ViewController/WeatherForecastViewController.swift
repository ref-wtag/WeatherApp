//
//  WeatherForecastViewController.swift
//  WeatherApp
//
//  Created by Refat E Ferdous on 12/11/23.
//

import UIKit
import RealmSwift

class WeatherForecastViewController: UIViewController{

    let realm = try! Realm()
    @IBOutlet var tablewView : UITableView!
    
    @IBOutlet var cityName : UILabel!
    @IBOutlet var temperature : UILabel!
    @IBOutlet var weatherType : UILabel!
    @IBOutlet var currentDate : UILabel!
    @IBOutlet var minMaxTemperature : UILabel!
    @IBOutlet var iconImage : UIImageView!
    
    var viewModel =  WeatherForecastViewModel()
    var weatherForecastInfo : WeatherForecastResponse? = nil
    
    var cityNameString : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        bindWeatherForecastViewModel()
        viewModel.fetchWeatherForecastInfo()
    }
    
    func setTableView(){
        let nib = UINib(nibName: "WeatherForecastDataTableViewCell", bundle: nil)
        tablewView.register(nib, forCellReuseIdentifier: "cell")
        tablewView.dataSource = self
        tablewView.delegate = self
    }

    func bindWeatherForecastViewModel(){
        
        viewModel.tableViewdata.bind { weatherData in
        guard let weatherData = weatherData else{
            return
            }
            self.weatherForecastInfo = weatherData
            self.tablewView.reloadData()
        }
        
        viewModel.weatherData.bind { weatherData in
            guard let waetherData = weatherData else{
                self.getWeatherForecastData()
                return
            }
            
            self.weatherForecastInfo = weatherData
            self.loadData()
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
    

   
    func getWeatherForecastData(){
        let data = realm.objects(WeatherForecast.self)
        
        for weatherData in data {
            self.cityName.text = weatherData.cityName
            self.temperature.text = weatherData.temperature
            self.weatherType.text = weatherData.weatherType
            self.currentDate.text = weatherData.currentDate
            self.minMaxTemperature.text = "weatherData.minTemperature" + " weatherData.maxTemperature"
            
            let imageUrlString = "https://openweathermap.org/img/w/" + (weatherData.icon ?? "") + ".png"
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
