//
//  ViewController.swift
//  WeatherApp
//
//  Created by Refat E Ferdous on 12/6/23.
//

import UIKit

class ViewController: UIViewController {

    
    let networkManager = NetworkManager()
    var hourlyWeatherInfo : HourlyWeatherInfoResponse? = nil
    var currentWeatherInfo : CurrentWeatherInfoResponse? = nil
    
    @IBOutlet var collectionView : UICollectionView!
    
    @IBOutlet var  cityName : UILabel!
    @IBOutlet var temperature : UILabel!
    @IBOutlet var icon : UIImageView!
    @IBOutlet var weatherType : UILabel!
    @IBOutlet var weatherLabel : UILabel!
    
    
    @IBAction func SearchCity(){
        
        
    }
    
    @IBAction func WeatherForecast(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "WeatherForecastCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")

        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchHourlyWeatherInfo()
        fetchCurrentWeatherInfo()
        
    }
    
    func fetchHourlyWeatherInfo(){
        networkManager.fetchHourlyWeatherInfo{ result in
            switch result{
            case .success(let hourlyWeatherInfo):
                DispatchQueue.main.async {
                    self.hourlyWeatherInfo = hourlyWeatherInfo
                    self.reloadDataOnView()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    func fetchCurrentWeatherInfo(){
        networkManager.fetchCurrentWeatherInfo{ result in
            switch result{
            case .success(let currentWeatherInfo):
                DispatchQueue.main.async {
                    self.currentWeatherInfo = currentWeatherInfo
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func reloadDataOnView(){
        cityName.text = "No City To Show Right Now"
        temperature.text = "\(currentWeatherInfo?.main.temp)"
        weatherType.text = currentWeatherInfo?.weather[0].main
        
        var imageUrlString = "https://openweathermap.org/img/w/" + (currentWeatherInfo?.weather[0].icon ?? "") + ".png"
        let imageUrl = URL(string:  imageUrlString)
        
        URLSession.shared.dataTask(with: imageUrl!) { data, _, error in
            if let imageData = data, let image = UIImage(data: imageData){
                DispatchQueue.main.sync{
                    self.icon.image = image
                }
            }
        }.resume()
    }

}


extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyWeatherInfo?.list.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WeatherForecastCollectionViewCell
        
        guard indexPath.row < (hourlyWeatherInfo?.list.count)! else{
            return cell
        }
        
        let dateString = hourlyWeatherInfo?.list[indexPath.row].dt_txt ?? ""

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "h:mm a"
            let formattedDateString = dateFormatter.string(from: date)
            cell.time.text =  formattedDateString
        }
       
        let tempInCelcious = (hourlyWeatherInfo?.list[indexPath.row].main.temp ?? 0.0) - 273.15
        let temp = String(format: "%.2f", tempInCelcious)
        cell.temperature.text = String(temp) + "°C"
    
        if let windSpeed = hourlyWeatherInfo?.list[indexPath.row].wind.speed{
            cell.windSpeed.text = "\(windSpeed)"
        }else{
            cell.windSpeed.text = ""
        }
        
        var imageUrlString = "https://openweathermap.org/img/w/" + (hourlyWeatherInfo?.list[indexPath.row].weather[0].icon)! + ".png"
        let imageUrl = URL(string:  imageUrlString)
        
        URLSession.shared.dataTask(with: imageUrl!) { data, _, error in
            if let imageData = data, let image = UIImage(data: imageData){
                DispatchQueue.main.sync{
                    cell.imageView.image = image
                }
            }
        }.resume()
        
    
        return cell
    }
    
}
