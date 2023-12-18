//
//  ViewController.swift
//  WeatherApp
//
//  Created by Refat E Ferdous on 12/6/23.
//

import UIKit
import CoreLocation
import RealmSwift

class ViewController: UIViewController {

    var lat : Double = 0.0
    var long : Double = 0.0
    let locationManager = CLLocationManager()
    var cityNameString : String = ""
    var realmManager = RealmManager()
    let realm = try! Realm()
    
    let networkManager = NetworkManager()
    var weatherForecastInfo : WeatherForecastResponse? = nil
    var currentWeatherInfo : CurrentWeatherInfoResponse? = nil
    
    @IBOutlet var collectionView : UICollectionView!
    
    
    @IBOutlet var  cityName : UILabel!
    @IBOutlet var temperature : UILabel!
    @IBOutlet var icon : UIImageView!
    @IBOutlet var weatherType : UILabel!
    @IBOutlet var weatherLabel : UILabel!
    
    @IBOutlet var searchCityButton : UIButton!
    @IBOutlet var weatherForecastButton : UIButton!
    
    @IBAction func SearchCityButton(){
       // let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocationSearchViewController") as! LocationSearchViewController
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
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        let nib = UINib(nibName: "WeatherForecastCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
    
        setColorForButton()
        fetchCurrentWeatherInfo()
        fetchWeatherForecastInfo()
        getCurrentLocation()
    }
    
    func setColorForButton(){
        searchCityButton.setTitle("Click Here to Search City", for: .normal)
        searchCityButton.setTitleColor(UIColor.white, for: .normal)
        
        weatherForecastButton.setTitle("5-Day Weather Forecast", for: .normal)
        weatherForecastButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    
    func fetchCurrentWeatherInfo(){
        networkManager.fetchCurrentWeatherInfo{ result in
            switch result{
            case .success(let currentWeatherInfo):
                DispatchQueue.main.async {
                    self.currentWeatherInfo = currentWeatherInfo
                    self.loadCurrentLocationData()
                    self.realmManager.deleteWeatherInfoData()
                    self.saveWeatherInfoData()
                    
                }
            case .failure(let error):
                self.getWeatherInfoData()
                print(error.localizedDescription)
            }
        }
       
    }
    
    func fetchWeatherForecastInfo(){
        networkManager.fetchWeatherForecastInfo{ result in
            switch result{
            case .success(let hourlyWeatherInfo):
                DispatchQueue.main.async {
                    self.weatherForecastInfo = hourlyWeatherInfo
                    self.collectionView.reloadData()
                    self.realmManager.deleteWeatherForecastData()
                    self.saveHourlyWeatherForecastData()
                }
            case .failure(let error):
                self.collectionView.reloadData()
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
    
    //Realm
    func saveWeatherInfoData(){
        
    let weatherInfo = WeatherInfoRealmClass()
        weatherInfo.cityName = self.cityNameString
        weatherInfo.temperature = "\(currentWeatherInfo?.main.temp)"
        weatherInfo.icon = currentWeatherInfo?.weather[0].icon
        weatherInfo.weatherType = currentWeatherInfo?.weather[0].main
        
      try! realm.write{
      realm.add(weatherInfo)
      }
  }
    
    func saveHourlyWeatherForecastData(){
        let weatherForecastInfoSize : Int? = weatherForecastInfo?.list.count
    
        for i in 0..<(weatherForecastInfoSize ?? 3){
                let weatherForecastData = HourlyWeatherForecastRealmClass()
                weatherForecastData.time = weatherForecastInfo?.list[i].dt_txt
                weatherForecastData.temperature = "\(weatherForecastInfo?.list[i].main.temp)"
                weatherForecastData.icon = weatherForecastInfo?.list[i].weather[0].icon
                weatherForecastData.windSpeed = "\(weatherForecastInfo?.list[i].wind.speed)"
                
                try! realm.write{
                    realm.add(weatherForecastData)
                }
        }
    }
    
    func getWeatherInfoData(){
        let weatherInfoData = realm.objects(WeatherInfoRealmClass.self)

        for i in weatherInfoData {
            self.cityName.text = i.cityName
            self.temperature.text = i.temperature
            
            let imageUrlString = "https://openweathermap.org/img/w/" + (i.icon ?? "") + ".png"
            let imageUrl = URL(string:  imageUrlString)
            
            URLSession.shared.dataTask(with: imageUrl!) { data, _, error in
                if let imageData = data, let image = UIImage(data: imageData){
                    DispatchQueue.main.sync{
                        self.icon.image = image
                    }
                }
            }.resume()
            self.weatherType.text = i.weatherType
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
        guard ((weatherForecastInfo?.list.count) != nil) else{
            cell.getHourlyWeatherForecastData()
            return cell
        }
        let data = weatherForecastInfo?.list[indexPath.row]
        cell.updateCollectionViewWithData(withData: data!)
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
