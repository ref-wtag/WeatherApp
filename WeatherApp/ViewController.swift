//
//  ViewController.swift
//  WeatherApp
//
//  Created by Refat E Ferdous on 12/6/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    var lat : Double = 0.0
    var long : Double = 0.0
    let locationManager = CLLocationManager()
    var cityNameString : String = ""
    
    let networkManager = NetworkManager()
    var weatherForecastInfo : WeatherForecastResponse? = nil
    var currentWeatherInfo : CurrentWeatherInfoResponse? = nil
    
    @IBOutlet var collectionView : UICollectionView!
    
    @IBOutlet var  cityName : UILabel!
    @IBOutlet var temperature : UILabel!
    @IBOutlet var icon : UIImageView!
    @IBOutlet var weatherType : UILabel!
    @IBOutlet var weatherLabel : UILabel!
    
    
    @IBAction func SearchCityButton(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocationSearchViewController") as! LocationSearchViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func WeatherForecastButton(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WeatherForecastViewController") as! WeatherForecastViewController
        vc.cityNameString = self.cityNameString
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "WeatherForecastCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")

        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchCurrentWeatherInfo()
        fetchWeatherForecastInfo()
        getCurrentLocation()
    }
    
    func fetchWeatherForecastInfo(){
        networkManager.fetchWeatherForecastInfo{ result in
            switch result{
            case .success(let hourlyWeatherInfo):
                DispatchQueue.main.async {
                    self.weatherForecastInfo = hourlyWeatherInfo
                    self.collectionView.reloadData()
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
                    self.loadCurrentLocationData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
       
    }
    
    func loadCurrentLocationData(){
    
        let tempInCelcious = (currentWeatherInfo?.main.temp ?? 0.0) - 273.15
        let temp = String(format: "%.2f", tempInCelcious)
        temperature.text = String(temp) + "°C"
        
        weatherType.text = currentWeatherInfo?.weather[0].main
        
        let imageUrlString = "https://openweathermap.org/img/w/" + (currentWeatherInfo?.weather[0].icon ?? "") + ".png"
        let imageUrl = URL(string:  imageUrlString)
        
        URLSession.shared.dataTask(with: imageUrl!) { data, _, error in
            if let imageData = data, let image = UIImage(data: imageData){
                DispatchQueue.main.sync{
                    self.icon.image = image
                }
            }
        }.resume()
    }
    
    func getCurrentLocation(){
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        DispatchQueue.global().async { [self] in
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
        }
    }
    
    func getCityName(){
        let location = CLLocation(latitude: lat, longitude: long)
        location.fetchCityAndCountry { city, country, error in
            
        guard let city = city, let country = country, error == nil else { return }
            self.cityName.text = city
            self.cityNameString = city
            
        }
    }

}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherForecastInfo?.list.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WeatherForecastCollectionViewCell
        
        guard indexPath.row < (weatherForecastInfo?.list.count)! else{
            return cell
        }
        
        let dateString = weatherForecastInfo?.list[indexPath.row].dt_txt ?? ""

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "h:mm a"
            let formattedDateString = dateFormatter.string(from: date)
            cell.time.text =  formattedDateString
        }
       
        let tempInCelcious = (weatherForecastInfo?.list[indexPath.row].main.temp ?? 0.0) - 273.15
        let temp = String(format: "%.2f", tempInCelcious)
        cell.temperature.text = String(temp) + "°C"
    
        if let windSpeed = weatherForecastInfo?.list[indexPath.row].wind.speed{
            cell.windSpeed.text = "\(windSpeed) Km/H"
        }else{
            cell.windSpeed.text = ""
        }
        
        var imageUrlString = "https://openweathermap.org/img/w/" + (weatherForecastInfo?.list[indexPath.row].weather[0].icon)! + ".png"
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

extension ViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue : CLLocationCoordinate2D = manager.location?.coordinate else{return}
        self.lat = locationValue.latitude
        self.long = locationValue.longitude
        self.getCityName()
    }
}

extension CLLocation{
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.administrativeArea, $0?.first?.country, $1) }
    }
}
